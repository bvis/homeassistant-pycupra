#!/usr/bin/env bash
# Installs git hooks for this repository.

set -e

HOOK_DIR="$(git rev-parse --show-toplevel)/.git/hooks"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cp "$SCRIPT_DIR/pre-push" "$HOOK_DIR/pre-push"
chmod +x "$HOOK_DIR/pre-push"

echo "Git hooks installed successfully."
