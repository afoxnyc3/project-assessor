Read PROJECT_CONTEXT.md in the project root. If it does not exist, stop and instruct the user to run /scout first.

Conduct a three-phase technical assessment using the structured context. Do NOT re-explore the raw codebase — work from PROJECT_CONTEXT.md only. If critical information is missing from the context file, note the gap rather than exploring files directly.

Use the template from templates/ASSESSMENT.md for output structure (or the fallback structure at the end of this prompt).

---

## Phase 1: Technical Analysis

### Weighted Scoring
Score each dimension 1-10. Every score requires a 2-3 sentence justification grounded in specific evidence from PROJECT_CONTEXT.md.

| Dimension | Weight | Scoring Guide |
|-----------|--------|---------------|
| Problem-solution fit | 3x | Is this solving a real, well-defined problem? Is the implementation aligned with the problem scope? |
| Security posture | 2x | Auth, secrets management, dependency hygiene, attack surface. Score 1-3 if secrets in code or no auth. |
| Implementation completeness | 2x | Feature coverage, error handling, edge cases, input validation. Score based on what's built vs what's needed. |
| Tech stack modernity | 1.5x | Ecosystem health, active maintenance, community size, future trajectory. Penalize EOL or deprecated choices. |
| Code quality | 1.5x | Testing presence/coverage, type safety, documentation, consistent patterns. Score what's observed, not assumed. |
| Innovation / differentiation | 1x | What's unique? Novel approach, UX, integration, or architecture that competitors lack. |

Calculate weighted composite: `(score × weight) for each / sum of weights`

Scale reference:
- 1-3: Significant concerns, needs major work
- 4-6: Functional but notable gaps
- 7-8: Strong, production-ready
- 9-10: Exceptional, best-in-class (rare — justify thoroughly)

### Architecture Analysis
Based on PROJECT_CONTEXT.md, evaluate:

**Strengths** — What's well-designed? Good patterns, smart tech choices, clean separation.
**Weaknesses** — What's missing, over-engineered, or problematic?
**Scalability** — Can this handle 10x load? What breaks first?
**Technical Debt** — Outdated deps, missing tests, hardcoded config, tight coupling.

---

## Phase 2: Market Research

Use the Exa MCP tools to research alternatives. Execute these searches:
1. `web_search_exa`: "[project description] open source alternative" — find OSS competitors
2. `web_search_exa`: "[project description] SaaS product" — find commercial competitors  
3. `web_search_exa`: "[project name] vs" — find existing comparisons

Curate 4-5 comparable solutions (mix of OSS and commercial). For each:

| Field | Requirement |
|-------|-------------|
| Name + URL | Direct link to repo or product |
| Type | OSS / Commercial / Freemium |
| Description | 1-2 sentences |
| Tech Stack | Primary language/framework |
| Differentiators | What does it do better or worse than this project? |
| Pricing/License | MIT, Apache, proprietary, pricing tier |
| GitHub Stats | Stars, last commit, contributors (OSS only) |
| Maintenance Status | Active / Maintenance-only / Abandoned |

**Filtering rules:**
- OSS: Must have 500+ stars AND commits within last 6 months
- Commercial: Must be currently operational (not sunset/acqui-hired)
- Exclude anything archived or in read-only mode
- If fewer than 4 qualify, relax star threshold to 100+ and note this

If Exa is unavailable or the user said "Skip Phase 2", omit this section and note: "Market research skipped — Exa MCP not configured or user opted out."

---

## Phase 3: Recommendations

Based on Phase 1 and Phase 2 findings:

### Top 3 Architectural Improvements
Prioritize by impact. For each:
- What to change
- Why it matters (link to a specific score or weakness)
- Effort estimate: Low (<1 day), Medium (1-5 days), High (1-2 weeks)
- Expected impact on composite score

### Tech Stack Changes
Only recommend changes with clear justification. "Newer" is not sufficient reason.
- What to swap and what to swap it for
- Migration complexity
- Risk of NOT changing

### Competitive Gaps
- Features this project has that alternatives lack (defend/emphasize these)
- Features competitors have that this project should consider (prioritize by user value)

### Security Hardening (if security score < 7)
- Specific, actionable steps ordered by risk severity
- Quick wins first (secrets rotation, .gitignore fixes, dependency updates)

---

## Output

Write ASSESSMENT.md to the project root.

### Fallback Template Structure

If the template file is not accessible, use this structure:

```markdown
# Technical Assessment: [PROJECT NAME]
> Generated on [DATE] via project-assessor

## Executive Summary
[3-4 sentences: what this project is, its strongest quality, its biggest gap, and overall recommendation]

## Scores

| Dimension | Weight | Score | Justification |
|-----------|--------|-------|---------------|
| Problem-solution fit | 3x | /10 | |
| Security posture | 2x | /10 | |
| Implementation completeness | 2x | /10 | |
| Tech stack modernity | 1.5x | /10 | |
| Code quality | 1.5x | /10 | |
| Innovation / differentiation | 1x | /10 | |
| **Weighted Composite** | | **/10** | |

## Architecture Analysis

### Strengths
...

### Weaknesses
...

### Scalability
...

### Technical Debt
...

## Competitive Landscape

| Name | Type | Stack | Differentiators | License/Pricing | GitHub Stars | Status |
|------|------|-------|-----------------|-----------------|-------------|--------|
| | | | | | | |

### Competitive Position Summary
[2-3 sentences on where this project fits in the landscape]

## Recommendations

### Priority Improvements
| # | Change | Why | Effort | Score Impact |
|---|--------|-----|--------|-------------|
| 1 | | | | |
| 2 | | | | |
| 3 | | | | |

### Tech Stack Changes
...

### Competitive Gaps
**This project's advantages:**
...

**Features to consider adding:**
...

### Security Hardening
...

---
*Assessment generated by [project-assessor](https://github.com/YOUR_ORG/project-assessor)*
```

After writing the file, report: "Assessment complete. See ASSESSMENT.md for the full report."
