# PowerShell Script Templates

Use these snippets when creating new scripts in this repository. Start with `header.ps1`, then add only the sections the script needs.

## Preferred Header

New PowerShell scripts should begin with Jason's metadata header:

```powershell
# Filename: <ScriptName>.ps1
# Revision : 1.0.0
# Description : <Short description of what this script does>
# Author : Jason Lamb (with help from Codex)
# Created Date : <YYYY-MM-DD>
# Modified Date : <YYYY-MM-DD>
# Changelog :
# 1.0.0 initial release
```

## Template Files

- `header.ps1` - metadata header, `[CmdletBinding()]`, parameters, and default error handling.
- `modules.ps1` - required module install/import pattern.
- `logging.pa1` - logging helper template; rename to `logging.ps1` if used directly.
- `api.ps1` - reusable `Invoke-RestMethod` wrapper.
- `footer.ps1` - standard try/catch finalization block.
