# Developer Offboarding

When a team member leaves, revoke their signing key to prevent future commits from being verified under their identity.

## Steps

### 1. Remove from allowed signers

Open `.auths/allowed_signers` and remove the line containing their email:

```bash
# Find their entry
grep "departing-dev@example.com" .auths/allowed_signers

# Remove it (or edit the file manually)
sed -i '' '/departing-dev@example.com/d' .auths/allowed_signers
```

### 2. Commit and push

```bash
git add .auths/allowed_signers
git commit -m "chore: revoke signing key for departing-dev"
git push
```

### 3. Notify the team

Let the team know the key has been revoked. Past commits signed by the departing developer remain valid — revocation only prevents new commits from being verified.

### 4. Verify revocation

After the next CI run, any new commits signed by the revoked key will fail verification:

```bash
auths verify --allowed-signers .auths/allowed_signers
```

## Notes

- Revocation is immediate once `.auths/allowed_signers` is updated and pushed.
- The nightly sync workflow will not re-add revoked keys unless they are still registered in the Auths registry. If the developer has been removed from the GitHub org, their keys will not be re-synced.
- Consider also removing the developer from your GitHub org and any CI secrets they had access to.
