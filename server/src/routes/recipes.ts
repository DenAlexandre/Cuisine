import { Router } from "express";
import { z } from "zod";
import { pool } from "../db/pool";
import { optionalAuth, requireAuth } from "../middleware/auth";

const router = Router();

const RECIPE_CATEGORIES = ["cocktail", "entree", "plat", "dessert"] as const;

// Code de la catégorie Nutrition "Boissons" (voir db/import-aliments.ts) : les
// ingrédients qui en font partie se saisissent en cl plutôt qu'en grammes.
const BOISSONS_CATEGORIE_CODE = 8;

// 1 cl ≈ 10 g : approximation (densité proche de 1) utilisée uniquement pour
// convertir les boissons en équivalent grammes lors du calcul nutritionnel, qui
// repose sur des valeurs CIQUAL exprimées pour 100 g.
const CL_TO_G = 10;
const CL_TO_ML = 10;

// Alcoolémie estimée (cocktails uniquement) via la formule de Widmark :
// alcool pur (g) = volume (mL) x degré (% vol) x densité de l'éthanol / 100,
// puis alcoolémie (g/L) = alcool pur (g) / (poids (kg) x facteur r).
// Le poids utilisé est un poids de référence paramétrable par un admin (page
// Options système), faute de connaître le poids réel de la personne qui
// consultera la recette : c'est une estimation indicative, pas une mesure.
const ETHANOL_DENSITY_G_PER_ML = 0.8;
const WIDMARK_FACTOR = 0.7;
const DEFAULT_REFERENCE_WEIGHT_KG = 70;

async function fetchReferenceWeightKg(): Promise<number> {
  const { rows } = await pool.query<{ reference_weight_kg: string }>(
    "SELECT reference_weight_kg FROM system_settings WHERE id = 1"
  );
  return rows[0] ? Number(rows[0].reference_weight_kg) : DEFAULT_REFERENCE_WEIGHT_KG;
}

// Taille maximale acceptee pour la photo (deja recadree/compressee cote client) :
// filet de securite au cas ou le controle cote client serait contourne.
const MAX_PHOTO_BYTES = 2 * 1024 * 1024;

const recipeSchema = z.object({
  title: z.string().min(3).max(255),
  description: z.string().min(1),
  steps: z.string().min(1),
  servings: z.number().int().positive(),
  category: z.enum(RECIPE_CATEGORIES),
  // undefined = ne pas toucher la photo existante, null = la retirer, string = nouvelle photo.
  photoBase64: z.string().nullable().optional(),
  ingredients: z
    .array(
      z.object({
        alimentCode: z.number().int(),
        quantity: z.number().positive(),
      })
    )
    .min(1, "Au moins un ingrédient est requis."),
});

const RECIPE_FIELDS = `
  r.id, r.title, r.description, r.steps, r.servings, r.category, r.status,
  r.created_at, r.reviewed_at, r.author_id, u.username AS author_username,
  (r.photo IS NOT NULL) AS "hasPhoto",
  EXTRACT(EPOCH FROM r.photo_updated_at)::bigint AS "photoVersion"
`;

// Decode une data URL ("data:image/jpeg;base64,...") ou une chaine base64 nue.
function decodePhotoBase64(value: string): Buffer {
  const base64 = value.includes(",") ? value.split(",")[1] : value;
  return Buffer.from(base64, "base64");
}

interface IngredientRow {
  recipe_id: number;
  aliment_code: number;
  quantity: string;
  unit: "g" | "cl" | "unite";
  nom: string;
  t_proteines: string | null;
  t_glucides: string | null;
  t_lipides: string | null;
  t_energie: string | null;
  degre_alcool: string | null;
  poids_unitaire_g: string | null;
  libelle_unite: string | null;
}

function num(value: string | null): number {
  return value === null ? 0 : Number(value);
}

function quantityInGrams(row: IngredientRow): number {
  const quantity = num(row.quantity);
  if (row.unit === "cl") return quantity * CL_TO_G;
  if (row.unit === "unite") return quantity * num(row.poids_unitaire_g);
  return quantity;
}

function pureAlcoholGrams(row: IngredientRow): number {
  if (row.unit !== "cl" || row.degre_alcool === null) return 0;
  const volumeMl = num(row.quantity) * CL_TO_ML;
  return volumeMl * (num(row.degre_alcool) / 100) * ETHANOL_DENSITY_G_PER_ML;
}

