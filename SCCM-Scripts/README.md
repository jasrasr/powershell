# SCCM-Scripts

## Purpose
Scripts tailored for Microsoft System Center Configuration Manager automation and troubleshooting.

## Files
| Name | Type | Rev | Description |
| --- | --- | --- | --- |
| `apps.csv` | csv | 3cfac93 | File |
| `deploy-apps-to-distribution-and-collectionps1.ps1` | ps1 | 3cfac93 | Deploy multiple applications as "Available" to a user collection in Software Center and distribute content to a list of Distribution Points. Rev 1.1 |
| `deploy-apps-to-distribution-points.ps1` | ps1 | 3cfac93 | Distribute multiple applications to a list of Distribution Points only (no deployment). Fix Set-Location to CMSite drive and trim SiteCode. Rev 1.3 |
| `deploy-appstousercollection.ps1` | ps1 | 3cfac93 | Deploy multiple applications as "Available" to a user collection in Software Center. |
| `new-app-via-csv-sample.csv` | csv | 3cfac93 | File |
| `new-app-via-csv.csv` | csv | 3cfac93 | File |
| `new-app-via-csv.ps1` | ps1 | 3cfac93 | Import the PSD1 file (returns a hashtable) |
| `new-cmapp.ps1` | ps1 | 3cfac93 | Create a ConfigMgr Application with MSI or Script deployment type + detection, then optionally distribute content. |
| `README.md` | md | 6fd63ee | Documentation |
| `Retrieve-all-Applications-from-sccm.ps1` | ps1 | 3cfac93 | Connection to SCCM server required before running this script |
| `test-update.ps1` | ps1 | 3cfac93 | test update |