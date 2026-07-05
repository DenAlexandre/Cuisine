import "dotenv/config";
import { pool } from "./pool";

const SQL = `
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(30) NOT NULL,
  password_hash TEXT NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'user')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Mise a niveau des bases existantes creees avant l'ajout de ces colonnes.
ALTER TABLE users ADD COLUMN IF NOT EXISTS username VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS first_name VARCHAR(100);
ALTER TABLE users ADD COLUMN IF NOT EXISTS last_name VARCHAR(100);
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(30);

UPDATE users SET username = COALESCE(username, 'user' || id) WHERE username IS NULL;
UPDATE users SET first_name = COALESCE(first_name, 'Inconnu') WHERE first_name IS NULL;
UPDATE users SET last_name = COALESCE(last_name, 'Inconnu') WHERE last_name IS NULL;
UPDATE users SET phone = COALESCE(phone, '') WHERE phone IS NULL;

ALTER TABLE users ALTER COLUMN username SET NOT NULL;
ALTER TABLE users ALTER COLUMN first_name SET NOT NULL;
ALTER TABLE users ALTER COLUMN last_name SET NOT NULL;
ALTER TABLE users ALTER COLUMN phone SET NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS ux_users_username ON users(username);

CREATE TABLE IF NOT EXISTS recipes (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  steps TEXT NOT NULL,
  servings INTEGER NOT NULL DEFAULT 1 CHECK (servings > 0),
  category VARCHAR(20) NOT NULL DEFAULT 'plat' CHECK (category IN ('cocktail', 'entree', 'plat', 'dessert')),
  author_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  reviewed_at TIMESTAMPTZ,
  reviewed_by INTEGER REFERENCES users(id) ON DELETE SET NULL
);

-- Le champ "ingredients" en texte libre est remplace par la table recipe_ingredients ci-dessous.
ALTER TABLE recipes DROP COLUMN IF EXISTS ingredients;
ALTER TABLE recipes ADD COLUMN IF NOT EXISTS servings INTEGER NOT NULL DEFAULT 1 CHECK (servings > 0);

-- Categorie du plat (cocktail/entree/plat/dessert), utilisee pour le classement
-- visuel de la page Recettes. Les recettes existantes recoivent 'plat' par defaut.
ALTER TABLE recipes ADD COLUMN IF NOT EXISTS category VARCHAR(20);
ALTER TABLE recipes ALTER COLUMN category SET DEFAULT 'plat';
UPDATE recipes SET category = 'plat' WHERE category IS NULL;
ALTER TABLE recipes ALTER COLUMN category SET NOT NULL;
ALTER TABLE recipes DROP CONSTRAINT IF EXISTS recipes_category_check;
ALTER TABLE recipes ADD CONSTRAINT recipes_category_check
  CHECK (category IN ('cocktail', 'entree', 'plat', 'dessert'));

-- Photo de la recette (deja recadree/compressee cote client avant envoi).
ALTER TABLE recipes ADD COLUMN IF NOT EXISTS photo BYTEA;

CREATE INDEX IF NOT EXISTS idx_recipes_status ON recipes(status);
CREATE INDEX IF NOT EXISTS idx_recipes_author ON recipes(author_id);
CREATE INDEX IF NOT EXISTS idx_recipes_category ON recipes(category);

-- Reference nutritionnelle importee depuis le projet Nutrition (voir db/import-aliments.ts).
CREATE TABLE IF NOT EXISTS aliments (
  t_groupe_code INTEGER,
  t_ss_groupe_code INTEGER,
  t_ss_ss_groupe_code INTEGER,
  t_groupe_nom TEXT,
  t_ss_groupe_nom TEXT,
  t_ss_ss_groupe_nom TEXT,
  t_aliment_code INTEGER PRIMARY KEY,
  t_aliment_nom TEXT NOT NULL,
  t_proteines NUMERIC,
  t_glucides NUMERIC,
  t_lipides NUMERIC,
  t_energie NUMERIC
);

-- Groupes/sous-groupes/sous-sous-groupes : deduits des donnees d'aliments par
-- db/import-aliments.ts, qui ajoute ensuite les FK depuis "aliments" (voir ce fichier).
CREATE TABLE IF NOT EXISTS groupes (
  code INTEGER PRIMARY KEY,
  nom TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sous_groupes (
  groupe_code INTEGER NOT NULL REFERENCES groupes(code),
  code INTEGER NOT NULL,
  nom TEXT NOT NULL,
  PRIMARY KEY (groupe_code, code)
);

CREATE TABLE IF NOT EXISTS sous_sous_groupes (
  groupe_code INTEGER NOT NULL,
  sous_groupe_code INTEGER NOT NULL,
  code INTEGER NOT NULL,
  nom TEXT NOT NULL,
  PRIMARY KEY (groupe_code, sous_groupe_code, code),
  FOREIGN KEY (groupe_code, sous_groupe_code) REFERENCES sous_groupes(groupe_code, code)
);

-- Categorisation simplifiee (un seul niveau) utilisee par l'interface, deduite
-- des groupes techniques ci-dessus par db/import-aliments.ts.
CREATE TABLE IF NOT EXISTS categories_simples (
  code INTEGER PRIMARY KEY,
  nom TEXT NOT NULL
);

-- La valeur par defaut n'est qu'un filet de securite pour que le ré-import brut
-- (qui ne renseigne pas cette colonne) ne bute pas sur la contrainte NOT NULL
-- avant meme la resolution du ON CONFLICT ; CATEGORIZE_ALIMENTS_SQL recalcule
-- ensuite la vraie categorie de chaque ligne.
ALTER TABLE aliments ADD COLUMN IF NOT EXISTS categorie_code INTEGER;
ALTER TABLE aliments ALTER COLUMN categorie_code SET DEFAULT 7;

-- Degre d'alcool (%), pertinent uniquement pour les aliments de la categorie "Boissons".
ALTER TABLE aliments ADD COLUMN IF NOT EXISTS degre_alcool NUMERIC;

-- Note libre optionnelle (allergenes, conseil de conservation, etc.).
ALTER TABLE aliments ADD COLUMN IF NOT EXISTS info_complementaire TEXT;

-- Codes attribues aux aliments crees depuis l'interface admin (voir routes/aliments.ts),
-- dans une plage qui ne recoupe jamais les codes CIQUAL importes (tous < 100000).
CREATE SEQUENCE IF NOT EXISTS aliments_custom_code_seq START WITH 900000;

CREATE TABLE IF NOT EXISTS recipe_ingredients (
  id SERIAL PRIMARY KEY,
  recipe_id INTEGER NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  aliment_code INTEGER NOT NULL REFERENCES aliments(t_aliment_code),
  quantity_g NUMERIC NOT NULL CHECK (quantity_g > 0),
  UNIQUE (recipe_id, aliment_code)
);

CREATE INDEX IF NOT EXISTS idx_recipe_ingredients_recipe ON recipe_ingredients(recipe_id);

-- "quantity_g" devient "quantity" car les boissons s'y expriment desormais en cl
-- (voir colonne "unit" ci-dessous), pas seulement en grammes.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'recipe_ingredients' AND column_name = 'quantity_g'
  ) THEN
    ALTER TABLE recipe_ingredients RENAME COLUMN quantity_g TO quantity;
  END IF;
END $$;

ALTER TABLE recipe_ingredients ADD COLUMN IF NOT EXISTS unit VARCHAR(10);
ALTER TABLE recipe_ingredients ALTER COLUMN unit SET DEFAULT 'g';
UPDATE recipe_ingredients SET unit = 'g' WHERE unit IS NULL;
ALTER TABLE recipe_ingredients ALTER COLUMN unit SET NOT NULL;
ALTER TABLE recipe_ingredients DROP CONSTRAINT IF EXISTS recipe_ingredients_unit_check;
ALTER TABLE recipe_ingredients ADD CONSTRAINT recipe_ingredients_unit_check CHECK (unit IN ('g', 'cl'));

-- Filet de securite : la contrainte inline ci-dessus ne s'applique qu'a la creation
-- initiale de la table. Si "aliments" a deja ete recreee via un DROP ... CASCADE
-- (ce qui arrive au moins une fois dans l'historique de ce projet), la contrainte
-- est perdue et CREATE TABLE IF NOT EXISTS ne la restaure pas. On nettoie d'abord
-- les lignes orphelines (sinon ADD CONSTRAINT echoue sur les donnees existantes),
-- puis on reassert la contrainte.
DELETE FROM recipe_ingredients ri
WHERE NOT EXISTS (SELECT 1 FROM aliments a WHERE a.t_aliment_code = ri.aliment_code);

ALTER TABLE recipe_ingredients DROP CONSTRAINT IF EXISTS recipe_ingredients_aliment_code_fkey;
ALTER TABLE recipe_ingredients
  ADD CONSTRAINT recipe_ingredients_aliment_code_fkey
  FOREIGN KEY (aliment_code) REFERENCES aliments(t_aliment_code);

CREATE TABLE IF NOT EXISTS favorites (
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  recipe_id INTEGER NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, recipe_id)
);

-- Suivi du poids (page IMC) : chaque pesee est horodatee cote serveur.
-- height_cm/bmi ne sont renseignes que lorsque l'utilisateur enregistre un
-- calcul d'IMC complet (sinon simple saisie de poids seul, via "Entrer mon
-- poids aujourd'hui").
CREATE TABLE IF NOT EXISTS weight_entries (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  weight_kg NUMERIC NOT NULL CHECK (weight_kg > 0),
  recorded_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE weight_entries ADD COLUMN IF NOT EXISTS height_cm NUMERIC;
ALTER TABLE weight_entries ADD COLUMN IF NOT EXISTS bmi NUMERIC;

CREATE INDEX IF NOT EXISTS idx_weight_entries_user ON weight_entries(user_id);
`;

async function migrate() {
  await pool.query(SQL);
  console.log("Migration terminée.");
  await pool.end();
}

migrate().catch((err) => {
  console.error(err);
  process.exit(1);
});