// Attache la liste des ingrédients et le total nutritionnel calculé à chaque recette.
// Pour un cocktail, attache aussi une estimation indicative d'alcoolémie.
export async function attachIngredients<
  T extends { id: number; category?: string; servings?: number }
>(recipes: T[]) {
  if (recipes.length === 0) {
    return recipes as (T & { ingredients: unknown[]; nutrition: unknown; alcohol: unknown })[];
  }

  const [{ rows }, referenceWeightKg] = await Promise.all([
    pool.query<IngredientRow>(
      `SELECT ri.recipe_id, ri.aliment_code, ri.quantity, ri.unit,
              a.t_aliment_nom AS nom, a.t_proteines, a.t_glucides, a.t_lipides, a.t_energie,
              a.degre_alcool, a.poids_unitaire_g, a.libelle_unite
       FROM recipe_ingredients ri
       JOIN aliments a ON a.t_aliment_code = ri.aliment_code
       WHERE ri.recipe_id = ANY($1::int[])
       ORDER BY ri.id ASC`,
      [recipes.map((r) => r.id)]
    ),
    fetchReferenceWeightKg(),
  ]);

  const byRecipe = new Map<number, IngredientRow[]>();
  for (const row of rows) {
    const list = byRecipe.get(row.recipe_id) ?? [];
    list.push(row);
    byRecipe.set(row.recipe_id, list);
  }

  return recipes.map((recipe) => {
    const ingredientRows = byRecipe.get(recipe.id) ?? [];
    const ingredients = ingredientRows.map((row) => ({
      alimentCode: row.aliment_code,
      nom: row.nom,
      quantity: num(row.quantity),
      unit: row.unit,
      proteines: row.t_proteines === null ? null : num(row.t_proteines),
      glucides: row.t_glucides === null ? null : num(row.t_glucides),
      lipides: row.t_lipides === null ? null : num(row.t_lipides),
      energie: row.t_energie === null ? null : num(row.t_energie),
      // kcal réellement apportées par la quantité utilisée dans la recette
      // (contrairement à "energie" ci-dessus, qui est la valeur CIQUAL pour 100 g).
      kcal: row.t_energie === null ? null : (quantityInGrams(row) / 100) * num(row.t_energie),
      degreAlcool: row.degre_alcool === null ? null : num(row.degre_alcool),
      // Libellé ("œuf(s)"...) et poids par unité de l'aliment tel qu'il est
      // configuré AUJOURD'HUI (indépendamment de l'unité réellement stockée sur
      // cette ligne) : permet au formulaire d'édition de proposer de convertir
      // un ingrédient enregistré en grammes avant l'ajout de cette fonctionnalité
      // (ex: "36 g" de jaune d'œuf) vers une saisie "à la pièce" ("2").
      libelleUnite: row.libelle_unite,
      poidsUnitaireG: row.poids_unitaire_g === null ? null : num(row.poids_unitaire_g),
      gramsEquivalent: row.unit === "unite" ? quantityInGrams(row) : null,
    }));

    const totalNutrition = ingredientRows.reduce(
      (total, row) => {
        const factor = quantityInGrams(row) / 100;
        total.proteines += factor * num(row.t_proteines);
        total.glucides += factor * num(row.t_glucides);
        total.lipides += factor * num(row.t_lipides);
        total.energie += factor * num(row.t_energie);
        return total;
      },
      { proteines: 0, glucides: 0, lipides: 0, energie: 0 }
    );
    // Valeurs par personne plutôt que pour la recette entière : c'est ce que la
    // valeur nutritionnelle affichée doit représenter, comparable à un étiquetage
    // nutritionnel individuel plutôt qu'au plat complet.
    const servingsForNutrition = recipe.servings && recipe.servings > 0 ? recipe.servings : 1;
    const nutrition = {
      proteines: totalNutrition.proteines / servingsForNutrition,
      glucides: totalNutrition.glucides / servingsForNutrition,
      lipides: totalNutrition.lipides / servingsForNutrition,
      energie: totalNutrition.energie / servingsForNutrition,
    };

    let alcohol: {
      gramsPerServing: number;
      bloodAlcoholGL: number;
      referenceWeightKg: number;
    } | null = null;
    if (recipe.category === "cocktail") {
      const totalAlcoholG = ingredientRows.reduce((sum, row) => sum + pureAlcoholGrams(row), 0);
      const servings = recipe.servings && recipe.servings > 0 ? recipe.servings : 1;
      const gramsPerServing = totalAlcoholG / servings;
      alcohol = {
        gramsPerServing,
        bloodAlcoholGL: gramsPerServing / (referenceWeightKg * WIDMARK_FACTOR),
        referenceWeightKg,
      };
    }

    return { ...recipe, ingredients, nutrition, alcohol };
  });
}

