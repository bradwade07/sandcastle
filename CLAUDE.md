# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Status

**Repository is currently empty.** This CLAUDE.md is a template. Update as you add code and establish patterns.

## Development Setup

To be filled in once project structure is established. Include:
- How to install dependencies
- Required environment variables
- How to run the development server
- How to run tests (unit and integration)
- How to run linters and formatters
- How to build for production

Example structure:
```bash
npm install          # Install dependencies
npm run dev          # Start dev server
npm test             # Run all tests
npm run test:watch   # Run tests in watch mode
npm run lint         # Check code style
npm run build        # Build for production
```

## Code Architecture

To be documented once the project structure solidifies. Should cover:
- High-level folder organization (what each top-level directory does)
- Major architectural patterns (client/server split, state management, API design)
- Technology stack and why those choices were made
- How the main workflows connect together
- Any third-party integrations or external dependencies

## Key Files & Directories

To be added as the project grows.

## Testing Strategy

Document:
- Test framework and configuration
- Where tests live (co-located with code, separate directory, etc.)
- How to run specific test suites
- Coverage expectations or CI requirements
- Any special test patterns (fixtures, mocks, test utilities)

## Version Control Practices

Include if relevant:
- Branch naming conventions
- Commit message conventions beyond defaults
- PR requirements (required reviews, status checks)
- Deployment branch strategy

## Important Configuration Files

If the project has notable config files (docker-compose.yml, .env.example, tsconfig.json, etc.), document how they work and what needs to be modified locally.

## Known Constraints or Tech Debt

Note any:
- Browser/runtime compatibility requirements
- Performance constraints
- Security considerations specific to this project
- Deprecated patterns to avoid
