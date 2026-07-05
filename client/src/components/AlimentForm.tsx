import { useEffect, useState } from "react";
import type { FormEvent } from "react";
import { fetchCategories } from "../api/categories";
import type { Category } from "../api/categories";
import type { Aliment, AlimentInput } from "../api/aliments";
import { ApiError } from "../api/client";

interface AlimentFormProps {
  initial?: Aliment;
  onSubmit: (input: AlimentInput) => Promise<void>;
  onCancel: () => void;
}

function toInputValue(value: number | null | undefined): string {
  return value == null ? "" : String(value);
}

function toNullableNumber(value: string): number | null {
  return value.trim() === "" ? null : Number(value);
}

export function AlimentForm({ initial, onSubmit, onCancel }: AlimentFormProps) {
  const [categories, setCategories] = useState<Category[]>([]);
  const [nom, setNom] = useState(initial?.nom ?? "");
  const [categorieCode, setCategorieCode] = useState(toInputValue(initial?.categorieCode));
  const [proteines, setProteines] = useState(toInputValue(initial?.proteines));
  const [glucides, setGlucides] = useState(toInputValue(initial?.glucides));
  const [lipides, setLipides] = useState(toInputValue(initial?.lipides));
  const [energie, setEnergie] = useState(toInputValue(initial?.energie));
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    fetchCategories()
      .then(({ categories }) => setCategories(categories))
      .catch(() => setCategories([]));
  }, []);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    if (categorieCode === "") {
      setError("Choisissez une catégorie.");
      return;
    }
    setError(null);
    setSubmitting(true);
    try {
      await onSubmit({
        nom,
        categorieCode: Number(categorieCode),
        proteines: toNullableNumber(proteines),
        glucides: toNullableNumber(glucides),
        lipides: toNullableNumber(lipides),
        energie: toNullableNumber(energie),
      });
    } catch (err) {
      setError(err instanceof ApiError ? err.message : "Erreur lors de l'enregistrement.");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <form className="aliment-form" onSubmit={handleSubmit}>
      <label>
        Nom
        <input value={nom} onChange={(e) => setNom(e.target.value)} required />
      </label>
      <label>
        Catégorie
        <select
          value={categorieCode}
          onChange={(e) => setCategorieCode(e.target.value)}
          required
        >
          <option value="">Choisir une catégorie</option>
          {categories.map((c) => (
            <option key={c.code} value={c.code}>
              {c.nom}
            </option>
          ))}
        </select>
      </label>

      <div className="aliment-form-grid">
        <label>
          Protéines (g/100g)
          <input
            type="number"
            step="any"
            min={0}
            value={proteines}
            onChange={(e) => setProteines(e.target.value)}
          />
        </label>
        <label>
          Glucides (g/100g)
          <input
            type="number"
            step="any"
            min={0}
            value={glucides}
            onChange={(e) => setGlucides(e.target.value)}
          />
        </label>
        <label>
          Lipides (g/100g)
          <input
            type="number"
            step="any"
            min={0}
            value={lipides}
            onChange={(e) => setLipides(e.target.value)}
          />
        </label>
        <label>
          Énergie (kcal/100g)
          <input
            type="number"
            step="any"
            min={0}
            value={energie}
            onChange={(e) => setEnergie(e.target.value)}
          />
        </label>
      </div>

      {error && <p className="error">{error}</p>}

      <div className="aliment-form-actions">
        <button type="submit" disabled={submitting}>
          {initial ? "Enregistrer" : "Ajouter"}
        </button>
        <button type="button" className="danger" onClick={onCancel}>
          Annuler
        </button>
      </div>
    </form>
  );
}
