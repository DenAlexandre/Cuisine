import type { RecipeCategory } from "../api/recipes";
import { RECIPE_CATEGORIES } from "../constants/recipeCategories";

interface CategoryThumbnailProps {
  category: RecipeCategory;
  className?: string;
}

// Image par défaut d'une recette : le pictogramme/couleur de sa catégorie,
// utilisée tant qu'aucune photo personnalisée n'a été choisie.
export function CategoryThumbnail({ category, className }: CategoryThumbnailProps) {
  const meta = RECIPE_CATEGORIES.find((c) => c.value === category) ?? RECIPE_CATEGORIES[2];
  return (
    <div
      className={`category-thumbnail ${className ?? ""}`}
      style={{ backgroundColor: meta.color }}
    >
      <span>{meta.emoji}</span>
    </div>
  );
}
