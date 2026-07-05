import { useEffect, useRef, useState } from "react";
import { searchAliments } from "../api/aliments";
import type { Aliment } from "../api/aliments";
import type { RecipeIngredientInput } from "../api/recipes";
import { CategoryFilter } from "./CategoryFilter";

interface PickedIngredient extends RecipeIngredientInput {
  nom: string;
}

interface IngredientPickerProps {
  value: PickedIngredient[];
  onChange: (ingredients: PickedIngredient[]) => void;
}

export function IngredientPicker({ value, onChange }: IngredientPickerProps) {
  const [query, setQuery] = useState("");
  const [categorieCode, setCategorieCode] = useState<number | null>(null);
  const [suggestions, setSuggestions] = useState<Aliment[]>([]);
  const timeoutRef = useRef<number | undefined>(undefined);

  const hasQuery = query.trim().length >= 2;
  const hasCategory = categorieCode !== null;

  useEffect(() => {
    window.clearTimeout(timeoutRef.current);
    if (!hasQuery && !hasCategory) {
      setSuggestions([]);
      return;
    }
    timeoutRef.current = window.setTimeout(() => {
      searchAliments({ q: query.trim(), categorieCode })
        .then(({ aliments }) => setSuggestions(aliments))
        .catch(() => setSuggestions([]));
    }, 250);
    return () => window.clearTimeout(timeoutRef.current);
  }, [query, categorieCode, hasQuery, hasCategory]);

  function addIngredient(aliment: Aliment) {
    if (value.some((i) => i.alimentCode === aliment.code)) return;
    onChange([...value, { alimentCode: aliment.code, nom: aliment.nom, quantityG: 100 }]);
    // Reset complet (texte + catégorie) : sinon, si une catégorie était sélectionnée,
    // la recherche se relance automatiquement et rouvre la liste de suggestions.
    resetSearch();
  }

  function updateQuantity(alimentCode: number, quantityG: number) {
    onChange(value.map((i) => (i.alimentCode === alimentCode ? { ...i, quantityG } : i)));
  }

  function removeIngredient(alimentCode: number) {
    onChange(value.filter((i) => i.alimentCode !== alimentCode));
  }

  function resetSearch() {
    setQuery("");
    setCategorieCode(null);
    setSuggestions([]);
  }

  return (
    <div className="ingredient-picker">
      {(hasQuery || hasCategory) && (
        <div className="ingredient-picker-toolbar">
          <button type="button" className="link-button" onClick={resetSearch}>
            Réinitialiser la recherche
          </button>
        </div>
      )}

      <CategoryFilter value={categorieCode} onChange={setCategorieCode} />

      <div className="ingredient-search">
        <input
          type="text"
          placeholder="Rechercher un aliment (ex: pomme, poulet...)"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
        />
        {suggestions.length > 0 && (
          <ul className="ingredient-suggestions">
            {suggestions.map((aliment) => (
              <li key={aliment.code}>
                <button type="button" onClick={() => addIngredient(aliment)}>
                  {aliment.nom}
                </button>
              </li>
            ))}
          </ul>
        )}
      </div>

      {value.length > 0 && (
        <ul className="ingredient-list">
          {value.map((item) => (
            <li key={item.alimentCode}>
              <span>{item.nom}</span>
              <input
                type="number"
                min={1}
                step="1"
                value={item.quantityG}
                onChange={(e) => updateQuantity(item.alimentCode, Number(e.target.value))}
              />
              <span className="muted">g</span>
              <button type="button" className="danger" onClick={() => removeIngredient(item.alimentCode)}>
                Retirer
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
