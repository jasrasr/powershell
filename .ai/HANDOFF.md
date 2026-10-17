# Handoff

## Current objective
Maintain shared project memory and keep the repository context documented.

## Completed and verified
- Shared project memory is set up: `.ai/PROJECT.md`, `.ai/DECISIONS.md`, `.ai/HANDOFF.md`, and a shared-memory section in `CLAUDE.md` and `AGENTS.md`.
- `.ai/PROJECT.md` describes the repository purpose, architecture, important paths, and validation, based on `CLAUDE.md`.
- Verified that different AI tools and fresh sessions read this same root handoff and update it.

## Open work
Review the shared-memory documentation for accuracy as the repository evolves.

## Risks / blockers
This repository is public. Never record secrets, credentials, customer data, internal hostnames, or company-confidential details in `.ai/` files.

## Next actions
1. Run `Notifications/Test-Notifications.ps1` if behavior changes are made to the notification system.
2. Update `.ai/PROJECT.md` when repository structure or validation practices change.
3. Record durable architectural decisions in `.ai/DECISIONS.md`.

## Platform-specific notes
None. This handoff is AI platform, session, computer, and model agnostic: do not record which tool did the work. Add a note here only when one platform or model is better suited to a task (for example, a task that exceeds another's token or context limit), and say why.

## Updated
2026-10-17
