import { useNavigate, useSearchParams } from "react-router-dom";
import { createRecipe } from "../api/recipes";
import type { RecipeCategory } from "../api/recipes";
import { RecipeForm } from "../components/RecipeForm";
import { RECIPE_CATEGORIES } from "../constants/recipeCategories";

export function NewRecipePage() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const categoryParam = searchParams.get("categorie") as RecipeCategory | null;
  const initialCategory =
    RECIPE_CATEGORIES.find((c) => c.value === categoryParam)?.value ?? "plat";

  return (
    <div>
      <h1>Proposer une nouvelle recette</h1>
      <section className="create-recipe">
        <RecipeForm
          initialCategory={initialCategory}
          submitLabel="Soumettre pour validation"
          onSubmit={async (input) => {
            await createRecipe(input);
            navigate("/mes-recettes");
          }}
        />
      </section>
    </div>
  );
}
