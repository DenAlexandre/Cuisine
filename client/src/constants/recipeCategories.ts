import type { RecipeCategory } from "../api/recipes";

export interface RecipeCategoryMeta {
  value: RecipeCategory;
  label: string;
  emoji: string;
  color: string;
}

export const RECIPE_CATEGORIES: RecipeCategoryMeta[] = [
  { value: "cocktail", label: "Cocktails", emoji: "🍸", color: "#7c3aed" },
  { value: "entree", label: "Entrées", emoji: "🥗", color: "#2f9e44" },
  { value: "plat", label: "Plats", emoji: "🍽️", color: "#e2622b" },
  { value: "dessert", label: "Desserts", emoji: "🍰", color: "#d6336c" },
];
