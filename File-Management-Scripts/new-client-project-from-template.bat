:: Created by Jason Lamb
:: Middough IT Department
:: Updated 12/30/22
:: Edited 1/30/23 to reflect the 10.0 BIM folder changes
:: Edited 5/30/24 to add a 'created' file to the 'new project folder'
:: Edited 10/2/24 to add a 'created' file to new client folder, _Gen, _Stds, and subfolders

::Labels - where the program goes to after different actions
:: lblstart
:: lblnewclient
:: lblcreatenewclient
:: lblexistingclient
:: lblnewprojectname 132
:: lblecnewprojectname 167
:: lblcontecnewprojectname 169
:: lblcontecnewprojectname 182
:: lblsubfolderquestion 213
:: lblsubfolderquestionec 222
:: lblsubfoldercreate 231
:: lbluseitno 239
:: lblsubfoldercreateec 240
:: lblnewprojectnamesubfolder 268
:: lblnewprojectnamesubfolderec 303
:: lblnewprojectnamesubfolderecesf 317
:: lblstartend 331
:: lblstartover 339
:: lblend 361

@echo off
cls :: Clears screen
:: echo. = blank new line

set SAVESTAMP=%DATE:/=-%@%TIME::=-%
set SAVESTAMP=%SAVESTAMP: =%
set SAVESTAMP=%SAVESTAMP:,=.%
echo log file location: \\middough.local\corp\data\proj\!TEMPLATE\logs\robocopylog-%savestamp%.txt

echo.
echo . . . . . . . . . . . . . . . . . . . . . .
echo .                                         . 
echo . Create a new CLIENT or PROJECT or BOTH  .
echo .                                         .
echo . . . . . . . . . . . . . . . . . . . . . .
echo.

:: start by asking whether new client or not
:lblstart
echo.
echo START lblstart
echo.
set newclientname=
set newprojectname=
set existingclientname=
set ecnewprojectname=
set subfolder=
set subfolderec=
set newprojectnamesubfolder=
set newprojectnamesubfolderec=
set newprojectnamesubfolderec-esf=


choice /c yn /m "New Client? (DO NOT HIT ENTER)"
if %errorlevel% ==1 goto lblnewclient
if %errorlevel% ==2 goto lblexistingclient

:: ask for new client name
:lblnewclient
echo.
echo START lblnewclient
echo.
set /p newclientname= "New Client Name?"
echo.
echo New Client Name is: %newclientname%

if exist "\\middough.local\corp\data\proj\%newclientname%\" (
echo.
echo CLIENT ALREADY EXIST!
set "existingclientname=%newclientname%"
goto lblsubfolderquestion 

) else ( 

echo Client does not exist...
goto lblcreatenewclient

)
goto lblend

:lblcreatenewclient
echo.
echo START lblcreatenewclient
echo.
echo Creating Client folder...

robocopy "\\middough.local\corp\data\proj\!newclienttemplate\_Gen" "\\middough.local\corp\data\proj\%newclientname%\_Gen" /e /copyall /secfix /log+:"\\middough.local\corp\data\proj\!TEMPLATE\logs\robocopylog-%savestamp%.txt"
fsutil file createnew "\\middough.local\corp\data\proj\%newclientname%\created-%savestamp%.txt" 0
fsutil file createnew "\\middough.local\corp\data\proj\%newclientname%\_Gen\created-%savestamp%.txt" 0
robocopy "\\middough.local\corp\data\proj\!newclienttemplate\_Stds" "\\middough.local\corp\data\proj\%newclientname%\_Stds" /e /copyall /secfix /log+:"\\middough.local\corp\data\proj\!TEMPLATE\logs\robocopylog-%savestamp%.txt"
fsutil file createnew "\\middough.local\corp\data\proj\%newclientname%\_Stds\created-%savestamp%.txt" 0

echo.
echo ......................................
echo.
if exist "\\middough.local\corp\data\proj\%newclientname%\" (
echo Client folder %newclientname% created.
echo.
echo ......................................
echo.

goto lblsubfolderquestion
) else (
echo error creating folder in lblcreatenewclient
goto lblstartend
)

:: enter existing client name to for new project
:lblexistingclient
echo.
echo START lblexistingclient
echo.
set /p existingclientname= "Existing Client Name?"
echo Existing Client Name is: %existingclientname%

