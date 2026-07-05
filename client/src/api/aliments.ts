import { apiFetch } from "./client";

export interface Aliment {
  code: number;
  nom: string;
  categorie: string | null;
  proteines: number | null;
  glucides: number | null;
  lipides: number | null;
  energie: number | null;
}

export interface AlimentSearchFilters {
  q?: string;
  categorieCode?: number | null;
}

export function searchAliments(filters: AlimentSearchFilters) {
  const params = new URLSearchParams();
  if (filters.q) params.set("q", filters.q);
  if (filters.categorieCode != null) params.set("categorie", String(filters.categorieCode));
  return apiFetch<{ aliments: Aliment[] }>(`/aliments?${params.toString()}`);
}
