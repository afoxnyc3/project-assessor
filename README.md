# Project Assessor

A two-stage Claude Code command toolkit for systematic technical assessment of any codebase. Scout first, assess second — structured context in, structured analysis out.

## How It Works

```
┌─────────────┐     ┌──────────────────────┐     ┌─────────────────────┐
│  /scout      │ ──► │  PROJECT_CONTEXT.md   │ ──► │  /assess             │
│  (~30 sec)   │     │  (reviewable artifact)│     │  (~2-3 min)          │
│  Extract facts│     │                      │     │  Analysis + Research │
└─────────────┘     └──────────────────────┘     └──────┬──────────────┘
                                                         │
                                                         ▼
                                                  ┌─────────────────┐
                                                  │  ASSESSMENT.md   │
                                                  │  (final report)  │
                                                  └─────────────────┘
```

**Stage 1: Scout** — Fast, deterministic context extraction. Reads config files, maps architecture, catalogs dependencies, checks security signals. Produces `PROJECT_CONTEXT.md`.

**Stage 2: Assess** — Analytical evaluation using scout output. Scores across weighted dimensions, researches competitors via Exa, generates prioritized recommendations. Produces `ASSESSMENT.md`.

## Quick Start

### Option A: Install globally (recommended)

Run the install script once. It symlinks the commands so every project gets access:

```bash
git clone https://github.com/YOUR_ORG/project-assessor.git ~/project-assessor
cd ~/project-assessor
chmod +x bin/install.sh
./bin/install.sh
```

Then in any project:

```bash
cd /path/to/any-project
claude
# Inside Claude Code:
/scout
# Review PROJECT_CONTEXT.md, then:
/assess
```

### Option B: Copy into a single project

```bash
# From target project root
cp -r /path/to/project-assessor/.claude/commands/* .claude/commands/
cp -r /path/to/project-assessor/templates/ .assessor-templates/
```

### Option C: One-liner with npx (no install)

```bash
# From target project root — pulls commands into .claude/commands/
npx degit YOUR_ORG/project-assessor/.claude/commands .claude/commands
npx degit YOUR_ORG/project-assessor/templates .assessor-templates
```

## Usage

### Step 1: Scout the Project

```
/scout
```

This produces `PROJECT_CONTEXT.md` in the project root. Review it — this is the factual foundation the assessment builds on. If it missed something important (e.g., a non-standard directory structure), edit it before proceeding.

### Step 2: Run the Assessment

```
/assess
```

Reads `PROJECT_CONTEXT.md`, scores the project across weighted dimensions, researches competitors using Exa, and outputs `ASSESSMENT.md`.

### Step 3 (Optional): Compare Projects

```
/compare path/to/ASSESSMENT_A.md path/to/ASSESSMENT_B.md
```

Side-by-side comparison of two assessed projects. Useful for build-vs-buy, fork evaluation, or vendor selection.

## Commands Reference

| Command | Purpose | Time | Output |
|---------|---------|------|--------|
| `/scout` | Extract structured context from codebase | ~30s | `PROJECT_CONTEXT.md` |
| `/assess` | Full technical assessment + market research | ~2-3m | `ASSESSMENT.md` |
| `/compare` | Diff two assessments side-by-side | ~1m | `COMPARISON.md` |

## Scoring Framework

Assessments use weighted scoring across six dimensions:

| Dimension | Weight | What It Measures |
|-----------|--------|------------------|
| Problem-solution fit | 3x | Is this solving a real problem well? |
| Security posture | 2x | Auth, secrets, dependencies, attack surface |
| Implementation completeness | 2x | Feature coverage, edge cases, error handling |
| Tech stack modernity | 1.5x | Ecosystem health, community, longevity |
| Code quality | 1.5x | Testing, types, docs, maintainability |
| Innovation / differentiation | 1x | What's unique vs. alternatives? |

Composite score = weighted average. Scale: 1-3 (weak), 4-6 (adequate), 7-8 (strong), 9-10 (exceptional).

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated
- [Exa MCP server](https://docs.anthropic.com/en/docs/claude-code/mcp) configured (for market research in `/assess`)

### Exa MCP Setup

If you haven't configured Exa yet, add to your Claude Code MCP config:

```json
{
  "mcpServers": {
    "exa": {
      "command": "npx",
      "args": ["-y", "exa-mcp-server"],
      "env": {
        "EXA_API_KEY": "your-key-here"
      }
    }
  }
}
```

## File Structure

```
project-assessor/
├── .claude/
│   └── commands/
│       ├── scout.md          # Stage 1: context extraction
│       ├── assess.md         # Stage 2: analysis + research
│       └── compare.md        # Stage 3: side-by-side diff
├── templates/
│   ├── PROJECT_CONTEXT.md    # Scout output template
│   ├── ASSESSMENT.md         # Assessment output template
│   └── COMPARISON.md         # Comparison output template
├── bin/
│   └── install.sh            # Global install script
├── CLAUDE.md                 # Agent guidelines for this repo
├── .gitignore
└── README.md
```

## Customization

### Adjusting Scoring Weights

Edit the scoring table in `.claude/commands/assess.md` to match your evaluation priorities. For security-focused reviews, bump Security posture to 3x. For greenfield evaluation, bump Innovation to 2x.

### Adding Dimensions

Add rows to the scoring table in both `assess.md` and `templates/ASSESSMENT.md`. Keep total dimensions under 8 to avoid score dilution.

### Skipping Market Research

If you only need internal analysis (no Exa), add `Skip Phase 2` to your `/assess` invocation. The command will produce scores and architecture analysis without competitive landscape.

## Integration with Agent Zero

For autonomous assessment pipelines:

```python
# Agent Zero orchestration example
steps = [
    "cd /path/to/target-repo",
    "claude /scout",                    # Extract context
    "# Approval gate: review PROJECT_CONTEXT.md",
    "claude /assess",                   # Full assessment
    "mv ASSESSMENT.md /assessments/project-name-$(date +%Y%m%d).md"
]
```

## License

MIT
