---
description: "Analyse les changements Git, propose un message de commit et crée le commit après confirmation"
argument-hint: "[message libre ou --all]"
allowed-tools: ["Bash"]
---

# Créer un commit Git

Analyse les changements staged/unstaged, génère un message de commit cohérent avec l'historique du projet, et crée le commit après confirmation.

## Étapes

### 1. Analyser l'état du dépôt

```bash
git status --short
git diff --cached --stat
git diff --stat
```

### 2. Gérer le staging

Si `$ARGUMENTS` contient `--all` : stage tous les fichiers modifiés (`git add -A`) avant de continuer.

Sinon :
- Si des fichiers sont déjà staged → continuer avec ce qui est staged
- Si rien n'est staged mais qu'il y a des modifications → demander à l'utilisateur quels fichiers stager, ou proposer `git add -A` et attendre confirmation

Ne jamais stager silencieusement sans que l'utilisateur ait explicitement demandé `--all` ou confirmé.

### 3. Lire le diff staged

```bash
git diff --cached -- ':!*.lock' ':!*.sum' ':!dist/' ':!vendor/'
```

Limiter à 300 lignes si le diff est volumineux.

### 4. Analyser le style de l'historique

```bash
git log --oneline -10
```

Détecter :
- Conventional commits (`feat:`, `fix:`, `chore:`, etc.)
- Format libre
- Langue (français / anglais)

Adopter le style dominant du projet.

### 5. Générer le message de commit

Si `$ARGUMENTS` contient un message libre (pas `--all`) → l'utiliser comme base et affiner si besoin.

Sinon, générer :

**Première ligne** (≤ 72 caractères) :
- Impératif présent, même langue que l'historique
- Conventional commit si le projet l'utilise : `type(scope): action`
- Pas de point final

**Corps** (optionnel, séparé par une ligne vide) :
- Uniquement si le changement est non trivial et que le pourquoi n'est pas évident
- Bullet points courts
- Pas de redite avec le titre

### 6. Présenter et demander confirmation

Afficher :
- La liste des fichiers qui seront committés
- Le message proposé (titre + corps si applicable)

Demander confirmation. Si l'utilisateur veut modifier le message, l'intégrer et redemander confirmation.

### 7. Créer le commit

```bash
git commit -m "<titre>" [-m "<corps si présent>"]
```

Afficher le hash court du commit créé.
