# Key Rotation Policy

Keys should be rotated every 90 days to limit the blast radius of a compromised key.

## When to Rotate

- Every 90 days (set a calendar reminder)
- Immediately if you suspect your key has been compromised
- When switching machines (generate a new key on the new device)

## Rotation Steps

### 1. Generate a new identity

```bash
auths init --force
```

This creates a new cryptographic key pair and updates your local signing configuration.

### 2. Update allowed signers

Ask a team admin to add your new key:

```bash
auths signers add-from-github <your-github-username>
```

Or wait for the nightly sync workflow to pick up the new key automatically.

### 3. Remove the old key

Once the new key is in `.auths/allowed_signers`, remove the old entry:

```bash
# The old key line will have your email but a different public key
# Edit .auths/allowed_signers to remove the outdated line
```

### 4. Commit the update

```bash
git add .auths/allowed_signers
git commit -m "chore: rotate signing key for $(git config user.email)"
git push
```

### 5. Verify

```bash
git log --show-signature -1
```

## Automation

The `enforce-rotation-policy.yml` workflow (if configured) can flag keys older than 90 days and notify developers to rotate.

## FAQ

**Do old commits become unverified after rotation?**
No. Commits signed with the old key remain verifiable as long as the old key was in `allowed_signers` at the time of signing. Removing the old key only prevents new commits from being verified with it.

**Can I have two keys active during rotation?**
Yes. Keep both the old and new key in `allowed_signers` during the transition period, then remove the old key once you've confirmed the new key works.
