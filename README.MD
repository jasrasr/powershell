Note: Info in this readme.me file mignt not be 100% accurate as I am always adding/deleting/editing to this repo. 

# PowerShell Scripts

A collection of useful PowerShell scripts designed for automating and managing IT operations. This repository includes scripts for system administration, file management, and general automation tasks.

Table of Contents

	•	Installation
	•	Usage
	•	Scripts Included
	•	Contributing
	•	License
	•	Contact

Installation

	1.	Clone this repository to your local machine:

git clone https://github.com/jasrasr/powershell.git


	2.	Ensure that you have PowerShell 7 or later installed.
	3.	(Optional) Install required modules depending on the scripts you intend to use. For example:

Install-Module -Name SomeModule



Usage

To use any of the scripts in this repository, follow these general steps:

	1.	Open a PowerShell terminal.
	2.	Navigate to the directory where you cloned the repository:

cd C:\Users\%username%\Documents\GitHub\PowerShell


	3.	Run the desired script with the appropriate parameters:

.\ScriptName.ps1 -ParameterName ParameterValue



For example, to run a backup script:

.\BackupScript.ps1 -SourcePath "C:\Data" -DestinationPath "D:\Backup"


Feel free to explore other scripts in the repository and see the comments within each script for additional information.

## Featured: Notification System

The repository now includes a comprehensive **Notification System** with read/unread status tracking:

### Quick Start
```powershell
# Import the notification manager
. .\Notifications\NotificationManager.ps1

# Create a notification
New-Notification -Title "System Alert" -Message "Server restart required" -Type "Warning" -Category "System"

# View all notifications
Show-Notifications

# Mark a notification as read
$notifications = Get-Notifications -UnreadOnly
Set-NotificationRead -Id $notifications[0].Id

# Get statistics
Get-NotificationStatistics
```

### Features
- ✅ **Read/Unread Status Tracking** - Full management of notification read status
- ✅ **Persistent Storage** - JSON-based storage that works cross-platform
- ✅ **Rich Filtering** - Filter by type, category, and read status
- ✅ **Color-coded Display** - Visual indicators for different notification types
- ✅ **Statistics & Reporting** - Summary counts and breakdowns
- ✅ **Cross-Platform** - Works on Windows, Linux, and macOS

See the [Notifications README](./Notifications/README.md) for complete documentation and examples.

Contributing

Contributions are always welcome! If you’d like to add a new script or improve an existing one, please follow the steps below:

	1.	Fork the repository.
	2.	Create a new branch for your feature or fix:

git checkout -b feature-branch


	3.	Make your changes and commit them:

git commit -m "Description of changes"


	4.	Push your branch:

git push origin feature-branch


	5.	Open a pull request to merge your changes.

License

This project is licensed under the UKNOWN License. See the LICENSE file for more details.

Contact

For any questions or suggestions, feel free to reach out:

	•	Jason Lamb (aka jasrasr) - https://jasr.me/ps1

This template includes all the essentials for your public repository. Let me know if you’d like to make any adjustments or if you want to add details for specific scripts.
