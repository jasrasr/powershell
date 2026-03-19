# Revision : 1.2
# Description : Save a string list into an array-formatted PowerShell file, removing trailing comma on the last item, and append multiple foreach loop examples
# Author : Jason Lamb
# Created Date : 2025-07-23
# Modified Date : 2025-09-12

$datetime = Get-Date -Format "yyyyMMdd-HHmmss"
$outputPath = "$psexports\path-array-output-$datetime.ps1"

$textToArray = @'
Ryan.Alders@altronic-llc.com
John.Allen@altronic-llc.com
Stephanie.Allen@altronic-llc.com
David.Anderson@altronic-llc.com
Mark.Balent@altronic-llc.com
Jeffrey.Balent@altronic-llc.com
Stephen.Balluck@altronic-llc.com
Craig.Balluck@altronic-llc.com
Connor.Bankey@altronic-llc.com
David.Bell@altronic-llc.com
Tereso.Beltran@altronic-llc.com
Patrick.Bender@altronic-llc.com
Margaret.Bennett@altronic-llc.com
Tina.Benton@altronic-llc.com
Christopher.Biggs@altronic-llc.com
Sandra.Bindas@altronic-llc.com
Krystal.Braun@altronic-llc.com
Pamela.Brooks@altronic-llc.com
Keith.Brooks@altronic-llc.com
Richard.Bucci@altronic-llc.com
David.Bulkley@altronic-llc.com
Mandy.Butch@altronic-llc.com
Daniel.Cabuno@altronic-llc.com
Nicholas.Cabuno@altronic-llc.com
Michael.Calderone@altronic-llc.com
Joseph.Calwise@altronic-llc.com
Morgan.Campbell@altronic-llc.com
Tiffany.Clark@altronic-llc.com
Debra.Clark@altronic-llc.com
Ralph.Clark@altronic-llc.com
Michael.Colaneri@altronic-llc.com
Cody.Compton@altronic-llc.com
DeAndre.Cooperwood@altronic-llc.com
Davida.Davis@altronic-llc.com
Amanda.Dawson@altronic-llc.com
Mark.Dietz@altronic-llc.com
Matthew.Donham@altronic-llc.com
Diane.Downing@altronic-llc.com
Jessica.Drew@altronic-llc.com
John.Dyer@altronic-llc.com
Randy.Edenfield@altronic-llc.com
Michelle.Evans@altronic-llc.com
Buddy.Fares@altronic-llc.com
Dess.Fedele@altronic-llc.com
Andrew.Femia-Smith@altronic-llc.com
Alfred.Fingulin@altronic-llc.com
Kenneth.Fisher@altronic-llc.com
Diana.Fitzpatrick@altronic-llc.com
Katherine.Fleming@altronic-llc.com
Lashana.Ford@altronic-llc.com
Carol.Foutz@altronic-llc.com
Julie.Fridley@altronic-llc.com
Melissa.Fuentes@altronic-llc.com
Jean.Gaetano@altronic-llc.com
Anthony.Gallo@altronic-llc.com
Alyssa.Garrett@altronic-llc.com
Andrew.Gesicki@altronic-llc.com
Eric.Gilkinson@altronic-llc.com
Joshua.Gilmore@altronic-llc.com
Anusheel.Goswami@altronic-llc.com
Trevor.Gregory@altronic-llc.com
Gregg.Grubbs@altronic-llc.com
Tamala.Hacon@altronic-llc.com
Robert.Hanna@altronic-llc.com
Shanell.Heard@altronic-llc.com
James.Henson@altronic-llc.com
Lukas.Henson@altronic-llc.com
Melissa.Herdman@altronic-llc.com
Julie.Herdman@altronic-llc.com
Keith.Hineman@altronic-llc.com
Larry.Hlywa@altronic-llc.com
Amanda.Hoagland@altronic-llc.com
Anisha.Hobbs@altronic-llc.com
Olivia.Honthy@altronic-llc.com
Raymond.Hood@altronic-llc.com
Sheila.Horn@altronic-llc.com
Tracey.Horton@altronic-llc.com
Tracy.Horvatich@altronic-llc.com
David.Hutch@altronic-llc.com
Elysa.Jackson@altronic-llc.com
Michael.Jackson@altronic-llc.com
Shawn.James@altronic-llc.com
Alan.Kail@altronic-llc.com
Paul.Kalaitzian@altronic-llc.com
Wendy.Kelly@altronic-llc.com
Marc.Kindle@altronic-llc.com
Vicky.Kosec@altronic-llc.com
Joseph.Kowalik@altronic-llc.com
Frank.Krempasky@altronic-llc.com
Adam.Krieder@altronic-llc.com
Patrick.Krohn@altronic-llc.com
Steven.Landreth@altronic-llc.com
Mary.Leggett@altronic-llc.com
David.Lepley@altronic-llc.com
Garen.Levis@altronic-llc.com
Joseph.Luchisan@altronic-llc.com
David.Ludt@altronic-llc.com
DeAndre.Lurry@altronic-llc.com
Michael.Macovitz@altronic-llc.com
Nikki.Mannion@altronic-llc.com
Daniel.Marhulik@altronic-llc.com
David.Markovitch@altronic-llc.com
Shamara.Martin@altronic-llc.com
Rene.McCarthy@altronic-llc.com
Judith.McClain@altronic-llc.com
Joyce.McCray@altronic-llc.com
Alicia.McFall@altronic-llc.com
Paul.McHenry@altronic-llc.com
Gayle.Mendenhall@altronic-llc.com
Kristie.Merlo@altronic-llc.com
Lindsay.Merlo@altronic-llc.com
Mark.Miller@altronic-llc.com
Ludovit.Minjarik@altronic-llc.com
Brandon.Mirto@altronic-llc.com
Timothy.Moff@altronic-llc.com
Jonathan.Nance@altronic-llc.com
Debra.Neiferd@altronic-llc.com
Matthew.Nelson@altronic-llc.com
Joseph.Nenadich@altronic-llc.com
Caleb.O'Brien@altronic-llc.com
Paul.Olbrych@altronic-llc.com
Timothy.Oliver@altronic-llc.com
Femi.Olugbon@altronic-llc.com
Danielle.Opatich@altronic-llc.com
Trevor.Orr@altronic-llc.com
Victoria.Paridon@altronic-llc.com
Nicole.Pascarella@altronic-llc.com
Harnish.Patel@altronic-llc.com
Mark.Pemberton@altronic-llc.com
Ashlee.Pemberton@altronic-llc.com
Aaron.Phifer@altronic-llc.com
David.Phillips@altronic-llc.com
Samuel.Pierson@altronic-llc.com
Steven.Pirko@altronic-llc.com
Damon.Ponds@altronic-llc.com
Michael.Porter@altronic-llc.com
Rodney.Pugh@altronic-llc.com
David.Quillin@altronic-llc.com
William.Radwanski@altronic-llc.com
Daniel.Raiti@altronic-llc.com
Chandana.Ramisetty@altronic-llc.com
Jennifer.Ramsey@altronic-llc.com
Jackson.Ramsey@altronic-llc.com
Melanie.Rawson@altronic-llc.com
Adele.Riffle@altronic-llc.com
Beth.Rober@altronic-llc.com
Orlesia.Robinson@altronic-llc.com
Jared.Rohm@altronic-llc.com
Alexandra.Russell@altronic-llc.com
Jennifer.Sankey@altronic-llc.com
Andrew.Sarich@altronic-llc.com
Patricia.Scarnecchia@altronic-llc.com
Erica.Schlatter@altronic-llc.com
Crystal.Scott@altronic-llc.com
Kayla.Seifert@altronic-llc.com
Sarah.Shaffer@altronic-llc.com
Joan.Shonce@altronic-llc.com
Nicholas.Sirianni@altronic-llc.com
David.Smigle@altronic-llc.com
Charles.Smith@altronic-llc.com
Robert.Smrecansky@altronic-llc.com
Christine.Sparling@altronic-llc.com
Hailey.Sturtz@altronic-llc.com
Valerie.Sweeney@altronic-llc.com
Taylor.Sweitzer@altronic-llc.com
Ashley.Takat@altronic-llc.com
Thomas.Terhune@altronic-llc.com
Glenn.Terry@altronic-llc.com
Joseph.Thomas@altronic-llc.com
Matthew.Traina@altronic-llc.com
Chad.Tucker@altronic-llc.com
Lisa.Underwood@altronic-llc.com
Tammy.Vanderhoeven@altronic-llc.com
Brighid.Wagner@altronic-llc.com
Jerrod.Waldron@altronic-llc.com
Nicholas.Waldron@altronic-llc.com
Brenda.Walton@altronic-llc.com
Curtis.Ward@altronic-llc.com
Abigail.Warren@altronic-llc.com
Tim.Webster@altronic-llc.com
Thomas.Westbrook@altronic-llc.com
Sena.Wheelhouse@altronic-llc.com
Ray.White@altronic-llc.com
Brittanie.Willis@altronic-llc.com
William.Winans@altronic-llc.com
Sandra.Winans@altronic-llc.com
Ruth.Wissinger@altronic-llc.com
Roc.Worth@altronic-llc.com
Larry.Yarger@altronic-llc.com
Loretta.Yates@altronic-llc.com
Richard.Yohman@altronic-llc.com
Michael.Young@altronic-llc.com
Leo.Younkins@altronic-llc.com
'@ -split "`r?`n"

New-Item -ItemType File -Path $outputPath -Force | Out-Null

# Start array declaration
Add-Content -Path $outputPath -Value '$textToArray = @('

# Add each item to the array, no trailing comma on last
for ($i = 0; $i -lt $textToArray.Count; $i++) {
    $line = '    "' + $textToArray[$i] + '"'
    if ($i -lt ($textToArray.Count - 1)) {
        $line += ','
    }
    Add-Content -Path $outputPath -Value $line
}

# Close array
Add-Content -Path $outputPath -Value ')'
Add-Content -Path $outputPath -Value ''

# Append foreach loop #1
Add-Content -Path $outputPath -Value 'foreach ($item in $textToArray) {'
Add-Content -Path $outputPath -Value '    # Do something with $item'
Add-Content -Path $outputPath -Value '    Write-Host "Processing : $item"'
Add-Content -Path $outputPath -Value '}'
Add-Content -Path $outputPath -Value ''

Write-Host "Array output saved to : $outputPath" -ForegroundColor Green
code $outputPath
