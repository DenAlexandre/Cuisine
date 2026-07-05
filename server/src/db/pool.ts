import { Pool } from "pg";

// Neon (et la plupart des Postgres managés) exigent TLS mais présentent un
// certificat que le client pg ne valide pas toujours correctement par défaut.
// "rejectUnauthorized: false" chiffre quand même la connexion, seule la
// vérification stricte de la chaîne de certificats est désactivée. Inutile en
// local (Docker, sans TLS) : activé uniquement si l'URL le demande explicitement.
const useSsl = process.env.DATABASE_URL?.includes("sslmode=require") ?? false;

export const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: useSsl ? { rejectUnauthorized: false } : undefined,
});
