import { apiFetch } from "./client";

export type RecipeStatus = "pending" | "approved" | "rejected";

export interface RecipeIngredient {
  alimentCode: number;
  nom: string;
  quantityG: number;
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
  status: RecipeStatus;
  created_at: string;
  reviewed_at: string | null;
  author_id: number;
  author_username?: string;
  ingredients: RecipeIngredient[];
  nutrition: RecipeNutrition;
}

export interface RecipeIngredientInput {
  alimentCode: number;
  quantityG: number;
}

export interface RecipeInput {
  title: string;
  description: string;
  steps: string;
  ingredients: RecipeIngredientInput[];
}

export function fetchApprovedRecipes() {
  return apiFetch<{ recipes: Recipe[] }>("/recipes");
}

export function fetchRecipe(id: number | string) {
  return apiFetch<{ recipe: Recipe }>(`/recipes/${id}`);
}

export function fetchMyRecipes() {
  return apiFetch<{ recipes: Recipe[] }>("/recipes/mine");
}

export function createRecipe(input: RecipeInput) {
  return apiFetch<{ recipe: Recipe }>("/recipes", {
    method: "POST",
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
