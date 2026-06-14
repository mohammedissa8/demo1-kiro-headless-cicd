# Demo Script: Kiro CLI Headless in CI/CD

## Pre-requisites
- GitHub repo with this demo code pushed
- `KIRO_API_KEY` added as GitHub Secret (Settings → Secrets → Actions)
- Branch protection enabled on `main`
- Kiro CLI installed locally for the containerized demo

## Demo 1: GitHub Actions PR Review (~5 min)

### Setup (before audience)
1. Push this demo repo to GitHub
2. Create a `main` branch with clean code
3. Prepare a feature branch with a deliberate bug (e.g., hardcoded secret, missing error handling)

### Live Demo Steps

**Step 1: Show the agent config**
```bash
cat .kiro/agents/code-reviewer.json
```
Key points: read/grep only, no shell, categorizes by severity.

**Step 2: Show the steering file**
```bash
cat .kiro/steering/ci-context.md
```
Key points: team's standards encoded, same file guides humans AND the CI agent.

**Step 3: Show the workflow**
```bash
cat .github/workflows/kiro-code-review.yml
```
Walk through: trigger → install (~13s) → get diff → run Kiro → post-process → comment.

**Step 4: Open a PR with a bug**
```bash
git checkout -b demo-bug
# Introduce a bug (e.g., add `const API_KEY = "sk-1234..."` in a file)
git add . && git commit -m "feat: add payment integration"
git push -u origin demo-bug
# Open PR via GitHub UI or:
gh pr create --title "feat: add payment integration" --base main
```

**Step 5: Watch the Action run**
- Go to Actions tab → show it running
- Point out: install ~13s, review ~47s, total ~60s

**Step 6: Show the PR comment**
- Go back to the PR → Kiro's review appears as a comment
- Show it caught the hardcoded secret (CRITICAL)
- Show formatted output (post-processing worked)

**Talking point:** "That's 1-2 hours of manual review in 60 seconds. And it runs on EVERY PR automatically."

## Demo 2: Containerized Kiro (~3 min)

### Live Demo Steps

**Step 1: Show the Dockerfile**
```bash
cat Dockerfile
```
Key points: API key injected at runtime (never hardcoded), entry point is non-interactive.

**Step 2: Build the container**
```bash
docker build -t kiro-headless .
```
(Pre-build if short on time — image is cached)

**Step 3: Run it**
```bash
docker run -e KIRO_API_KEY=$KIRO_API_KEY kiro-headless \
  --prompt "List 5 creative CI/CD automations you could do running inside a container"
```

**Step 4: Show output**
- Kiro responds with use cases (incident diagnosis, chaos engineering, etc.)

**Talking point:** "Same agent, same capabilities. Just running inside a container instead of your terminal. This can be a K8s pod, an ECS task, a cron job."

## Key Messages to Reinforce

1. **One env var** (`KIRO_API_KEY`) is the only difference between interactive and headless
2. **Read/grep only** for review agents — no write tools in unattended CI
3. **Post-processing is essential** — raw output needs ANSI stripping before posting
4. **Pass the diff, not the full repo** — cost efficiency
5. **Branch protection** — prevents anyone from modifying the agent config via PR
6. **Advisory only** — Kiro reviews and reports, it doesn't merge or deploy
