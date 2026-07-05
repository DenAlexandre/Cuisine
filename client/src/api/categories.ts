import { apiFetch } from "./client";

export interface Category {
  code: number;
  nom: string;
}

export function fetchCategories() {
  return apiFetch<{ categories: Category[] }>("/categories");
}
