# Kiro CLI Headless in CI/CD — Demo

Automated code review using Kiro CLI in GitHub Actions. Every PR triggers an AI-powered review that posts findings as a PR comment.

## Setup

1. **Generate a Kiro API key** from [account settings](https://app.kiro.dev)
2. **Add as GitHub Secret**: Repository Settings → Secrets → Actions → `KIRO_API_KEY`
3. **Enable branch protection** on `main` (prevents agent config tampering)

## How it works

```
PR opened → GitHub Action triggers → Kiro CLI reviews changed files → Posts findings as PR comment
```

## Files

```
.github/workflows/kiro-code-review.yml   # The workflow
.kiro/agents/code-reviewer.json          # Agent definition (persona, tools, constraints)
.kiro/steering/ci-context.md             # Pipeline-specific context (standards, conventions)
```

## Customization

- **Change review focus**: Edit the `prompt` in `code-reviewer.json`
- **Add tools**: Add to `tools` array. Only add to `allowedTools` if safe for unattended execution
- **Update standards**: Edit `ci-context.md` — changes take effect on next PR
- **Restrict commands**: Modify `toolsSettings.shell.allowedCommands`

## Security considerations

- Agent config lives in the repo → tamper-evident with branch protection
- `allowedTools` controls what runs without confirmation (read-only tools only)
- `toolsSettings.shell.allowedCommands` whitelists specific commands
- API key stored as GitHub Secret (never exposed in logs)
- Agent output is advisory only — no auto-merge, no write access
