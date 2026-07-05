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
  author_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  reviewed_at TIMESTAMPTZ,
  reviewed_by INTEGER REFERENCES users(id) ON DELETE SET NULL
);

-- Le champ "ingredients" en texte libre est remplace par la table recipe_ingredients ci-dessous.
ALTER TABLE recipes DROP COLUMN IF EXISTS ingredients;
ALTER TABLE recipes ADD COLUMN IF NOT EXISTS servings INTEGER NOT NULL DEFAULT 1 CHECK (servings > 0);

CREATE INDEX IF NOT EXISTS idx_recipes_status ON recipes(status);
CREATE INDEX IF NOT EXISTS idx_recipes_author ON recipes(author_id);

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

CREATE TABLE IF NOT EXISTS recipe_ingredients (
  id SERIAL PRIMARY KEY,
  recipe_id INTEGER NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  aliment_code INTEGER NOT NULL REFERENCES aliments(t_aliment_code),
  quantity_g NUMERIC NOT NULL CHECK (quantity_g > 0),
  UNIQUE (recipe_id, aliment_code)
);

CREATE INDEX IF NOT EXISTS idx_recipe_ingredients_recipe ON recipe_ingredients(recipe_id);
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
