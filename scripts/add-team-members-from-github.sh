#!/bin/bash
# Add one or more GitHub users' SSH keys to .auths/allowed_signers.
# Usage: ./scripts/add-team-members-from-github.sh <username1> [username2] ...

set -euo pipefail

SIGNERS_FILE=".auths/allowed_signers"

if [ $# -eq 0 ]; then
    echo "Usage: $0 <github-username> [github-username ...]"
    echo ""
    echo "Examples:"
    echo "  $0 alice"
    echo "  $0 alice bob charlie"
    exit 1
fi

if ! command -v auths &> /dev/null; then
    echo "Error: auths CLI not found."
    echo "Install it with: brew install auths-dev/auths-cli/auths"
    exit 1
fi

ADDED=0
for username in "$@"; do
    echo "Adding keys for $username..."
    if auths signers add-from-github "$username"; then
        ADDED=$((ADDED + 1))
        echo "  Added $username"
    else
        echo "  Warning: could not add $username (no Ed25519 keys found?)"
    fi
done

echo ""
echo "Done. Added keys for $ADDED/$# users."
echo ""
echo "Next steps:"
echo "  git add $SIGNERS_FILE"
echo "  git commit -m 'chore: add team members to allowed signers'"
echo "  git push"
