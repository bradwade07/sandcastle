#!/bin/bash
# Setup deepseek config from .env before starting the container

if [ -f /home/agent/.env ]; then
  export $(cat /home/agent/.env | grep -v '^#' | xargs)
fi

if [ -n "$DEEPSEEK_API_KEY" ]; then
  mkdir -p ~/.deepseek
  cat > ~/.deepseek/settings.json <<EOF
{"auth": {"provider": "deepseek", "apiKey": "$DEEPSEEK_API_KEY"}}
EOF
fi

# Run the original entrypoint
exec sleep infinity
