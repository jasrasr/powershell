# Retrieve all Applications with Deployment Count and Status
$applications = Get-CMApplication | ForEach-Object {
    $deployments = Get-CMDeployment | Where-Object { $_.PackageName -eq $_.LocalizedDisplayName }
    [PSCustomObject]@{
        Name            = $_.LocalizedDisplayName
        DeploymentCount = $deployments.Count
        Status          = if ($deployments) {
            if (($deployments | Select-Object -First 1).Enabled) { 'Enabled' } else { 'Disabled' }
        } else {
            'No Deployments'
        }
    }
}

# Retrieve all Packages with Deployment Count and Status
$packages = Get-CMPackage | ForEach-Object {
    $deployments = Get-CMDeployment | Where-Object { $_.PackageID -eq $_.PackageID }
    [PSCustomObject]@{
        Name            = $_.Name
        DeploymentCount = $deployments.Count
        Status          = if ($deployments) {
            if (($deployments | Select-Object -First 1).Enabled) { 'Enabled' } else { 'Disabled' }
        } else {
            'No Deployments'
        }
    }
}

# Output results
Write-Host "`n===== Applications =====`n"
$applications | Format-Table -AutoSize

<#
Name                                                  DeploymentCount Status
----                                                  --------------- ------
.NET Framework 4.5.1                                              469 Enabled
3EPlus V4.1                                                       469 Enabled
AccXes Client Tools 15                                            469 Enabled
AccXess Tools Uninstall                                           469 Enabled
CCMCACHE Cleanup                                                  469 Enabled
Citrix ICA 10.200 Web Client                                      469 Enabled
Citrix Online Plug-In (Full)                                      469 Enabled
Design Flow Drive Mapping                                         469 Enabled
DOT Net 4.6.1 Uninstall                                           469 Enabled
eBlue Upload Control                                              469 Enabled
Engineering Power Tools Plus                                      469 Enabled
ePlans 360                                                        469 Enabled
FEATools                                                          469 Enabled
Firefox                                                           469 Enabled
Google Chrome x64                                                 469 Enabled
KB Removal                                                        469 Enabled
Kohler Power Solutions Center                                     469 Enabled
Leica Cyclone Object Enabler 6.0.5                                469 Enabled
Microsoft Lync Web App Plug-in                                    469 Enabled
Movie Maker                                                       469 Enabled
Navisworks SP 2 Uninstall                                         469 Enabled
Nelprof                                                           469 Enabled
Nelprof 6.0.6                                                     469 Enabled
Newforma Client Cleveland                                         469 Enabled
Newforma Client Chicago                                           469 Enabled
nScreen Share                                                     469 Enabled
Pro Steam                                                         469 Enabled
ProFlow III                                                       469 Enabled
ReConWall                                                         469 Enabled
RSA SecurID Software Token                                        469 Enabled
SEL AcSELerator                                                   469 Enabled
Smart Plant Freeview                                              469 Enabled
SmartPlant Instrumentation 2013                                   469 Enabled
Smartplant Instrumentation 2013 Administration                    469 Enabled
Smartplant Instrumentation Launch                                 469 Enabled
Smartplant Instrumentation Registry Key Import (ASH)              469 Enabled
Smartplant Instrumentation Registry Key Import (CHI)              469 Enabled
Smartplant Instrumentation Registry Key Import (CLE)              469 Enabled
Smartplant Instrumentation Registry Key Import (HOU)              469 Enabled
Smartplant Instrumentation Registry Key Import (PHL)              469 Enabled
Smartplant Instrumentation Registry Key Import (TOL)              469 Enabled
Smartplant License Manager                                        469 Enabled
Smartplant License Manager 2012                                   469 Enabled
Smartplant License Manager Launch                                 469 Enabled
SQL Local Client 2012                                             469 Enabled
Storm and Sewer file copy                                         469 Enabled
TacoNet                                                           469 Enabled
Tekla BIMsight                                                    469 Enabled
TraceCalc Pro                                                     469 Enabled
ValspeQ 4.04.1                                                    469 Enabled
Windows Live Essentials                                           469 Enabled
Compute-A-Fan 9.6                                                 469 Enabled
aspenONE Regkey Removal                                           469 Enabled
Visual Flow 5.8                                                   469 Enabled
HMEx                                                              469 Enabled
Revit Freebies                                                    469 Enabled
Newforma Client Ashland                                           469 Enabled
Newforma Client Buffalo                                           469 Enabled
Newforma Client Toledo                                            469 Enabled
Newforma Client Buffalo 64bit                                     469 Enabled
Citrix Receiver 4.8                                               469 Enabled
Microsoft Photo Editor                                            469 Enabled
.NET 4.6                                                          469 Enabled
CHEMCAD Suite 7                                                   469 Enabled
SmartPlant External Editor                                        469 Enabled
Microsoft Access Database Uninstall                               469 Enabled
Smartplant External Editor 11                                     469 Enabled
7-Zip                                                             469 Enabled
Act! Premium                                                      469 Enabled
Newforma Client Cleveland 64bit                                   469 Enabled
.NET 3.5 for Windows 10                                           469 Enabled
Revit Column Splitter                                             469 Enabled
PRO II                                                            469 Enabled
MCPC_NewForma_CLE                                                 469 Enabled
Newforma Client Ashland 64bit                                     469 Enabled
Newforma Client Chicago 64bit                                     469 Enabled
Newforma Client Toledo 64bit                                      469 Enabled
MCPC_Cisco_AnyConnect Secure Mobility_Reg_Edit                    469 Enabled
MCPC_Cisco AnyConnect Secure Mobility Client                      469 Enabled
MCPC_NewForma_BUF                                                 469 Enabled
MCPC_NewForma_ASH                                                 469 Enabled
MCPC_NewForma_CHI                                                 469 Enabled
MCPC_NewForma_TOL                                                 469 Enabled
MCPC_Office _365                                                  469 Enabled
DHTML Editor                                                      469 Enabled
Adobe Acrobat DC                                                  469 Enabled
Project Creation Wizard                                           469 Enabled
Revit InfraWorks Updater                                          469 Enabled
Microdrainage Utility                                             469 Enabled
Infrastructure Parts Editor                                       469 Enabled
Drawing Purge                                                     469 Enabled
WinIGS 7.7                                                        469 Enabled
AcSELerator Quickset                                              469 Enabled
Smartplant Instrumentation 2018                                   469 Enabled
Smartplant Schema Component 2018                                  469 Enabled
Smartplant Client 2018                                            469 Enabled
Smartplant License Manager 2018                                   469 Enabled
MasterWorks-Chicago 2019                                          469 Enabled
Masterworks-Cleveland 2019                                        469 Enabled
Intergraph FreeView                                               469 Enabled
Praxair Autocad 2019 Customizations                               469 Enabled
Prerequisites for Bentley 08.11.07.03                             469 Enabled
Screencast 3.6                                                    469 Enabled
Raster Design 2020                                                469 Enabled
Smartplant 3D Loader for Navisworks 2019                          469 Enabled
PLS-CADD 16                                                       469 Enabled
Nelprof 6.2.11                                                    469 Enabled
OCE Publisher                                                     469 Enabled
Xrev Freebies                                                     469 Enabled
Notepad ++ v7.8.4                                                 469 Enabled
Teams                                                             469 Enabled
Smartplant 3D Loader for Navisworks 2020                          469 Enabled
EdgeWise Prerequisites                                            469 Enabled
eDrawings                                                         469 Enabled
Tekla-Revit Integrator 2020                                       469 Enabled
eDrawings 2020                                                    469 Enabled
Zscaler                                                           469 Enabled
ProStructures CONNECT ObjectEnabler for AutoCAD                   469 Enabled
Petro-SIM 7.1                                                     469 Enabled
Google Earth Pro 7.3.3                                            469 Enabled
Image Resizer for Windows                                         469 Enabled
ProCAD 2022                                                       469 Enabled
Trane Trace 700 6.3.5.1                                           469 Enabled
Visual Lighting 2020 R2                                           469 Enabled
Bluebeam Revu 20                                                  469 Enabled
Print Nightmare                                                   469 Enabled
Mathcad Prime 7                                                   469 Enabled
Revit 2022                                                        469 Enabled
AutoCAD 2022                                                      469 Enabled
AutoCAD Electrical 2022                                           469 Enabled
AutoCAD MEP 2022                                                  469 Enabled
3ds Max 2022                                                      469 Enabled
AutoCAD Architecture 2022                                         469 Enabled
AutoCAD MAP 3D 2022                                               469 Enabled
AutoCAD Plant 3D 2022                                             469 Enabled
Raster Design 2022                                                469 Enabled
Advance Steel 2022                                                469 Enabled
Civil 3D 2022                                                     469 Enabled
ReCap Pro 2022                                                    469 Enabled
Bulk Renaming Utility 3.4.3                                       469 Enabled
Tank v12 (Includes SP1)                                           469 Enabled
VLC Media Player v 3.0.16.0                                       469 Enabled
Worx Plugins 2021.245.1500.0                                      469 Enabled
LPILE                                                             469 Enabled
Navisworks Manage 2022                                            469 Enabled
Revit 2022.1.1 Hotfix                                             469 Enabled
Revit Issues Addin V3 2022                                        469 Enabled
Cyclone Register 360 2022                                         469 Enabled
Cyclone 2022                                                      469 Enabled
CloudWORX for AutoCAD 2022                                        469 Enabled
FileOpen                                                          469 Enabled
Advance Steel 2022 Object Enabler                                 469 Enabled
Civil 3D 2022 Object Enabler                                      469 Enabled
AutoCAD Plant 3D 2022 Object Enabler                              469 Enabled
CPak for Bondstrand                                               469 Enabled
AutoPIPE 12.07                                                    469 Enabled
DWG TrueView                                                      469 Enabled
AutoCAD Plant 3D 2022.1.1                                         469 Enabled
BXF Exporter for Plant 3D                                         469 Enabled
BXF Importer for Revit                                            469 Enabled
SQL Management Express                                            469 Enabled
Company Portal                                                    469 Enabled
Snagit 2022.1                                                     469 Enabled
Civil 3D Object Enabler 2022.2                                    469 Enabled
Roombook Areabook Buildingbook for Revit 2022                     469 Enabled
Revit 2022.1.3 Hotfix                                             469 Enabled
Navisworks Exporters 2022                                         469 Enabled
AcSELerator Quickset 7.0.0.7                                      469 Enabled
Named User                                                        469 Enabled
EasyPower 10.6                                                    469 Enabled
Issues Addin for Revit 2022 V5                                    469 Enabled
Civil 3D 2022.2.1                                                 469 Enabled
Civil 3D 2022.2                                                   469 Enabled
ComCheck 4.1.5.5                                                  469 Enabled
AutoCAD Mechanical 2022.0.1                                       469 Enabled
Caesar II V 13                                                    469 Enabled
WorkSpace 22.9                                                    469 Enabled
Graitec Advance 2020                                              469 Enabled
Cadworx OE 2020 R2                                                469 Enabled
DiRoots                                                           469 Enabled
BIM Batch Suite 2023                                              469 Enabled
BIM Project Suite 2023                                            469 Enabled
Cadworx OE 2020                                                   469 Enabled
Cadworx OE 2019 SP2 HF                                            469 Enabled
Vehicle Tracking 2022                                             469 Enabled
LayoutFAST                                                        469 Enabled
Revit 2023                                                        469 Enabled
PV Elite 24 + SP2                                                 469 Enabled
Fisher Specification Manager 2.22.1.0                             469 Enabled
AspenONE 14                                                       469 Enabled
Fidelis 14                                                        469 Enabled
Sketchup Viewer 2022                                              469 Enabled
Solidworks 2022 (With SP5)                                        469 Enabled
Revit Extension for Fabrication MEP Exchange                      469 Enabled
Licad 11.1.0.125                                                  469 Enabled
AutoCAD 2022.1.3                                                  469 Enabled
Navisworks Exporters 2023                                         469 Enabled
Revit 2023.1.1                                                    469 Enabled
Cyclone Object Enabler for Autocad                                469 Enabled
Caesar II v 13 Hot Fix 1                                          469 Enabled
AFT Fathom 12.0.1123                                              469 Enabled
OneLaunch Uninstall                                               469 Enabled
PV Elite v 25                                                     469 Enabled
Ram Concept 8.4.0.122                                             469 Enabled
Navisworks Freedom 2022                                           469 Enabled
Microstation Connect 10.17.02.061                                 469 Enabled
Xrev Freebies 2.8.0                                               469 Enabled
ISM Plug In for Revit11.03                                        469 Enabled
Arrow 9.0.1119                                                    469 Enabled
Coordinates Transformation Tool for Civil 3D                      469 Enabled
Grading Optimization for Civil 3D                                 469 Enabled
Storm & Sanitary Analysis Update                                  469 Enabled
Project Explorer for Civil 3D 2022                                469 Enabled
Vulcraft Joist Tools for Revit 2020                               469 Enabled
Vulcraft Joist Tools for Revit 2022                               469 Enabled
PRV2SIZE 2.9.84                                                   469 Enabled
SketchUp Import 3.3.0                                             469 Enabled
ICC Digital Codes Premium Add-In                                  469 Enabled
TEDDS and Structural Designer 2023                                469 Enabled
PV Elite v 25 SP1                                                 469 Enabled
Mimecast for Outlook                                              469 Enabled
AutoCAD 2024                                                      469 Enabled
AutoCAD Plant 3D 2024                                             469 Enabled
Licad Plant 3D Plug-in 11.1.0.9                                   469 Enabled
Dell Display Manager 2.2.1.17                                     469 Enabled
Architecture 2024                                                 469 Enabled
Raster Design 2024                                                469 Enabled
Autocad VBA 2022                                                  469 Enabled
Navisworks Manage 2024                                            469 Enabled
ReCap Pro 2024                                                    469 Enabled
Civil 3D Object Enabler 2024                                      469 Enabled
AutoCAD Plant 3D 2024 Object Enabler                              469 Enabled
AutoCAD Plant 3D 2024 Object Enabler (Navisworks)                 469 Enabled
PV Elite v 25.00.01.1110                                          469 Enabled
Twinmotion For Revit 2023.1                                       469 Enabled
Vehicle Tracking 2024                                             469 Enabled
Vehicle Tracking Object Enabler 2024                              469 Enabled
KG-TOWER v 5.4                                                    469 Enabled
AutoCAD Electrical 2022.0.2                                       469 Enabled
Advance Steel 2024                                                469 Enabled
Advance Steel 2024 Object Enabler                                 469 Enabled
Navisworks Exporters 2024                                         469 Enabled
Unifying Software                                                 469 Enabled
Revit 2024                                                        469 Enabled
Civil 3D 2024                                                     469 Enabled
Twinmotion for Revit 2022                                         469 Enabled
KeePass 2.54                                                      469 Enabled
WinIGS 7.7w                                                       469 Enabled
PTC Mathcad Prime 9                                               469 Enabled
ETAP 22.5                                                         469 Enabled
Viusual C++2015-2022 Redistrubuteable                             469 Enabled
Blender 3.6                                                       469 Enabled
Visual C++ 2015-2022                                              469 Enabled
Identity Manager                                                  469 Enabled
Connection Client 23.0.0.10                                       469 Enabled
RAM Connection 2023                                               469 Enabled
iTwin Analytical Syncronizer 2023                                 469 Enabled
RAM Elements 2023                                                 469 Enabled
RAM Structural System 2023                                        469 Enabled
Inspector 3.0                                                     469 Enabled
Civil 3d 2022.2.4                                                 469 Enabled
AutoCAD Electrical 2024                                           469 Enabled
CADWorx Bundle 2023                                               469 Enabled
Robot 2024                                                        469 Enabled
SKM Power Tools 11                                                469 Enabled
Visio 2021                                                        469 Enabled
Project 2021                                                      469 Enabled
Office 365 2501                                                   469 Enabled
Navisworks Manage 2024 Update 1                                   469 Enabled
Advanced Steel Extension for Revit 2024                           469 Enabled
Publish NWC Add-In for Revit 2024                                 469 Enabled
Advanced Steel Extension for Revit 2022                           469 Enabled
Advanced Steel Extension for Revit 2023                           469 Enabled
Revit 2024 Update 1.1                                             469 Enabled
Issues Addin v 5.1 for Revit 2024                                 469 Enabled
Worx Plugins 2023                                                 469 Enabled
Edgewise 5.8.0                                                    469 Enabled
Pinnacle Management Console 2023.6.1.107                          469 Enabled
Pinnacle Series User Tools 2023.8.1.110                           469 Enabled
Fathom 13                                                         469 Enabled
ReCap Pro 2024.1                                                  469 Enabled
ReCap Photo 2024.0.1                                              469 Enabled
Navisworks Manage 2022 Update 5                                   469 Enabled
Architecture 2024.0.1                                             469 Enabled
Autodesk Single Sign On Component 13.7.7.1807                     469 Enabled
Arrow 10                                                          469 Enabled
Cadworx 2019 Object Eabler                                        469 Enabled
TruView 2022                                                      469 Enabled
Cyclone 2023                                                      469 Enabled
CloudWORX for AutoCAD 2023                                        469 Enabled
Revit 2024 Update 2                                               469 Enabled
Revit 2022.1.5                                                    469 Enabled
Global Protect 6.1.2                                              469 Enabled
CADWorx Bundle 2023 SP1                                           469 Enabled
Navisworks Freedom 2020 Update 7                                  469 Enabled
Inventor (Pro) 2024                                               469 Enabled
Inventor Nastran 2024                                             469 Enabled
AspenONE 14.2                                                     469 Enabled
ReCap Photo 2022.2.2                                              469 Enabled
ReCap Pro 2022.2.2                                                469 Enabled
MEP 2024                                                          469 Enabled
Autocad VBA 2024                                                  469 Enabled
Twinmotion For Revit 2023.2                                       469 Enabled
STAAD Foundation Advanced 2023                                    469 Enabled
Navisworks Freedom 2024                                           469 Enabled
AutoCAD Electrical 2024.0.1                                       469 Enabled
Dell Command Update 5.2.0                                         469 Enabled
Infraworks 2024                                                   469 Enabled
Vehicle Tracking 2024.0.1                                         469 Enabled
Compress 8400                                                     469 Enabled
Inspect 8400                                                      469 Enabled
Cadworx Plant SP1 HF1                                             469 Enabled
Civil 3D 2024.3                                                   469 Enabled
Civil 3D 2024.3 Object Enabler                                    469 Enabled
STAAD.Pro 2023 (23.0.2.361)                                       469 Enabled
RAM Connection 2023 (23.0.1.91)                                   469 Enabled
RAM Elements 2023 (23.0.1.95)                                     469 Enabled
Trane Trace 3D+ 6.00.106                                          469 Enabled
7-Zip 23.1                                                        469 Enabled
Xrev Freebies 2.9                                                 469 Enabled
Identity Manager 1.0 1.10.10                                      469 Enabled
PRG FEA Solutions 2024.1.0.1801                                   469 Enabled
Autocad 2024.1.2                                                  469 Enabled
Caesar II v 14                                                    469 Enabled
Windows 11                                                        469 Enabled
Autodesk Single Sign On Component 13.8.4.1804                     469 Enabled
Civil 3D Infrastructure Parts Editor 2022                         469 Enabled
Civil 3D Infrastructure Parts Editor 2024                         469 Enabled
Computrace Design Suite 6.1                                       469 Enabled
EasyPower 11                                                      469 Enabled
AutoCAD 2022.1.4                                                  469 Enabled
AutoCAD 2024.1.3                                                  469 Enabled
Identity Manager 1.11.9.11                                        469 Enabled
AutoCAD Plant 3D 2022.1.3                                         469 Enabled
AutoCAD Plant 3D 2024.1.2                                         469 Enabled
Leica CLM 2.16.0.0                                                469 Enabled
AutoCAD Plant 3D 2024.1.2 Object Enabler (Navisworks)             469 Enabled
Autodesk Access 2.5.0.112                                         469 Enabled
Pinnacle Series User Tools 18.3.0.315                             469 Enabled
Connection Client 23.0.1.25                                       469 Enabled
Pinnacle Management Console 2024.3.1.118                          469 Enabled
Ram Connection 2024 (24.0.0.140)                                  469 Enabled
Ram Structural System 23.0.1.275                                  469 Enabled
STAAD Pro 23.0.3.25                                               469 Enabled
Ram Elements 2024 24.0.0.154                                      469 Enabled
Fusion 12904.2.1.0                                                469 Enabled
AutoCAD 2025                                                      469 Enabled
Revit 2024 Update 2.1                                             469 Enabled
ReCap Pro 2024.1.1                                                469 Enabled
ReCap Photo 2024.0.2                                              469 Enabled
Navisworks Coordination Issues Add-In 4.4.0.0                     469 Enabled
AutoCAD Electrical 2025                                           469 Enabled
Architecture 2025                                                 469 Enabled
Revit 2025                                                        469 Enabled
Civil 3D 2025                                                     469 Enabled
Cyclone 2023.1                                                    469 Enabled
AutoCAD Plant 3D 2025                                             469 Enabled
Navisworks Manage 2025                                            469 Enabled
Cyclone Register 360 2024.0.1                                     469 Enabled
PsyCalc 7.0.1                                                     469 Enabled
AFT Fathom  Release 2024.04.16                                    469 Enabled
Advance Steel 2025                                                469 Enabled
ReCap Pro 2025                                                    469 Enabled
Navisworks Manage 2024 Update 2                                   469 Enabled
Navisworks Freedom 2025                                           469 Enabled
Inventor (Pro) 2025                                               469 Enabled
Raster Design 2025                                                469 Enabled
MEP 2025                                                          469 Enabled
Caesar II v 14 TEST                                               469 Enabled
Visual C++ redistributeable 14.36.32532.0                         469 Enabled
AutoCAD 2024.1.4                                                  469 Enabled
Autodesk Single Sign On Component 13.8.6.1806                     469 Enabled
Smart Licensing Client 14.02.04.0109                              469 Enabled
Revit 2022.1.6 Hotfix                                             469 Enabled
Advance Steel 2022.0.2                                            469 Enabled
Advance Steel 2022.0.2 Object Enabler                             469 Enabled
AutoCAD Architecture 2022.0.2                                     469 Enabled
RealDWG 2024.1.3                                                  469 Enabled
TEDDS and Structural Designer 2024                                469 Enabled
Nerdio AVD 1.2.5454.0                                             469 Enabled
Desktop Connector 16.9.0.2204                                     469 Enabled
AutoCAD 2024.1.5                                                  469 Enabled
CloudWORX for AutoCAD 2023.1                                      469 Enabled
TruView 2024                                                      469 Enabled
Leica LGSConverter Tool 2024.0.1.0                                469 Enabled
Caps 4.44                                                         469 Enabled
Identity Manager 1.0.1.11.13                                      469 Enabled
Visual Lighting 2020 R2 2.11.0094                                 469 Enabled
Arrow 2024                                                        469 Enabled
Bluebeam 21                                                       469 Enabled
Everything 1.4.1.1024                                             469 Enabled
Autocad 2022.1.5                                                  469 Enabled
Google Chrome                                                     469 Enabled
N-Able Windows Agent                                              469 Enabled
Microsoft 365 Apps for enterprise x64                             469 Enabled
Adobe Acrobat Reader DC MUI                                       469 Enabled
Autocad 2025.1                                                    469 Enabled
RealDWG 2025.1                                                    469 Enabled
Dell Command | Update for Windows Universal                       469 Enabled
Revit 2022.1.7 Hotfix                                             469 Enabled
Microsoft Visual C++ Redistributable x64 2015-2022                469 Enabled
Python Cable Tray 3.03                                            469 Enabled
Cloudflare WARP 2024.6.473.0                                      469 Enabled
Freshservice Discovery Agent 3.4.0                                469 Enabled
Automox Agent                                                     469 Enabled
Cadworx Plant PID 2020 OE R2 SP1                                  469 Enabled
Cadworx Plant PID OE 2020 R2 SP1 HF2                              469 Enabled
Revit 2023.1.5                                                    469 Enabled
Smart Licensing Client 14.02.05.0241                              469 Enabled
Identity Manager 1.0 1.12.0                                       469 Enabled
eDrawings 2024                                                    469 Enabled
Cadworx Structure 2020 R2 SP1 HF1                                 469 Enabled
CADWorx Bundle 2023 SP1 HF5                                       469 Enabled
Creative Cloud 6.3.0.207                                          469 Enabled
Navisworks Manage 2025.2                                          469 Enabled
Navisworks Coordination Issues Add-In 4.5.0.0                     469 Enabled
Pxx Simulator 3.0.122                                             469 Enabled
Autodesk CER 7.0.3                                                469 Enabled
AutoCAD Plant 3D 2025.1                                           469 Enabled
Navisworks Manage 2022.6                                          469 Enabled
Revit 2024 Update 2.2                                             469 Enabled
Filezilla 3.67.1                                                  469 Enabled
Fabrication MEP 2024                                              469 Enabled
Navisworks Freedom 2022.6                                         469 Enabled
Navisworks Freedom 2024.2                                         469 Enabled
Navisworks Freedom 2025.1                                         469 Enabled
Navisworks Exporters 2025                                         469 Enabled
Civil 3D 2025.1                                                   469 Enabled
AutoCAD MAP 3D 2025                                               469 Enabled
Solidworks 2024                                                   469 Enabled
3DS Max 2025                                                      469 Enabled
AutoCAD Electrical 2025.0.2                                       469 Enabled
Revit 2024.3                                                      469 Enabled
CADWorx Bundle 2024                                               469 Enabled
Cadworx Bundle 2024 HF1                                           469 Enabled
Cadworx Bundle 2024 OE                                            469 Enabled
Worx Plugins 2024                                                 469 Enabled
MEP 2024.0.2                                                      469 Enabled
Navisworks Manage 2025.3                                          469 Enabled
Civil 3D 2022.2.7                                                 469 Enabled
Civil 3D 2022.2.7 Object Enabler                                  469 Enabled
PV Elite 26                                                       469 Enabled
Cadworx 2024 HF2                                                  469 Enabled
ReCap Pro 2025.1                                                  469 Enabled
Firefox 131.0.3                                                   469 Enabled
GageView Thickness                                                469 Enabled
WinIGS 8                                                          469 Enabled
Revit 2025.3                                                      469 Enabled
AutoCAD 2024.1.6                                                  469 Enabled
Zoom Workplace                                                    469 Enabled
Phast 8.21                                                        469 Enabled
RealDWG 2024.1.6                                                  469 Enabled
Connection Client 24.1.1.12                                       469 Enabled
STAAD Foundation Advanced 2023 (23.0.1.128)                       469 Enabled
RAM Structural System 2024 (24.0.0.160)                           469 Enabled
Inspector 5.0                                                     469 Enabled
RAM Connection 2024 (24.0.2.41)                                   469 Enabled
iTwin Analytical Synchronizer 2023 (23.1.9.31)                    469 Enabled
RAM Elements 2024 (24.0.2.40)                                     469 Enabled
AutoCAD 2025.1.1                                                  469 Enabled
Navisworks Manage 2024 Update 3                                   469 Enabled
Autodesk Licensing Service                                        469 Enabled
OpenBuildings Designer                                            469 Enabled
Revit 2023.1.6                                                    469 Enabled
RealDWG 2025.1.1                                                  469 Enabled
Revit Content Catalog Extension 1.1.2.3                           469 Enabled
Notepad ++ v8.7.1                                                 469 Enabled
Dell Command | Update Universal App                               469 Enabled
ReCap Pro 2024.1.2                                                469 Enabled
ReCap Photo 2024.0.3                                              469 Enabled
Inventor (Pro) 2024.3.3                                           469 Enabled
Autodesk CER 7.1.1                                                469 Enabled
Inventor (Pro) 2025.2                                             469 Enabled
Inventor Interoperability 2025                                    469 Enabled
Navisworks Freedom 2024.3                                         469 Enabled
Navisworks Freedom 2025.3                                         469 Enabled
Inventor Nastran 2025                                             469 Enabled
Adobe Acrobat Reader                                              469 Enabled
Revit 2024.3.1                                                    469 Enabled
Civil 3D 2025.2                                                   469 Enabled
Autodesk CER 7.1.2                                                469 Enabled
Revit 2025.4                                                      469 Enabled
Inventor (Pro) 2025.2.1                                           469 Enabled
3DS Max 2024                                                      469 Enabled
GlobalProtect 6.2.3                                               469 Enabled
Identity Manager 1.15.0                                           469 Enabled
Desktop Connector                                                 469 Enabled
Navisworks Manage 2025.4                                          469 Enabled
ETAP 2024                                                         469 Enabled
Advance Steel 2025 Hotfix 2025.0.2                                469 Enabled
Advance Steel 2025 Object Enabler                                 469 Enabled
Cloudworx for AutoCAD 2024.1.1                                    469 Enabled
Caps 4.45                                                         469 Enabled
Egnyte Desktop                                                    469 Enabled
Paint.NET                                                         469 Enabled
Civil 3D 2025 Object Enabler                                      469 Enabled
Logi Options+                                                     469 Enabled
Civil 3D 2024.4.2                                                 469 Enabled
AutoCAD Mechaincal 2025                                           469 Enabled
Compress 8500                                                     469 Enabled
Inspect 8500                                                      469 Enabled
DBWorx                                                            469 Enabled
Issues Addin for Revit 2022 V7                                    469 Enabled
Issues Addin for Revit 2023 V7                                    469 Enabled
Vehicle Tracking 2025                                             469 Enabled
Global Protect                                                    469 Enabled


