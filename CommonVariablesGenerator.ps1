# This script also generates a list of $variables from other files, different output than the other script - CommonVariables.ps1

# Define the folder path where your .ps1 files are located
$scriptFolder = "C:\Users\...\PowerShell"

# Define the output file path for the variables
$outputPs1 = "C:\Users\...\PowerShellCommonProfile.ps1"

# Get all .ps1 files in the folder
$ps1Files = Get-ChildItem -Path $scriptFolder -Filter *.ps1

# Initialize an empty array to hold new variable information
$newVariables = @()

# Loop through each .ps1 file
foreach ($file in $ps1Files) {
    # Read the contents of the script
    $scriptContent = Get-Content -Path $file.FullName

    # Use a regular expression to find all variable definitions (lines that start with $)
    $variables = $scriptContent | Select-String -Pattern "\$[a-zA-Z_][a-zA-Z0-9_]*" | ForEach-Object {
        # Clean up the variable name to remove any unwanted characters like `=` or `,`
        $_.Matches.Value -replace "[^a-zA-Z0-9_$]", ""
    }

    # Create a custom object for each variable to store the filename and variable name
    foreach ($var in $variables) {
        $newVariables += [pscustomobject]@{
            ScriptFile  = $file.Name
            Variable    = $var
        }
    }
}

# Check if the CommonVariables.ps1 file already exists
if (-not (Test-Path $outputPs1)) {
    # Create the file and add a header comment
    Add-Content -Path $outputPs1 -Value "# This file contains common variables extracted from other scripts"
}

# Loop through the new variables and append them to the CommonVariables.ps1 file
foreach ($newVar in $newVariables) {
    # Check if the variable already exists in the CommonVariables.ps1 file
    $existingContent = Get-Content -Path $outputPs1
    if (-not ($existingContent -match [regex]::Escape($newVar.Variable))) {
        # Append the new variable to the file
        Add-Content -Path $outputPs1 -Value "`$($newVar.Variable) = `"$($newVar.Variable)_value`"  # from $($newVar.ScriptFile)"
    }
}

