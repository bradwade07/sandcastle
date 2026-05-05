#!/bin/bash
# Load .env and run sandcastle

if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

npx tsx .sandcastle/main.mts
