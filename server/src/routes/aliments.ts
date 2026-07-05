import { Router } from "express";
import { pool } from "../db/pool";

const router = Router();

const ALIMENT_FIELDS = `
  a.t_aliment_code AS code,
  a.t_aliment_nom AS nom,
  c.nom AS categorie,
  a.t_proteines::float8 AS proteines,
  a.t_glucides::float8 AS glucides,
  a.t_lipides::float8 AS lipides,
  a.t_energie::float8 AS energie
`;

const ALIMENT_JOINS = `
  FROM aliments a
  LEFT JOIN categories_simples c ON c.code = a.categorie_code
`;

function parseIntParam(value: unknown): number | null {
  if (typeof value !== "string" || value.trim() === "") return null;
  const parsed = Number(value);
  return Number.isInteger(parsed) ? parsed : null;
}

// La recherche texte est utilisable seule, tout comme le filtre de catégorie seul :
// au moins un des deux doit être fourni pour renvoyer des résultats.
router.get("/", async (req, res) => {
  const q = typeof req.query.q === "string" ? req.query.q.trim() : "";
  const categorieCode = parseIntParam(req.query.categorie);

  const conditions: string[] = [];
  const params: unknown[] = [];

  if (q.length >= 2) {
    params.push(`%${q}%`);
    conditions.push(`a.t_aliment_nom ILIKE $${params.length}`);
  }
  if (categorieCode !== null) {
    params.push(categorieCode);
    conditions.push(`a.categorie_code = $${params.length}`);
  }

  if (conditions.length === 0) {
    return res.json({ aliments: [] });
  }

  const result = await pool.query(
    `SELECT ${ALIMENT_FIELDS} ${ALIMENT_JOINS}
     WHERE ${conditions.join(" AND ")}
     ORDER BY a.t_aliment_nom ASC
     LIMIT 20`,
    params
  );
  res.json({ aliments: result.rows });
});

export default router;
