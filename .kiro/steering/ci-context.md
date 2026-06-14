# CI Pipeline Context

## Build System
- Node.js 20, npm workspaces
- Test framework: Jest (coverage threshold: 80%)
- Lint: ESLint + Prettier (npm run lint)
- Build: npm run build (TypeScript → JavaScript)

## PR Review Standards
- No console.log in production code (use structured logger)
- All exported functions must have JSDoc comments
- No direct dependency on external APIs without try/catch
- No secrets, tokens, or credentials in source code
- No use of eval(), Function(), or dynamic code execution
- New dependencies must be pinned to exact versions

## When reviewing in CI, always:
1. Run `git diff --name-only origin/main` to identify changed files
2. Focus review on changed files only (don't review the entire repo)
3. Check if tests exist for new/modified functions
4. Flag any new dependencies added to package.json
5. Verify error handling on all async/await calls
6. Check for hardcoded URLs, IPs, or environment-specific values
