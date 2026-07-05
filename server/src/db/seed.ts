import "dotenv/config";
import bcrypt from "bcrypt";
import { pool } from "./pool";

async function seed() {
  const email = process.env.SEED_ADMIN_EMAIL;
  const password = process.env.SEED_ADMIN_PASSWORD;

  if (!email || !password) {
    throw new Error(
      "SEED_ADMIN_EMAIL et SEED_ADMIN_PASSWORD doivent être définis dans .env"
    );
  }

  const passwordHash = await bcrypt.hash(password, 10);

  await pool.query(
    `INSERT INTO users (email, password_hash, role)
     VALUES ($1, $2, 'admin')
     ON CONFLICT (email) DO UPDATE SET role = 'admin'`,
    [email, passwordHash]
  );

  console.log(`Compte admin prêt : ${email}`);
  await pool.end();
}

seed().catch((err) => {
  console.error(err);
  process.exit(1);
});