// Marque chaque recette comme favorite ou non pour l'utilisateur connecté
// (toujours false pour un visiteur anonyme).
async function attachFavoriteFlag<T extends { id: number }>(recipes: T[], userId?: number) {
  if (!userId || recipes.length === 0) {
    return recipes.map((r) => ({ ...r, isFavorite: false }));
  }

  const { rows } = await pool.query<{ recipe_id: number }>(
    "SELECT recipe_id FROM favorites WHERE user_id = $1 AND recipe_id = ANY($2::int[])",
    [userId, recipes.map((r) => r.id)]
  );
  const favoriteIds = new Set(rows.map((r) => r.recipe_id));
  return recipes.map((r) => ({ ...r, isFavorite: favoriteIds.has(r.id) }));
}

// L'unité (g ou cl) n'est jamais fournie par le client : elle est déterminée ici
// à partir de la catégorie Nutrition de l'aliment, pour rester la seule source de vérité.
async function writeIngredients(
  recipeId: number,
  ingredients: { alimentCode: number; quantity: number }[]
) {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    await client.query("DELETE FROM recipe_ingredients WHERE recipe_id = $1", [recipeId]);

    if (ingredients.length > 0) {
      const { rows: aliments } = await client.query<{
        t_aliment_code: number;
        categorie_code: number;
        poids_unitaire_g: string | null;
      }>(
        "SELECT t_aliment_code, categorie_code, poids_unitaire_g FROM aliments WHERE t_aliment_code = ANY($1::int[])",
        [ingredients.map((i) => i.alimentCode)]
      );
      const alimentByCode = new Map(aliments.map((a) => [a.t_aliment_code, a]));

      for (const item of ingredients) {
        const aliment = alimentByCode.get(item.alimentCode);
        const unit =
          aliment?.categorie_code === BOISSONS_CATEGORIE_CODE
            ? "cl"
            : aliment?.poids_unitaire_g !== null && aliment?.poids_unitaire_g !== undefined
              ? "unite"
              : "g";
        await client.query(
          `INSERT INTO recipe_ingredients (recipe_id, aliment_code, quantity, unit) VALUES ($1, $2, $3, $4)`,
          [recipeId, item.alimentCode, item.quantity, unit]
        );
      }
    }

    await client.query("COMMIT");
  } catch (err) {
    await client.query("ROLLBACK");
    throw err;
  } finally {
    client.release();
  }
}

// Liste publique des recettes approuvées, filtrable par catégorie
router.get("/", optionalAuth, async (req, res) => {
  const category = typeof req.query.categorie === "string" ? req.query.categorie : null;
  const params: unknown[] = [];
  let categoryFilter = "";
  if (category && (RECIPE_CATEGORIES as readonly string[]).includes(category)) {
    params.push(category);
    categoryFilter = `AND r.category = $${params.length}`;
  }

  const result = await pool.query(
    `SELECT ${RECIPE_FIELDS} FROM recipes r
     JOIN users u ON u.id = r.author_id
     WHERE r.status = 'approved' ${categoryFilter}
     ORDER BY r.created_at DESC`,
    params
  );
  const withIngredients = await attachIngredients(result.rows);
  res.json({ recipes: await attachFavoriteFlag(withIngredients, req.user?.id) });
});

// Recettes de l'utilisateur connecté, tous statuts confondus
router.get("/mine", requireAuth, async (req, res) => {
  const result = await pool.query(
    `SELECT ${RECIPE_FIELDS} FROM recipes r
     JOIN users u ON u.id = r.author_id
     WHERE r.author_id = $1
     ORDER BY r.created_at DESC`,
    [req.user!.id]
  );
  res.json({ recipes: await attachIngredients(result.rows) });
});

