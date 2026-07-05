import { useEffect, useState } from "react";
import { Link, useOutletContext } from "react-router-dom";
import { approveRecipe, deleteRecipe, fetchPendingRecipes, rejectRecipe } from "../api/recipes";
import type { Recipe } from "../api/recipes";

interface LayoutContext {
  refreshPendingCount: () => void;
}

export function AdminPage() {
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [loading, setLoading] = useState(true);
  const { refreshPendingCount } = useOutletContext<LayoutContext>();

  function loadRecipes() {
    return fetchPendingRecipes().then(({ recipes }) => setRecipes(recipes));
  }

  useEffect(() => {
    loadRecipes().finally(() => setLoading(false));
  }, []);

  async function handleApprove(id: number) {
    await approveRecipe(id);
    await loadRecipes();
    refreshPendingCount();
  }

  async function handleReject(id: number) {
    await rejectRecipe(id);
    await loadRecipes();
    refreshPendingCount();
  }

  async function handleDelete(recipe: Recipe) {
    if (!window.confirm(`Supprimer « ${recipe.title} » ?`)) return;
    await deleteRecipe(recipe.id);
    await loadRecipes();
    refreshPendingCount();
  }

  if (loading) return <p>Chargement...</p>;

  return (
    <div>
      <h1>Recettes en attente de validation</h1>
      {recipes.length === 0 && <p>Aucune recette en attente.</p>}
      <ul className="validations-list">
        {recipes.map((recipe) => (
          <li key={recipe.id}>
            <div>
              <Link to={`/recettes/${recipe.id}`}>{recipe.title}</Link>
              <span className="muted"> — proposée par {recipe.author_username}</span>
            </div>
            <div className="validations-actions">
              <button onClick={() => handleApprove(recipe.id)}>Valider</button>
              <button onClick={() => handleReject(recipe.id)} className="danger">
                Rejeter
              </button>
              <Link to={`/recettes/${recipe.id}/modifier`} className="button-link">
                Modifier
              </Link>
              <button onClick={() => handleDelete(recipe)} className="danger">
                Supprimer
              </button>
            </div>
          </li>
        ))}
      </ul>
    </div>
  );
}
