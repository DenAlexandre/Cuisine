import { useEffect, useState } from "react";
import type { MouseEvent } from "react";
import { Link, useSearchParams } from "react-router-dom";
import {
  addFavorite,
  fetchApprovedRecipes,
  fetchRecipeCounts,
  getRecipePhotoUrl,
  removeFavorite,
} from "../api/recipes";
import type { Recipe, RecipeCategory } from "../api/recipes";
import { RECIPE_CATEGORIES } from "../constants/recipeCategories";
import { CategoryThumbnail } from "../components/CategoryThumbnail";
import { useAuth } from "../context/AuthContext";

function HeartIcon({ filled }: { filled: boolean }) {
  return (
    <svg
      width="20"
      height="20"
      viewBox="0 0 24 24"
      fill={filled ? "currentColor" : "none"}
      stroke="currentColor"
      strokeWidth="2"
    >
      <path d="M12 21s-6.7-4.35-9.3-8.2C1 10.1 1.6 6.6 4.5 5.1c2.3-1.2 4.9-.4 6.2 1.4l1.3 1.8 1.3-1.8c1.3-1.8 3.9-2.6 6.2-1.4 2.9 1.5 3.5 5 1.8 7.7C18.7 16.65 12 21 12 21Z" />
    </svg>
  );
}

export function HomePage() {
  const { user } = useAuth();
  const [searchParams] = useSearchParams();
  const categoryParam = searchParams.get("categorie") as RecipeCategory | null;
  const activeCategory = RECIPE_CATEGORIES.find((c) => c.value === categoryParam) ?? null;

  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [loading, setLoading] = useState(true);
  const [counts, setCounts] = useState<Record<RecipeCategory, number> | null>(null);

  useEffect(() => {
    setLoading(true);
    fetchApprovedRecipes(activeCategory?.value)
      .then(({ recipes }) => setRecipes(recipes))
      .finally(() => setLoading(false));
  }, [activeCategory]);

  useEffect(() => {
    if (activeCategory) return;
    fetchRecipeCounts()
      .then(({ counts }) => setCounts(counts))
      .catch(() => setCounts(null));
  }, [activeCategory]);

  async function toggleFavorite(e: MouseEvent, recipe: Recipe) {
    e.preventDefault();
    e.stopPropagation();
    if (recipe.isFavorite) {
      await removeFavorite(recipe.id);
    } else {
      await addFavorite(recipe.id);
    }
    setRecipes((prev) =>
      prev.map((r) => (r.id === recipe.id ? { ...r, isFavorite: !r.isFavorite } : r))
    );
  }

  if (!activeCategory) {
    return (
      <div>
        <div className="page-header">
          <h1>Recettes</h1>
          {user && (
            <Link to="/nouvelle-recette" className="button-link">
              Ajouter une recette
            </Link>
          )}
        </div>
        <p className="muted">Choisissez une catégorie pour voir les recettes associées.</p>
        <div className="category-grid">
          {RECIPE_CATEGORIES.map((c) => (
            <Link
              key={c.value}
              to={`/?categorie=${c.value}`}
              className="category-tile"
              style={{ backgroundColor: c.color }}
            >
              <span className="category-tile-emoji">{c.emoji}</span>
              <span className="category-tile-label">{c.label}</span>
              {counts && <span className="category-tile-count">{counts[c.value]}</span>}
            </Link>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="page-header">
        <div>
          <Link to="/" className="link-button">
            ← Toutes les catégories
          </Link>
          <h1>
            {activeCategory.emoji} {activeCategory.label}
          </h1>
        </div>
        {user && (
          <Link to={`/nouvelle-recette?categorie=${activeCategory.value}`} className="button-link">
            Ajouter une recette
          </Link>
        )}
      </div>

      {loading && <p>Chargement des recettes...</p>}
      {!loading && recipes.length === 0 && (
        <p>Aucune recette publiée dans cette catégorie pour le moment.</p>
      )}
      <div className="recipe-grid">
        {recipes.map((recipe) => (
          <Link key={recipe.id} to={`/recettes/${recipe.id}`} className="recipe-card">
            {recipe.hasPhoto ? (
              <img
                src={getRecipePhotoUrl(recipe.id, recipe.photoVersion)}
                alt={recipe.title}
                className="recipe-card-photo"
              />
            ) : (
              <CategoryThumbnail category={recipe.category} className="recipe-card-photo" />
            )}
            {user && (
              <button
                type="button"
                className={`favorite-toggle ${recipe.isFavorite ? "active" : ""}`}
                onClick={(e) => toggleFavorite(e, recipe)}
                aria-label={recipe.isFavorite ? "Retirer des favoris" : "Ajouter aux favoris"}
              >
                <HeartIcon filled={recipe.isFavorite} />
              </button>
            )}
            <h2>{recipe.title}</h2>
            <p>{recipe.description}</p>
            <span className="muted">par {recipe.author_username}</span>
          </Link>
        ))}
      </div>
    </div>
  );
}