// Recettes mises en favoris par l'utilisateur connecté
router.get("/favorites", requireAuth, async (req, res) => {
  const result = await pool.query(
    `SELECT ${RECIPE_FIELDS} FROM recipes r
     JOIN users u ON u.id = r.author_id
     JOIN favorites f ON f.recipe_id = r.id
     WHERE f.user_id = $1
     ORDER BY f.created_at DESC`,
    [req.user!.id]
  );
  const withIngredients = await attachIngredients(result.rows);
  res.json({ recipes: withIngredients.map((r) => ({ ...r, isFavorite: true })) });
});

// Nombre de recettes approuvées par catégorie (page d'accueil, tuiles de
// catégories) : évite de charger la liste complète de chaque catégorie juste
// pour un compteur. Doit rester déclarée avant "/:id" pour ne pas être
// interprétée comme un id de recette.
router.get("/counts", async (_req, res) => {
  const result = await pool.query<{ category: string; count: string }>(
    `SELECT category, COUNT(*)::int AS count FROM recipes WHERE status = 'approved' GROUP BY category`
  );
  const counts = Object.fromEntries(RECIPE_CATEGORIES.map((c) => [c, 0]));
  for (const row of result.rows) {
    counts[row.category] = Number(row.count);
  }
  res.json({ counts });
});

// Sert la photo binaire d'une recette (indépendant de RECIPE_FIELDS, qui n'expose
// que le booléen "hasPhoto" pour ne pas alourdir les listes).
router.get("/:id/photo", async (req, res) => {
  const result = await pool.query("SELECT photo FROM recipes WHERE id = $1", [req.params.id]);
  const photo = result.rows[0]?.photo;
  if (!photo) {
    return res.status(404).json({ error: "Aucune photo pour cette recette." });
  }
  res.set("Content-Type", "image/jpeg");
  // "no-cache" (pas "no-store") : le navigateur peut garder une copie mais doit
  // la revalider avant de l'utiliser. Sans ça, l'URL etant toujours la même
  // ("/recipes/:id/photo"), un "max-age" laissait le navigateur réafficher
  // l'ancienne photo (avant recadrage) pendant une heure après une modification.
  res.set("Cache-Control", "private, no-cache");
  res.send(photo);
});

// Détail d'une recette (visible si approuvée, ou si l'auteur/l'admin la consulte)
router.get("/:id", optionalAuth, async (req, res) => {
  const result = await pool.query(
    `SELECT ${RECIPE_FIELDS} FROM recipes r
     JOIN users u ON u.id = r.author_id
     WHERE r.id = $1`,
    [req.params.id]
  );
  const recipe = result.rows[0];
  if (!recipe) {
    return res.status(404).json({ error: "Recette introuvable." });
  }

  if (recipe.status !== "approved") {
    const isOwner = req.user?.id === recipe.author_id;
    const isAdmin = req.user?.role === "admin";
    if (!isOwner && !isAdmin) {
      return res.status(404).json({ error: "Recette introuvable." });
    }
  }

  const [enriched] = await attachIngredients([recipe]);
  const [withFavorite] = await attachFavoriteFlag([enriched], req.user?.id);
  res.json({ recipe: withFavorite });
});

// Création d'une recette par un utilisateur connecté (statut initial: pending)
router.post("/", requireAuth, async (req, res) => {
  const parsed = recipeSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0].message });
  }
  const { title, description, steps, servings, category, photoBase64, ingredients } = parsed.data;

  const photo = photoBase64 ? decodePhotoBase64(photoBase64) : null;
  if (photo && photo.length > MAX_PHOTO_BYTES) {
    return res.status(400).json({ error: "Image trop volumineuse." });
  }

  const result = await pool.query(
    `INSERT INTO recipes (title, description, steps, servings, category, photo, photo_updated_at, author_id, status)
     VALUES ($1, $2, $3, $4, $5, $6, CASE WHEN $6::bytea IS NULL THEN NULL ELSE now() END, $7, 'pending')
     RETURNING id, title, description, steps, servings, category, status, created_at, author_id,
               (photo IS NOT NULL) AS "hasPhoto",
               EXTRACT(EPOCH FROM photo_updated_at)::bigint AS "photoVersion"`,
    [title, description, steps, servings, category, photo, req.user!.id]
  );
  const recipe = result.rows[0];

  await writeIngredients(recipe.id, ingredients);

  const [enriched] = await attachIngredients([recipe]);
  res.status(201).json({ recipe: enriched });
});

