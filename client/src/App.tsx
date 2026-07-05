import { Route, Routes } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import { Layout } from "./components/Layout";
import { ProtectedRoute, AdminRoute } from "./components/ProtectedRoute";
import { HomePage } from "./pages/HomePage";
import { RecipeDetailPage } from "./pages/RecipeDetailPage";
import { LoginPage } from "./pages/LoginPage";
import { RegisterPage } from "./pages/RegisterPage";
import { MyRecipesPage } from "./pages/MyRecipesPage";
import { NewRecipePage } from "./pages/NewRecipePage";
import { EditRecipePage } from "./pages/EditRecipePage";
import { AdminPage } from "./pages/AdminPage";
import { NutritionPage } from "./pages/NutritionPage";
import { ImcPage } from "./pages/ImcPage";

function App() {
  return (
    <AuthProvider>
      <Routes>
        <Route element={<Layout />}>
          <Route index element={<HomePage />} />
          <Route path="recettes/:id" element={<RecipeDetailPage />} />
          <Route
            path="recettes/:id/modifier"
            element={
              <ProtectedRoute>
                <EditRecipePage />
              </ProtectedRoute>
            }
          />
          <Route
            path="nutrition"
            element={
              <AdminRoute>
                <NutritionPage />
              </AdminRoute>
            }
          />
          <Route
            path="imc"
            element={
              <ProtectedRoute>
                <ImcPage />
              </ProtectedRoute>
            }
          />
          <Route path="login" element={<LoginPage />} />
          <Route path="register" element={<RegisterPage />} />
          <Route
            path="mes-recettes"
            element={
              <ProtectedRoute>
                <MyRecipesPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="nouvelle-recette"
            element={
              <ProtectedRoute>
                <NewRecipePage />
              </ProtectedRoute>
            }
          />
          <Route
            path="admin"
            element={
              <AdminRoute>
                <AdminPage />
              </AdminRoute>
            }
          />
        </Route>
      </Routes>
    </AuthProvider>
  );
}

export default App;
