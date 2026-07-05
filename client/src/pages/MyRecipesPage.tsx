import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { deleteRecipe, fetchFavoriteRecipes, fetchMyRecipes, removeFavorite } from "../api/recipes";
import type { Recipe } from "../api/recipes";

const STATUS_LABELS: Record<Recipe["status"], string> = {
  pending: "En attente",
  approved: "Validée",
  rejected: "Rejetée",
};

export function MyRecipesPage() {
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [loading, setLoading] = useState(true);
  const [favorites, setFavorites] = useState<Recipe[]>([]);
  const [favoritesLoading, setFavoritesLoading] = useState(true);

  function loadRecipes() {
    return fetchMyRecipes().then(({ recipes }) => setRecipes(recipes));
  }

  function loadFavorites() {
    return fetchFavoriteRecipes().then(({ recipes }) => setFavorites(recipes));
  }

  useEffect(() => {
    loadRecipes().finally(() => setLoading(false));
    loadFavorites().finally(() => setFavoritesLoading(false));
  }, []);

  async function handleRemoveFavorite(id: number) {
    await removeFavorite(id);
    await loadFavorites();
  }

  async function handleDelete(id: number) {
    await deleteRecipe(id);
    await loadRecipes();
  }

  return (
    <div>
      <div className="page-header">
        <h1>Mes recettes</h1>
        <Link to="/nouvelle-recette" className="button-link">
          Ajouter une recette
        </Link>
      </div>

      <section>
        <h2>Mes favoris</h2>
        {favoritesLoading && <p>Chargement...</p>}
        {!favoritesLoading && favorites.length === 0 && (
          <p>Vous n'avez pas encore de recette en favori.</p>
        )}
        <ul className="my-recipes-list">
          {favorites.map((recipe) => (
            <li key={recipe.id}>
              <Link to={`/recettes/${recipe.id}`}>{recipe.title}</Link>
              <span className="muted">par {recipe.author_username}</span>
              <button className="danger" onClick={() => handleRemoveFavorite(recipe.id)}>
                Retirer des favoris
              </button>
            </li>
          ))}
        </ul>
      </section>

      <section>
        <h2>Mes soumissions</h2>
        {loading && <p>Chargement...</p>}
        {!loading && recipes.length === 0 && <p>Vous n'avez pas encore proposé de recette.</p>}
        <ul className="my-recipes-list">
          {recipes.map((recipe) => (
            <li key={recipe.id}>
              <Link to={`/recettes/${recipe.id}`}>{recipe.title}</Link>
              <span className={`status-badge status-${recipe.status}`}>
                {STATUS_LABELS[recipe.status]}
              </span>
              {recipe.status === "pending" && (
                <button onClick={() => handleDelete(recipe.id)}>Supprimer</button>
              )}
            </li>
          ))}
        </ul>
      </section>
    </div>
  );
}
