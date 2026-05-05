#!/bin/bash
# Wrapper script to configure deepseek-cli with API key and run it

# Create settings directory if it doesn't exist
mkdir -p ~/.deepseek

# Write API key to settings if DEEPSEEK_API_KEY is set
if [ -n "$DEEPSEEK_API_KEY" ]; then
  cat > ~/.deepseek/settings.json <<EOF
{
  "auth": {
    "provider": "deepseek",
    "apiKey": "$DEEPSEEK_API_KEY"
  }
}
EOF
fi

# Run the deepseek CLI
exec npx @sluisr/deepseek-cli "$@"
