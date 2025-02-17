#download pdfsharp from https://sourceforge.net/projects/pdfsharp/files/pdfsharp/PDFsharp%201.50.5147/PDFsharp-MigraDocFoundation-Assemblies-1_50_5147.zip/download
# Extract the contents of the downloaded ZIP file to a folder on your computer.
# Copy the PDFsharp.dll file from the extracted folder to the same folder as your PowerShell script.
# Run the following PowerShell script to merge PDF files in batches of 100.
# The script will merge files named sn-000.pdf, sn-001.pdf, ..., sn-099.pdf into a single PDF named merged-000-099.pdf, and so on.
# You can adjust the source and output folders, as well as the batch range, to suit your needs.
# The script will skip any missing files in the sequence and continue merging the rest.
# The merged PDF files will be saved in the output folder with the specified batch range in the file name.
# The script will output a message for each batch range processed, indicating the files have been merged successfully.
# The script will skip any missing files in the sequence and continue merging the rest.
# The merged PDF files will be saved in the output folder with the specified batch range in the file name.
# The script will output a message for each batch range processed, indicating the files have been merged successfully.

cd 'C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell\File-Management-Scripts'
# Download PDFsharp library (assumes you have curl.exe in the same folder as the script)

# Navigate to the directory where you want to install the package
cd 'C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell\File-Management-Scripts'

# Download the NuGet executable
Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile "nuget.exe"
Move-Item -Path "nuget.exe" -Destination "C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell\nuget"

# Install PDFsharp package
.\nuget.exe install PDFsharp -Version 1.50.5147

# Load PDFsharp library (assumes you have PDFsharp.dll in the same folder as the script)
$scriptPath = $MyInvocation.MyCommand.Path
$scriptFolder = Split-Path -Path $scriptPath
Add-Type -Path (Join-Path -Path $scriptFolder -ChildPath "PDFsharp.dll")
cd 'C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell\File-Management-Scripts'
# Download PDFsharp library (assumes you have curl.exe in the same folder as the script)

curl.exe -o PDFsharp.zip https://sourceforge.net/projects/pdfsharp/files/pdfsharp/PDFsharp%201.50.5147/PDFsharp-MigraDocFoundation-Assemblies-1_50_5147.zip/download
Expand-Archive -Path PDFsharp.zip -DestinationPath PDFsharp
Copy-Item -Path PDFsharp\PDFsharp-MigraDocFoundation-Assemblies-1_50_5147\PDFsharp-MigraDocFoundation-Assemblies-1_50_5147\lib\net40\PdfSharp.dll -Destination .



# Load PDFsharp library (assumes you have PDFsharp.dll in the same folder as the script)
$scriptPath = $MyInvocation.MyCommand.Path
$scriptFolder = Split-Path -Path $scriptPath
Add-Type -Path (Join-Path -Path $scriptFolder -ChildPath "PDFsharp.dll")
# Load PDFsharp library (assumes you have PDFsharp.dll in the same folder as the script)
Add-Type -Path "C:\Path\To\PDFsharp.dll"

# Define the source and output folders
$sourceFolder = "C:\Users\jason.lamb\OneDrive - middough\Downloads\GRC_SN_Files\PDFs"
$outputFolder = "C:\Users\jason.lamb\OneDrive - middough\Downloads\GRC_SN_Files\Merged"

# Loop through each batch range (0-9) to handle 000-099, 100-199, ..., 900-999
for ($batch = 0; $batch -le 9; $batch++) {
    # Calculate the start and end numbers for each batch
    $start = $batch * 100
    $end = $batch * 100 + 99
    
    # Format the batch range for the output file name
    $outputRange = "{0:D3}-{1:D3}" -f $start, $end
    $outputFile = Join-Path -Path $outputFolder -ChildPath "merged-$outputRange.pdf"

    # Create a new PDF document for merging
    $mergedPdf = New-Object PdfSharp.Pdf.PdfDocument

    # Loop through each file in the current batch and add its pages to the merged PDF
    for ($i = $start; $i -le $end; $i++) {
        # Format the current file number with leading zeros
        $fileName = "sn-" + "{0:D3}" -f $i + ".pdf"
        $filePath = Join-Path -Path $sourceFolder -ChildPath $fileName

        # Check if the file exists before adding
        if (Test-Path -Path $filePath) {
            # Open the PDF to be merged
            $pdf = [PdfSharp.Pdf.IO.PdfReader]::Open($filePath, [PdfSharp.Pdf.IO.PdfDocumentOpenMode]::Import)
            # Import each page of the PDF to the merged document
            foreach ($page in $pdf.Pages) {
                $mergedPdf.AddPage($page)
            }
        }
    }

    # Save the merged PDF
    $mergedPdf.Save($outputFile)
    Write-Output "Files from $outputRange have been merged into $outputFile"
}
