# Déploiement gratuit (Neon + Render + Vercel)

Ce guide suppose que le code est déjà poussé sur `github.com/DenAlexandre/Cuisine.git` (remote déjà
configuré). Trois services gratuits, chacun avec un rôle précis :

- **Neon** : base PostgreSQL (remplace le conteneur Docker local)
- **Render** : héberge le serveur Express (API)
- **Vercel** : héberge le client React (statique)

## 1. Neon (base de données)

1. Créez un compte sur [neon.tech](https://neon.tech) (gratuit, pas de carte bancaire requise).
2. Créez un projet, nommez la base `cuisine`.
3. Dans le dashboard du projet, copiez la **Connection string** (format
   `postgres://user:password@host/cuisine?sslmode=require`).
4. Depuis votre machine, initialisez le schéma sur cette base distante :
   ```bash
   cd server
   DATABASE_URL="<connection string Neon>" npm run migrate
   DATABASE_URL="<connection string Neon>" npm run seed
   DATABASE_URL="<connection string Neon>" npm run import:aliments
   ```
   (sous PowerShell : `$env:DATABASE_URL="<...>"; npm run migrate`, etc.)
5. Gardez cette connection string de côté, elle sera réutilisée à l'étape Render.

## 2. Render (serveur API)

1. Créez un compte sur [render.com](https://render.com), connectez votre compte GitHub.
2. Dashboard Render → **New** → **Blueprint** → sélectionnez le repo `Cuisine`. Render détecte
   automatiquement `render.yaml` à la racine (déjà présent dans le repo) et propose de créer le
   service `cuisine-server`.
3. Render vous demande de renseigner les variables marquées `sync: false` :
   - `DATABASE_URL` : la connection string Neon de l'étape 1.
   - `CLIENT_ORIGIN` : laissez vide pour l'instant, à renseigner après l'étape Vercel (l'URL Vercel
     du client). Vous pourrez la modifier après coup dans Render sans redéployer manuellement.
   - `SEED_ADMIN_*` : reprenez les valeurs de `server/.env` (ou vos propres identifiants admin).
   - `JWT_SECRET` : laissez Render le générer automatiquement (`generateValue: true`).
4. Déployez. Notez l'URL générée par Render, du type `https://cuisine-server.onrender.com`.
5. **Limite du plan gratuit** : le service s'endort après 15 minutes d'inactivité ; la requête
   suivante prend 30 à 60 secondes le temps qu'il redémarre. Normal, pas un bug.

## 3. Vercel (client)

1. Créez un compte sur [vercel.com](https://vercel.com), connectez votre compte GitHub.
2. **Add New** → **Project** → importez le repo `Cuisine`.
3. Dans la configuration du projet :
   - **Root Directory** : `client` (important, sinon Vercel essaiera de builder tout le monorepo).
   - Framework détecté automatiquement : Vite.
   - Variable d'environnement : `VITE_API_URL` = `https://cuisine-server.onrender.com/api`
     (l'URL Render de l'étape 2, suffixée de `/api`).
4. Déployez. Notez l'URL générée par Vercel, du type `https://cuisine-xxxx.vercel.app`.

## 4. Boucler la config CORS

Retournez dans Render → service `cuisine-server` → Environment → mettez à jour `CLIENT_ORIGIN`
avec l'URL Vercel exacte de l'étape 3 (sans `/` final), puis redéployez le service (Render le fait
automatiquement après un changement de variable d'environnement).

## Vérification

- Ouvrez l'URL Vercel : la page de connexion doit s'afficher.
- Connectez-vous avec les identifiants `SEED_ADMIN_*` définis à l'étape Render.
- Si la connexion échoue avec une erreur réseau/CORS dans la console du navigateur, vérifiez que
  `CLIENT_ORIGIN` (Render) correspond exactement à l'URL Vercel, et que `VITE_API_URL` (Vercel)
  pointe bien vers `.../api` sur l'URL Render.

## Mises à jour futures

Un `git push` sur `main` redéploie automatiquement le client (Vercel) et le serveur (Render) : les
deux surveillent le repo GitHub. Pour rejouer une migration après un changement de schéma, relancez
la commande `npm run migrate` de l'étape 1 avec la connection string Neon.
