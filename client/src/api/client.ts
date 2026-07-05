export const API_URL = import.meta.env.VITE_API_URL || "http://localhost:4000/api";

// Stocké en sessionStorage (propre à chaque onglet/fenêtre) plutôt qu'en cookie,
// pour permettre plusieurs sessions différentes ouvertes en parallèle sur le
// même navigateur (ex: admin dans une fenêtre, user dans une autre).
const TOKEN_KEY = "cuisine.token";

export function getToken(): string | null {
  return sessionStorage.getItem(TOKEN_KEY);
}

export function setToken(token: string | null) {
  if (token) {
    sessionStorage.setItem(TOKEN_KEY, token);
  } else {
    sessionStorage.removeItem(TOKEN_KEY);
  }
}

export class ApiError extends Error {
  status: number;
  constructor(status: number, message: string) {
    super(message);
    this.status = status;
  }
}

export async function apiFetch<T>(path: string, options: RequestInit = {}): Promise<T> {
  const token = getToken();

  const res = await fetch(`${API_URL}${path}`, {
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
    ...options,
  });

  if (res.status === 204) {
    return undefined as T;
  }

  const body = await res.json().catch(() => ({}));

  if (!res.ok) {
    throw new ApiError(res.status, body.error || "Une erreur est survenue.");
  }

  return body as T;
}
