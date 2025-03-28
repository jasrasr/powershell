# Define the folder path where your .ps1 files are located
$scriptFolder = "C:\users\%username%\onedrive - middough\documents\github\powershell"

# Get all .ps1 files in the folder
$ps1Files = Get-ChildItem -Path $scriptFolder -Filter *.ps1

# Initialize an empty array to hold variable information
$allVariables = @()

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
        $allVariables += [pscustomobject]@{
            ScriptFile  = $file.Name
            Variable    = $var
        }
    }
}

# Output the list of variables to the console
$allVariables | Format-Table -AutoSize

# Optionally, export the results to a CSV file for further analysis
$allVariables | Export-Csv -Path "$scriptFolder\VariablesReport.csv" -NoTypeInformation