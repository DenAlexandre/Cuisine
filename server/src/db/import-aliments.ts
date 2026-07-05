import "dotenv/config";
import { readFileSync } from "fs";
import { join } from "path";
import { pool } from "./pool";

// Retient, pour un code donne, le nom le plus frequent parmi les aliments qui le
// portent (les noms vides ou "-" sont ecartes en priorite : ce sont des artefacts
// du dump source, pas des noms de groupe valides).
const GROUPES_SQL = `
INSERT INTO groupes (code, nom)
SELECT t_groupe_code, nom FROM (
  SELECT t_groupe_code, t_groupe_nom AS nom,
         ROW_NUMBER() OVER (
           PARTITION BY t_groupe_code
           ORDER BY (t_groupe_nom = '' OR t_groupe_nom = '-') ASC, COUNT(*) DESC
         ) AS rn
  FROM aliments
  GROUP BY t_groupe_code, t_groupe_nom
) ranked
WHERE rn = 1
ON CONFLICT (code) DO UPDATE SET nom = EXCLUDED.nom;
`;

const SOUS_GROUPES_SQL = `
INSERT INTO sous_groupes (groupe_code, code, nom)
SELECT t_groupe_code, t_ss_groupe_code, nom FROM (
  SELECT t_groupe_code, t_ss_groupe_code, t_ss_groupe_nom AS nom,
         ROW_NUMBER() OVER (
           PARTITION BY t_groupe_code, t_ss_groupe_code
           ORDER BY (t_ss_groupe_nom = '' OR t_ss_groupe_nom = '-') ASC, COUNT(*) DESC
         ) AS rn
  FROM aliments
  GROUP BY t_groupe_code, t_ss_groupe_code, t_ss_groupe_nom
) ranked
WHERE rn = 1
ON CONFLICT (groupe_code, code) DO UPDATE SET nom = EXCLUDED.nom;
`;

const SOUS_SOUS_GROUPES_SQL = `
INSERT INTO sous_sous_groupes (groupe_code, sous_groupe_code, code, nom)
SELECT t_groupe_code, t_ss_groupe_code, t_ss_ss_groupe_code, nom FROM (
  SELECT t_groupe_code, t_ss_groupe_code, t_ss_ss_groupe_code, t_ss_ss_groupe_nom AS nom,
         ROW_NUMBER() OVER (
           PARTITION BY t_groupe_code, t_ss_groupe_code, t_ss_ss_groupe_code
           ORDER BY (t_ss_ss_groupe_nom = '' OR t_ss_ss_groupe_nom = '-') ASC, COUNT(*) DESC
         ) AS rn
  FROM aliments
  GROUP BY t_groupe_code, t_ss_groupe_code, t_ss_ss_groupe_code, t_ss_ss_groupe_nom
) ranked
WHERE rn = 1
ON CONFLICT (groupe_code, sous_groupe_code, code) DO UPDATE SET nom = EXCLUDED.nom;
`;

// Ajoutee seulement une fois les tables de groupes peuplees : sinon la validation
// de la contrainte echouerait sur les 3185 lignes d'aliments deja presentes.
const LINK_ALIMENTS_SQL = `
ALTER TABLE aliments DROP CONSTRAINT IF EXISTS fk_aliments_groupe;
ALTER TABLE aliments DROP CONSTRAINT IF EXISTS fk_aliments_sous_groupe;
ALTER TABLE aliments DROP CONSTRAINT IF EXISTS fk_aliments_sous_sous_groupe;

ALTER TABLE aliments
  ADD CONSTRAINT fk_aliments_groupe
    FOREIGN KEY (t_groupe_code) REFERENCES groupes(code);
ALTER TABLE aliments
  ADD CONSTRAINT fk_aliments_sous_groupe
    FOREIGN KEY (t_groupe_code, t_ss_groupe_code) REFERENCES sous_groupes(groupe_code, code);
ALTER TABLE aliments
  ADD CONSTRAINT fk_aliments_sous_sous_groupe
    FOREIGN KEY (t_groupe_code, t_ss_groupe_code, t_ss_ss_groupe_code)
    REFERENCES sous_sous_groupes(groupe_code, sous_groupe_code, code);
`;

async function importAliments() {
  const sql = readFileSync(join(__dirname, "seed-data", "aliments.sql"), "utf-8");
  await pool.query(sql);

  await pool.query(GROUPES_SQL);
  await pool.query(SOUS_GROUPES_SQL);
  await pool.query(SOUS_SOUS_GROUPES_SQL);
  await pool.query(LINK_ALIMENTS_SQL);

  const { rows } = await pool.query("SELECT COUNT(*)::int AS count FROM aliments");
  const { rows: groupRows } = await pool.query("SELECT COUNT(*)::int AS count FROM groupes");
  console.log(
    `Base Nutrition importée : ${rows[0].count} aliments, ${groupRows[0].count} groupes.`
  );
  await pool.end();
}

importAliments().catch((err) => {
  console.error(err);
  process.exit(1);
});
