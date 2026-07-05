import { useEffect, useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import { deleteRecipe, fetchRecipe, getRecipePhotoUrl } from "../api/recipes";
import type { Recipe } from "../api/recipes";
import { ApiError } from "../api/client";
import { CategoryThumbnail } from "../components/CategoryThumbnail";
import { useAuth } from "../context/AuthContext";

const STATUS_LABELS: Record<Recipe["status"], string> = {
  pending: "En attente de validation",
  approved: "Validée",
  rejected: "Rejetée",
};

export function RecipeDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { user } = useAuth();
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

  const isAdmin = user?.role === "admin";
  const isOwner = user?.id === recipe.author_id;
  const canManage = isAdmin || (isOwner && recipe.status === "pending");

  async function handleDelete() {
    if (!recipe) return;
    if (!window.confirm(`Supprimer « ${recipe.title} » ?`)) return;
    await deleteRecipe(recipe.id);
    navigate(isAdmin ? "/admin" : "/mes-recettes");
  }

  return (
    <article className="recipe-detail">
      <div className="page-header">
        <h1>{recipe.title}</h1>
        {canManage && (
          <div className="validations-actions">
            <Link to={`/recettes/${recipe.id}/modifier`} className="button-link">
              Modifier
            </Link>
            <button type="button" className="danger" onClick={handleDelete}>
              Supprimer
            </button>
          </div>
        )}
      </div>
      {recipe.hasPhoto ? (
        <img
          src={getRecipePhotoUrl(recipe.id, recipe.photoVersion)}
          alt={recipe.title}
          className="recipe-photo"
        />
      ) : (
        <CategoryThumbnail category={recipe.category} className="recipe-photo" />
      )}
      {recipe.status !== "approved" && (
        <p className={`status-badge status-${recipe.status}`}>{STATUS_LABELS[recipe.status]}</p>
      )}
      <p>{recipe.description}</p>
      <p className="muted">Pour {recipe.servings} personne{recipe.servings > 1 ? "s" : ""}</p>

      <h2>Ingrédients</h2>
      <ul className="ingredient-list-readonly">
        {recipe.ingredients.map((ingredient) => (
          <li key={ingredient.alimentCode}>
            {ingredient.nom} — {ingredient.quantity}{" "}
            {ingredient.unit === "unite" ? ingredient.libelleUnite : ingredient.unit}
            {ingredient.gramsEquivalent != null && (
              <span className="muted"> ({Math.round(ingredient.gramsEquivalent)} g)</span>
            )}
            {ingredient.kcal != null && (
              <span className="muted"> · {Math.round(ingredient.kcal)} kcal</span>
            )}
            {ingredient.degreAlcool != null && (
              <span className="muted"> · {ingredient.degreAlcool}° d'alcool</span>
            )}
          </li>
        ))}
      </ul>

      <h2>Étapes</h2>
      <p className="preformatted">{recipe.steps}</p>

      <h2>Valeurs nutritionnelles (par personne)</h2>
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

      {recipe.alcohol && (
        <>
          <h2>Alcoolémie estimée</h2>
          <p className="muted">
            Environ {recipe.alcohol.gramsPerServing.toFixed(1)} g d'alcool pur par personne, soit
            une alcoolémie indicative de <strong>{recipe.alcohol.bloodAlcoholGL.toFixed(2)} g/L</strong>{" "}
            (poids de référence : {recipe.alcohol.referenceWeightKg} kg).
          </p>
          <p className="muted">
            Estimation indicative (formule de Widmark), qui ne tient pas compte de votre poids ou
            sexe réels : elle ne remplace pas un éthylotest.
          </p>
        </>
      )}
    </article>
  );
}
