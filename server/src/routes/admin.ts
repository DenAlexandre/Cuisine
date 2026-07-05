import { Router } from "express";
import bcrypt from "bcrypt";
import { z } from "zod";
import { pool } from "../db/pool";
import { requireAuth, requireRole } from "../middleware/auth";
import { attachIngredients } from "./recipes";

const router = Router();

router.use(requireAuth, requireRole("admin"));

router.get("/recipes/pending", async (_req, res) => {
  const result = await pool.query(
    `SELECT r.id, r.title, r.description, r.steps, r.status,
            r.created_at, r.author_id, u.username AS author_username
     FROM recipes r
     JOIN users u ON u.id = r.author_id
     WHERE r.status = 'pending'
     ORDER BY r.created_at ASC`
  );
  res.json({ recipes: await attachIngredients(result.rows) });
});

router.post("/recipes/:id/approve", async (req, res) => {
  const result = await pool.query(
    `UPDATE recipes SET status = 'approved', reviewed_at = now(), reviewed_by = $1
     WHERE id = $2 AND status = 'pending'
     RETURNING id, title, status`,
    [req.user!.id, req.params.id]
  );
  if (!result.rowCount) {
    return res.status(404).json({ error: "Recette en attente introuvable." });
  }
  res.json({ recipe: result.rows[0] });
});

router.post("/recipes/:id/reject", async (req, res) => {
  const result = await pool.query(
    `UPDATE recipes SET status = 'rejected', reviewed_at = now(), reviewed_by = $1
     WHERE id = $2 AND status = 'pending'
     RETURNING id, title, status`,
    [req.user!.id, req.params.id]
  );
  if (!result.rowCount) {
    return res.status(404).json({ error: "Recette en attente introuvable." });
  }
  res.json({ recipe: result.rows[0] });
});

const USER_FIELDS = `
  id, username, first_name AS "firstName", last_name AS "lastName",
  email, phone, role, created_at AS "createdAt"
`;

const userUpdateSchema = z.object({
  username: z
    .string()
    .min(3, "Le pseudo doit contenir au moins 3 caractères.")
    .max(50)
    .regex(/^[a-zA-Z0-9_.-]+$/, "Le pseudo ne peut contenir que lettres, chiffres, '.', '_' ou '-'."),
  firstName: z.string().min(1, "Le prénom est requis."),
  lastName: z.string().min(1, "Le nom est requis."),
  email: z.string().email("Email invalide."),
  phone: z.string().min(6, "Numéro de téléphone invalide."),
  role: z.enum(["admin", "user"]),
});

const userCreateSchema = userUpdateSchema.extend({
  password: z.string().min(8, "Le mot de passe doit contenir au moins 8 caractères."),
});

// Liste des comptes (admin uniquement).
router.get("/users", async (_req, res) => {
  const result = await pool.query(`SELECT ${USER_FIELDS} FROM users ORDER BY username ASC`);
  res.json({ users: result.rows });
});

// Création d'un compte directement par un admin (rôle choisi dès la création).
router.post("/users", async (req, res) => {
  const parsed = userCreateSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0].message });
  }
  const { username, firstName, lastName, email, phone, role, password } = parsed.data;

  const conflict = await pool.query("SELECT id FROM users WHERE email = $1 OR username = $2", [
    email,
    username,
  ]);
  if (conflict.rowCount) {
    return res.status(409).json({ error: "Un compte existe déjà avec ce pseudo ou cet email." });
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const result = await pool.query(
    `INSERT INTO users (username, first_name, last_name, email, phone, password_hash, role)
     VALUES ($1, $2, $3, $4, $5, $6, $7)
     RETURNING ${USER_FIELDS}`,
    [username, firstName, lastName, email, phone, passwordHash, role]
  );
  res.status(201).json({ user: result.rows[0] });
});

// Modification d'un compte (profil + rôle). Un admin ne peut pas se retirer
// lui-même le rôle admin depuis cette page, pour éviter de se verrouiller dehors.
router.put("/users/:id", async (req, res) => {
  const parsed = userUpdateSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0].message });
  }
  const targetId = Number(req.params.id);
  const { username, firstName, lastName, email, phone, role } = parsed.data;

  if (targetId === req.user!.id && role !== "admin") {
    return res.status(400).json({ error: "Vous ne pouvez pas retirer votre propre rôle admin." });
  }

  const conflict = await pool.query(
    "SELECT id FROM users WHERE (email = $1 OR username = $2) AND id <> $3",
    [email, username, targetId]
  );
  if (conflict.rowCount) {
    return res.status(409).json({ error: "Un autre compte utilise déjà ce pseudo ou cet email." });
  }

  const result = await pool.query(
    `UPDATE users SET username = $1, first_name = $2, last_name = $3, email = $4, phone = $5, role = $6
     WHERE id = $7
     RETURNING ${USER_FIELDS}`,
    [username, firstName, lastName, email, phone, role, targetId]
  );
  if (!result.rowCount) {
    return res.status(404).json({ error: "Utilisateur introuvable." });
  }
  res.json({ user: result.rows[0] });
});

// Suppression d'un compte (admin uniquement). Un admin ne peut pas se supprimer
// lui-même depuis cette page. Les recettes/favoris/pesées du compte sont
// supprimés en cascade (contraintes existantes).
router.delete("/users/:id", async (req, res) => {
  const targetId = Number(req.params.id);
  if (targetId === req.user!.id) {
    return res.status(400).json({ error: "Vous ne pouvez pas supprimer votre propre compte." });
  }

  const result = await pool.query("DELETE FROM users WHERE id = $1", [targetId]);
  if (!result.rowCount) {
    return res.status(404).json({ error: "Utilisateur introuvable." });
  }
  res.status(204).send();
});

export default router;
