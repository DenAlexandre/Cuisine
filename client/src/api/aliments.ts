import { apiFetch } from "./client";

export interface Aliment {
  code: number;
  nom: string;
  categorie: string | null;
  categorieCode: number | null;
  proteines: number | null;
  glucides: number | null;
  lipides: number | null;
  energie: number | null;
  degreAlcool: number | null;
  infoComplementaire: string | null;
  // Permet de saisir cet aliment "à la pièce" (ex: 2 œufs) : poids d'une unité
  // en grammes + libellé affiché (ex: "œuf(s)"). Toujours renseignés ensemble.
  poidsUnitaireG: number | null;
  libelleUnite: string | null;
}

export interface AlimentSearchFilters {
  q?: string;
  categorieCode?: number | null;
}

export interface AlimentInput {
  nom: string;
  categorieCode: number;
  proteines: number | null;
  glucides: number | null;
  lipides: number | null;
  energie: number | null;
  degreAlcool: number | null;
  infoComplementaire: string | null;
  poidsUnitaireG: number | null;
  libelleUnite: string | null;
}

export function searchAliments(filters: AlimentSearchFilters) {
  const params = new URLSearchParams();
  if (filters.q) params.set("q", filters.q);
  if (filters.categorieCode != null) params.set("categorie", String(filters.categorieCode));
  return apiFetch<{ aliments: Aliment[] }>(`/aliments?${params.toString()}`);
}

export function createAliment(input: AlimentInput) {
  return apiFetch<{ aliment: Aliment }>("/aliments", {
    method: "POST",
    body: JSON.stringify(input),
  });
}

export function updateAliment(code: number, input: AlimentInput) {
  return apiFetch<{ aliment: Aliment }>(`/aliments/${code}`, {
    method: "PUT",
    body: JSON.stringify(input),
  });
}

export function deleteAliment(code: number) {
  return apiFetch<void>(`/aliments/${code}`, { method: "DELETE" });
}
