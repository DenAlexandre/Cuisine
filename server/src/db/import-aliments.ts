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

// Categorisation "cuisine du quotidien" en un seul niveau, pensee pour choisir un
// ingredient rapidement plutot que pour la nomenclature nutritionnelle complete.
const CATEGORIES_SQL = `
INSERT INTO categories_simples (code, nom) VALUES
  (1, 'Fruits'),
  (2, 'Légumes'),
  (3, 'Viandes, poissons & œufs'),
  (4, 'Produits laitiers'),
  (5, 'Féculents & céréales'),
  (6, 'Matières grasses & sauces'),
  (7, 'Produits sucrés & desserts'),
  (8, 'Boissons'),
  (9, 'Aides culinaires & épices'),
  (10, 'Plats préparés'),
  (11, 'Aliments infantiles')
ON CONFLICT (code) DO UPDATE SET nom = EXCLUDED.nom;
`;

// Un seul aliment (code groupe 0, "Dessert (aliment moyen)") tombe dans le cas
// par defaut ci-dessous ; tous les autres groupes sont mappes explicitement.
const CATEGORIZE_ALIMENTS_SQL = `
UPDATE aliments SET categorie_code = CASE
  WHEN t_groupe_code = 1 THEN 10
  WHEN t_groupe_code = 2 AND t_ss_groupe_code IN (204, 205) THEN 1
  WHEN t_groupe_code = 2 THEN 2
  WHEN t_groupe_code = 3 THEN 5
  WHEN t_groupe_code = 4 THEN 3
  WHEN t_groupe_code = 5 THEN 4
  WHEN t_groupe_code = 6 THEN 8
  WHEN t_groupe_code = 7 THEN 7
  WHEN t_groupe_code = 8 THEN 7
  WHEN t_groupe_code = 9 THEN 6
  WHEN t_groupe_code = 10 THEN 9
  WHEN t_groupe_code = 11 THEN 11
  ELSE 7
END;

ALTER TABLE aliments DROP CONSTRAINT IF EXISTS fk_aliments_categorie;
ALTER TABLE aliments ALTER COLUMN categorie_code SET NOT NULL;
ALTER TABLE aliments
  ADD CONSTRAINT fk_aliments_categorie FOREIGN KEY (categorie_code) REFERENCES categories_simples(code);
`;

async function importAliments() {
  const sql = readFileSync(join(__dirname, "seed-data", "aliments.sql"), "utf-8");
  await pool.query(sql);

  await pool.query(GROUPES_SQL);
  await pool.query(SOUS_GROUPES_SQL);
  await pool.query(SOUS_SOUS_GROUPES_SQL);
  await pool.query(LINK_ALIMENTS_SQL);
  await pool.query(CATEGORIES_SQL);
  await pool.query(CATEGORIZE_ALIMENTS_SQL);

  const { rows } = await pool.query("SELECT COUNT(*)::int AS count FROM aliments");
  const { rows: categoryRows } = await pool.query(
    "SELECT COUNT(*)::int AS count FROM categories_simples"
  );
  console.log(
    `Base Nutrition importée : ${rows[0].count} aliments, ${categoryRows[0].count} catégories.`
  );
  await pool.end();
}

importAliments().catch((err) => {
  console.error(err);
  process.exit(1);
});