===== Packages =====


Name                                               DeploymentCount Status
----                                               --------------- ------
User State Migration Tool for Windows                          469 Enabled
Configuration Manager Client Package                           469 Enabled
Configuration Manager Client Piloting Package                  469 Enabled
STAAD Pro                                                      469 Enabled
Software Prerequisite Pack                                     469 Enabled
Microstation                                                   469 Enabled
PDF995                                                         469 Enabled
MathCAD                                                        469 Enabled
orajinit                                                       469 Enabled
AcSELerator Quickset                                           469 Enabled
09 - Praxair Bentley Prostructures V8i                         469 Enabled
Visual                                                         469 Enabled
I-Quest                                                        469 Enabled
I-Quest                                                        469 Enabled
Project Setup Wizard                                           469 Enabled
TK Solver                                                      469 Enabled
MCPC_NewForma_Install                                          469 Enabled
Windows10_Unattend_File                                        469 Enabled
AppRemoval                                                     469 Enabled
Dot Net Framework 3.5                                          469 Enabled
App Removal Script                                             469 Enabled
netfx35                                                        469 Enabled
MCPC_Newforma_Install                                          469 Enabled
Mimecast for outlook 7.10.1.133 (x64)                          469 Enabled
GlobalProtect                                                  469 Enabled
Global Protect x64 5.2.12                                      469 Enabled
474.30-quadro-rtx-desktop-notebook-win10-win11-64b             469 Enabled
MCPC_Nvidia Installation Package                               469 Enabled
Registry: TargetReleaseVersion + Info                          469 Enabled
Vis C++2015-2022 Redistx64                                     469 Enabled
Global Protect x64 6.1.2                                       469 Enabled
MCPC_Nvidia Installation Package                               469 Enabled
MCPC_Nvidia Installation Package                               469 Enabled
Adobe Acrobat DC                                               469 Enabled
Dell Command Update                                            469 Enabled
Microsoft 365 Apps for enterprise (ODT)                        469 Enabled
Vis C++2015-2022 Redistx64                                     469 Enabled
Google Chrome                                                  469 Enabled
Newforma 2023.3                                                469 Enabled
Newforma Project Center | OSD Package                          469 Enabled
Remove-Appx-AllUsers                                           469 Enabled
PSWindowsUpdate                                                469 Enabled
Creative Cloud                                                 469 Enabled
nvidia-test   
#>

Write-Host "`n===== Packages =====`n"
$packages | Format-Table -AutoSize
