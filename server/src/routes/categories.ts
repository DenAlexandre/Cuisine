import { Router } from "express";
import { pool } from "../db/pool";

const router = Router();

router.get("/", async (_req, res) => {
  const result = await pool.query("SELECT code, nom FROM categories_simples ORDER BY nom ASC");
  res.json({ categories: result.rows });
});

export default router;
