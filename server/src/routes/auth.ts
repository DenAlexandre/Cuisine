import { Router } from "express";
import bcrypt from "bcrypt";
import { z } from "zod";
import { pool } from "../db/pool";
import { signToken } from "../utils/jwt";
import { requireAuth } from "../middleware/auth";

const router = Router();

const credentialsSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8, "Le mot de passe doit contenir au moins 8 caractères."),
});

const COOKIE_OPTIONS = {
  httpOnly: true,
  sameSite: "lax" as const,
  secure: process.env.NODE_ENV === "production",
  maxAge: 7 * 24 * 60 * 60 * 1000,
};

router.post("/register", async (req, res) => {
  const parsed = credentialsSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0].message });
  }
  const { email, password } = parsed.data;

  const existing = await pool.query("SELECT id FROM users WHERE email = $1", [email]);
  if (existing.rowCount) {
    return res.status(409).json({ error: "Un compte existe déjà avec cet email." });
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const result = await pool.query(
    `INSERT INTO users (email, password_hash, role) VALUES ($1, $2, 'user')
     RETURNING id, email, role`,
    [email, passwordHash]
  );
  const user = result.rows[0];

  const token = signToken({ id: user.id, role: user.role });
  res.cookie("token", token, COOKIE_OPTIONS);
  res.status(201).json({ user });
});

router.post("/login", async (req, res) => {
  const parsed = credentialsSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: "Email ou mot de passe invalide." });
  }
  const { email, password } = parsed.data;

  const result = await pool.query(
    "SELECT id, email, password_hash, role FROM users WHERE email = $1",
    [email]
  );
  const user = result.rows[0];
  if (!user || !(await bcrypt.compare(password, user.password_hash))) {
    return res.status(401).json({ error: "Email ou mot de passe invalide." });
  }

  const token = signToken({ id: user.id, role: user.role });
  res.cookie("token", token, COOKIE_OPTIONS);
  res.json({ user: { id: user.id, email: user.email, role: user.role } });
});

router.post("/logout", (_req, res) => {
  res.clearCookie("token", COOKIE_OPTIONS);
  res.status(204).send();
});

router.get("/me", requireAuth, async (req, res) => {
  const result = await pool.query(
    "SELECT id, email, role FROM users WHERE id = $1",
    [req.user!.id]
  );
  const user = result.rows[0];
  if (!user) {
    return res.status(404).json({ error: "Utilisateur introuvable." });
  }
  res.json({ user });
});

export default router;
