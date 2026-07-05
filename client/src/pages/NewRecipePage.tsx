import { useNavigate } from "react-router-dom";
import { createRecipe } from "../api/recipes";
import { RecipeForm } from "../components/RecipeForm";

export function NewRecipePage() {
  const navigate = useNavigate();

  return (
    <div>
      <h1>Proposer une nouvelle recette</h1>
      <section className="create-recipe">
        <RecipeForm
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
