import "dotenv/config";
import express from "express";
import "express-async-errors";
import cors from "cors";
import authRoutes from "./routes/auth";
import recipeRoutes from "./routes/recipes";
import adminRoutes from "./routes/admin";
import alimentRoutes from "./routes/aliments";
import categoryRoutes from "./routes/categories";
import weightRoutes from "./routes/weight";

const app = express();
const PORT = process.env.PORT || 4000;
const CLIENT_ORIGIN = process.env.CLIENT_ORIGIN || "http://localhost:5173";

// L'authentification passe par un header Authorization (Bearer), pas un cookie :
// pas besoin de "credentials: true" ni de cookie-parser.
app.use(cors({ origin: CLIENT_ORIGIN }));
// Limite relevee pour accueillir la photo de recette (deja recadree/compressee
// cote client, encodee en base64 dans le JSON).
app.use(express.json({ limit: "5mb" }));

app.use("/api/auth", authRoutes);
app.use("/api/recipes", recipeRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/aliments", alimentRoutes);
app.use("/api/categories", categoryRoutes);
app.use("/api/weight", weightRoutes);

app.use((err: unknown, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error(err);
  res.status(500).json({ error: "Erreur serveur interne." });
});

app.listen(PORT, () => {
  console.log(`Serveur démarré sur http://localhost:${PORT}`);
});
