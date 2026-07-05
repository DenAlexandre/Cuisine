# Cuisine

Site de recettes de cuisine avec gestion de rôles : les utilisateurs (`user`) proposent des recettes,
qui doivent être validées par un administrateur (`admin`) avant d'être visibles publiquement.

## Stack

- **client/** : React + Vite + TypeScript, React Router
- **server/** : Node.js + Express + TypeScript, PostgreSQL (`pg`), JWT (cookie httpOnly), bcrypt

## Prérequis

- Node.js 18+
- Une base PostgreSQL accessible

## Installation

### 1. Base de données

Le plus simple : lancer PostgreSQL via Docker avec le script fourni (idempotent, volume persistant) :

```powershell
./start-db.ps1
```

Sinon, créez manuellement une base PostgreSQL (ex: `cuisine`), puis dans `server/` :

```bash
cd server
cp .env.example .env
# éditez .env : DATABASE_URL, JWT_SECRET, SEED_ADMIN_EMAIL, SEED_ADMIN_PASSWORD
npm install
npm run migrate   # crée les tables users / recipes
npm run seed      # crée le compte admin défini dans .env
```

### 2. Serveur API

```bash
cd server
npm run dev       # démarre sur http://localhost:4000
```

### 3. Client

```bash
cd client
cp .env.example .env   # VITE_API_URL=http://localhost:4000/api
npm install
npm run dev             # démarre sur http://localhost:5173
```

## Lancer en debug depuis VS Code

Ouvrez `Cuisine.code-workspace` (double-clic, ou `code Cuisine.code-workspace`), puis dans l'onglet **Run and Debug** (Ctrl+Shift+D) :

- **Server: Debug (Express/TS)** : lance `npm run dev` dans un terminal avec breakpoints actifs sur le code TypeScript du serveur.
- **Client: Debug (Chrome)** : démarre le serveur Vite puis ouvre Chrome avec les breakpoints actifs sur le code React (`client/src`).
- **Full Stack: Server + Client** : lance les deux en même temps.

Les configurations sont dans `.vscode/launch.json` et `.vscode/tasks.json`.

## Fonctionnement

- Un visiteur non connecté peut consulter les recettes **validées**.
- Un utilisateur inscrit peut proposer une recette (statut `pending`), voir ses propres soumissions
  (tous statuts) et supprimer/modifier celles encore en attente.
- Un administrateur (compte créé via `npm run seed`) accède à `/admin` pour valider ou rejeter les
  recettes en attente.

## Structure

```
Cuisine/
├── client/   # application React
└── server/   # API REST Express
```