:: check for existing client folder
if exist "\\middough.local\corp\data\proj\%existingclientname%\" (
echo.
echo Client DOES exist.
::goto lblcontecnewprojectname
goto lblsubfolderquestionec
) else ( 
echo.
echo.
echo ......................................
echo.
echo Client Name Does NOT Exist...
echo.
echo ......................................
echo.

:: verify create new client
choice /c yn /m "Create Client %existingclientname%?"
if %errorlevel% ==1 goto lblcreatenewclient
if %errorlevel% ==2 echo lblstart 
)


:: new project name for new client
:lblnewprojectname
echo.
echo START lblnewprojectname
echo.
set /p newprojectname= "New Project Name?"

if exist "\\middough.local\corp\data\proj\%newclientname%\%newprojectname%\" (
echo.
echo Project already exists.
goto lblnewprojectname 
) else (
echo Project doesn't currently exist...
echo Creating Project folder...
robocopy "\\middough.local\corp\data\proj\!newprojecttemplate-BIM" "\\middough.local\corp\data\proj\%newclientname%\%newprojectname%" /e /copyall /secfix /log+:"\\middough.local\corp\data\proj\!TEMPLATE\logs\robocopylog-%savestamp%.txt"
fsutil file createnew "\\middough.local\corp\data\proj\%newclientname%\%newprojectname%\created-%savestamp%.txt" 0

if exist "\\middough.local\corp\data\proj\%newclientname%\%newprojectname%" (
echo.
echo ......................................
echo.
echo Client %newclientname% and Project %newprojectname% created.
echo.
echo ......................................
echo.

) else (
echo.
echo error creating folder in lblnewprojectname
goto lblstart
)
)

goto lblstartover



:: create new project for existing client
:lblecnewprojectname
echo.
echo START lblecnewprojectname
echo.
echo ===========================================
echo 1: create new project under existing client
echo 2: start with new client name
echo ===========================================
echo.
choice /c 12 /m "Choice?"
if %errorlevel% ==1 goto lblcontecnewprojectname
if %errorlevel% ==2 goto lblstartover

:lblcontecnewprojectname
echo.
echo START lblcontecnewprojectname
echo.
set /p ecnewprojectname= "Enter New Project Name for Client: %existingclientname% ? "

if exist "\\middough.local\corp\data\proj\%existingclientname%\%ecnewprojectname%\" (
echo Project already exists.

goto lblcontecnewprojectname 

) else (
echo Creating New Project...
robocopy "\\middough.local\corp\data\proj\!newprojecttemplate-BIM" "\\middough.local\corp\data\proj\%existingclientname%\%ecnewprojectname%" /e /copyall /secfix /secfix /log+:"\\middough.local\corp\data\proj\!TEMPLATE\logs\robocopylog-%savestamp%.txt"
fsutil file createnew "\\middough.local\corp\data\proj\%existingclientname%\%ecnewprojectname%\created-%savestamp%.txt" 0
echo ......................................
echo.
if exist "\\middough.local\corp\data\proj\%existingclientname%\%ecnewprojectname%" (
echo ......................................
echo.
echo %existingclientname%\%ecnewprojectname% created
echo.
echo ......................................
goto lblstartend
) else (
echo.
echo error creating folder in lblcontecnewprojectname
goto lblstartend

)
)

:lblsubfolderquestion
echo START lblsubfolderquestion
:: sub folder question for new client
choice /c yn /m "Create/Use a subfolder?"
if %errorlevel% ==1 goto lblsubfoldercreate
if %errorlevel% ==2 goto lblnewprojectname


:lblsubfolderquestionec
echo START lblsubfolderquestionec
:: sub folder question for existing client
choice /c yn /m "Create/Use a subfolder?"
if %errorlevel% ==1 goto lblsubfoldercreateec
if %errorlevel% ==2 goto lblecnewprojectname


:lblsubfoldercreate
:: sub folder for new client
echo START lblsubfoldercreate
set /p subfolder= "Enter Subfolder for Client: %newclientname%? "
mkdir "\\middough.local\corp\data\proj\%newclientname%\%subfolder%"
fsutil file createnew "\\middough.local\corp\data\proj\%newclientname%\%subfolder%\created-%savestamp%.txt" 0
goto :lblnewprojectnamesubfolder

:lbluseitno
:lblsubfoldercreateec
:: sub folder for existing client
echo START lblsubfoldercreateec
set /p subfolderec= "Enter Subfolder for Client: %existingclientname%? "
if exist "\\middough.local\corp\data\proj\%existingclientname%\%subfolderec%" (
echo %existingclientname%\%subfolderec% 
choice /c yn /m "That folder already exist, use it?"
if %errorlevel% ==1 goto lblnewprojectnamesubfolderecesf
if %errorlevel% ==2 goto lbluseitno
) else (
echo sub folder does not exist, creating now
mkdir "\\middough.local\corp\data\proj\%existingclientname%\%subfolderec%"
fsutil file createnew ""\\middough.local\corp\data\proj\%existingclientname%\%subfolderec%\created-%savestamp%.txt" 0
)
echo WTH
pause
goto :lblnewprojectnamesubfolderecesf


