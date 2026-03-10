# Developer Onboarding

Welcome to the team! Follow these steps to set up commit signing with Auths.

## Prerequisites

- Git 2.34+
- Auths CLI: `brew install auths-dev/auths-cli/auths`

## Step-by-Step

### 1. Initialize your Auths identity

```bash
auths init
```

This creates a cryptographic identity on your machine and registers it with the Auths registry.

### 2. Configure Git for signing

```bash
auths git setup
```

This sets `gpg.format = ssh`, `commit.gpgsign = true`, and points your signing key to the Auths-managed key.

### 3. Configure git hooks

```bash
git config core.hooksPath .githooks
```

This activates the pre-commit (signing warning) and post-merge (auto-sync signers) hooks.

### 4. Add yourself to allowed signers

Ask a team admin to run:

```bash
auths signers add-from-github <your-github-username>
git add .auths/allowed_signers
git commit -m "chore: add <your-name> to allowed signers"
git push
```

Or run the bulk script:

```bash
./scripts/add-team-members-from-github.sh <your-github-username>
```

### 5. Make your first signed commit

```bash
echo "# Hello from $(whoami)" >> CONTRIBUTORS.md
git add CONTRIBUTORS.md
git commit -m "chore: add myself to contributors"
```

### 6. Verify your signature

```bash
git log --show-signature -1
```

You should see `Good "git" signature for <your-email>`.

## Pairing a Second Device

If you work on multiple machines:

```bash
# On your new device
auths init
auths pair
```

Follow the prompts to link the new device to your existing identity.

## Troubleshooting

- **"error: Load key: No such file"** — Run `auths status` to check your identity. You may need to run `auths init` again.
- **"Could not sign commit"** — Ensure `ssh-agent` is running: `eval "$(ssh-agent -s)"`.
