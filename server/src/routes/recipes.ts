import { Router } from "express";
import { z } from "zod";
import { pool } from "../db/pool";
import { optionalAuth, requireAuth } from "../middleware/auth";

const router = Router();

const recipeSchema = z.object({
  title: z.string().min(3).max(255),
  description: z.string().min(1),
  steps: z.string().min(1),
  ingredients: z
    .array(
      z.object({
        alimentCode: z.number().int(),
        quantityG: z.number().positive(),
      })
    )
    .min(1, "Au moins un ingrédient est requis."),
});

const RECIPE_FIELDS = `
  r.id, r.title, r.description, r.steps, r.status,
  r.created_at, r.reviewed_at, r.author_id, u.username AS author_username
`;

interface IngredientRow {
  recipe_id: number;
  aliment_code: number;
  quantity_g: string;
  nom: string;
  t_proteines: string | null;
  t_glucides: string | null;
  t_lipides: string | null;
  t_energie: string | null;
}

function num(value: string | null): number {
  return value === null ? 0 : Number(value);
}

// Attache la liste des ingrédients et le total nutritionnel calculé à chaque recette.
export async function attachIngredients<T extends { id: number }>(recipes: T[]) {
  if (recipes.length === 0) return recipes as (T & { ingredients: unknown[]; nutrition: unknown })[];

  const { rows } = await pool.query<IngredientRow>(
    `SELECT ri.recipe_id, ri.aliment_code, ri.quantity_g,
            a.t_aliment_nom AS nom, a.t_proteines, a.t_glucides, a.t_lipides, a.t_energie
     FROM recipe_ingredients ri
     JOIN aliments a ON a.t_aliment_code = ri.aliment_code
     WHERE ri.recipe_id = ANY($1::int[])
     ORDER BY ri.id ASC`,
    [recipes.map((r) => r.id)]
  );

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
      quantityG: num(row.quantity_g),
      proteines: row.t_proteines === null ? null : num(row.t_proteines),
      glucides: row.t_glucides === null ? null : num(row.t_glucides),
      lipides: row.t_lipides === null ? null : num(row.t_lipides),
      energie: row.t_energie === null ? null : num(row.t_energie),
    }));

    const nutrition = ingredientRows.reduce(
      (total, row) => {
        const factor = num(row.quantity_g) / 100;
        total.proteines += factor * num(row.t_proteines);
        total.glucides += factor * num(row.t_glucides);
        total.lipides += factor * num(row.t_lipides);
        total.energie += factor * num(row.t_energie);
        return total;
      },
      { proteines: 0, glucides: 0, lipides: 0, energie: 0 }
    );

    return { ...recipe, ingredients, nutrition };
  });
}

async function writeIngredients(recipeId: number, ingredients: { alimentCode: number; quantityG: number }[]) {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    await client.query("DELETE FROM recipe_ingredients WHERE recipe_id = $1", [recipeId]);
    for (const item of ingredients) {
      await client.query(
        `INSERT INTO recipe_ingredients (recipe_id, aliment_code, quantity_g) VALUES ($1, $2, $3)`,
        [recipeId, item.alimentCode, item.quantityG]
      );
    }
    await client.query("COMMIT");
  } catch (err) {
    await client.query("ROLLBACK");
    throw err;
  } finally {
    client.release();
  }
}

// Liste publique des recettes approuvées
router.get("/", async (_req, res) => {
  const result = await pool.query(
    `SELECT ${RECIPE_FIELDS} FROM recipes r
     JOIN users u ON u.id = r.author_id
     WHERE r.status = 'approved'
     ORDER BY r.created_at DESC`
  );
  res.json({ recipes: await attachIngredients(result.rows) });
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
  res.json({ recipe: enriched });
});

// Création d'une recette par un utilisateur connecté (statut initial: pending)
router.post("/", requireAuth, async (req, res) => {
  const parsed = recipeSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0].message });
  }
  const { title, description, steps, ingredients } = parsed.data;

  const result = await pool.query(
    `INSERT INTO recipes (title, description, steps, author_id, status)
     VALUES ($1, $2, $3, $4, 'pending')
     RETURNING id, title, description, steps, status, created_at, author_id`,
    [title, description, steps, req.user!.id]
  );
  const recipe = result.rows[0];

  await writeIngredients(recipe.id, ingredients);

  const [enriched] = await attachIngredients([recipe]);
  res.status(201).json({ recipe: enriched });
});

// Modification par l'auteur, uniquement tant que la recette est en attente
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
  if (recipe.author_id !== req.user!.id) {
    return res.status(403).json({ error: "Accès refusé." });
  }
  if (recipe.status !== "pending") {
    return res.status(409).json({ error: "Seule une recette en attente peut être modifiée." });
  }

  const { title, description, steps, ingredients } = parsed.data;
  const result = await pool.query(
    `UPDATE recipes SET title = $1, description = $2, steps = $3
     WHERE id = $4
     RETURNING id, title, description, steps, status, created_at, author_id`,
    [title, description, steps, req.params.id]
  );

  await writeIngredients(result.rows[0].id, ingredients);

  const [enriched] = await attachIngredients([result.rows[0]]);
  res.json({ recipe: enriched });
});

// Suppression par l'auteur, uniquement tant que la recette est en attente
router.delete("/:id", requireAuth, async (req, res) => {
  const existing = await pool.query("SELECT author_id, status FROM recipes WHERE id = $1", [
    req.params.id,
  ]);
  const recipe = existing.rows[0];
  if (!recipe) {
    return res.status(404).json({ error: "Recette introuvable." });
  }
  if (recipe.author_id !== req.user!.id) {
    return res.status(403).json({ error: "Accès refusé." });
  }
  if (recipe.status !== "pending") {
    return res.status(409).json({ error: "Seule une recette en attente peut être supprimée." });
  }

  await pool.query("DELETE FROM recipes WHERE id = $1", [req.params.id]);
  res.status(204).send();
});

export default router;
