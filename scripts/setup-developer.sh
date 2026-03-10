#!/bin/bash
# One-command developer setup for Auths commit signing.
# Usage: ./scripts/setup-developer.sh

set -euo pipefail

echo "=== Auths Developer Setup ==="
echo ""

# Check prerequisites
if ! command -v auths &> /dev/null; then
    echo "Error: auths CLI not found."
    echo "Install it with: brew install auths-dev/auths-cli/auths"
    echo "Or: cargo install --git https://github.com/auths-dev/auths.git auths_cli"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "Error: git not found."
    exit 1
fi

# Initialize Auths identity (non-interactive)
echo "1/3 Initializing Auths identity..."
auths init --non-interactive

# Configure Git for signing
echo "2/3 Configuring Git for Auths signing..."
auths git setup

# Set up git hooks
echo "3/3 Configuring git hooks..."
git config core.hooksPath .githooks

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Your identity:"
auths status
echo ""
echo "Next steps:"
echo "  1. Ask a team admin to add your key: auths signers add-from-github <your-github-username>"
echo "  2. Make a signed commit: git commit -am 'test: my first signed commit'"
echo "  3. Verify: git log --show-signature -1"
