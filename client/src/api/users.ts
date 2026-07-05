import { apiFetch } from "./client";
import type { Role } from "./auth";

export interface AdminUser {
  id: number;
  username: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  role: Role;
  createdAt: string;
}

export interface AdminUserInput {
  username: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  role: Role;
}

export interface AdminUserCreateInput extends AdminUserInput {
  password: string;
}

export function fetchUsers() {
  return apiFetch<{ users: AdminUser[] }>("/admin/users");
}

export function createUser(input: AdminUserCreateInput) {
  return apiFetch<{ user: AdminUser }>("/admin/users", {
    method: "POST",
    body: JSON.stringify(input),
  });
}

export function updateUser(id: number, input: AdminUserInput) {
  return apiFetch<{ user: AdminUser }>(`/admin/users/${id}`, {
    method: "PUT",
    body: JSON.stringify(input),
  });
}

export function deleteUser(id: number) {
  return apiFetch<void>(`/admin/users/${id}`, { method: "DELETE" });
}
