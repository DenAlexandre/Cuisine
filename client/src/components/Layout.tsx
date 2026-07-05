import { useState } from "react";
import { Link, NavLink, Outlet, useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export function Layout() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [menuOpen, setMenuOpen] = useState(false);

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
            <NavLink to="/admin" onClick={closeMenu}>
              Validations
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
          <Outlet />
        </main>
      </div>
    </div>
  );
}
