# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal fork of [@ai-hero/sandcastle](https://github.com/mattpocock/sandcastle), configured to use Deepseek API instead of OpenAI Codex.

Sandcastle orchestrates multi-agent AI workflows in isolated Docker containers:
- **Phase 1 (Plan):** Analyze issues and build dependency graph
- **Phase 2 (Execute):** Spawn parallel sandboxes, each runs implementer + reviewer agents
- **Phase 3 (Merge):** Merge all completed branches into main

## Setup

1. **Fill API key:**
   ```bash
   cp .sandcastle/.env.example .env
   # Edit .env and add your DEEPSEEK_API_KEY
   ```

2. **Run:**
   ```bash
   bash run-sandcastle.sh
   ```

   This script sources `.env` (loads DEEPSEEK_API_KEY into environment) then runs `npx tsx .sandcastle/main.mts`.

## Architecture

### AgentProvider Interface

Sandcastle uses an extensible `AgentProvider` interface. Custom providers implement:
- `buildPrintCommand(prompt)` → returns `{ command, stdin }`
- `parseStreamLine(line)` → returns `[{ type: "text", text: "..." }]`
- `env: Record<string, string>` → environment variables passed to subprocess

### Deepseek Provider

`.sandcastle/deepseek-provider.mts` implements the provider for `@sluisr/deepseek-cli`:
- Reads `process.env.DEEPSEEK_API_KEY` at provider init time
- Passes it to sandbox via `env` field
- Deepseek-cli runs headless: `npx @sluisr/deepseek-cli -m deepseek-v3 --approval-mode=yolo -p ""` with prompt on stdin

### Docker Setup

`.sandcastle/Dockerfile`:
- Installs `@sluisr/deepseek-cli` globally
- Copies `.env` to container so agents can access credentials
- Sets `entrypoint.sh` to source `.env` at container startup (though Sandcastle may override this)

### Main Orchestration

`.sandcastle/main.mts`:
- Reads issue list, builds dependency graph (planner phase)
- For each unblocked issue: spawn sandbox → run implementer (100 iterations max) → if commits produced, run reviewer (1 iteration)
- All issue pipelines run in parallel via `Promise.allSettled()`
- Merge phase runs sequentially to resolve conflicts
- Loop repeats up to `MAX_ITERATIONS` times

## Prompts

- `.sandcastle/plan-prompt.md`: Planner reads open issues, outputs `<plan>` JSON
- `.sandcastle/implement-prompt.md`: Implementer solves the issue
- `.sandcastle/review-prompt.md`: Reviewer audits commits
- `.sandcastle/merge-prompt.md`: Merger integrates branches and closes issues

## Key Files

| File | Purpose |
|---|---|
| `.sandcastle/main.mts` | Main orchestration loop |
| `.sandcastle/deepseek-provider.mts` | Deepseek CLI integration |
| `.sandcastle/Dockerfile` | Container setup |
| `.sandcastle/entrypoint.sh` | Container init (sources .env) |
| `.env` | API credentials (git-ignored) |
| `.sandcastle/.env.example` | Template for .env |
| `run-sandcastle.sh` | Launch script (sources .env, runs main.mts) |

## Development

### Debugging

- Deepseek-cli must have valid `DEEPSEEK_API_KEY` in environment before it runs
- Verify: `docker run --rm --entrypoint bash -e DEEPSEEK_API_KEY=... sandcastle-test -c 'npx @sluisr/deepseek-cli -p "" <<< "test"'`
- Check Sandcastle config in `main.mts`: adjust `MAX_ITERATIONS`, `maxIterations` per agent, `hooks`, `copyToWorktree`

### Common Changes

- **Change model:** Edit `deepseek("deepseek-v3")` calls in main.mts to use different model
- **Change iteration limits:** Adjust `MAX_ITERATIONS` (outer loop) or per-agent `maxIterations` in `sandbox.run()`
- **Adjust prompts:** Edit `.sandcastle/*.md` files; use `{{PLACEHOLDER}}` for dynamic values injected via `promptArgs`

## Running Tests

Sandcastle doesn't have unit tests — it's designed to be run end-to-end. Test by:
1. Create a test issue in your repo
2. Run `bash run-sandcastle.sh`
3. Watch logs; check if planner generates a plan, implementer makes commits, reviewer audits, merger integrates
