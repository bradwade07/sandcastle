#!/bin/bash
# Setup Sandcastle in a new project
# Usage: bash setup-sandcastle.sh /path/to/target-project

if [ -z "$1" ]; then
  echo "Usage: bash setup-sandcastle.sh /path/to/target-project"
  exit 1
fi

TARGET="$1"

if [ ! -d "$TARGET" ]; then
  echo "Error: Target directory does not exist: $TARGET"
  exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Copying .sandcastle to $TARGET..."
cp -r "$SCRIPT_DIR/.sandcastle" "$TARGET/"

echo "Copying .env.example to $TARGET..."
cp "$SCRIPT_DIR/.env.example" "$TARGET/.env.example"

echo "Creating .env template in $TARGET..."
cat > "$TARGET/.env" << 'EOF'
# Fill in your API credentials
DEEPSEEK_API_KEY=
GH_TOKEN=
EOF

echo "Installing dependencies in $TARGET..."
cd "$TARGET"
npm install @ai-hero/sandcastle 2>/dev/null || echo "npm install skipped (may already be installed)"

echo ""
echo "✓ Sandcastle setup complete in $TARGET"
echo ""
echo "Next steps:"
echo "  1. cd $TARGET"
echo "  2. Edit .env and fill in DEEPSEEK_API_KEY and GH_TOKEN"
echo "  3. Run: npx tsx .sandcastle/main.mts"
