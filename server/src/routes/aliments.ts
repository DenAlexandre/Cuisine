import { Router } from "express";
import { z } from "zod";
import { pool } from "../db/pool";
import { requireAuth, requireRole } from "../middleware/auth";

const router = Router();

const ALIMENT_FIELDS = `
  a.t_aliment_code AS code,
  a.t_aliment_nom AS nom,
  c.nom AS categorie,
  a.categorie_code AS "categorieCode",
  a.t_proteines::float8 AS proteines,
  a.t_glucides::float8 AS glucides,
  a.t_lipides::float8 AS lipides,
  a.t_energie::float8 AS energie,
  a.degre_alcool::float8 AS "degreAlcool",
  a.info_complementaire AS "infoComplementaire",
  a.poids_unitaire_g::float8 AS "poidsUnitaireG",
  a.libelle_unite AS "libelleUnite"
`;

const ALIMENT_JOINS = `
  FROM aliments a
  LEFT JOIN categories_simples c ON c.code = a.categorie_code
`;

const alimentSchema = z
  .object({
    nom: z.string().min(1, "Le nom est requis.").max(255),
    categorieCode: z.number().int(),
    proteines: z.number().nonnegative().nullable(),
    glucides: z.number().nonnegative().nullable(),
    lipides: z.number().nonnegative().nullable(),
    energie: z.number().nonnegative().nullable(),
    degreAlcool: z.number().min(0).max(100).nullable(),
    infoComplementaire: z.string().max(2000).nullable(),
    // Permet de saisir cet aliment "à la pièce" (ex: 2 oeufs) plutôt qu'en
    // grammes : les deux champs vont toujours ensemble (l'un sans l'autre n'a
    // pas de sens pour convertir la quantité en grammes ni l'afficher).
    poidsUnitaireG: z.number().positive().nullable(),
    libelleUnite: z.string().max(50).nullable(),
  })
  .refine((data) => (data.poidsUnitaireG === null) === (data.libelleUnite === null), {
    message: "Le poids par unité et son libellé doivent être renseignés ensemble.",
    path: ["libelleUnite"],
  });

function parseIntParam(value: unknown): number | null {
  if (typeof value !== "string" || value.trim() === "") return null;
  const parsed = Number(value);
  return Number.isInteger(parsed) ? parsed : null;
}

async function fetchAlimentByCode(code: number) {
  const result = await pool.query(
    `SELECT ${ALIMENT_FIELDS} ${ALIMENT_JOINS} WHERE a.t_aliment_code = $1`,
    [code]
  );
  return result.rows[0] ?? null;
}

function isForeignKeyViolation(err: unknown): boolean {
  return typeof err === "object" && err !== null && "code" in err && err.code === "23503";
}

// La recherche texte est utilisable seule, tout comme le filtre de catégorie seul :
// au moins un des deux doit être fourni pour renvoyer des résultats.
//
// La base CIQUAL importée contient ~3185 aliments avec de nombreuses variantes
// très détaillées d'un même produit (cuisson, découpe, marque...). Un tri
// purement alphabétique noie les aliments génériques recherchés sous ces
// variantes. On garde l'exhaustivité (aucun aliment filtré) mais on fait
// remonter en priorité : 1) les noms qui commencent par la recherche plutôt
// qu'un match au milieu d'une liste de qualificatifs, 2) les noms les plus
// simples (peu de virgules, plus courts) avant les variantes détaillées.
router.get("/", async (req, res) => {
  const q = typeof req.query.q === "string" ? req.query.q.trim() : "";
  const categorieCode = parseIntParam(req.query.categorie);

  const conditions: string[] = [];
  const orderClauses: string[] = [];
  const params: unknown[] = [];

  if (q.length >= 2) {
    params.push(`%${q}%`);
    conditions.push(`a.t_aliment_nom ILIKE $${params.length}`);

    params.push(`${q}%`);
    orderClauses.push(`(a.t_aliment_nom ILIKE $${params.length}) DESC`);
  }
  if (categorieCode !== null) {
    params.push(categorieCode);
    conditions.push(`a.categorie_code = $${params.length}`);
  }

  if (conditions.length === 0) {
    return res.json({ aliments: [] });
  }

  orderClauses.push(
    "(length(a.t_aliment_nom) - length(replace(a.t_aliment_nom, ',', ''))) ASC",
    "length(a.t_aliment_nom) ASC",
    "a.t_aliment_nom ASC"
  );

  const result = await pool.query(
    `SELECT ${ALIMENT_FIELDS} ${ALIMENT_JOINS}
     WHERE ${conditions.join(" AND ")}
     ORDER BY ${orderClauses.join(", ")}
     LIMIT 20`,
    params
  );
  res.json({ aliments: result.rows });
});

