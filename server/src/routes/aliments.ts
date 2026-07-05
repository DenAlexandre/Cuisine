import { Router } from "express";
import { pool } from "../db/pool";

const router = Router();

const ALIMENT_FIELDS = `
  a.t_aliment_code AS code,
  a.t_aliment_nom AS nom,
  g.nom AS groupe,
  sg.nom AS "sousGroupe",
  ssg.nom AS "sousSousGroupe",
  a.t_proteines::float8 AS proteines,
  a.t_glucides::float8 AS glucides,
  a.t_lipides::float8 AS lipides,
  a.t_energie::float8 AS energie
`;

const ALIMENT_JOINS = `
  FROM aliments a
  LEFT JOIN groupes g ON g.code = a.t_groupe_code
  LEFT JOIN sous_groupes sg ON sg.groupe_code = a.t_groupe_code AND sg.code = a.t_ss_groupe_code
  LEFT JOIN sous_sous_groupes ssg
    ON ssg.groupe_code = a.t_groupe_code
    AND ssg.sous_groupe_code = a.t_ss_groupe_code
    AND ssg.code = a.t_ss_ss_groupe_code
`;

function parseIntParam(value: unknown): number | null {
  if (typeof value !== "string" || value.trim() === "") return null;
  const parsed = Number(value);
  return Number.isInteger(parsed) ? parsed : null;
}

// La recherche texte est utilisable seule, tout comme les filtres de groupe seuls :
// au moins un des deux doit être fourni pour renvoyer des résultats.
router.get("/", async (req, res) => {
  const q = typeof req.query.q === "string" ? req.query.q.trim() : "";
  const groupeCode = parseIntParam(req.query.groupe);
  const sousGroupeCode = parseIntParam(req.query.sousGroupe);
  const sousSousGroupeCode = parseIntParam(req.query.sousSousGroupe);

  const conditions: string[] = [];
  const params: unknown[] = [];

  if (q.length >= 2) {
    params.push(`%${q}%`);
    conditions.push(`a.t_aliment_nom ILIKE $${params.length}`);
  }
  if (groupeCode !== null) {
    params.push(groupeCode);
    conditions.push(`a.t_groupe_code = $${params.length}`);
  }
  if (sousGroupeCode !== null) {
    params.push(sousGroupeCode);
    conditions.push(`a.t_ss_groupe_code = $${params.length}`);
  }
  if (sousSousGroupeCode !== null) {
    params.push(sousSousGroupeCode);
    conditions.push(`a.t_ss_ss_groupe_code = $${params.length}`);
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
