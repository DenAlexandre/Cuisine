import { useEffect, useRef, useState } from "react";
import { searchAliments } from "../api/aliments";
import type { Aliment } from "../api/aliments";
import type { RecipeCategory, RecipeIngredientInput, RecipeIngredientUnit } from "../api/recipes";
import { CategoryFilter } from "./CategoryFilter";

interface PickedIngredient extends RecipeIngredientInput {
  nom: string;
  unit: RecipeIngredientUnit;
}

interface IngredientPickerProps {
  value: PickedIngredient[];
  onChange: (ingredients: PickedIngredient[]) => void;
  recipeCategory: RecipeCategory;
}

function unitFor(aliment: Aliment): RecipeIngredientUnit {
  return aliment.categorie === "Boissons" ? "cl" : "g";
}

// Code de la catégorie simplifiée "Boissons" (voir import-aliments.ts) : un
// cocktail se compose presque toujours de boissons, on pré-filtre dessus.
const BOISSONS_CATEGORY_CODE = 8;

function defaultCategorieCode(recipeCategory: RecipeCategory): number | null {
  return recipeCategory === "cocktail" ? BOISSONS_CATEGORY_CODE : null;
}

export function IngredientPicker({ value, onChange, recipeCategory }: IngredientPickerProps) {
  const [query, setQuery] = useState("");
  const [categorieCode, setCategorieCode] = useState<number | null>(() =>
    defaultCategorieCode(recipeCategory)
  );
  const [categoryTouched, setCategoryTouched] = useState(false);
  const [suggestions, setSuggestions] = useState<Aliment[]>([]);
  const timeoutRef = useRef<number | undefined>(undefined);

  const hasQuery = query.trim().length >= 2;
  const hasCategory = categorieCode !== null;

  // Tant que l'utilisateur n'a pas choisi lui-même une catégorie d'aliment,
  // le filtre continue de suivre la catégorie de recette (cocktail -> Boissons).
  useEffect(() => {
    if (categoryTouched) return;
    setCategorieCode(defaultCategorieCode(recipeCategory));
  }, [recipeCategory, categoryTouched]);

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
    onChange([
      ...value,
      { alimentCode: aliment.code, nom: aliment.nom, quantity: 100, unit: unitFor(aliment) },
    ]);
    setQuery("");
    setSuggestions([]);
  }

  function updateQuantity(alimentCode: number, quantity: number) {
    onChange(value.map((i) => (i.alimentCode === alimentCode ? { ...i, quantity } : i)));
  }

  function removeIngredient(alimentCode: number) {
    onChange(value.filter((i) => i.alimentCode !== alimentCode));
  }

  function resetSearch() {
    setQuery("");
    setCategoryTouched(false);
    setCategorieCode(defaultCategorieCode(recipeCategory));
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

      <CategoryFilter
        value={categorieCode}
        onChange={(code) => {
          setCategoryTouched(true);
          setCategorieCode(code);
        }}
      />

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
                value={item.quantity}
                onChange={(e) => updateQuantity(item.alimentCode, Number(e.target.value))}
              />
              <span className="muted">{item.unit}</span>
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
