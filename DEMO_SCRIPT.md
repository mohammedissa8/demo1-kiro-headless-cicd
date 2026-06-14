# Demo Script: Kiro CLI Headless in CI/CD

**Repo:** https://github.com/mohammedissa8/demo1-kiro-headless-cicd

## How It Works (for your mental model)

- GitHub Actions runs on **GitHub's servers** (ephemeral Ubuntu VMs), NOT your machine
- When you push/open a PR, GitHub spins up a fresh VM, installs Kiro CLI there, runs the review, posts the comment — all remotely
- Your local Kiro CLI is not involved after `git push`
- You watch it happen in the **Actions** tab in your browser

## Setup (done once, before demo)

### 1. Add the API key secret
- Repo → Settings → Secrets and variables → Actions → New repository secret
- Name: `KIRO_API_KEY`
- Value: your Kiro API key from https://app.kiro.dev (Settings → API Keys)

### 2. Enable branch protection on main
- Repo → Settings → Branches → Add branch protection rule
- Branch name pattern: `main`
- Check: ✅ Require a pull request before merging
- Click Create

### 3. Prepare the demo bug branch (before audience)
```bash
git clone git@github.com:mohammedissa8/demo1-kiro-headless-cicd.git
cd demo1-kiro-headless-cicd
git checkout -b dem0-bug
mkdir -p src
cat > src/payment.js << 'EOF'
const API_KEY = "sk-live-1234567890abcdef";

async function chargeCustomer(amount) {
  const response = await fetch("https://api.stripe.com/v1/charges", {
    headers: { Authorization: `Bearer ${API_KEY}` }
  });
  return response.json();
}

module.exports = { chargeCustomer };
EOF
git add . && git commit -m "feat: add payment integration"
git push -u origin dem0-bug
```
Don't open the PR yet — save that for the live demo.

## Live Demo (~8 min)

### Step 1: Show the repo structure (1 min)
Open https://github.com/mohammedissa8/demo1-kiro-headless-cicd in browser.

Show 3 files:
- `.kiro/agents/code-reviewer.json` — "This is the agent. Read/grep only. No shell, no write."
- `.kiro/steering/ci-context.md` — "This is the team's standards. Same file guides humans AND the CI agent."
- `.github/workflows/kiro-code-review.yml` — "This is the pipeline. Triggers on every PR."

### Step 2: Walk through the workflow (1 min)
Highlight the key steps:
1. Trigger: `on: pull_request` targeting main
2. Get changed files: `git diff --name-only` (pass only the diff, not full repo — cost efficient)
3. Install Kiro CLI: `curl -fsSL https://cli.kiro.dev/install | bash` (~13 seconds on GitHub's VM)
4. Run Kiro: `--agent code-reviewer --no-interactive` with API key from secrets
5. Post-process: strip ANSI characters, format output
6. Post as PR comment

### Step 3: Open the PR (1 min)
Either via GitHub UI:
- Go to repo → "Compare & pull request" for `dem0-bug` branch
- Title: "feat: add payment integration"
- Create PR

Or if showing terminal:
```bash
git push -u origin demo-bug
# Then open PR via GitHub UI: repo page → "Compare & pull request" banner
```

### Step 4: Watch the Action run (2 min)
- Go to Actions tab → click the running workflow
- Expand steps as they execute
- Point out: install ~13s, review ~47s, total ~60s
- "This is running on GitHub's servers, not my machine"

### Step 5: Show the PR comment (2 min)
- Go back to the PR → scroll to comments
- Kiro's review appears as "🤖 Kiro Code Review"
- It caught: **CRITICAL — hardcoded API key** in src/payment.js
- May also flag: missing error handling on fetch, no input validation on amount

**Talking point:** "That's 1-2 hours of manual review done in 60 seconds. Runs on every PR automatically. The developer gets feedback before any human reviewer even looks at it."

### Step 6: Security message (1 min)
- "The agent config lives in the repo — branch protection means no one can modify it without a reviewed PR"
- "Read/grep only — the agent cannot modify code, push, or deploy"
- "Output is advisory — the PR still needs human approval to merge"

## Reset for Next Demo Run
Use a different branch name each time

git checkout main
git pull
git checkout -b demo-bug-2
mkdir -p src
cat > src/db.js << 'EOF'
const password = "admin123";
const conn = `postgres://root:${password}@prod-db:5432/users`;
EOF
git add . && git commit -m "feat: add database connection"
git push -u origin demo-bug-2
# GitHub shows "Compare & pull request" banner → click it

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Action doesn't trigger | Check workflow file is on `main` branch (not just on feature branch) |
| "KIRO_API_KEY not set" | Verify secret name matches exactly in Settings → Secrets |
| Empty PR comment | Check post-processing step — raw output might have unexpected format |
| Action takes too long | Kiro CLI install is cached after first run; review depends on file count |
