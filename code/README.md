# code

## Purpose
Scratchpad of code snippets, notebooks, or experiments that support the rest of the repo.

## Directory listing
| Name | Type | Description |
| --- | --- | --- |
| `README.md` | File | Markdown documentation |
| `remote.ps1` | File | PowerShell script |

# Example

PS> irm https://raw.githubusercontent.com/jasrasr/powershell/refs/heads/main/code/remote.ps1 | iex
or
PS> irm https://jasr.me/remote | iex

Running the remote PowerShell script...

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
      9     1.89       3.26       0.00   11288   0 AggregatorHost
      9     2.30       5.98       0.00    4160   0 amdfendrsr
     20    12.41       9.69       0.53   29284   1 AppActions
     29    46.05       9.66       0.27   19444   1 ApplicationFrameHost
     15    21.68      25.33      65.48   24940   0 audiodg
Gathering system information...
Hostname: COMPUTERNAME
OS Version: 10.0.26200
Logged-in User: first.last
remote1.ps1 has been saved to C:\temp\remote1.ps1. You can inspect and run it manually if needed.
