# code

## Purpose

This folder contains the client-side PowerShell script used to collect basic
computer information and submit it to the `jasr.me` receiver.

## Files

| Name | Description |
| --- | --- |
| `README.md` | Documentation for the data submission script. |
| `remote.ps1` | Collects system information and submits it over HTTPS. |

## How `remote.ps1` works

The script collects:

- Public IP address
- Private IPv4 address
- Windows OS version
- Computer hostname
- Logged-in username

It sends the data as JSON using an authenticated `POST` request to:

```text
https://jasr.me/code/receive.php
```

The request includes the `X-API-Key` header. The key must match the value in
the server-side `private/config.php` file located in the
`updated-security-rev1` deployment package.

## Running the script

Run locally from PowerShell:

```powershell
.\code\remote.ps1
```

The server stores accepted submissions in its protected `private` folder.
The `view.php` page also requires the same API key and should not be made
publicly accessible.

## Remote execution

The script can be downloaded and run from PowerShell with:

```powershell
irm https://raw.githubusercontent.com/jasrasr/powershell/main/code/remote.ps1 | iex
```

Only run this command when the script and receiver are trusted, because it
executes downloaded code and submits local system information.

## Security notes

- Use HTTPS for the receiver and all supporting services.
- Do not commit the API key to a public repository. The current client script
  contains the key because it must authenticate directly to the receiver;
  rotate it if the repository is public or the key is exposed.
- Do not expose `private/config.php`, logs, or collected data through the web
  server.
- The old HTTP-based `remote1.ps1` downloader is no longer used.
