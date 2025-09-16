<#
$files =@(
    '\\azurezp03\data\archive\Firstenergyserv\FES1943\4.0 Technical Documents\4.18 Discipline\Structural\Calcs\Regulator\Regulator FDN Analysis (ASCE7-10).ted',
    '\\azurezp03\data\archive\Firstenergyserv\FES1943\4.0 Technical Documents\4.18 Discipline\Structural\Calcs\Regulator\Regulator Soil Bearing.xlsx',
    '\\azurezp01\data\archive\Sherwin Williams\SW2212\10.0 Cad\SW2212\PipingPart.xml.plck',
    '\\azurezp01\data\archive\Sherwin Williams\SW2212\10.0 Cad\SW2212\PnIdPart.xml.plck',
    '\\azurezp01\data\archive\Sherwin Williams\SW2212\10.0 Cad\SW2212\IsoPart.xml.plck',
    '\\azurezp01\data\archive\Sherwin Williams\SW2102\4.0 Technical Documents\4.18 Discipline\350 Process\Process Correspondence\Meeting Minutes\2021-04-21 PFD Review\SW2101 PFD PRELIMINARY 2021-04-20.pdf',
    '\\azurezp01\data\archive\Sherwin Williams\SW1901\10.0 Cad\10.6 Discipline\PIPING\SW1901\PnIdPart.xml.plck',
    '\\azurezp01\data\archive\Sherwin Williams\SW2212\10.0 Cad\SW2212\MiscPart.xml.plck',
    '\\azurezp01\data\archive\Sherwin Williams\SW2212\10.0 Cad\SW2212\OrthoPart.xml.plck'
)
#>

$files =@(
    'archive\Firstenergyserv\FES1943\4.0 Technical Documents\4.18 Discipline\Structural\Calcs\Regulator\Regulator FDN Analysis (ASCE7-10).ted',
    'archive\Firstenergyserv\FES1943\4.0 Technical Documents\4.18 Discipline\Structural\Calcs\Regulator\Regulator Soil Bearing.xlsx',
    'archive\Sherwin Williams\SW2212\10.0 Cad\SW2212\PipingPart.xml.plck',
    'archive\Sherwin Williams\SW2212\10.0 Cad\SW2212\PnIdPart.xml.plck',
    'archive\Sherwin Williams\SW2212\10.0 Cad\SW2212\IsoPart.xml.plck',
    'archive\Sherwin Williams\SW2102\4.0 Technical Documents\4.18 Discipline\350 Process\Process Correspondence\Meeting Minutes\2021-04-21 PFD Review\SW2101 PFD PRELIMINARY 2021-04-20.pdf',
    'archive\Sherwin Williams\SW1901\10.0 Cad\10.6 Discipline\PIPING\SW1901\PnIdPart.xml.plck',
    'archive\Sherwin Williams\SW2212\10.0 Cad\SW2212\MiscPart.xml.plck',
    'archive\Sherwin Williams\SW2212\10.0 Cad\SW2212\OrthoPart.xml.plck'
)

$filerserver = @(
'\\middough.local\corp\data',
'\\azurepz01\data',
'\\azurepz02\data',
'\\azurepz03\data',
'\\azurepz04\data',
'\\ashpz01\data',
'\\clepz01\data',
'\\chipz01\data',
'\\pitpz01\data',
'\\tolpz01\data',
'\\bufpz01\data',
'\\nwipz01\data'
)



foreach ($file in $files) {
    write-host $file

    foreach ($filer in $filerserver) {
    $fullfolder = Join-Path -Path $filer -ChildPath $file
        write-host $fullfolder " - " (test-path $fullfolder)

    }
    write-host .
}


<#
 #test-path $file
 # change servername to \\middough.local
 $newfile = $file -replace '\\azurezp0[123]', '\middough.local'
 #write-host "New file path: $newfile"
 #Test-Path $newfile
 # get parent folder
 $parentFolder = Split-Path $newfile -Parent
 write-host "Parent folder: $parentFolder"
 Test-Path $parentFolder
#>