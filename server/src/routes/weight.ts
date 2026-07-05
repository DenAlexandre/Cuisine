import { Router } from "express";
import { z } from "zod";
import { pool } from "../db/pool";
import { requireAuth } from "../middleware/auth";

const router = Router();

const weightSchema = z.object({
  weightKg: z.number().positive().max(500),
  // Renseigné uniquement quand l'utilisateur enregistre un calcul d'IMC complet
  // (sinon simple saisie de poids seul) ; le BMI est recalculé ici, jamais
  // fait confiance au client.
  heightCm: z.number().positive().max(300).nullable().optional(),
});

const ENTRY_FIELDS = `
  id, weight_kg::float8 AS "weightKg", height_cm::float8 AS "heightCm",
  bmi::float8 AS bmi, recorded_at AS "recordedAt"
`;

// Historique des pesées/calculs d'IMC de l'utilisateur connecté, du plus récent au plus ancien.
router.get("/", requireAuth, async (req, res) => {
  const result = await pool.query(
    `SELECT ${ENTRY_FIELDS} FROM weight_entries WHERE user_id = $1 ORDER BY recorded_at DESC`,
    [req.user!.id]
  );
  res.json({ entries: result.rows });
});

// Enregistre une pesée (et, si la taille est fournie, le calcul d'IMC associé)
// avec l'horodatage du serveur (date + heure du jour).
router.post("/", requireAuth, async (req, res) => {
  const parsed = weightSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0].message });
  }
  const { weightKg, heightCm } = parsed.data;
  const bmi = heightCm ? weightKg / (heightCm / 100) ** 2 : null;

  const result = await pool.query(
    `INSERT INTO weight_entries (user_id, weight_kg, height_cm, bmi)
     VALUES ($1, $2, $3, $4)
     RETURNING ${ENTRY_FIELDS}`,
    [req.user!.id, weightKg, heightCm ?? null, bmi]
  );
  res.status(201).json({ entry: result.rows[0] });
});

export default router;
