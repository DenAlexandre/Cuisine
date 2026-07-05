import { useEffect, useState } from "react";
import type { FormEvent } from "react";
import { Link } from "react-router-dom";
import { createRecipe, deleteRecipe, fetchMyRecipes } from "../api/recipes";
import type { Recipe } from "../api/recipes";
import { ApiError } from "../api/client";
import { IngredientPicker } from "../components/IngredientPicker";

const STATUS_LABELS: Record<Recipe["status"], string> = {
  pending: "En attente",
  approved: "Validée",
  rejected: "Rejetée",
};

const EMPTY_FORM = {
  title: "",
  description: "",
  steps: "",
  servings: 4,
  ingredients: [] as { alimentCode: number; quantityG: number; nom: string }[],
};

export function MyRecipesPage() {
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState(EMPTY_FORM);
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  function loadRecipes() {
    return fetchMyRecipes().then(({ recipes }) => setRecipes(recipes));
  }

  useEffect(() => {
    loadRecipes().finally(() => setLoading(false));
  }, []);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);

    if (form.ingredients.length === 0) {
      setError("Ajoutez au moins un ingrédient.");
      return;
    }

    setSubmitting(true);
    try {
      await createRecipe({
        title: form.title,
        description: form.description,
        steps: form.steps,
        servings: form.servings,
        ingredients: form.ingredients.map(({ alimentCode, quantityG }) => ({
          alimentCode,
          quantityG,
        })),
      });
      setForm(EMPTY_FORM);
      await loadRecipes();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : "Erreur lors de la création.");
    } finally {
      setSubmitting(false);
    }
  }

  async function handleDelete(id: number) {
    await deleteRecipe(id);
    await loadRecipes();
  }

  return (
    <div>
      <h1>Mes recettes</h1>

      <section className="create-recipe">
        <h2>Proposer une nouvelle recette</h2>
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
            Nombre de personnes
            <input
              type="number"
              min={1}
              step="1"
              value={form.servings}
              onChange={(e) => setForm({ ...form, servings: Number(e.target.value) })}
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
            Soumettre pour validation
          </button>
        </form>
      </section>

      <section>
        <h2>Mes soumissions</h2>
        {loading && <p>Chargement...</p>}
        {!loading && recipes.length === 0 && <p>Vous n'avez pas encore proposé de recette.</p>}
        <ul className="my-recipes-list">
          {recipes.map((recipe) => (
            <li key={recipe.id}>
              <Link to={`/recettes/${recipe.id}`}>{recipe.title}</Link>
              <span className={`status-badge status-${recipe.status}`}>
                {STATUS_LABELS[recipe.status]}
              </span>
              {recipe.status === "pending" && (
                <button onClick={() => handleDelete(recipe.id)}>Supprimer</button>
              )}
            </li>
          ))}
        </ul>
      </section>
    </div>
  );
}