// Création d'un aliment (admin uniquement). Le code est généré automatiquement
// dans une plage dédiée qui ne recoupe jamais les codes CIQUAL importés.
router.post("/", requireAuth, requireRole("admin"), async (req, res) => {
  const parsed = alimentSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0].message });
  }
  const {
    nom,
    categorieCode,
    proteines,
    glucides,
    lipides,
    energie,
    degreAlcool,
    infoComplementaire,
    poidsUnitaireG,
    libelleUnite,
  } = parsed.data;

  const result = await pool.query(
    `INSERT INTO aliments (t_aliment_code, t_aliment_nom, categorie_code, t_proteines, t_glucides, t_lipides, t_energie, degre_alcool, info_complementaire, poids_unitaire_g, libelle_unite)
     VALUES (nextval('aliments_custom_code_seq'), $1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
     RETURNING t_aliment_code`,
    [
      nom,
      categorieCode,
      proteines,
      glucides,
      lipides,
      energie,
      degreAlcool,
      infoComplementaire,
      poidsUnitaireG,
      libelleUnite,
    ]
  );

  const aliment = await fetchAlimentByCode(result.rows[0].t_aliment_code);
  res.status(201).json({ aliment });
});

// Modification d'un aliment existant (admin uniquement, CIQUAL ou personnalisé).
router.put("/:code", requireAuth, requireRole("admin"), async (req, res) => {
  const parsed = alimentSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0].message });
  }
  const {
    nom,
    categorieCode,
    proteines,
    glucides,
    lipides,
    energie,
    degreAlcool,
    infoComplementaire,
    poidsUnitaireG,
    libelleUnite,
  } = parsed.data;

  const result = await pool.query(
    `UPDATE aliments
     SET t_aliment_nom = $1, categorie_code = $2, t_proteines = $3, t_glucides = $4, t_lipides = $5, t_energie = $6, degre_alcool = $7, info_complementaire = $8, poids_unitaire_g = $9, libelle_unite = $10
     WHERE t_aliment_code = $11`,
    [
      nom,
      categorieCode,
      proteines,
      glucides,
      lipides,
      energie,
      degreAlcool,
      infoComplementaire,
      poidsUnitaireG,
      libelleUnite,
      req.params.code,
    ]
  );
  if (!result.rowCount) {
    return res.status(404).json({ error: "Aliment introuvable." });
  }

  const aliment = await fetchAlimentByCode(Number(req.params.code));
  res.json({ aliment });
});

// Suppression (admin uniquement). Refusée si l'aliment est utilisé dans une recette.
router.delete("/:code", requireAuth, requireRole("admin"), async (req, res) => {
  try {
    const result = await pool.query("DELETE FROM aliments WHERE t_aliment_code = $1", [
      req.params.code,
    ]);
    if (!result.rowCount) {
      return res.status(404).json({ error: "Aliment introuvable." });
    }
    res.status(204).send();
  } catch (err) {
    if (isForeignKeyViolation(err)) {
      return res.status(409).json({
        error: "Cet aliment est utilisé dans une ou plusieurs recettes et ne peut pas être supprimé.",
      });
    }
    throw err;
  }
});

export default router;