// Modification par l'auteur (tant que la recette est en attente) ou par un admin (toujours)
router.put("/:id", requireAuth, async (req, res) => {
  const parsed = recipeSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0].message });
  }

  const existing = await pool.query("SELECT author_id, status FROM recipes WHERE id = $1", [
    req.params.id,
  ]);
  const recipe = existing.rows[0];
  if (!recipe) {
    return res.status(404).json({ error: "Recette introuvable." });
  }
  const isOwner = recipe.author_id === req.user!.id;
  const isAdmin = req.user!.role === "admin";
  if (!isOwner && !isAdmin) {
    return res.status(403).json({ error: "Accès refusé." });
  }
  if (!isAdmin && recipe.status !== "pending") {
    return res.status(409).json({ error: "Seule une recette en attente peut être modifiée." });
  }

  const { title, description, steps, servings, category, photoBase64, ingredients } = parsed.data;

  if (photoBase64) {
    const photo = decodePhotoBase64(photoBase64);
    if (photo.length > MAX_PHOTO_BYTES) {
      return res.status(400).json({ error: "Image trop volumineuse." });
    }
  }

  await pool.query(
    `UPDATE recipes SET title = $1, description = $2, steps = $3, servings = $4, category = $5
     WHERE id = $6`,
    [title, description, steps, servings, category, req.params.id]
  );

  // photoBase64 absent du payload (undefined) => la photo existante n'est pas touchée.
  // Horodater le changement (même en cas de suppression) : c'est ce qui permet
  // au client de "casser" le cache navigateur en changeant l'URL de la photo.
  if (photoBase64 !== undefined) {
    const photo = photoBase64 === null ? null : decodePhotoBase64(photoBase64);
    await pool.query("UPDATE recipes SET photo = $1, photo_updated_at = now() WHERE id = $2", [
      photo,
      req.params.id,
    ]);
  }

  await writeIngredients(Number(req.params.id), ingredients);

  const updated = await pool.query(
    `SELECT id, title, description, steps, servings, category, status, created_at, author_id,
            (photo IS NOT NULL) AS "hasPhoto",
            EXTRACT(EPOCH FROM photo_updated_at)::bigint AS "photoVersion"
     FROM recipes WHERE id = $1`,
    [req.params.id]
  );

  const [enriched] = await attachIngredients([updated.rows[0]]);
  res.json({ recipe: enriched });
});

// Suppression par l'auteur (tant que la recette est en attente) ou par un admin (toujours)
router.delete("/:id", requireAuth, async (req, res) => {
  const existing = await pool.query("SELECT author_id, status FROM recipes WHERE id = $1", [
    req.params.id,
  ]);
  const recipe = existing.rows[0];
  if (!recipe) {
    return res.status(404).json({ error: "Recette introuvable." });
  }
  const isOwner = recipe.author_id === req.user!.id;
  const isAdmin = req.user!.role === "admin";
  if (!isOwner && !isAdmin) {
    return res.status(403).json({ error: "Accès refusé." });
  }
  if (!isAdmin && recipe.status !== "pending") {
    return res.status(409).json({ error: "Seule une recette en attente peut être supprimée." });
  }

  await pool.query("DELETE FROM recipes WHERE id = $1", [req.params.id]);
  res.status(204).send();
});

// Ajout / retrait d'une recette dans les favoris de l'utilisateur connecté
router.post("/:id/favorite", requireAuth, async (req, res) => {
  const existing = await pool.query("SELECT id FROM recipes WHERE id = $1", [req.params.id]);
  if (!existing.rowCount) {
    return res.status(404).json({ error: "Recette introuvable." });
  }
  await pool.query(
    "INSERT INTO favorites (user_id, recipe_id) VALUES ($1, $2) ON CONFLICT DO NOTHING",
    [req.user!.id, req.params.id]
  );
  res.status(204).send();
});

router.delete("/:id/favorite", requireAuth, async (req, res) => {
  await pool.query("DELETE FROM favorites WHERE user_id = $1 AND recipe_id = $2", [
    req.user!.id,
    req.params.id,
  ]);
  res.status(204).send();
});

export default router;
