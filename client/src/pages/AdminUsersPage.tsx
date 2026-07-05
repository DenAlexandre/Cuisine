import { useEffect, useState } from "react";
import { createUser, deleteUser, fetchUsers, updateUser } from "../api/users";
import type { AdminUser, AdminUserCreateInput } from "../api/users";
import { UserForm } from "../components/UserForm";
import { useAuth } from "../context/AuthContext";
import { useSortableTable } from "../hooks/useSortableTable";
import { SortableTh } from "../components/SortableTh";

type FormState = { mode: "closed" } | { mode: "create" } | { mode: "edit"; user: AdminUser };

type UserSortKey = "username" | "name" | "email" | "phone" | "role";

function userSortValue(user: AdminUser, key: UserSortKey) {
  switch (key) {
    case "username":
      return user.username;
    case "name":
      return `${user.firstName} ${user.lastName}`;
    case "email":
      return user.email;
    case "phone":
      return user.phone;
    case "role":
      return user.role;
    default:
      return null;
  }
}

export function AdminUsersPage() {
  const { user: currentUser } = useAuth();
  const [users, setUsers] = useState<AdminUser[]>([]);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState<FormState>({ mode: "closed" });
  const [actionError, setActionError] = useState<string | null>(null);
  const { sorted: sortedUsers, sortKey, direction, toggleSort } = useSortableTable<
    AdminUser,
    UserSortKey
  >(users, userSortValue);

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
              <SortableTh label="Pseudo" sortKey="username" activeKey={sortKey} direction={direction} onSort={toggleSort} />
              <SortableTh label="Nom" sortKey="name" activeKey={sortKey} direction={direction} onSort={toggleSort} />
              <SortableTh label="Email" sortKey="email" activeKey={sortKey} direction={direction} onSort={toggleSort} />
              <SortableTh label="Téléphone" sortKey="phone" activeKey={sortKey} direction={direction} onSort={toggleSort} />
              <SortableTh label="Rôle" sortKey="role" activeKey={sortKey} direction={direction} onSort={toggleSort} />
              <th></th>
            </tr>
          </thead>
          <tbody>
            {sortedUsers.map((u) => (
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
