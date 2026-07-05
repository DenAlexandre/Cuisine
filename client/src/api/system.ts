import { API_URL, ApiError, apiFetch, getToken } from "./client";

export interface SystemSettings {
  referenceWeightKg: number;
}

export function fetchSystemSettings() {
  return apiFetch<{ settings: SystemSettings }>("/admin/settings");
}

export function updateSystemSettings(referenceWeightKg: number) {
  return apiFetch<{ settings: SystemSettings }>("/admin/settings", {
    method: "PUT",
    body: JSON.stringify({ referenceWeightKg }),
  });
}

// Téléchargement d'un export complet de la base en .sql. Une réponse fichier
// (pas du JSON) ne peut pas passer par apiFetch : on gère ici la récupération
// du blob et le déclenchement du téléchargement navigateur.
export async function downloadDatabaseExport(): Promise<void> {
  const token = getToken();
  const res = await fetch(`${API_URL}/admin/export-sql`, {
    headers: token ? { Authorization: `Bearer ${token}` } : {},
  });

  if (!res.ok) {
    const body = await res.json().catch(() => ({}));
    throw new ApiError(res.status, body.error || "Erreur lors de l'export.");
  }

  const blob = await res.blob();
  const disposition = res.headers.get("Content-Disposition") ?? "";
  const filename = disposition.match(/filename="([^"]+)"/)?.[1] ?? "cuisine-export.sql";

  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  link.remove();
  URL.revokeObjectURL(url);
}
