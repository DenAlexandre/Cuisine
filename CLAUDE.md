# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A recipe site with role-based access (`user` / `admin`). Users submit recipes (with structured
ingredients drawn from an imported nutrition database) which stay `pending` until an admin approves
or rejects them via `/admin`. Approved recipes are public. Recipes carry a computed nutrition
summary (protein/carbs/fat/energy) derived from their linked ingredients.

Monorepo: `client/` (React) + `server/` (Express API), each with its own `package.json` and no
shared root scripts — always `cd` into the relevant one first.

## Commands

Database (requires Docker):
```powershell
./scripts/start-db.ps1        # idempotent: creates or starts the "cuisine-db" postgres container
```

Server (`server/`):
```bash
cp .env.example .env          # required — .env is gitignored and NOT persisted; recreate if missing
npm install
npm run migrate                # idempotent schema migration (safe to re-run)
npm run seed                   # creates/updates the admin account from SEED_ADMIN_* env vars
npm run import:aliments        # idempotent: imports/re-derives the ~3185-row nutrition dataset
npm run dev                     # tsx watch, http://localhost:4000
npm run build                   # tsc -> dist/
```

Client (`client/`):
```bash
cp .env.example .env          # VITE_API_URL, defaults to http://localhost:4000/api
npm install
npm run dev                     # http://localhost:5173
npm run build                   # tsc -b && vite build
npm run lint                    # oxlint
```

Convenience script for both at once: `./scripts/run-dev.ps1` (installs deps if missing, opens
server + client each in their own PowerShell window).

There is no test suite in this repo.

**Before starting dev servers, check whether they're already running** (e.g. `netstat -an | grep -E "4000|5173"`)
instead of blindly spawning new ones — this project has repeatedly hit `EADDRINUSE` and duplicate
terminal windows from doing that.

VS Code: open `Cuisine.code-workspace`, then use the `Full Stack: Server + Client` launch config
(Run and Debug panel) to run both with breakpoints attached — configs live in `.vscode/launch.json`
and `.vscode/tasks.json`.

## Architecture

### Auth

JWT in an httpOnly cookie (`token`), signed/verified in `server/src/utils/jwt.ts`. Login is by
**username** (pseudo), not email — see `server/src/routes/auth.ts`. Three middlewares in
`server/src/middleware/auth.ts`:
- `requireAuth` — 401s if no valid cookie.
- `optionalAuth` — populates `req.user` if a valid cookie is present, otherwise continues as
  anonymous. Used on `GET /api/recipes/:id` so the same endpoint serves public visitors, the
  recipe's own author (to preview a `pending`/`rejected` recipe), and admins.
- `requireRole('admin')` — used on all of `server/src/routes/admin.ts`.

### Recipe → ingredient → nutrition pipeline

Recipes don't store free-text ingredients. `recipe_ingredients` links a recipe to an `aliments` row
by `aliment_code` + `quantity_g`. All recipe read endpoints (list/mine/detail) pass their rows
through `attachIngredients()` in `server/src/routes/recipes.ts` (also reused by
`server/src/routes/admin.ts`), which joins `recipe_ingredients` + `aliments` and computes the
per-recipe nutrition total (`quantityG/100 * per-100g value`, summed per ingredient) server-side —
the client never recomputes this. Writes go through `writeIngredients()`, which replaces a recipe's
entire ingredient set inside a transaction (delete-then-reinsert, not a diff).

### Nutrition reference data

`server/src/db/seed-data/aliments.sql` is a static, committed snapshot (~3185 `INSERT` statements,
each with `ON CONFLICT (t_aliment_code) DO NOTHING`) derived once from an external "Nutrition"
project's Postgres dump — that source project is not a runtime dependency. `npm run import:aliments`
(`server/src/db/import-aliments.ts`) is the only thing that loads it, and does more than a straight
import:
1. Runs the raw INSERTs into `aliments` (idempotent).
2. Derives `groupes` / `sous_groupes` / `sous_sous_groupes` from the raw `t_groupe_nom` /
   `t_ss_groupe_nom` / `t_ss_ss_groupe_nom` text columns on `aliments`, picking the most-frequent
   non-blank name per code (the source data has some blank/inconsistent names for a given code).
3. Adds FK constraints from `aliments` to those tables — deliberately done *after* population,
   because `aliments` and the group tables are populated from the same source data and a FK added
   too early would fail validation against not-yet-inserted rows.
4. Derives a much coarser, human-friendly `categories_simples` (11 rows: Fruits, Légumes, etc.) via
   a hardcoded `CASE` mapping keyed on `t_groupe_code`/`t_ss_groupe_code`, and sets
   `aliments.categorie_code` accordingly. This is what the app's UI actually filters/displays by —
   the detailed `groupes`/`sous_groupes`/`sous_sous_groupes` tables still exist and stay populated
   for data provenance but have no route or UI exposing them anymore.

Gotcha if you touch this: `aliments.categorie_code` has a `DEFAULT 7` specifically so the raw
`ON CONFLICT DO NOTHING` INSERT (step 1) doesn't fail its `NOT NULL` constraint on a re-run before
step 4 recomputes the real value — every row's category is unconditionally recalculated on every
import, so the default's actual value doesn't matter, but removing it breaks idempotency.

### Database migrations

`server/src/db/migrate.ts` is a single hand-written idempotent SQL script (no migration framework):
`CREATE TABLE IF NOT EXISTS` for new tables, paired `ADD COLUMN IF NOT EXISTS` + backfill `UPDATE`
+ `SET NOT NULL` for adding a required column to a table that may already have rows (see how
`users.username`/`recipes.servings`/`aliments.categorie_code` were each added this way). Always
follow this pattern rather than assuming a fresh database.

### Backend structure

Route modules under `server/src/routes/` are mounted in `server/src/index.ts`. Each route file owns
its own Zod schema (defined inline, e.g. `recipeSchema` in `recipes.ts`) — there's no shared
validation layer. `express-async-errors` is imported once in `index.ts` so `async` route handlers
that throw are caught by the trailing error-handling middleware without manual try/catch.

### Frontend structure

`client/src/api/*.ts` wraps every backend route (one file per resource); all requests go through
`apiFetch()` in `client/src/api/client.ts`, which sets `credentials: "include"` (required for the
auth cookie) and throws `ApiError` on non-2xx. `AuthContext` (`client/src/context/AuthContext.tsx`)
loads the current user via `GET /api/auth/me` on mount and exposes `login`/`register`/`logout`.
`ProtectedRoute` / `AdminRoute` (`client/src/components/ProtectedRoute.tsx`) gate routes in
`App.tsx` on auth state.

Layout (`client/src/components/Layout.tsx`) is a persistent left sidebar on desktop that becomes a
slide-in drawer (hamburger-triggered, backdrop-dismissible) below the `880px` breakpoint defined in
`index.css` — there's no CSS framework, all styling is hand-written in the single `index.css`.

`IngredientPicker` (recipe form) and `NutritionPage` both search aliments via the same
`CategoryFilter` component + `searchAliments()` API call (`q` and/or `categorieCode`, at least one
required or the endpoint returns an empty list).
