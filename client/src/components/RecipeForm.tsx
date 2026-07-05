import { useState } from "react";
import type { FormEvent } from "react";
import type { Recipe, RecipeCategory, RecipeIngredientUnit, RecipeInput } from "../api/recipes";
import { getRecipePhotoUrl } from "../api/recipes";
import { ApiError } from "../api/client";
import { IngredientPicker } from "./IngredientPicker";
import { PhotoField } from "./PhotoField";
import { RECIPE_CATEGORIES } from "../constants/recipeCategories";

interface RecipeFormProps {
  initial?: Recipe;
  initialCategory?: RecipeCategory;
  submitLabel: string;
  onSubmit: (input: RecipeInput) => Promise<void>;
}

// Un cocktail se sert par personne (1), les autres catégories se partagent (4).
function defaultServings(category: RecipeCategory) {
  return category === "cocktail" ? 1 : 4;
}

function toForm(initial: Recipe | undefined, initialCategory: RecipeCategory) {
  const category = (initial?.category ?? initialCategory) as RecipeCategory;
  return {
    title: initial?.title ?? "",
    description: initial?.description ?? "",
    steps: initial?.steps ?? "",
    servings: initial?.servings ?? defaultServings(category),
    category,
    ingredients:
      initial?.ingredients ??
      ([] as { alimentCode: number; quantity: number; unit: RecipeIngredientUnit; nom: string }[]),
  };
}

export function RecipeForm({ initial, initialCategory = "plat", submitLabel, onSubmit }: RecipeFormProps) {
  const [form, setForm] = useState(() => toForm(initial, initialCategory));
  // Tant que l'utilisateur n'a pas modifié lui-même le nombre de personnes,
  // changer de catégorie continue d'ajuster la valeur par défaut (1 pour un
  // cocktail, 4 sinon). Une recette existante est considérée comme déjà figée.
  const [servingsTouched, setServingsTouched] = useState(!!initial);
  const [photoPreview, setPhotoPreview] = useState<string | null>(
    initial?.hasPhoto ? getRecipePhotoUrl(initial.id) : null
  );
  // undefined = ne pas toucher la photo existante, null = la retirer, string = nouvelle photo.
  const [photoChange, setPhotoChange] = useState<string | null | undefined>(undefined);
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  function handlePhotoChange(photoBase64: string | null) {
    setPhotoPreview(photoBase64);
    setPhotoChange(photoBase64);
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);

    if (form.ingredients.length === 0) {
      setError("Ajoutez au moins un ingrédient.");
      return;
    }

    setSubmitting(true);
    try {
      await onSubmit({
        title: form.title,
        description: form.description,
        steps: form.steps,
        servings: form.servings,
        category: form.category,
        photoBase64: photoChange,
        ingredients: form.ingredients.map(({ alimentCode, quantity }) => ({
          alimentCode,
          quantity,
        })),
      });
    } catch (err) {
      setError(err instanceof ApiError ? err.message : "Erreur lors de l'enregistrement.");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      <label>
        Titre
        <input
          value={form.title}
          onChange={(e) => setForm({ ...form, title: e.target.value })}
          required
        />
      </label>
      <label>
        Description
        <textarea
          value={form.description}
          onChange={(e) => setForm({ ...form, description: e.target.value })}
          required
        />
      </label>
      <label>
        Catégorie
        <select
          value={form.category}
          onChange={(e) => {
            const category = e.target.value as RecipeCategory;
            setForm((prev) => ({
              ...prev,
              category,
              servings: servingsTouched ? prev.servings : defaultServings(category),
            }));
          }}
          required
        >
          {RECIPE_CATEGORIES.map((c) => (
            <option key={c.value} value={c.value}>
              {c.emoji} {c.label}
            </option>
          ))}
        </select>
      </label>
      <label>
        Photo
        <PhotoField previewUrl={photoPreview} category={form.category} onChange={handlePhotoChange} />
      </label>
      <label>
        Nombre de personnes
        <input
          type="number"
          min={1}
          step="1"
          value={form.servings}
          onChange={(e) => {
            setServingsTouched(true);
            setForm({ ...form, servings: Number(e.target.value) });
          }}
          required
        />
      </label>
      <label>
        Ingrédients
        <IngredientPicker
          value={form.ingredients}
          onChange={(ingredients) => setForm({ ...form, ingredients })}
        />
      </label>
      <label>
        Étapes
        <textarea
          value={form.steps}
          onChange={(e) => setForm({ ...form, steps: e.target.value })}
          required
        />
      </label>
      {error && <p className="error">{error}</p>}
      <button type="submit" disabled={submitting}>
        {submitLabel}
      </button>
    </form>
  );
}
