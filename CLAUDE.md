# CLAUDE.md — Project Assessor

## Purpose
This repo contains Claude Code custom commands for systematic technical assessment of any codebase. It is a toolbox, not a project to assess.

## Commands
- `/scout` — Extract structured context from a target codebase → PROJECT_CONTEXT.md
- `/assess` — Analyze scout output + market research → ASSESSMENT.md
- `/compare` — Side-by-side diff of two assessments → COMPARISON.md

## Guidelines

### Scout Phase
- Extract facts only. No opinions, no scoring, no judgments.
- If a file doesn't exist (e.g., no pyproject.toml), skip it — don't hallucinate.
- Sample representative modules, don't dump entire source files.
- Keep PROJECT_CONTEXT.md under 3000 tokens. Concise > comprehensive.

### Assessment Phase
- Always read PROJECT_CONTEXT.md first. Never re-explore the raw codebase.
- Every score requires a 2-3 sentence justification. No naked numbers.
- Use Exa for market research. Verify repos are actively maintained.
- Recommendations must include effort estimate (low/medium/high).

### Output Standards
- All output files go in the target project root, not this repo.
- Use the templates in /templates as structure — adapt content to the project.
- Tables for scores and comparisons. Prose for analysis and recommendations.

### What NOT to Do
- Don't assess this repo. It's the tool, not the target.
- Don't modify templates during assessment runs.
- Don't include raw source code in assessment output.
