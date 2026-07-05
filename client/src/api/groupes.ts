import { apiFetch } from "./client";

export interface GroupeOption {
  code: number;
  nom: string;
}

export function fetchGroupes() {
  return apiFetch<{ groupes: GroupeOption[] }>("/groupes");
}

export function fetchSousGroupes(groupeCode: number) {
  return apiFetch<{ sousGroupes: GroupeOption[] }>(`/groupes/${groupeCode}/sous-groupes`);
}

export function fetchSousSousGroupes(groupeCode: number, sousGroupeCode: number) {
  return apiFetch<{ sousSousGroupes: GroupeOption[] }>(
    `/groupes/${groupeCode}/sous-groupes/${sousGroupeCode}/sous-sous-groupes`
  );
}
