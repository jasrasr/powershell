# ExchangeOnline-Scripts

## Purpose
Utilities for interacting with Exchange Online, covering mailbox, transport, and policy operations.

## Directory listing
| Name | Type | Description |
| --- | --- | --- |
| `README.md` | File | Markdown documentation |
| `adjust-shared-calendar-timezone.ps1` | File | PowerShell script |
| `change-resource-calendar-to-allow-conflicts.txt` | File | Text file |
| `get-mailbox-size.ps1` | File | PowerShell script |
| `Search-FileContent.ps1` | File | Search text content in plain text files, `.docx`, and `.xlsx` |

## Content Search
`Search-FileContent.ps1` searches actual file content across common plain text files plus Office Open XML formats:

- `.xlsx`: reads only `xl/sharedStrings.xml` and `xl/worksheets/*.xml`
- `.docx`: reads only `word/document.xml`, headers, footers, footnotes, endnotes, and comments

Examples:

```powershell
.\Search-FileContent.ps1 -SearchText 'u4al_jdy'
.\Search-FileContent.ps1 -SearchText 'u4al_jdy' -RootPath $env:OneDrive -Include '*.xlsx','*.docx'
.\Search-FileContent.ps1 -SearchText 'Contoso' -RootPath $env:OneDrive -Include '*.docx' -Threads 12
.\Search-FileContent.ps1 -SearchText 'mailbox.*size' -Regex -Include '*.ps1','*.md'
```
