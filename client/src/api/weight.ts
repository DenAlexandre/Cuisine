import { apiFetch } from "./client";

export interface WeightEntry {
  id: number;
  weightKg: number;
  heightCm: number | null;
  bmi: number | null;
  recordedAt: string;
}

export function fetchWeightHistory() {
  return apiFetch<{ entries: WeightEntry[] }>("/weight");
}

export function addWeightEntry(weightKg: number, heightCm?: number | null) {
  return apiFetch<{ entry: WeightEntry }>("/weight", {
    method: "POST",
    body: JSON.stringify({ weightKg, heightCm: heightCm ?? null }),
  });
}
