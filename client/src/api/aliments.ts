import { apiFetch } from "./client";

export interface Aliment {
  code: number;
  nom: string;
  groupe: string | null;
  sousGroupe: string | null;
  sousSousGroupe: string | null;
  proteines: number | null;
  glucides: number | null;
  lipides: number | null;
  energie: number | null;
}

export interface AlimentSearchFilters {
  q?: string;
  groupeCode?: number | null;
  sousGroupeCode?: number | null;
  sousSousGroupeCode?: number | null;
}

export function searchAliments(filters: AlimentSearchFilters) {
  const params = new URLSearchParams();
  if (filters.q) params.set("q", filters.q);
  if (filters.groupeCode != null) params.set("groupe", String(filters.groupeCode));
  if (filters.sousGroupeCode != null) params.set("sousGroupe", String(filters.sousGroupeCode));
  if (filters.sousSousGroupeCode != null) {
    params.set("sousSousGroupe", String(filters.sousSousGroupeCode));
  }
  return apiFetch<{ aliments: Aliment[] }>(`/aliments?${params.toString()}`);
}
