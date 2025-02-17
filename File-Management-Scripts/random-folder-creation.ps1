<# 
Set-Location -path U:\Cleveland 
$deptfolders = (Get-ChildItem -path u:\cleveland -Directory | Select-Object -ExpandProperty name)
ForEach ($deptfolder in $deptfolders) {
    mkdir J:\Cleveland\$deptfolder
}
#>
<#
Set-Location J:\
$cityfolders = (Get-ChildItem -Directory | Select-Object -ExpandProperty name)
foreach ( $cityfolder in $cityfolders ) { 
    Copy-Item -Path j:\Cleveland\* -Destination J:\$cityfolder -Force -Recurse
}

copy-item -path j:\cleveland -destination j:\Ashland  -recurse -force
copy-item -path j:\cleveland -destination J:\Buffalo -recurse -force
copy-item -path j:\cleveland -destination J:\Chicago -recurse -force
copy-item -path j:\cleveland -destination J:\Dallas -recurse -force
copy-item -path j:\cleveland -destination J:\Indiana -recurse -force
copy-item -path j:\cleveland -destination J:\Madison -recurse -force
copy-item -path j:\cleveland -destination J:\Minneapolis -recurse -force
copy-item -path j:\cleveland -destination J:\Pittsburgh -recurse -force
copy-item -path j:\cleveland -destination J:\Toledo -recurse -force


# Count the number of child items in each directory
foreach ($cityfolder in $cityfolders) {
    $childItemCount = (Get-ChildItem -Path J:\$cityfolder -Recurse | Measure-Object).Count
    Write-Host "Directory: J:\$cityfolder has $childItemCount child items."
}

# Sample first names and last names
$firstNames = @("John", "Jane", "Michael", "Sarah", "David", "Emily", "Robert", "Jessica", "Daniel", "Laura", 
                "James", "Mary", "William", "Patricia", "Joseph", "Linda", "Charles", "Barbara", "Thomas", "Elizabeth",
                "Christopher", "Jennifer", "Matthew", "Maria", "Anthony", "Susan", "Mark", "Margaret", "Paul", "Dorothy",
                "Steven", "Lisa", "Andrew", "Nancy", "Kenneth", "Karen", "Joshua", "Betty", "Kevin", "Helen",
                "Brian", "Sandra", "George", "Donna", "Edward", "Carol", "Ronald", "Ruth", "Timothy", "Sharon")
$lastNames = @("Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez",
                "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin",
                "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson",
                "Walker", "Young", "Allen", "King", "Wright", "Scott", "Torres", "Nguyen", "Hill", "Flores",
                "Green", "Adams", "Nelson", "Baker", "Hall", "Rivera", "Campbell", "Mitchell", "Carter", "Roberts")

# Generate 350 random folder names
$folderNames = @()
1..350 | ForEach-Object {
    $firstName = $firstNames | Get-Random
    $lastName = $lastNames | Get-Random
    $folderName = "$firstName.$lastName"
    $folderNames += $folderName
}

# Check for duplicates and recreate them
$duplicateFolders = $folderNames | Group-Object | Where-Object { $_.Count -gt 1 }

while ($duplicateFolders) {
    foreach ($duplicate in $duplicateFolders) {
        for ($i = 1; $i -lt $duplicate.Count; $i++) {
            $firstName = $firstNames | Get-Random
            $lastName = $lastNames | Get-Random
            $newFolderName = "$firstName.$lastName"
            $folderNames[$folderNames.IndexOf($duplicate.Name)] = $newFolderName
        }
    }
    $duplicateFolders = $folderNames | Group-Object | Where-Object { $_.Count -gt 1 }
}

Write-Host "No duplicate folder names found."

# Create the folders
$basePath = "J:\RandomFolders"
if (-not (Test-Path -Path $basePath)) {
    New-Item -Path $basePath -ItemType Directory
}

foreach ($folderName in $folderNames) {
    $folderPath = Join-Path -Path $basePath -ChildPath $folderName
    if (-not (Test-Path -Path $folderPath)) {
        New-Item -Path $folderPath -ItemType Directory
    }
}

Write-Host "350 random folders created in $basePath."
#>

###

#$cityfolders =  @("Ashland", "Buffalo", "Chicago", "Dallas", "Indiana", "Madison", "Minneapolis", "Pittsburgh", "Toledo")
$cityfolders = @("Buffalo", "Chicago", "Dallas", "Indiana", "Madison", "Minneapolis", "Pittsburgh", "Toledo")
foreach ($cityfolder in $cityfolders) {

# Define the source and destination paths
$sourcePath = "J:\RandomFolders"
$destinationBasePath = $cityfolder

# Get the list of destination folders
$destinationPathFolders = Get-ChildItem -Path $destinationBasePath -Directory

# Initialize the counter
$destinationfoldercounter = $destinationPathFolders.Count - 1

# Loop through the destination folders and move a file from $randomFolders
while ($destinationfoldercounter -ge 0) {
    $sourcepathfolders = Get-ChildItem -Path $sourcePath -Directory
    $randomFolder = Get-Random -InputObject $sourcepathfolders
    $namefolderpath = $randomFolder.FullName
    $destinationFolder = $destinationPathFolders[$destinationfoldercounter].FullName
    Move-Item -Path $namefolderpath -Destination $destinationFolder
    Write-Host "$namefolderpath moved to $destinationFolder"
    $destinationfoldercounter--
}
}
<#

###
# Loop through the destination folders and move a file from $randomFolders
while ($destinationfoldercounter -ge 0) {
    if ($randomFolders.Count -gt 0) {
        $folderToMove = $randomFolders[0]
        $destinationFolder = $destinationPathFolders[$destinationfoldercounter]
        $destinationPath = Join-Path -Path $destinationFolder.FullName -ChildPath $folderToMove.Name
        Move-Item -Path $folderToMove.FullName -Destination $destinationPath
        Write-Host "Moved folder '$($folderToMove.Name)' to '$destinationPath'."
        $randomFolders = $randomFolders | Where-Object { $_.FullName -ne $folderToMove.FullName }
        $destinationfoldercounter--
    } else {
        Write-Host "No more folders to move."
        break
    }
}

###



# Loop through the random folders and move them to the destination paths
foreach ($folder in $randomFolders) {
    $destinationPath = Join-Path -Path $destinationBasePath -ChildPath $counter


    Move-Item -Path $folder.FullName -Destination $destinationPath
    Write-Host "Moved folder '$($folder.Name)' to '$destinationPath'."
    $counter--
}

#>