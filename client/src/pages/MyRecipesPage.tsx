import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { deleteRecipe, fetchFavoriteRecipes, fetchMyRecipes, removeFavorite } from "../api/recipes";
import type { Recipe } from "../api/recipes";
import { RECIPE_CATEGORIES } from "../constants/recipeCategories";
import { useSortableTable } from "../hooks/useSortableTable";
import { SortableTh } from "../components/SortableTh";

function categoryLabel(category: Recipe["category"]) {
  const meta = RECIPE_CATEGORIES.find((c) => c.value === category);
  return meta ? `${meta.emoji} ${meta.label}` : category;
}

type FavoriteSortKey = "title" | "category" | "proteines" | "glucides" | "lipides" | "energie";

function favoriteSortValue(recipe: Recipe, key: FavoriteSortKey) {
  switch (key) {
    case "title":
      return recipe.title;
    case "category":
      return categoryLabel(recipe.category);
    case "proteines":
      return recipe.nutrition.proteines;
    case "glucides":
      return recipe.nutrition.glucides;
    case "lipides":
      return recipe.nutrition.lipides;
    case "energie":
      return recipe.nutrition.energie;
    default:
      return null;
  }
}

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
  const {
    sorted: sortedFavorites,
    sortKey: favoriteSortKey,
    direction: favoriteDirection,
    toggleSort: toggleFavoriteSort,
  } = useSortableTable<Recipe, FavoriteSortKey>(favorites, favoriteSortValue);

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
        {favorites.length > 0 && (
          <div className="table-scroll">
            <p className="muted">Valeurs nutritionnelles par personne.</p>
            <table className="nutrition-table">
              <thead>
                <tr>
                  <SortableTh label="Recette" sortKey="title" activeKey={favoriteSortKey} direction={favoriteDirection} onSort={toggleFavoriteSort} />
                  <SortableTh label="Catégorie" sortKey="category" activeKey={favoriteSortKey} direction={favoriteDirection} onSort={toggleFavoriteSort} />
                  <SortableTh label="Protéines" sortKey="proteines" activeKey={favoriteSortKey} direction={favoriteDirection} onSort={toggleFavoriteSort} />
                  <SortableTh label="Glucides" sortKey="glucides" activeKey={favoriteSortKey} direction={favoriteDirection} onSort={toggleFavoriteSort} />
                  <SortableTh label="Lipides" sortKey="lipides" activeKey={favoriteSortKey} direction={favoriteDirection} onSort={toggleFavoriteSort} />
                  <SortableTh label="Énergie" sortKey="energie" activeKey={favoriteSortKey} direction={favoriteDirection} onSort={toggleFavoriteSort} />
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {sortedFavorites.map((recipe) => (
                  <tr key={recipe.id}>
                    <td>
                      <Link to={`/recettes/${recipe.id}`}>{recipe.title}</Link>
                    </td>
                    <td>{categoryLabel(recipe.category)}</td>
                    <td>{recipe.nutrition.proteines.toFixed(1)} g</td>
                    <td>{recipe.nutrition.glucides.toFixed(1)} g</td>
                    <td>{recipe.nutrition.lipides.toFixed(1)} g</td>
                    <td>{recipe.nutrition.energie.toFixed(0)} kcal</td>
                    <td>
                      <button className="danger" onClick={() => handleRemoveFavorite(recipe.id)}>
                        Retirer des favoris
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
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