::lblsubfoldercreate-useit
:: use existing subfolder
:: mkdir "\\middough.local\corp\data\proj\%existingclientname%\%subfolderec%"
:: goto :lblnewprojectnamesubfolderecesf

:lblnewprojectnamesubfolder
:: new project name for new client within sub folder
echo.
echo START lblnewprojectnamesubfolder
echo.
set /p newprojectnamesubfolder= "New Project Name?"

::if exist "\\middough.local\corp\data\proj\%newclientname%\%subfolder%\%newprojectname%\" (
:: echo.
:: echo Project already exists.
:: goto lblnewprojectnamesubfolder 
:: ) else (
:: echo Project doesn't currently exist...
echo Creating Project folder...
echo client name: %newclientname%
echo sub folder: %subfolder%
echo project name: %newprojectnamesubfolder%
robocopy "\\middough.local\corp\data\proj\!newprojecttemplate-BIM" "\\middough.local\corp\data\proj\%newclientname%\%subfolder%\%newprojectnamesubfolder%" /e /copyall /secfix /log+:"\\middough.local\corp\data\proj\!TEMPLATE\logs\robocopylog-%savestamp%.txt"
fsutil file createnew "\\middough.local\corp\data\proj\%newclientname%\%subfolder%\%newprojectnamesubfolder%\created-%savestamp%.txt" 0

:: if exist "\\middough.local\corp\data\proj\%newclientname%\%subfolder%\%newprojectname%" (
:: echo.
:: echo ......................................
:: echo.
:: echo Client %newclientname%  with sub folder %subfolder% and Project %newprojectname% created.
:: echo.
:: echo ......................................
:: echo.

:: ) else (
:: echo.
:: echo error creating folder in lblnewprojectnamesubfolder
:: goto lblstart
:: )
:: )
goto lblstartend

:lblnewprojectnamesubfolderec
:: new project name for existing client within sub folder
echo.
echo START lblnewprojectnamesubfolderec
echo.
set /p newprojectnamesubfolderec= "New Project Name?"
echo Creating Project folder...
echo client name: %existingclientname%
echo sub folder: %subfolderec%
echo project name: %newprojectnamesubfolderec%
robocopy "\\middough.local\corp\data\proj\!newprojecttemplate-BIM" "\\middough.local\corp\data\proj\%existingclientname%\%subfolderec%\%newprojectnamesubfolderec%" /e /copyall /secfix /log+:"\\middough.local\corp\data\proj\!TEMPLATE\logs\robocopylog-%savestamp%.txt"
fsutil file createnew "\\middough.local\corp\data\proj\%existingclientname%\%subfolderec%\%newprojectnamesubfolderec%\created-%savestamp%.txt" 0
goto lblstartend


:lblnewprojectnamesubfolderecesf
:: new project name for existing client within existin sub folder
echo.
echo START lblnewprojectnamesubfolderecesf
echo.
set /p newprojectnamesubfolderec-esf= "New Project Name?"
echo Creating Project folder...
echo client name: %existingclientname%
echo sub folder: %subfolderec%
echo project name: %newprojectnamesubfolderec-esf%
robocopy "\\middough.local\corp\data\proj\!newprojecttemplate-BIM" "\\middough.local\corp\data\proj\%existingclientname%\%subfolderec%\%newprojectnamesubfolderec-esf%" /e /copyall /secfix /log+:"\\middough.local\corp\data\proj\!TEMPLATE\logs\robocopylog-%savestamp%.txt"
fsutil file createnew "\\middough.local\corp\data\proj\%existingclientname%\%subfolderec%\%newprojectnamesubfolderec-esf%\created-%savestamp%.txt" 0
goto lblstartend

:lblstartend
:: start again to the top?
choice /c yn /m "Start Again?"
if %errorlevel% ==1 goto lblstartover
if %errorlevel% ==2 goto lblend


:lblstartover
echo.
echo ~ ~ ~ START OVER ~ ~ ~
echo.
echo.
echo AND AGAIN...
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
goto lblstart

:: pause the screen at the end of all functions
:lblend
echo END - GOOD BYE!
pause

