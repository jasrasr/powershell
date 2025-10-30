$filters = @(
    "1.1 Proposal Cover Letter",
    "1.10 Project Profile",
    "1.11 Standard File Index",
    "1.2 Contract Release PO-CO",
    "1.3 CA-Change Authorization",
    "1.4 Secrecy Agreements",
    "1.5 Subconsultant Prop Contract-PO",
    "1.6 Patents",
    "1.7 Invoices",
    "1.8 Sr. Mgmt. Review",
    "1.9 Close-Out Report",
    "10.1 Blocks",
    "10.2 Client Originals",
    "10.3 Temp Wrk Files",
    "10.4 Vendor Dwgs",
    "10.5 Wrk Dwgs",
    "10.6 Discipline",
    "2.1 Distribution-Communication Matrix",
    "2.2 Internal",
    "2.3 Client",
    "2.4 Transmittals",
    "2.5 Meeting Minutes",
    "2.6 Action Item List",
    "2.7 Regulatory Agencies",
    "2.8 Vendor-Subconsultant",
    "2.9 Logos",
    "3.1 PDS",
    "3.2 DTSR",
    "3.3 PSR",
    "3.4 Schedule",
    "3.5 Project Evaluation Report",
    "3.6 Project Plan",
    "3.7 Misc. Status Reports",
    "4.1 Scope of Services",
    "4.10 Equipment List",
    "4.11 Piping Line List",
    "4.12 Tie-In List",
    "4.13 Instrument List",
    "4.14 Deliverables List-File",
    "4.15 I-O List",
    "4.16 Vendor Files",
    "4.17 Photos",
    "4.18 Discipline",
    "4.2 Coordination Manual",
    "4.3 Design Manual",
    "4.4 Statement-Requirements",
    "4.5 Design Spec",
    "4.6 Environ-Geotech Data Surveys",
    "4.7 Design Basis",
    "4.8 Middough Tech Reports",
    "4.9 Drawing List",
    "5.1 Quality Checklist",
    "5.2 Design Reviews",
    "5.3 Safety-HAZOP Reviews",
    "5.4 Constructability Reviews",
    "5.5 Operability Reviews",
    "5.6 Procedures",
    "6.1 Capital Cost Estimate",
    "6.2 Back-up - Take-offs",
    "6.3 Cost Report",
    "6.4 Overall Project",
    "7.1 Status Reports",
    "7.10 Field CO Request",
    "7.11 Punch List",
    "7.12 Execution Plan",
    "7.13 Field Study",
    "7.2 Schedules",
    "7.3 Constr Package",
    "7.4 Meeting Minutes",
    "7.5 Submittals - Approvals",
    "7.6 Contractor Correspondence",
    "7.7 Constr Permits",
    "7.8 Field Test Reports",
    "7.9 Field Design CA",
    "8.1 Project Purchasing Procedure",
    "8.2 Purchase Orders - Bid Packages",
    "8.3 Subcontracts",
    "8.4 Vendor Data"
)

$inPath = "C:\temp\powershell-exports\folder-depth3-20251030-110930.txt"

# Read all lines, filter, and overwrite
$data = Get-Content -Path $inPath | Where-Object {
    $line = $_
    $keep = $false
    foreach ($filter in $filters) {
        if ($line -like "*$filter*") {
            $keep = $false
            break
        }
    }
    $keep
}

$data | Out-File -FilePath $inPath -Encoding UTF8