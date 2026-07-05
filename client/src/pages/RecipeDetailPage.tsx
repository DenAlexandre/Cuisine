import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { fetchRecipe } from "../api/recipes";
import type { Recipe } from "../api/recipes";
import { ApiError } from "../api/client";

const STATUS_LABELS: Record<Recipe["status"], string> = {
  pending: "En attente de validation",
  approved: "Validée",
  rejected: "Rejetée",
};

export function RecipeDetailPage() {
  const { id } = useParams<{ id: string }>();
  const [recipe, setRecipe] = useState<Recipe | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!id) return;
    fetchRecipe(id)
      .then(({ recipe }) => setRecipe(recipe))
      .catch((err) => setError(err instanceof ApiError ? err.message : "Erreur inconnue."))
      .finally(() => setLoading(false));
  }, [id]);

  if (loading) return <p>Chargement...</p>;
  if (error) return <p className="error">{error}</p>;
  if (!recipe) return null;

  return (
    <article className="recipe-detail">
      <h1>{recipe.title}</h1>
      {recipe.status !== "approved" && (
        <p className={`status-badge status-${recipe.status}`}>{STATUS_LABELS[recipe.status]}</p>
      )}
      <p>{recipe.description}</p>

      <h2>Ingrédients</h2>
      <ul className="ingredient-list-readonly">
        {recipe.ingredients.map((ingredient) => (
          <li key={ingredient.alimentCode}>
            {ingredient.nom} — {ingredient.quantityG} g
          </li>
        ))}
      </ul>

      <h2>Étapes</h2>
      <p className="preformatted">{recipe.steps}</p>

      <h2>Valeurs nutritionnelles</h2>
      <div className="table-scroll">
        <table className="nutrition-table">
          <thead>
            <tr>
              <th>Protéines</th>
              <th>Glucides</th>
              <th>Lipides</th>
              <th>Énergie</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>{recipe.nutrition.proteines.toFixed(1)} g</td>
              <td>{recipe.nutrition.glucides.toFixed(1)} g</td>
              <td>{recipe.nutrition.lipides.toFixed(1)} g</td>
              <td>{recipe.nutrition.energie.toFixed(0)} kcal</td>
            </tr>
          </tbody>
        </table>
      </div>
    </article>
  );
}
