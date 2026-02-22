#!/usr/bin/env bash
set -euo pipefail

# project-assessor install script
# Creates symlinks so /scout, /assess, /compare are available in any project

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMMANDS_SRC="$SCRIPT_DIR/.claude/commands"
TEMPLATES_SRC="$SCRIPT_DIR/templates"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "┌─────────────────────────────────────┐"
echo "│     Project Assessor — Install       │"
echo "└─────────────────────────────────────┘"
echo ""

# Verify source files exist
if [ ! -f "$COMMANDS_SRC/scout.md" ]; then
    echo -e "${RED}Error: scout.md not found in $COMMANDS_SRC${NC}"
    echo "Make sure you're running this from the project-assessor repo."
    exit 1
fi

# Determine install mode
echo "How would you like to install?"
echo ""
echo "  1) Global  — Symlink to ~/.claude/commands (available everywhere)"
echo "  2) Local   — Copy to current project's .claude/commands"
echo "  3) Cancel"
echo ""
read -rp "Choice [1/2/3]: " choice

case "$choice" in
    1)
        TARGET_DIR="$HOME/.claude/commands"
        TEMPLATE_TARGET="$HOME/.project-assessor/templates"
        MODE="symlink"
        ;;
    2)
        TARGET_DIR="$(pwd)/.claude/commands"
        TEMPLATE_TARGET="$(pwd)/.assessor-templates"
        MODE="copy"
        ;;
    3)
        echo "Cancelled."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice.${NC}"
        exit 1
        ;;
esac

# Create target directories
mkdir -p "$TARGET_DIR"
mkdir -p "$TEMPLATE_TARGET"

# Install commands
COMMANDS=(scout.md assess.md compare.md)
for cmd in "${COMMANDS[@]}"; do
    if [ "$MODE" = "symlink" ]; then
        ln -sf "$COMMANDS_SRC/$cmd" "$TARGET_DIR/$cmd"
        echo -e "  ${GREEN}✓${NC} Symlinked $cmd → $TARGET_DIR/$cmd"
    else
        cp "$COMMANDS_SRC/$cmd" "$TARGET_DIR/$cmd"
        echo -e "  ${GREEN}✓${NC} Copied $cmd → $TARGET_DIR/$cmd"
    fi
done

# Install templates
TEMPLATES=(PROJECT_CONTEXT.md ASSESSMENT.md COMPARISON.md)
for tmpl in "${TEMPLATES[@]}"; do
    if [ "$MODE" = "symlink" ]; then
        ln -sf "$TEMPLATES_SRC/$tmpl" "$TEMPLATE_TARGET/$tmpl"
        echo -e "  ${GREEN}✓${NC} Symlinked $tmpl → $TEMPLATE_TARGET/$tmpl"
    else
        cp "$TEMPLATES_SRC/$tmpl" "$TEMPLATE_TARGET/$tmpl"
        echo -e "  ${GREEN}✓${NC} Copied $tmpl → $TEMPLATE_TARGET/$tmpl"
    fi
done

echo ""
echo -e "${GREEN}Install complete.${NC}"
echo ""
echo "Usage:"
echo "  cd /path/to/any-project"
echo "  claude"
echo "  /scout          # Extract project context"
echo "  /assess         # Run full assessment"
echo "  /compare A B    # Compare two assessments"
echo ""

if [ "$MODE" = "symlink" ]; then
    echo -e "${YELLOW}Note:${NC} Commands are symlinked. Updates to this repo auto-propagate."
    echo "  To update: cd $SCRIPT_DIR && git pull"
else
    echo -e "${YELLOW}Note:${NC} Commands were copied. To update, re-run this script."
fi
echo ""
