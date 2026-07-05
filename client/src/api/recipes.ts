import { API_URL, apiFetch } from "./client";

export type RecipeStatus = "pending" | "approved" | "rejected";
export type RecipeCategory = "cocktail" | "entree" | "plat" | "dessert";

export type RecipeIngredientUnit = "g" | "cl";

export interface RecipeIngredient {
  alimentCode: number;
  nom: string;
  quantity: number;
  unit: RecipeIngredientUnit;
  proteines: number | null;
  glucides: number | null;
  lipides: number | null;
  energie: number | null;
}

export interface RecipeNutrition {
  proteines: number;
  glucides: number;
  lipides: number;
  energie: number;
}

export interface Recipe {
  id: number;
  title: string;
  description: string;
  steps: string;
  servings: number;
  category: RecipeCategory;
  status: RecipeStatus;
  created_at: string;
  reviewed_at: string | null;
  author_id: number;
  author_username?: string;
  ingredients: RecipeIngredient[];
  nutrition: RecipeNutrition;
  isFavorite: boolean;
  hasPhoto: boolean;
}

export interface RecipeIngredientInput {
  alimentCode: number;
  quantity: number;
}

export interface RecipeInput {
  title: string;
  description: string;
  steps: string;
  servings: number;
  category: RecipeCategory;
  // undefined = ne pas toucher la photo existante, null = la retirer, string = nouvelle photo.
  photoBase64?: string | null;
  ingredients: RecipeIngredientInput[];
}

export function getRecipePhotoUrl(id: number) {
  return `${API_URL}/recipes/${id}/photo`;
}

export function fetchApprovedRecipes(category?: RecipeCategory) {
  const query = category ? `?categorie=${category}` : "";
  return apiFetch<{ recipes: Recipe[] }>(`/recipes${query}`);
}

export function fetchRecipe(id: number | string) {
  return apiFetch<{ recipe: Recipe }>(`/recipes/${id}`);
}

export function fetchMyRecipes() {
  return apiFetch<{ recipes: Recipe[] }>("/recipes/mine");
}

export function fetchFavoriteRecipes() {
  return apiFetch<{ recipes: Recipe[] }>("/recipes/favorites");
}

export function addFavorite(id: number) {
  return apiFetch<void>(`/recipes/${id}/favorite`, { method: "POST" });
}

export function removeFavorite(id: number) {
  return apiFetch<void>(`/recipes/${id}/favorite`, { method: "DELETE" });
}

export function createRecipe(input: RecipeInput) {
  return apiFetch<{ recipe: Recipe }>("/recipes", {
    method: "POST",
    body: JSON.stringify(input),
  });
}

export function updateRecipe(id: number, input: RecipeInput) {
  return apiFetch<{ recipe: Recipe }>(`/recipes/${id}`, {
    method: "PUT",
    body: JSON.stringify(input),
  });
}

export function deleteRecipe(id: number) {
  return apiFetch<void>(`/recipes/${id}`, { method: "DELETE" });
}

export function fetchPendingRecipes() {
  return apiFetch<{ recipes: Recipe[] }>("/admin/recipes/pending");
}

export function approveRecipe(id: number) {
  return apiFetch<{ recipe: Recipe }>(`/admin/recipes/${id}/approve`, { method: "POST" });
}

export function rejectRecipe(id: number) {
  return apiFetch<{ recipe: Recipe }>(`/admin/recipes/${id}/reject`, { method: "POST" });
}
