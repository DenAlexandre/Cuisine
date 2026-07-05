import { Router } from "express";
import { pool } from "../db/pool";

const router = Router();

router.get("/", async (_req, res) => {
  const result = await pool.query(
    "SELECT code, nom FROM groupes WHERE nom <> '' ORDER BY nom ASC"
  );
  res.json({ groupes: result.rows });
});

router.get("/:code/sous-groupes", async (req, res) => {
  const result = await pool.query(
    "SELECT code, nom FROM sous_groupes WHERE groupe_code = $1 AND nom <> '' AND nom <> '-' ORDER BY nom ASC",
    [req.params.code]
  );
  res.json({ sousGroupes: result.rows });
});

router.get("/:code/sous-groupes/:sousGroupeCode/sous-sous-groupes", async (req, res) => {
  const result = await pool.query(
    `SELECT code, nom FROM sous_sous_groupes
     WHERE groupe_code = $1 AND sous_groupe_code = $2 AND nom <> '' AND nom <> '-'
     ORDER BY nom ASC`,
    [req.params.code, req.params.sousGroupeCode]
  );
  res.json({ sousSousGroupes: result.rows });
});

export default router;
