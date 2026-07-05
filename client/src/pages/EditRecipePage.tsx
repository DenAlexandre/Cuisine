import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { fetchRecipe, updateRecipe } from "../api/recipes";
import type { Recipe } from "../api/recipes";
import { ApiError } from "../api/client";
import { RecipeForm } from "../components/RecipeForm";

export function EditRecipePage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [recipe, setRecipe] = useState<Recipe | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!id) return;
    fetchRecipe(id)
      .then(({ recipe }) => setRecipe(recipe))
      .catch((err) => setError(err instanceof ApiError ? err.message : "Erreur inconnue."))
      .finally(() => setLoading(false));
  }, [id]);

  if (loading) return <p>Chargement...</p>;
  if (error) return <p className="error">{error}</p>;
  if (!recipe) return null;

  return (
    <div>
      <h1>Modifier la recette</h1>
      <section className="create-recipe">
        <RecipeForm
          initial={recipe}
          submitLabel="Enregistrer"
          onSubmit={async (input) => {
            await updateRecipe(recipe.id, input);
            navigate(`/recettes/${recipe.id}`);
          }}
        />
      </section>
    </div>
  );
}
