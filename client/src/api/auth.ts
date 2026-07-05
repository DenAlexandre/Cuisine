import { apiFetch } from "./client";

export type Role = "admin" | "user";

export interface User {
  id: number;
  email: string;
  role: Role;
}

export function register(email: string, password: string) {
  return apiFetch<{ user: User }>("/auth/register", {
    method: "POST",
    body: JSON.stringify({ email, password }),
  });
}

export function login(email: string, password: string) {
  return apiFetch<{ user: User }>("/auth/login", {
    method: "POST",
    body: JSON.stringify({ email, password }),
  });
}

export function logout() {
  return apiFetch<void>("/auth/logout", { method: "POST" });
}

export function fetchMe() {
  return apiFetch<{ user: User }>("/auth/me");
}
