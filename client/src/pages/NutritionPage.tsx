import { useCallback, useEffect, useRef, useState } from "react";
import { createAliment, deleteAliment, searchAliments, updateAliment } from "../api/aliments";
import type { Aliment } from "../api/aliments";
import { CategoryFilter } from "../components/CategoryFilter";
import { AlimentForm } from "../components/AlimentForm";
import { useAuth } from "../context/AuthContext";

function formatValue(value: number | null): string {
  return value === null ? "—" : value.toString();
}

type FormState = { mode: "closed" } | { mode: "create" } | { mode: "edit"; aliment: Aliment };

export function NutritionPage() {
  const { user } = useAuth();
  const isAdmin = user?.role === "admin";

  const [query, setQuery] = useState("");
  const [categorieCode, setCategorieCode] = useState<number | null>(null);
  const [results, setResults] = useState<Aliment[]>([]);
  const [searched, setSearched] = useState(false);
  const [form, setForm] = useState<FormState>({ mode: "closed" });
  const [actionError, setActionError] = useState<string | null>(null);
  const timeoutRef = useRef<number | undefined>(undefined);

  const hasQuery = query.trim().length >= 2;
  const hasCategory = categorieCode !== null;

  const runSearch = useCallback(() => {
    if (!hasQuery && !hasCategory) {
      setResults([]);
      setSearched(false);
      return;
    }
    searchAliments({ q: query.trim(), categorieCode })
      .then(({ aliments }) => {
        setResults(aliments);
        setSearched(true);
      })
      .catch(() => setResults([]));
  }, [query, categorieCode, hasQuery, hasCategory]);

  useEffect(() => {
    window.clearTimeout(timeoutRef.current);
    if (!hasQuery && !hasCategory) {
      setResults([]);
      setSearched(false);
      return;
    }
    timeoutRef.current = window.setTimeout(runSearch, 250);
    return () => window.clearTimeout(timeoutRef.current);
  }, [query, categorieCode, hasQuery, hasCategory, runSearch]);

  async function handleDelete(aliment: Aliment) {
    if (!window.confirm(`Supprimer « ${aliment.nom} » ?`)) return;
    setActionError(null);
    try {
      await deleteAliment(aliment.code);
      runSearch();
    } catch (err) {
      setActionError(err instanceof Error ? err.message : "Erreur lors de la suppression.");
    }
  }

  return (
    <div>
      <h1>Nutrition</h1>
      <p className="muted">Recherchez un aliment par nom, ou affinez par catégorie.</p>

      {isAdmin && form.mode === "closed" && (
        <button type="button" onClick={() => setForm({ mode: "create" })}>
          Ajouter un aliment
        </button>
      )}

      {isAdmin && form.mode !== "closed" && (
        <div className="aliment-form-panel">
          <h2>{form.mode === "edit" ? "Modifier l'aliment" : "Nouvel aliment"}</h2>
          <AlimentForm
            initial={form.mode === "edit" ? form.aliment : undefined}
            onCancel={() => setForm({ mode: "closed" })}
            onSubmit={async (input) => {
              if (form.mode === "edit") {
                await updateAliment(form.aliment.code, input);
              } else {
                await createAliment(input);
              }
              setForm({ mode: "closed" });
              runSearch();
            }}
          />
        </div>
      )}

      {actionError && <p className="error">{actionError}</p>}

      <CategoryFilter value={categorieCode} onChange={setCategorieCode} />

      <input
        type="text"
        placeholder="Rechercher un aliment (ex: pomme, poulet...)"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        className="nutrition-search"
      />

      {searched && results.length === 0 && <p>Aucun aliment trouvé.</p>}

      {results.length > 0 && (
        <div className="table-scroll">
          <table className="nutrition-table">
            <thead>
              <tr>
                <th>Aliment</th>
                <th>Catégorie</th>
                <th>Protéines (g)</th>
                <th>Glucides (g)</th>
                <th>Lipides (g)</th>
                <th>Énergie (kcal)</th>
                <th>Alcool (%)</th>
                {isAdmin && <th></th>}
              </tr>
            </thead>
            <tbody>
              {results.map((aliment) => (
                <tr key={aliment.code}>
                  <td>
                    {aliment.nom}
                    {aliment.infoComplementaire && (
                      <span className="info-tooltip" title={aliment.infoComplementaire}>
                        ⓘ
                      </span>
                    )}
                  </td>
                  <td className="muted">{aliment.categorie}</td>
                  <td>{formatValue(aliment.proteines)}</td>
                  <td>{formatValue(aliment.glucides)}</td>
                  <td>{formatValue(aliment.lipides)}</td>
                  <td>{formatValue(aliment.energie)}</td>
                  <td>{formatValue(aliment.degreAlcool)}</td>
                  {isAdmin && (
                    <td className="aliment-row-actions">
                      <button
                        type="button"
                        className="link-button"
                        onClick={() => setForm({ mode: "edit", aliment })}
                      >
                        Modifier
                      </button>
                      <button
                        type="button"
                        className="link-button danger-link"
                        onClick={() => handleDelete(aliment)}
                      >
                        Supprimer
                      </button>
                    </td>
                  )}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
