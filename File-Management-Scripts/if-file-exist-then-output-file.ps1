# EVALUTIONATION 
# This script is used to check if the Autodesk programs are installed on the machine.
# If the Autodesk programs are installed, the script will create a file in the C:\temp directory.
# If the file exists, the script will exit with a return code of 1.
# If the file does not exist, the script will exit with a return code of 0.

if (Test-Path C:\temp\AutodeskProgramsInstall*.txt) {
    write-output "exit 1"
    Get-Content C:\temp\AutodeskProgramsInstall*.txt
} else {
    write-output "exit 0"
}

# REMEDIATION

# The remediation for this script is to create a file in the C:\temp directory if the Autodesk programs are installed on the machine.
# The remediation script is as follows:

Get-Content C:\temp\AutodeskProgramsInstall*.txt