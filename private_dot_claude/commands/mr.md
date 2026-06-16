---
description: "Gère les Merge Requests GitLab — crée une MR pour la branche courante (défaut) ou affiche la MR existante"
argument-hint: "[create] [branche-cible] [--draft]"
---

# Merge Request GitLab

## Router la commande

### 1. Vérifier l'état Git

```bash
git status --short
git branch --show-current
git remote -v
```

Si le working tree contient des modifications non commitées, signale-le à l'utilisateur et demande confirmation avant de continuer.

### 2. Détecter une MR existante

```bash
glab mr list --source-branch $(git branch --show-current) --json iid,title,webUrl,state,draft 2>/dev/null
```

**Si une MR existe déjà pour la branche courante :**
- Afficher : titre, URL, état (open/draft/merged/closed)
- Si `$ARGUMENTS` ne contient pas `create` → **s'arrêter ici** en précisant que la MR existe déjà et rappeler que `/mr create` force la création d'une nouvelle MR
- Si `$ARGUMENTS` contient `create` → prévenir que la MR existe déjà, demander confirmation explicite avant de continuer

**Si aucune MR n'existe → passer directement à la création.**

---

## Création de MR

### 3. Déterminer la branche cible

Si `$ARGUMENTS` contient une branche connue (ex: `main`, `develop`), l'utiliser.
Sinon, détecter automatiquement :

```bash
git remote show origin 2>/dev/null | grep "HEAD branch" | awk '{print $NF}'
```

Fallback : `main` > `master` > `develop`.

### 4. Analyser les changements

```bash
git log origin/<branche-cible>..HEAD --oneline --no-merges
git diff origin/<branche-cible>...HEAD --stat
git diff origin/<branche-cible>...HEAD -- ':!*.lock' ':!*.sum' ':!dist/' ':!vendor/' | head -500
```

### 5. Pousser la branche si nécessaire

```bash
git push -u origin HEAD 2>&1
```

Si le push échoue, signale l'erreur et arrête.

### 6. Générer le titre et la description

**Titre** (≤ 72 caractères) :
- Format : `[scope]: action courte` ou directement l'action si pas de scope évident
- Impératif présent : "Add", "Fix", "Refactor", "Update", "Remove"
- Ne pas répéter le nom de la branche tel quel

**Description** (Markdown, concise et technique) :

```markdown
## Changements

- <bullet point technique, 1 ligne par changement majeur>
- ...

## Motivations

<1-3 phrases expliquant POURQUOI ces changements, pas QUOI>

## Points d'attention

<Optionnel — risques, effets de bord, dépendances, migrations>
```

Critères :
- Pas de redite avec les commit messages
- "Points d'attention" uniquement s'il y a vraiment quelque chose à signaler
- Si la MR est petite (≤ 3 fichiers, 1 commit), description ultra-courte (2-4 lignes)

### 7. Présenter et demander confirmation

Affiche :
- **Branche source** → **Branche cible**
- **Titre** proposé
- **Description** proposée
- **--draft** si l'argument `--draft` est passé

Demande confirmation avant de créer.

### 8. Créer la Merge Request

```bash
glab mr create \
  --title "<titre>" \
  --description "<description>" \
  --target-branch <branche-cible> \
  [--draft si --draft dans $ARGUMENTS]
```

Si `glab` échoue, utilise l'outil MCP `mcp__gitlab__create_merge_request` en fallback.

### 9. Afficher le résultat

Affiche l'URL de la MR créée.
Si la MR est en draft, rappelle : `glab mr ready <id>`.
