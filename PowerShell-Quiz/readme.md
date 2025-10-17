# PowerShell Quiz — Engine + Question Sets

Welcome to your modular PowerShell Quiz. This setup splits the **engine** (GUI/timing/logging/anti-cheat) from **question sets** (easy/medium/hard). Swap sets without touching the engine.

## Files

- `Quiz-Engine.ps1` – Reusable GUI engine (you already have it; Revision ≥ 1.5)
- `questions-easy.ps1` – Beginner set (no plaintext answers)
- `questions-medium.ps1` – Medium set (no plaintext answers)
- `questions-hard.ps1` – Hard set (no plaintext answers)

> Logs live at: `C:\temp\powershell-exports\powershell-quiz-<timestamp>.log`

## Run It

```powershell
# From the folder with the files:
. .\Quiz-Engine.ps1 -QuestionSetPath ".\questions-easy.ps1"   -RetryCooldownSeconds 10
. .\Quiz-Engine.ps1 -QuestionSetPath ".\questions-medium.ps1" -RetryCooldownSeconds 12
. .\Quiz-Engine.ps1 -QuestionSetPath ".\questions-hard.ps1"   -RetryCooldownSeconds 15