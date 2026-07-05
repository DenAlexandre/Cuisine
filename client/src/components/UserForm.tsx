import { useState } from "react";
import type { FormEvent } from "react";
import type { AdminUser, AdminUserCreateInput, AdminUserInput } from "../api/users";
import type { Role } from "../api/auth";
import { ApiError } from "../api/client";
import { PasswordField } from "./PasswordField";

interface UserFormProps {
  initial?: AdminUser;
  onSubmit: (input: AdminUserInput | AdminUserCreateInput) => Promise<void>;
  onCancel: () => void;
}

export function UserForm({ initial, onSubmit, onCancel }: UserFormProps) {
  const isCreate = !initial;
  const [username, setUsername] = useState(initial?.username ?? "");
  const [firstName, setFirstName] = useState(initial?.firstName ?? "");
  const [lastName, setLastName] = useState(initial?.lastName ?? "");
  const [email, setEmail] = useState(initial?.email ?? "");
  const [phone, setPhone] = useState(initial?.phone ?? "");
  const [role, setRole] = useState<Role>(initial?.role ?? "user");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      if (isCreate) {
        await onSubmit({ username, firstName, lastName, email, phone, role, password });
      } else {
        await onSubmit({ username, firstName, lastName, email, phone, role });
      }
    } catch (err) {
      setError(err instanceof ApiError ? err.message : "Erreur lors de l'enregistrement.");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <form className="aliment-form" onSubmit={handleSubmit}>
      <label>
        Pseudo
        <input value={username} onChange={(e) => setUsername(e.target.value)} required />
      </label>
      <div className="aliment-form-grid">
        <label>
          Nom
          <input value={lastName} onChange={(e) => setLastName(e.target.value)} required />
        </label>
        <label>
          Prénom
          <input value={firstName} onChange={(e) => setFirstName(e.target.value)} required />
        </label>
        <label>
          Email
          <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
        </label>
        <label>
          Téléphone
          <input type="tel" value={phone} onChange={(e) => setPhone(e.target.value)} required />
        </label>
        {isCreate && (
          <label>
            Mot de passe
            <PasswordField
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              minLength={8}
              required
            />
          </label>
        )}
      </div>
      <label>
        Rôle
        <select value={role} onChange={(e) => setRole(e.target.value as Role)}>
          <option value="user">Utilisateur</option>
          <option value="admin">Admin</option>
        </select>
      </label>

      {error && <p className="error">{error}</p>}

      <div className="aliment-form-actions">
        <button type="submit" disabled={submitting}>
          {isCreate ? "Créer le compte" : "Enregistrer"}
        </button>
        <button type="button" className="danger" onClick={onCancel}>
          Annuler
        </button>
      </div>
    </form>
  );
}
