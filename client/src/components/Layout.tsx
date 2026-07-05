import { useCallback, useEffect, useState } from "react";
import { Link, NavLink, Outlet, useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { fetchPendingRecipes } from "../api/recipes";

const PENDING_POLL_INTERVAL_MS = 30_000;

export function Layout() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [menuOpen, setMenuOpen] = useState(false);
  const [pendingCount, setPendingCount] = useState(0);

  const refreshPendingCount = useCallback(() => {
    if (user?.role !== "admin") return;
    fetchPendingRecipes()
      .then(({ recipes }) => setPendingCount(recipes.length))
      .catch(() => {});
  }, [user?.role]);

  useEffect(() => {
    if (user?.role !== "admin") {
      setPendingCount(0);
      return;
    }
    refreshPendingCount();
    const interval = setInterval(refreshPendingCount, PENDING_POLL_INTERVAL_MS);
    return () => clearInterval(interval);
  }, [user?.role, refreshPendingCount]);

  function handleLogout() {
    logout();
    navigate("/");
  }

  function closeMenu() {
    setMenuOpen(false);
  }

  return (
    <div className="shell">
      <aside className={`sidebar ${menuOpen ? "open" : ""}`}>
        <Link to="/" className="brand" onClick={closeMenu}>
          🍲 Cuisine
        </Link>

        <nav>
          <NavLink to="/" onClick={closeMenu} end>
            Recettes
          </NavLink>
          {user && (
            <NavLink to="/imc" onClick={closeMenu}>
              IMC
            </NavLink>
          )}
          {user?.role === "admin" && (
            <NavLink to="/nutrition" onClick={closeMenu}>
              Nutrition
            </NavLink>
          )}
          {user && (
            <NavLink to="/mes-recettes" onClick={closeMenu}>
              Mes recettes
            </NavLink>
          )}
          {user?.role === "admin" && (
            <NavLink to="/admin" onClick={closeMenu} className="nav-link-with-badge">
              Validations
              {pendingCount > 0 && (
                <span className="nav-badge" title={`${pendingCount} recette(s) en attente de validation`}>
                  {pendingCount}
                </span>
              )}
            </NavLink>
          )}
          {user?.role === "admin" && (
            <NavLink to="/admin/utilisateurs" onClick={closeMenu}>
              Utilisateurs
            </NavLink>
          )}
        </nav>

        <div className="auth-actions">
          {user ? (
            <>
              <span>{user.username}</span>
              <button onClick={handleLogout}>Déconnexion</button>
            </>
          ) : (
            <>
              <Link to="/login" onClick={closeMenu}>
                Connexion
              </Link>
              <Link to="/register" onClick={closeMenu}>
                Inscription
              </Link>
            </>
          )}
        </div>
      </aside>

      <div className={`sidebar-backdrop ${menuOpen ? "open" : ""}`} onClick={closeMenu} />

      <div className="main-area">
        <header className="mobile-topbar">
          <button
            type="button"
            className="nav-toggle"
            onClick={() => setMenuOpen((open) => !open)}
            aria-label={menuOpen ? "Fermer le menu" : "Ouvrir le menu"}
            aria-expanded={menuOpen}
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <line x1="3" y1="6" x2="21" y2="6" />
              <line x1="3" y1="12" x2="21" y2="12" />
              <line x1="3" y1="18" x2="21" y2="18" />
            </svg>
          </button>
          <Link to="/" className="brand" onClick={closeMenu}>
            🍲 Cuisine
          </Link>
        </header>
        <main>
          <Outlet context={{ refreshPendingCount }} />
        </main>
      </div>
    </div>
  );
}
