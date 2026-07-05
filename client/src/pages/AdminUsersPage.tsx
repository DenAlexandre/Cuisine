import { useEffect, useState } from "react";
import { createUser, deleteUser, fetchUsers, updateUser } from "../api/users";
import type { AdminUser, AdminUserCreateInput } from "../api/users";
import { UserForm } from "../components/UserForm";
import { useAuth } from "../context/AuthContext";

type FormState = { mode: "closed" } | { mode: "create" } | { mode: "edit"; user: AdminUser };

export function AdminUsersPage() {
  const { user: currentUser } = useAuth();
  const [users, setUsers] = useState<AdminUser[]>([]);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState<FormState>({ mode: "closed" });
  const [actionError, setActionError] = useState<string | null>(null);

  function loadUsers() {
    return fetchUsers().then(({ users }) => setUsers(users));
  }

  useEffect(() => {
    loadUsers().finally(() => setLoading(false));
  }, []);

  async function handleDelete(target: AdminUser) {
    if (!window.confirm(`Supprimer le compte « ${target.username} » et toutes ses recettes ?`)) {
      return;
    }
    setActionError(null);
    try {
      await deleteUser(target.id);
      await loadUsers();
    } catch (err) {
      setActionError(err instanceof Error ? err.message : "Erreur lors de la suppression.");
    }
  }

  if (loading) return <p>Chargement...</p>;

  return (
    <div>
      <div className="page-header">
        <h1>Utilisateurs</h1>
        {form.mode === "closed" && (
          <button type="button" onClick={() => setForm({ mode: "create" })}>
            Ajouter un utilisateur
          </button>
        )}
      </div>

      {form.mode !== "closed" && (
        <div className="aliment-form-panel">
          <h2>{form.mode === "edit" ? `Modifier « ${form.user.username} »` : "Nouvel utilisateur"}</h2>
          <UserForm
            initial={form.mode === "edit" ? form.user : undefined}
            onCancel={() => setForm({ mode: "closed" })}
            onSubmit={async (input) => {
              if (form.mode === "edit") {
                await updateUser(form.user.id, input);
              } else {
                await createUser(input as AdminUserCreateInput);
              }
              setForm({ mode: "closed" });
              await loadUsers();
            }}
          />
        </div>
      )}

      {actionError && <p className="error">{actionError}</p>}

      <div className="table-scroll">
        <table className="nutrition-table">
          <thead>
            <tr>
              <th>Pseudo</th>
              <th>Nom</th>
              <th>Email</th>
              <th>Téléphone</th>
              <th>Rôle</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {users.map((u) => (
              <tr key={u.id}>
                <td>{u.username}</td>
                <td className="muted">
                  {u.firstName} {u.lastName}
                </td>
                <td className="muted">{u.email}</td>
                <td className="muted">{u.phone}</td>
                <td>{u.role === "admin" ? "Admin" : "Utilisateur"}</td>
                <td className="aliment-row-actions">
                  <button
                    type="button"
                    className="link-button"
                    onClick={() => setForm({ mode: "edit", user: u })}
                  >
                    Modifier
                  </button>
                  <button
                    type="button"
                    className="link-button danger-link"
                    disabled={u.id === currentUser?.id}
                    onClick={() => handleDelete(u)}
                  >
                    Supprimer
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
