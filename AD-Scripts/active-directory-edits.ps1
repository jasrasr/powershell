Import-Module activedirectory

set-aduser -identity larry.whiz -state yy
new-aduser 

New-ADUser -Name “Karim Buzdar" -GivenName Karim -Surname Buzdar -SamAccountName kbuzdar -UserPrincipalName kbuzdar@pel.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAl"

CN=Thomas Jefferson,OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL

New-ADUser -Name “James Madison" -GivenName James -Surname Madison -SamAccountName james.madison -UserPrincipalName james.madison@middough.com -path OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAl
#New-ADUser -Name “James Madison -GivenName James=-SurnameMadison=-SamAccountNameJames.Madison=-UserPrincipalNameJames.Madison@pel.com -path OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAl"
#New-ADUser -Name “James Madison -GivenName James=-Surname Madison=-SamAccountNameJames.Madison=-UserPrincipalNameJames.Madison@pel.com -path OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAl"
#New-ADUser -Name “James Madison -GivenName James=-Surname Madison=-SamAccountName James.Madison=-UserPrincipalName James.Madison@pel.com -path OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAl"
#New-ADUser -Name “James Madison" -GivenName James-Surname Madison-SamAccountName James.Madison-UserPrincipalName James.Madison@middough.com -path OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAl"
#New-ADUser -Name “James Madison" -GivenName James -Surname Madison -SamAccountName James.Madison-UserPrincipalName James.Madison@middough.com -path OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAl"
#New-ADUser -Name “James Madison" -GivenName James -Surname Madison -SamAccountName James.Madison -UserPrincipalName James.Madison@middough.com -path OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAl
New-ADUser -Name “James Madison" -GivenName James -Surname Madison -SamAccountName James.Madison -UserPrincipalName James.Madison@middough.com -path OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAl
New-ADUser -Name “James Madison" -GivenName James -Surname Madison -SamAccountName James.Madison -UserPrincipalName James.Madison@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAl"
New-ADUser -Name “James Madison" -GivenName James -Surname Madison -SamAccountName James.Madison -UserPrincipalName James.Madison@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"

get-aduser jason.lamb

New-ADUser -Name “James Monroe" -GivenName James -Surname Monroe -SamAccountName James.Monroe -UserPrincipalName James.Monroe@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "James Monroe" -enabled 1 -AccountPassword (Read-Host -AsSecureString "Account Password")
get-aduser james.monroe

New-ADUser -Name “John Q Adams" -GivenName John -Surname Q Adams -SamAccountName John.QAdams -UserPrincipalName John.QAdams@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "John Q Adams"
New-ADUser -Name “Andrew Jackson" -GivenName Andrew -Surname Jackson -SamAccountName Andrew.Jackson -UserPrincipalName Andrew.Jackson@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Andrew Jackson"
New-ADUser -Name “Martin Van Buren" -GivenName Martin -Surname Van Buren -SamAccountName Martin.VanBuren -UserPrincipalName Martin.VanBuren@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Martin Van Buren"
New-ADUser -Name “Williams Harrison" -GivenName Williams -Surname Harrison -SamAccountName Williams.Harrison -UserPrincipalName Williams.Harrison@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Williams Harrison"
New-ADUser -Name “John Tyler" -GivenName John -Surname Tyler -SamAccountName John.Tyler -UserPrincipalName John.Tyler@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "John Tyler"
New-ADUser -Name “James Polk" -GivenName James -Surname Polk -SamAccountName James.Polk -UserPrincipalName James.Polk@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "James Polk"
New-ADUser -Name “Zachery Taylor" -GivenName Zachery -Surname Taylor -SamAccountName Zachery.Taylor -UserPrincipalName Zachery.Taylor@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Zachery Taylor"
New-ADUser -Name “Millard Fillmore" -GivenName Millard -Surname Fillmore -SamAccountName Millard.Fillmore -UserPrincipalName Millard.Fillmore@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Millard Fillmore"
New-ADUser -Name “Franklin Pierce" -GivenName Franklin -Surname Pierce -SamAccountName Franklin.Pierce -UserPrincipalName Franklin.Pierce@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Franklin Pierce"
New-ADUser -Name “James Buchanan" -GivenName James -Surname Buchanan -SamAccountName James.Buchanan -UserPrincipalName James.Buchanan@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "James Buchanan"
New-ADUser -Name “Abraham Lincoln" -GivenName Abraham -Surname Lincoln -SamAccountName Abraham.Lincoln -UserPrincipalName Abraham.Lincoln@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Abraham Lincoln"
New-ADUser -Name “Andrew Johnson" -GivenName Andrew -Surname Johnson -SamAccountName Andrew.Johnson -UserPrincipalName Andrew.Johnson@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Andrew Johnson"
New-ADUser -Name “Ulysses Grant" -GivenName Ulysses -Surname Grant -SamAccountName Ulysses.Grant -UserPrincipalName Ulysses.Grant@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Ulysses Grant"
New-ADUser -Name “Rutherford Hayes" -GivenName Rutherford -Surname Hayes -SamAccountName Rutherford.Hayes -UserPrincipalName Rutherford.Hayes@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Rutherford Hayes"
New-ADUser -Name “James Garfield" -GivenName James -Surname Garfield -SamAccountName James.Garfield -UserPrincipalName James.Garfield@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "James Garfield"
New-ADUser -Name “Chester Arthur" -GivenName Chester -Surname Arthur -SamAccountName Chester.Arthur -UserPrincipalName Chester.Arthur@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Chester Arthur"
New-ADUser -Name “Grover Cleveland" -GivenName Grover -Surname Cleveland -SamAccountName Grover.Cleveland -UserPrincipalName Grover.Cleveland@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Grover Cleveland"
New-ADUser -Name “Benjamin Harrison" -GivenName Benjamin -Surname Harrison -SamAccountName Benjamin.Harrison -UserPrincipalName Benjamin.Harrison@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Benjamin Harrison"
New-ADUser -Name “William McKinley" -GivenName William -Surname McKinley -SamAccountName William.McKinley -UserPrincipalName William.McKinley@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "William McKinley"
New-ADUser -Name “Theodore Roosevelt" -GivenName Theodore -Surname Roosevelt -SamAccountName Theodore.Roosevelt -UserPrincipalName Theodore.Roosevelt@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Theodore Roosevelt"
New-ADUser -Name “William Taft" -GivenName William -Surname Taft -SamAccountName William.Taft -UserPrincipalName William.Taft@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "William Taft"
New-ADUser -Name “Woodrow Wilson" -GivenName Woodrow -Surname Wilson -SamAccountName Woodrow.Wilson -UserPrincipalName Woodrow.Wilson@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Woodrow Wilson"
New-ADUser -Name “Warren Harding" -GivenName Warren -Surname Harding -SamAccountName Warren.Harding -UserPrincipalName Warren.Harding@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Warren Harding"
New-ADUser -Name “Calvin Coolidge" -GivenName Calvin -Surname Coolidge -SamAccountName Calvin.Coolidge -UserPrincipalName Calvin.Coolidge@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Calvin Coolidge"
New-ADUser -Name “Herbert Hoover" -GivenName Herbert -Surname Hoover -SamAccountName Herbert.Hoover -UserPrincipalName Herbert.Hoover@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Herbert Hoover"
New-ADUser -Name “Franklin Roosevelt" -GivenName Franklin -Surname Roosevelt -SamAccountName Franklin.Roosevelt -UserPrincipalName Franklin.Roosevelt@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Franklin Roosevelt"
New-ADUser -Name “Harry Truman" -GivenName Harry -Surname Truman -SamAccountName Harry.Truman -UserPrincipalName Harry.Truman@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Harry Truman"
New-ADUser -Name “Dwight Eisenhower" -GivenName Dwight -Surname Eisenhower -SamAccountName Dwight.Eisenhower -UserPrincipalName Dwight.Eisenhower@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Dwight Eisenhower"
New-ADUser -Name “John Kennedy" -GivenName John -Surname Kennedy -SamAccountName John.Kennedy -UserPrincipalName John.Kennedy@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "John Kennedy"
New-ADUser -Name “Lyndon Johnson" -GivenName Lyndon -Surname Johnson -SamAccountName Lyndon.Johnson -UserPrincipalName Lyndon.Johnson@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Lyndon Johnson"
New-ADUser -Name “Richard Nixon" -GivenName Richard -Surname Nixon -SamAccountName Richard.Nixon -UserPrincipalName Richard.Nixon@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Richard Nixon"
New-ADUser -Name “Gerald Ford" -GivenName Gerald -Surname Ford -SamAccountName Gerald.Ford -UserPrincipalName Gerald.Ford@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Gerald Ford"
New-ADUser -Name “James Carter" -GivenName James -Surname Carter -SamAccountName James.Carter -UserPrincipalName James.Carter@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "James Carter"
New-ADUser -Name “Ronald Regan" -GivenName Ronald -Surname Regan -SamAccountName Ronald.Regan -UserPrincipalName Ronald.Regan@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Ronald Regan"
New-ADUser -Name “George H.W. Bush" -GivenName George -Surname HW Bush -SamAccountName George.HWBush -UserPrincipalName George.HWBush@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "George H.W. Bush"
New-ADUser -Name “Bill Clinton" -GivenName Bill -Surname Clinton -SamAccountName Bill.Clinton -UserPrincipalName Bill.Clinton@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Bill Clinton"
New-ADUser -Name “George W. Bush" -GivenName George -Surname W Bush -SamAccountName George.WBush -UserPrincipalName George.WBush@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "George W. Bush"
New-ADUser -Name “Barrack Obama" -GivenName Barrack -Surname Obama -SamAccountName Barrack.Obama -UserPrincipalName Barrack.Obama@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Barrack Obama"
New-ADUser -Name “Donald Trump" -GivenName Donald -Surname Trump -SamAccountName Donald.Trump -UserPrincipalName Donald.Trump@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Donald Trump"
New-ADUser -Name “Joe Biden" -GivenName Joe -Surname Biden -SamAccountName Joe.Biden -UserPrincipalName Joe.Biden@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Joe Biden"


New-ADUser -Name “John Q Adams" -GivenName "John" -Surname "Q Adams" -SamAccountName John.QAdams -UserPrincipalName John.QAdams@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "John Q Adams"
New-ADUser -Name “Martin Van Buren" -GivenName "Martin" -Surname "Van Buren" -SamAccountName Martin.VanBuren -UserPrincipalName Martin.VanBuren@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Martin Van Buren"
New-ADUser -Name “George H.W. Bush" -GivenName "George" -Surname "HW Bush" -SamAccountName George.HWBush -UserPrincipalName George.HWBush@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "George H.W. Bush"
New-ADUser -Name “George W. Bush" -GivenName "George" -Surname "W Bush" -SamAccountName George.WBush -UserPrincipalName George.WBush@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "George W. Bush"


===

set-aduser -identity George.Washington -state AL -country "United States" -initials GW -employeeid 8750 -office Chicago -Department 999.99
set-aduser -identity John.adams -state AK -country "United States" -initials JA -employeeid 2281 -office Madison -manager George.Washington -Department 999.99
set-aduser -identity Thomas.jefferson -state AZ -country "United States" -initials TJ -employeeid 1269 -office Merrilville -manager George.Washington -Department 999.99
set-aduser -identity James.Madison -state AR -country "United States" -initials JM -employeeid 8114 -office Merrilville -manager George.Washington -Department 999.99
set-aduser -identity James.Monroe -state AS -country "United States" -initials JM -employeeid 8765 -office Cleveland -manager George.Washington -Department 999.99
set-aduser -identity John.QAdams -state CA -country "United States" -initials JQ -employeeid 7286 -office Merrilville -manager John.adams -Department 999.99
set-aduser -identity Andrew.Jackson -state CO -country "United States" -initials AJ -employeeid 6909 -office Madison -manager John.adams -Department 999.99
set-aduser -identity Martin.VanBuren -state CT -country "United States" -initials MV -employeeid 3174 -office Pittsburgh -manager John.adams -Department 999.99
set-aduser -identity Williams.Harrison -state DE -country "United States" -initials WH -employeeid 3910 -office Chicago -manager John.adams -Department 999.99
set-aduser -identity John.Tyler -state DC -country "United States" -initials JT -employeeid 8837 -office Chicago -manager Thomas.jefferson -Department 999.99
set-aduser -identity James.Polk -state FL -country "United States" -initials JP -employeeid 8684 -office Ashland -manager Thomas.jefferson -Department 999.99
set-aduser -identity Zachery.Taylor -state GA -country "United States" -initials ZT -employeeid 5406 -office Buffalo -manager Thomas.jefferson -Department 999.99
set-aduser -identity Millard.Fillmore -state GU -country "United States" -initials MF -employeeid 2223 -office Ashland -manager Thomas.jefferson -Department 999.99
set-aduser -identity Franklin.Pierce -state HI -country "United States" -initials FP -employeeid 1716 -office Merrilville -manager James.Madison -Department 999.99
set-aduser -identity James.Buchanan -state ID -country "United States" -initials JB -employeeid 5933 -office Ashland -manager James.Madison -Department 999.99
set-aduser -identity Abraham.Lincoln -state IL -country "United States" -initials AL -employeeid 1399 -office Merrilville -manager James.Madison -Department 999.99
set-aduser -identity Andrew.Johnson -state IN -country "United States" -initials AJ -employeeid 2630 -office Cleveland -manager James.Madison -Department 999.99
set-aduser -identity Ulysses.Grant -state IA -country "United States" -initials UG -employeeid 5538 -office Toledo -manager James.Monroe -Department 999.99
set-aduser -identity Rutherford.Hayes -state KS -country "United States" -initials RH -employeeid 7893 -office Merrilville -manager James.Monroe -Department 999.99
set-aduser -identity James.Garfield -state KY -country "United States" -initials JG -employeeid 6475 -office Merrilville -manager James.Monroe -Department 999.99
set-aduser -identity Chester.Arthur -state LA -country "United States" -initials CA -employeeid 6305 -office Ashland -manager James.Monroe -Department 999.99
set-aduser -identity Grover.Cleveland -state ME -country "United States" -initials GC -employeeid 4586 -office Cleveland -manager John.QAdams -Department 999.99
set-aduser -identity Benjamin.Harrison -state MD -country "United States" -initials BH -employeeid 7030 -office Buffalo -manager John.QAdams -Department 999.99
set-aduser -identity William.McKinley -state MA -country "United States" -initials WM -employeeid 5515 -office Toledo -manager John.QAdams -Department 999.99
set-aduser -identity Theodore.Roosevelt -state MI -country "United States" -initials TR -employeeid 5127 -office Ashland -manager John.QAdams -Department 999.99
set-aduser -identity William.Taft -state MN -country "United States" -initials WT -employeeid 8197 -office Ashland -manager Andrew.Jackson -Department 999.99
set-aduser -identity Woodrow.Wilson -state MS -country "United States" -initials WW -employeeid 8187 -office Cleveland -manager Andrew.Jackson -Department 999.99
set-aduser -identity Warren.Harding -state MO -country "United States" -initials WH -employeeid 2281 -office Buffalo -manager Andrew.Jackson -Department 999.99
set-aduser -identity Calvin.Coolidge -state MT -country "United States" -initials CC -employeeid 2186 -office Pittsburgh -manager Andrew.Jackson -Department 999.99
set-aduser -identity Herbert.Hoover -state NE -country "United States" -initials HH -employeeid 6512 -office Buffalo -manager Martin.VanBuren -Department 999.99
set-aduser -identity Franklin.Roosevelt -state NV -country "United States" -initials FR -employeeid 8271 -office Buffalo -manager Martin.VanBuren -Department 999.99
set-aduser -identity Harry.Truman -state NH -country "United States" -initials HT -employeeid 2808 -office Cleveland -manager Martin.VanBuren -Department 999.99
set-aduser -identity Dwight.Eisenhower -state NJ -country "United States" -initials DE -employeeid 8424 -office Pittsburgh -manager Martin.VanBuren -Department 999.99
set-aduser -identity John.Kennedy -state NM -country "United States" -initials JK -employeeid 7471 -office Chicago -manager Williams.Harrison -Department 999.99
set-aduser -identity Lyndon.Johnson -state NY -country "United States" -initials LJ -employeeid 8471 -office Merrilville -manager Williams.Harrison -Department 999.99
set-aduser -identity Richard.Nixon -state NC -country "United States" -initials RN -employeeid 2768 -office Ashland -manager Williams.Harrison -Department 999.99
set-aduser -identity Gerald.Ford -state ND -country "United States" -initials GF -employeeid 6624 -office Pittsburgh -manager Williams.Harrison -Department 999.99
set-aduser -identity James.Carter -state OH -country "United States" -initials JC -employeeid 3318 -office Ashland -manager John.Tyler -Department 999.99
set-aduser -identity Ronald.Regan -state OK -country "United States" -initials RR -employeeid 3615 -office Chicago -manager John.Tyler -Department 999.99
set-aduser -identity George.HWBush -state OR -country "United States" -initials GH -employeeid 1719 -office Chicago -manager George.Washington -Department 999.99
set-aduser -identity Bill.Clinton -state PA -country "United States" -initials BC -employeeid 4001 -office Toledo -manager Ronald.Regan -Department 999.99
set-aduser -identity George.WBush -state PR -country "United States" -initials GW -employeeid 7880 -office Pittsburgh -manager George.HWBush -Department 999.99
set-aduser -identity Barrack.Obama -state RI -country "United States" -initials BO -employeeid 4600 -office Toledo -manager Donald.Trump -Department 999.99
set-aduser -identity Donald.Trump -state RI -country "United States" -initials DT -employeeid 2674 -office Toledo -manager George.WBush -Department 999.99
set-aduser -identity Joe.Biden -country "Mexico" -initials JB -employeeid 6580 -office Toledo -manager Barrack.Obama -Department 999.99 -title President


#set-aduser -identity George.HWBush -country "United States" -manager george.washington -department 888.88
#CN=Daniel O'Connor,OU=799,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL


set-aduser Greg.Rice -Replace @{c="US";co="United States";countrycode=840}
set-aduser Michael.Salow -Replace @{c="US";co="United States";countrycode=840}
set-aduser Kent.Flanery -Replace @{c="US";co="United States";countrycode=840}
set-aduser Mark.Cummings -Replace @{c="US";co="United States";countrycode=840}
set-aduser Isai.Delarca -Replace @{c="US";co="United States";countrycode=840}
set-aduser Paul.Tremonti -Replace @{c="US";co="United States";countrycode=840}
set-aduser Robert.Wellert -Replace @{c="US";co="United States";countrycode=840}
set-aduser Zach.Densmore -Replace @{c="US";co="United States";countrycode=840}
set-aduser Mike.Sparker -Replace @{c="US";co="United States";countrycode=840}
set-aduser Kevin.Moore -Replace @{c="US";co="United States";countrycode=840}



get-aduser greg.rice

New-ADUser -Name “Hannah Isabella" -GivenName "Hannah" -Surname "Isabella" -SamAccountName Hannah.Isabella -UserPrincipalName hannah.isabella@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Hannah Isabella"
set-aduser -identity Hannah.Isabella -initials JB -employeeid 6580 -office Toledo -manager Barrack.Obama -Department 999.99 -title President

set-aduser  -identity Sortispd -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Bob.Smering -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Weinhejr -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity DavidsRJ -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity MayareD -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity KuzmaJS -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Caitlyn.Sullivan -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Glenn.Bettens -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Buzz.Seydel -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Ed.Curtis -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Sansonac -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity RawsonBY -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Cindy.Smith -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Aslanigm -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Hlavacgm -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Kilbyjw -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Jim.Harrold -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Berdysjf -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Friedmm -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Kathy.Olle -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity SefcikKP -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Pienostm -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Voytkotl -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Kordahyk -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Mike.Pollino -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Hilenssr -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity ThompsCJ -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity YoungCS -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Slabyja -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Jackmawr -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Pricewf -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Adin.Mann -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity andrew.gallagher -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Andy.Minderman -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Torosiaa -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Jeff.Zunich -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Rossjw -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Lytlemp -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity AtkinsJD -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Jonathan.Yang -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Justin.Walters -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Bordonra -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Rothrj -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Krakovlj -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Saivem -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Matthew.Sands -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Micayla.Moldenke -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Cloyeswg -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Terrance.Scott -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Thomas.McKeown -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Wesley.McCurdy -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Urankaaj -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Bridgecj -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Chris.Soprano -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity BalchaDM -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Rogersja -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Mckenzrl -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Kil.Smith -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Tholete -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Althoumj -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Mike.Paulic -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity norm.jaworski -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity JankeyRW -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Avionne.Weaver -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Jeff.Hollinshead -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Lawrence.Amerson -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity AugisAV -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Palmerbj -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Daniel.Devadoss -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Darren.Gilbert -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Eric.Whittaker -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity PrudenGA -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity GlivarJJ -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Jason.Jamil -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Sebekjj -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Kasickjc -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Stephekt -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Lapponta -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Nathen.Stevenson -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Patricia.Krupp -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Yoergerw -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Weiganrk -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Cuculirj -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Sam.Bennett -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Steve.Maggiano -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity DiFranG -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Christina.Wagner -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Heather.Judson -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity YoungKE -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Melilllm -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity EuckerRE -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity DyeSL -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Hilbercr -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Ledinje -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity TodaroTA -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity jason.lamb -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Szalkomg -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Schmidrc -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity OconnoDP -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Ledinrr -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Chris.Moran -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity ReedEL -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Kory.Siverd -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Mike.Picardi -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Todd.Alfonso -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Meyersmj -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Keyta -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Riedeltw -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity CullerTL -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Bryan.Thomas -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Sextonte -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Khaterjm -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity David.Schmidt -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Frederjw -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Mayerkm -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Strosnrl -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity David.Hempfling -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Timothy.McDonald -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity MakinsAP -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Julian.CoutoCarter -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity LantinZL -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Allen.Beeler -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity curtis.beaudoin -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Doug.Quasny -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Dylan.McNamee -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Gise.VanBaren -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity GrelewJF -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Keith.Luttell -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity thomas.twardowski -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Mario.Hernandez -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Otto.Wenzel -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Elena.Graupera -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity James.Korba -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity John.Rotroff -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity rob.hattabaugh -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Chris.Muntz -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Curtis.Merow -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Lenny.Laird -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Prakash.Patel -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity elaine.molinengo -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity KlockoKL -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Bill.Celian -Replace @{c="US";co="United States";countrycode=840}
set-aduser  -identity Matt.Morgan -Replace @{c="US";co="United States";countrycode=840}

New-ADUser -Name “Jasono Lambo" -GivenName "Jasono" -Surname "Lambo" -SamAccountName Jasono.Lambo -UserPrincipalName Jasono.Lambo@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "Jasono.Lambo" -office "Cleveland" -state OH -initials JL  -manager Jason.Lamb -Department 740.01 -street "1901 East 13th Street" -city Cleveland -postalcode 44114 -title "IT Test" -Company Middough -officephone 216-555-1234 -email jasono.lambo@middough.com
Add-ADGroupMember -identity "O365 E3 Teams Audio Conf" -Members jasono.lambo
Add-ADGroupMember -identity "cle_740" -Members jasono.lambo
set-aduser  -identity jasono.lambo -Replace @{c="US";co="United States";countrycode=840}
Add-ADGroupMember -identity "engineering_dept" -Members jasono.lambo
Add-ADGroupMember -identity "cad applications" -Members jasono.lambo
Add-ADGroupMember -identity "CAD_User_Project_Level_4" -Members jasono.lambo



set-aduser -identity torosiaa -manager Cloyeswg
set-aduser -identity clougheg -manager Cloyeswg
set-aduser -identity rothrj -manager Cloyeswg
set-aduser -identity saivem -manager Cloyeswg
set-aduser -identity bordonra -manager Cloyeswg
set-aduser -identity krakovlj -manager Cloyeswg
set-aduser -identity rossjw -manager Cloyeswg
set-aduser -identity lytlemp -manager Cloyeswg
set-aduser -identity atkinsjd -manager Cloyeswg
set-aduser -identity rossjw -manager Cloyeswg





Get-ADUser -Filter * | Select sAMAccountName

Import-Csv C:\temp\scripts\inputfile.txt | ForEach { Get-ADUser -Filter "displayName -eq '$($_.displayName)'" -Properties Name, SamAccountName | Select Name,SamAccountName } | Export-CSV -path C:\temp\scripts\outputfile.csv -NoTypeInformation



===


set-aduser -identity Johnsora -manager Walterac -department "100.05 ASH Structural"
set-aduser -identity PutnamKA -manager FaulknAM -department "821.02 CHI Estimating"
set-aduser -identity Sebonimj -manager FaulknAM -department "821.02 CHI Estimating"
set-aduser -identity Radtkeke -manager FaulknAM -department "821.02 CHI Estimating"
set-aduser -identity Rookerva -manager FaulknAM -department "820.02 CHI Project Controls"
set-aduser -identity Cussenkg -manager Shkurtav -department "100.02 CHI Structural"
set-aduser -identity SmithMJ -manager Shkurtav -department "100.02 CHI Structural"
set-aduser -identity RyanCD -manager Shkurtav -department "100.02 CHI Structural"
set-aduser -identity Braunske -manager Shkurtav -department "100.02 CHI Structural"
set-aduser -identity Bridendj -manager Shkurtav -department "100.02 CHI Structural"
set-aduser -identity WraseJW -manager Shkurtav -department "100.02 CHI Structural"
set-aduser -identity Jackmawr -manager Sansonac -department "125.01 CLE Asset Integrity"
set-aduser -identity Cloyeswg -manager Sansonac -department "400.01 CLE Mechanical"
set-aduser -identity Mckenzrl -manager Sansonac -department "425.01 CLE Piping"
set-aduser -identity Hoppelcl -manager Sansonac -department "100.01 CLE Structural"
set-aduser -identity Kilbyjw -manager Sansonac -department "100.01 CLE Structural"
set-aduser -identity Berdysjf -manager Sansonac -department "100.01 CLE Structural"
set-aduser -identity Hlavacgm -manager Sansonac -department "100.01 CLE Structural"
set-aduser -identity SefcikKP -manager Sansonac -department "100.01 CLE Structural"
set-aduser -identity Kordahyk -manager Sansonac -department "100.01 CLE Structural"
set-aduser -identity RawsonBY -manager Sansonac -department "100.01 CLE Structural"
set-aduser -identity Hilenssr -manager Sansonac -department "100.01 CLE Structural"
set-aduser -identity Pienostm -manager Sansonac -department "100.01 CLE Structural"
set-aduser -identity Friedmm -manager Sansonac -department "100.01 CLE Structural"
set-aduser -identity Voytkotl -manager Sansonac -department "100.01 CLE Structural"
set-aduser -identity Mcleanmc -manager Geresbc -department "800.02 CHI PMs"
set-aduser -identity Sortispd -manager Bob.Necciai -department "400.06 BUF Mechanical"
set-aduser -identity Weinhejr -manager Bob.Necciai -department "899.06 BUF SMMs"
set-aduser -identity Khaterjm -manager Bob.Necciai -department "899.01 CLE SMMs"
set-aduser -identity Sansonac -manager Bob.Necciai -department "100.01 CLE Structural"
set-aduser -identity Frederjw -manager Bob.Necciai -department "900.01 CLE SPM"
set-aduser -identity Strosnrl -manager Bob.Necciai -department "900.01 CLE SPM"
set-aduser -identity Mayerkm -manager Bob.Necciai -department "900.01 CLE SPM"
set-aduser -identity PiperCR -manager Bob.Necciai -department "899.27 PIT SMMs"
set-aduser -identity Newmankj -manager Lenharbd -department "800.03 TOL PMs"
set-aduser -identity Carnsjj -manager Lenharbd -department "800.03 TOL PMs"
set-aduser -identity SmithBM -manager Lenharbd -department "800.03 TOL PMs"
set-aduser -identity Andersla -manager Lenharbd -department "800.03 TOL PMs"
set-aduser -identity Kasickjc -manager KruppBE -department "600.01 CLE Electrical"
set-aduser -identity Stephekt -manager KruppBE -department "600.01 CLE Electrical"
set-aduser -identity Weiganrk -manager KruppBE -department "600.01 CLE Electrical"
set-aduser -identity Cuculirj -manager KruppBE -department "600.01 CLE Electrical"
set-aduser -identity SosterBM -manager KruppBE -department "600.01 CLE Electrical"
set-aduser -identity Palmerbj -manager KruppBE -department "600.01 CLE Electrical"
set-aduser -identity AugisAV -manager KruppBE -department "600.01 CLE Electrical"
set-aduser -identity PrudenGA -manager KruppBE -department "600.01 CLE Electrical"
set-aduser -identity Lapponta -manager KruppBE -department "600.01 CLE Electrical"
set-aduser -identity GlivarJJ -manager KruppBE -department "670.01 CLE Power"
set-aduser -identity Sebekjj -manager KruppBE -department "670.01 CLE Power"
set-aduser -identity Yoergerw -manager KruppBE -department "670.01 CLE Power"
set-aduser -identity StalteDE -manager KruppBE -department "670.01 CLE Power"
set-aduser -identity Gaertnmj -manager KruppBE -department "670.01 CLE Power"
set-aduser -identity DavidsRJ -manager TurneyBK -department "50.02 CHI Architectural"
set-aduser -identity Liuy -manager TurneyBK -department "650.02 CHI Controls"
set-aduser -identity Hurstdl -manager TurneyBK -department "400.02 CHI Mechanical"
set-aduser -identity HodepeTL -manager TurneyBK -department "350.02 CHI Process"
set-aduser -identity Shkurtav -manager TurneyBK -department "100.02 CHI Structural"
set-aduser -identity Salowma -manager Lowrydp -department "900.05 ASH SPM"
set-aduser -identity Hoggeml -manager Lowrydp -department "900.05 ASH SPM"
set-aduser -identity Flanertk -manager Lowrydp -department "900.05 ASH SPM"
set-aduser -identity Waltonjs -manager Lowrydp -department "425.03 TOL Piping"
set-aduser -identity Lenharbd -manager Lowrydp -department "900.03 TOL SPM"
set-aduser -identity Forresmd -manager Lowrydp -department "425.05 ASH Piping"
set-aduser -identity LantinZL -manager Lowrydp -department "100.08 IND Structural"
set-aduser -identity Dreiergp -manager Lowrydp -department "900.03 TOL SPM"
set-aduser -identity Winklekm -manager Lowrydp -department "900.03 TOL SPM"
set-aduser -identity Rabquewa -manager Lowrydp -department "900.03 TOL SPM"
set-aduser -identity Postacj -manager Lowrydp -department "900.03 TOL SPM"
set-aduser -identity GonzalED -manager Hurstdl -department "400.02 CHI Mechanical"
set-aduser -identity ScofieWH -manager Hurstdl -department "400.02 CHI Mechanical"
set-aduser -identity RoweGF -manager Hurstdl -department "400.02 CHI Mechanical"
set-aduser -identity Wickerth -manager GuptaDK -department "100.03 TOL Structural"
set-aduser -identity Stagerdj -manager GuptaDK -department "100.03 TOL Structural"
set-aduser -identity HitesZH -manager GuptaDK -department "100.03 TOL Structural"
set-aduser -identity Robertmd -manager GuptaDK -department "100.03 TOL Structural"
set-aduser -identity Granatpj -manager GuptaDK -department "100.03 TOL Structural"
set-aduser -identity Pondca -manager GuptaDK -department "100.03 TOL Structural"
set-aduser -identity Wheatmd -manager GuptaDK -department "100.03 TOL Structural"
set-aduser -identity Vidrare -manager GuptaDK -department "100.03 TOL Structural"
set-aduser -identity WanamaPM -manager Mjoenge -department "100.06 BUF Structural"
set-aduser -identity GoodJP -manager Mjoenge -department "100.06 BUF Structural"
set-aduser -identity Palmertp -manager Mjoenge -department "100.06 BUF Structural"
set-aduser -identity CarneySP -manager Greg.Pertle -department "800.02 CHI PMs"
set-aduser -identity Sinhask -manager Jalpan.Soni -department "600.02 CHI Electrical"
set-aduser -identity OlsonGA -manager Jalpan.Soni -department "600.02 CHI Electrical"
set-aduser -identity Nashad -manager Adamsjk -department "400.06 BUF Mechanical"
set-aduser -identity Failindj -manager Adamsjk -department "400.06 BUF Mechanical"
set-aduser -identity WeinheSG -manager Adamsjk -department "400.06 BUF Mechanical"
set-aduser -identity Sulzbamd -manager Adamsjk -department "400.06 BUF Mechanical"
set-aduser -identity Gibbsdr -manager Adamsjk -department "400.06 BUF Mechanical"
set-aduser -identity JaraczJP -manager Weinhejr -department "800.06 BUF PMs"
set-aduser -identity GawronRT -manager Weinhejr -department "800.06 BUF PMs"
set-aduser -identity WinterWF -manager KuzmaJS -department "425.02 CHI Piping"
set-aduser -identity MayareD -manager KuzmaJS -department "425.02 CHI Piping"
set-aduser -identity Gary.Stamper -manager KuzmaJS -department "425.02 CHI Piping"
set-aduser -identity Pazdanjw -manager KuzmaJS -department "425.02 CHI Piping"
set-aduser -identity Fishertl -manager Waltonjs -department "810.03 TOL Document Controls"
set-aduser -identity Sweenejw -manager Waltonjs -department "600.03 TOL Electrical"
set-aduser -identity Schrinmj -manager Waltonjs -department "425.03 TOL Piping"
set-aduser -identity Mclaugma -manager Waltonjs -department "820.03 TOL Project Controls"
set-aduser -identity GuptaDK -manager Waltonjs -department "100.03 TOL Structural"
set-aduser -identity Garetymw -manager Sweenejw -department "600.03 TOL Electrical"
set-aduser -identity Mitchekd -manager Sweenejw -department "600.03 TOL Electrical"
set-aduser -identity pendleet -manager Sweenejw -department "600.03 TOL Electrical"
set-aduser -identity Keyta -manager Khaterjm -department "810.01 CLE Document Controls"
set-aduser -identity Meyersmj -manager Khaterjm -department "810.01 CLE Document Controls"
set-aduser -identity Sextonte -manager Khaterjm -department "890.01 CLE Health & Safety"
set-aduser -identity CullerTL -manager Khaterjm -department "840.01 CLE Procurement"
set-aduser -identity Riedeltw -manager Khaterjm -department "820.01 CLE Project Controls"
set-aduser -identity MullenMA -manager Khaterjm -department "899.01 CLE SMMs"
set-aduser -identity Luppesjk -manager Walterja -department "800.02 CHI PMs"
set-aduser -identity Bonerich -manager Walterja -department "800.02 CHI PMs"
set-aduser -identity ReedEL -manager Mayerkm -department "800.01 CLE PMs"
set-aduser -identity IschSR -manager Bealmk -department "425.06 BUF Piping"
set-aduser -identity davisjl -manager Matt.Wisniewski -department "650.03 TOL Controls"
set-aduser -identity Durkindp -manager Matt.Wisniewski -department "650.03 TOL Controls"
set-aduser -identity Koniectl -manager Matt.Wisniewski -department "650.03 TOL Controls"
set-aduser -identity Polcynam -manager Matt.Wisniewski -department "650.03 TOL Controls"
set-aduser -identity Lesleylr -manager Matt.Wisniewski -department "650.03 TOL Controls"
set-aduser -identity TaylorTR -manager Matt.Wisniewski -department "650.03 TOL Controls"
set-aduser -identity Millerne -manager Endersmd -department "650.05 ASH Controls"
set-aduser -identity Endersmd -manager Forresmd -department "650.05 ASH Controls"
set-aduser -identity PericD -manager Forresmd -department "600.05 ASH Electrical"
set-aduser -identity Bowlinpa -manager Forresmd -department "425.05 ASH Piping"
set-aduser -identity Darbyjd -manager Forresmd -department "425.05 ASH Piping"
set-aduser -identity HollanGA -manager Forresmd -department "425.05 ASH Piping"
set-aduser -identity MillerJK -manager Forresmd -department "425.05 ASH Piping"
set-aduser -identity Grubbkl -manager Forresmd -department "425.05 ASH Piping"
set-aduser -identity Flaughpl -manager Forresmd -department "425.05 ASH Piping"
set-aduser -identity Halljl -manager Forresmd -department "425.05 ASH Piping"
set-aduser -identity Steve.Caproni -manager Forresmd -department "425.05 ASH Piping"
set-aduser -identity Reganlm -manager Forresmd -department "810.05 ASH Project Services"
set-aduser -identity Walterac -manager Forresmd -department "100.05 ASH Structural"
set-aduser -identity Zapataem -manager Mclaugma -department "820.03 TOL Project Controls"
set-aduser -identity Gravesrm -manager Mclaugma -department "820.03 TOL Project Controls"
set-aduser -identity Devriejc -manager Mclaugma -department "820.03 TOL Project Controls"
set-aduser -identity Fonsecmj -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Thompsba -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Browngt -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Witzkerm -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Seibolgr -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity StolleNW -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity BrownTJ -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Troutbd -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity KeaneBM -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity TerryAM -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Feeneysm -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Hoyecl -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Warnecm -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Ziskonm -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Wilkinvp -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Reamerda -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Reinerjm -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity reynoltl -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Hammonmr -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity JimeneMJ -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Rectordj -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Peacerj -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Munjesr -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity PorterMR -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity BettinJ -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity RadtkeAJ -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Magrumlp -manager Schrinmj -department "425.03 TOL Piping"
set-aduser -identity Overhorj -manager Sortispd -department "600.06 BUF Electrical"
set-aduser -identity Adamsjk -manager Sortispd -department "400.06 BUF Mechanical"
set-aduser -identity Bealmk -manager Sortispd -department "425.06 BUF Piping"
set-aduser -identity Mjoenge -manager Sortispd -department "100.06 BUF Structural"
set-aduser -identity Joschtlc -manager WrightPJ -department "810.02 CHI Document Controls"
set-aduser -identity SilajSM -manager WrightPJ -department "840.02 CHI Procurement"
set-aduser -identity FaulknAM -manager WrightPJ -department "820.02 CHI Project Controls"
set-aduser -identity James.Rossi -manager WrightPJ -department "899.02 CHI SMMs"
set-aduser -identity Bogaersm -manager HayesRJ -department "880.02 CHI Quality Management"
set-aduser -identity Perlaaj -manager HayesRJ -department "930.02 CHI Business Development"
set-aduser -identity Walterja -manager HayesRJ -department "900.02 CHI SPM"
set-aduser -identity Foxrb -manager HayesRJ -department "899.02 CHI SMMs"
set-aduser -identity WrightPJ -manager HayesRJ -department "899.02 CHI SMMs"
set-aduser -identity Streitgj -manager HayesRJ -department "899.02 CHI SMMs"
set-aduser -identity Blackjl -manager HayesRJ -department "899.02 CHI SMMs"
set-aduser -identity Geresbc -manager HayesRJ -department "900.02 CHI SPM"
set-aduser -identity UttechMJ -manager HayesRJ -department "899.28 MAD SMMs"
set-aduser -identity TurneyBK -manager HayesRJ -department "100.02 CHI Structural"
set-aduser -identity BalchaDM -manager Mckenzrl -department "425.01 CLE Piping"
set-aduser -identity Urankaaj -manager Mckenzrl -department "425.01 CLE Piping"
set-aduser -identity Tholete -manager Mckenzrl -department "425.01 CLE Piping"
set-aduser -identity Bridgecj -manager Mckenzrl -department "425.01 CLE Piping"
set-aduser -identity Althoumj -manager Mckenzrl -department "425.01 CLE Piping"
set-aduser -identity JankeyRW -manager Mckenzrl -department "425.01 CLE Piping"
set-aduser -identity Rogersja -manager Mckenzrl -department "425.01 CLE Piping"
set-aduser -identity Jon.Beskin -manager DavidsRJ -department "50.02 CHI Architectural"
set-aduser -identity MastanEJ -manager DavidsRJ -department "50.02 CHI Architectural"
set-aduser -identity KeehnGA -manager DavidsRJ -department "50.01 CLE Architectural"
set-aduser -identity Tielldm -manager Fishertl -department "810.03 TOL Document Controls"
set-aduser -identity Mclauge -manager Fishertl -department "810.03 TOL Document Controls"
set-aduser -identity Waynepj -manager Fishertl -department "810.03 TOL Document Controls"
set-aduser -identity FryNL -manager Fishertl -department "810.03 TOL Document Controls"
set-aduser -identity WitzkeTR -manager Fishertl -department "810.03 TOL Document Controls"
set-aduser -identity Lowryma -manager Fishertl -department "810.03 TOL Document Controls"
set-aduser -identity cookke -manager Fishertl -department "810.03 TOL Document Controls"
set-aduser -identity Stahlcw -manager Fishertl -department "810.03 TOL Document Controls"
set-aduser -identity Chihakaa -manager HodepeTL -department "350.02 CHI Process"
set-aduser -identity Micheljf -manager HodepeTL -department "350.02 CHI Process"
set-aduser -identity GatsakAB -manager HodepeTL -department "350.02 CHI Process"
set-aduser -identity Olesicka -manager Dankoww -department "750.01 CLE Accounting"
set-aduser -identity YoungCS -manager Jackmawr -department "125.01 CLE Asset Integrity"
set-aduser -identity Pricewf -manager Jackmawr -department "125.01 CLE Asset Integrity"
set-aduser -identity Slabyja -manager Jackmawr -department "125.01 CLE Asset Integrity"
set-aduser -identity RedmonJM -manager Liuy -department "650.02 CHI Controls"
set-aduser -identity Ecksteha -manager Liuy -department "650.02 CHI Controls"
set-aduser -identity Walterdl -manager Liuy -department "650.02 CHI Controls"
set-aduser -identity Shogresc -manager Liuy -department "650.02 CHI Controls"
set-aduser -identity AldridBC -manager Liuy -department "650.02 CHI Controls"
set-aduser -identity GrelewJF -manager LantinZL -department "125.08 IND Asset Integrity"
set-aduser -identity GeorgeM -manager LantinZL -department "400.08 IND Mechanical"
set-aduser -identity BundeE -manager LantinZL -department "400.08 IND Mechanical"
set-aduser -identity DeakinJR -manager LantinZL -department "400.08 IND Mechanical"
set-aduser -identity SmarTJ -manager LantinZL -department "400.08 IND Mechanical"
set-aduser -identity ZatoWA -manager LantinZL -department "425.08 IND Piping"
set-aduser -identity MakinsAP -manager LantinZL -department "100.08 IND Structural"

---
titles
---

set-aduser -identity Johnsora -title "Specialist"
set-aduser -identity PutnamKA -title "Staff Estimator"
set-aduser -identity Sebonimj -title "Staff Specialist"
set-aduser -identity Radtkeke -title "Sr Estimator"
set-aduser -identity Rookerva -title "Cost Scheduler"
set-aduser -identity Cussenkg -title "Sr Engineer"
set-aduser -identity SmithMJ -title "Staff Engineer"
set-aduser -identity RyanCD -title "Engineer"
set-aduser -identity Braunske -title "Sr Engineer"
set-aduser -identity Bridendj -title "Sr Designer"
set-aduser -identity WraseJW -title "Sr Engineer"
set-aduser -identity Jackmawr -title "Discipline Manager"
set-aduser -identity Cloyeswg -title "Discipline Manager"
set-aduser -identity Mckenzrl -title "Discipline Manager"
set-aduser -identity Hoppelcl -title "Sr Staff Engineer"
set-aduser -identity Kilbyjw -title "Project Engineer"
set-aduser -identity Berdysjf -title "Project Engineer"
set-aduser -identity Hlavacgm -title "Sr Engineer"
set-aduser -identity SefcikKP -title "Sr Engineer"
set-aduser -identity Kordahyk -title "Sr Engineer"
set-aduser -identity RawsonBY -title "Sr Designer"
set-aduser -identity Hilenssr -title "Sr Designer"
set-aduser -identity Pienostm -title "Sr Engineer"
set-aduser -identity Friedmm -title "Sr Engineer"
set-aduser -identity Voytkotl -title "Staff Engineer"
set-aduser -identity Mcleanmc -title "Project Manager"
set-aduser -identity Sortispd -title "Director"
set-aduser -identity Weinhejr -title "Director"
set-aduser -identity Khaterjm -title "Director"
set-aduser -identity Sansonac -title "Director"
set-aduser -identity Frederjw -title "Sr Project Manager"
set-aduser -identity Strosnrl -title "Sr Project Manager"
set-aduser -identity Mayerkm -title "Sr Project Manager"
set-aduser -identity PiperCR -title "Director"
set-aduser -identity Newmankj -title "Project Manager"
set-aduser -identity Carnsjj -title "Project Manager"
set-aduser -identity SmithBM -title "Project Manager"
set-aduser -identity Andersla -title "Project Manager"
set-aduser -identity Kasickjc -title "Sr Engineer"
set-aduser -identity Stephekt -title "Sr Specialist"
set-aduser -identity Weiganrk -title "Sr Designer"
set-aduser -identity Cuculirj -title "Sr Engineer"
set-aduser -identity SosterBM -title "Sr Engineer"
set-aduser -identity Palmerbj -title "Designer"
set-aduser -identity AugisAV -title "Project Engineer"
set-aduser -identity PrudenGA -title "Sr Specialist"
set-aduser -identity Lapponta -title "Project Engineer"
set-aduser -identity GlivarJJ -title "Sr Engineer"
set-aduser -identity Sebekjj -title "Project Engineer"
set-aduser -identity Yoergerw -title "Sr Designer"
set-aduser -identity StalteDE -title "Sr Engineer"
set-aduser -identity Gaertnmj -title "Specialist"
set-aduser -identity DavidsRJ -title "Sr Discipline Manager"
set-aduser -identity Liuy -title "Discipline Manager"
set-aduser -identity Hurstdl -title "Sr Discipline Manager"
set-aduser -identity HodepeTL -title "Discipline Manager"
set-aduser -identity Shkurtav -title "Discipline Manager"
set-aduser -identity Salowma -title "Sr Project Manager"
set-aduser -identity Hoggeml -title "Sr Project Manager"
set-aduser -identity Flanertk -title "Sr Project Manager"
set-aduser -identity Waltonjs -title "Director"
set-aduser -identity Lenharbd -title "Director"
set-aduser -identity Forresmd -title "Sr Technical Manager"
set-aduser -identity LantinZL -title "Tech Manager"
set-aduser -identity Dreiergp -title "Sr Project Manager"
set-aduser -identity Winklekm -title "Sr Project Manager"
set-aduser -identity Rabquewa -title "Sr Project Manager"
set-aduser -identity Postacj -title "Sr Project Manager"
set-aduser -identity GonzalED -title "Sr Engineer"
set-aduser -identity ScofieWH -title "Sr Engineer"
set-aduser -identity RoweGF -title "Sr Engineer"
set-aduser -identity Wickerth -title "Sr Designer"
set-aduser -identity Stagerdj -title "Designer"
set-aduser -identity HitesZH -title "Engineer"
set-aduser -identity Robertmd -title "Specialist"
set-aduser -identity Granatpj -title "Sr Staff Engineer"
set-aduser -identity Pondca -title "Designer"
set-aduser -identity Wheatmd -title "Sr Designer"
set-aduser -identity Vidrare -title "Sr Designer"
set-aduser -identity WanamaPM -title "Engineer"
set-aduser -identity GoodJP -title "Sr Designer"
set-aduser -identity Palmertp -title "Specialist"
set-aduser -identity CarneySP -title "Project Manager"
set-aduser -identity Sinhask -title "Sr Engineer"
set-aduser -identity OlsonGA -title "Sr Engineer"
set-aduser -identity Nashad -title "Staff Engineer"
set-aduser -identity Failindj -title "Sr Designer"
set-aduser -identity WeinheSG -title "Engineer"
set-aduser -identity Sulzbamd -title "Sr Specialist"
set-aduser -identity Gibbsdr -title "Sr Designer"
set-aduser -identity JaraczJP -title "Project Manager"
set-aduser -identity GawronRT -title "Project Manager"
set-aduser -identity WinterWF -title "Sr Specialist"
set-aduser -identity MayareD -title "Sr Specialist"
set-aduser -identity Gary.Stamper -title "Sr Specialist"
set-aduser -identity Pazdanjw -title "Staff Specialist"
set-aduser -identity Fishertl -title "Discipline Manager"
set-aduser -identity Sweenejw -title "Sr Discipline Manager"
set-aduser -identity Schrinmj -title "Discipline Manager"
set-aduser -identity Mclaugma -title "Discipline Manager"
set-aduser -identity GuptaDK -title "Sr Discipline Manager"
set-aduser -identity Garetymw -title "Sr Specialist"
set-aduser -identity Mitchekd -title "Sr Engineer"
set-aduser -identity pendleet -title "Drafter"
set-aduser -identity Keyta -title "Project Assistant"
set-aduser -identity Meyersmj -title "Project Assistant"
set-aduser -identity Sextonte -title "Sr Discipline Manager"
set-aduser -identity CullerTL -title "Sr Procurement Agent"
set-aduser -identity Riedeltw -title "Discipline Manager"
set-aduser -identity MullenMA -title "Major Projects Manager"
set-aduser -identity Luppesjk -title "Project Manager"
set-aduser -identity Bonerich -title "Project Manager"
set-aduser -identity ReedEL -title "Project Manager"
set-aduser -identity IschSR -title "Sr Designer"
set-aduser -identity davisjl -title "Sr Engineer"
set-aduser -identity Durkindp -title "Sr Engineer"
set-aduser -identity Koniectl -title "Sr Specialist"
set-aduser -identity Polcynam -title "Sr Engineer"
set-aduser -identity Lesleylr -title "Sr Specialist"
set-aduser -identity TaylorTR -title "Sr Specialist"
set-aduser -identity Millerne -title "Designer"
set-aduser -identity Endersmd -title "Discipline Manager"
set-aduser -identity PericD -title "Specialist"
set-aduser -identity Bowlinpa -title "Sr Specialist"
set-aduser -identity Darbyjd -title "Sr Specialist"
set-aduser -identity HollanGA -title "Specialist"
set-aduser -identity MillerJK -title "Designer"
set-aduser -identity Grubbkl -title "Specialist"
set-aduser -identity Flaughpl -title "Specialist"
set-aduser -identity Halljl -title "Designer"
set-aduser -identity Steve.Caproni -title "Project Controls Coordinator I"
set-aduser -identity Reganlm -title "Project Assistant"
set-aduser -identity Walterac -title "Discipline Manager"
set-aduser -identity Zapataem -title "Project Controls Coordinator"
set-aduser -identity Gravesrm -title "Project Controls Coordinator"
set-aduser -identity Devriejc -title "Cost Scheduler"
set-aduser -identity Fonsecmj -title "Sr Specialist"
set-aduser -identity Thompsba -title "Sr Designer"
set-aduser -identity Browngt -title "Sr Engineer"
set-aduser -identity Witzkerm -title "Sr Engineer"
set-aduser -identity Seibolgr -title "Sr Designer"
set-aduser -identity StolleNW -title "Engineer"
set-aduser -identity BrownTJ -title "Engineer"
set-aduser -identity Troutbd -title "Sr Engineer"
set-aduser -identity KeaneBM -title "Engineer"
set-aduser -identity TerryAM -title "Engineer"
set-aduser -identity Feeneysm -title "Sr Engineer"
set-aduser -identity Hoyecl -title "Sr Designer"
set-aduser -identity Warnecm -title "Sr Engineer"
set-aduser -identity Ziskonm -title "Designer"
set-aduser -identity Wilkinvp -title "Sr Engineer"
set-aduser -identity Reamerda -title "Project Engineer"
set-aduser -identity Reinerjm -title "Sr Engineer"
set-aduser -identity reynoltl -title "Engineer"
set-aduser -identity Hammonmr -title "Sr Engineer"
set-aduser -identity JimeneMJ -title "Sr Engineer"
set-aduser -identity Rectordj -title "Sr Specialist"
set-aduser -identity Peacerj -title "Sr Designer"
set-aduser -identity Munjesr -title "Staff Engineer"
set-aduser -identity PorterMR -title "Designer"
set-aduser -identity BettinJ -title "Sr Designer"
set-aduser -identity RadtkeAJ -title "Designer"
set-aduser -identity Magrumlp -title "Sr Designer"
set-aduser -identity Overhorj -title "Specialist"
set-aduser -identity Adamsjk -title "Discipline Manager"
set-aduser -identity Bealmk -title "Discipline Manager"
set-aduser -identity Mjoenge -title "Sr Discipline Manager"
set-aduser -identity Joschtlc -title "Document Controls Specialist II"
set-aduser -identity SilajSM -title "Procurement Agent"
set-aduser -identity FaulknAM -title "Discipline Manager"
set-aduser -identity James.Rossi -title "Major Projects Manager"
set-aduser -identity Bogaersm -title "Director"
set-aduser -identity Perlaaj -title "Vice President"
set-aduser -identity Walterja -title "Director"
set-aduser -identity Foxrb -title "Sr Major Project Manager"
set-aduser -identity WrightPJ -title "Sr Major Project Manager"
set-aduser -identity Streitgj -title "Sr Major Project Manager"
set-aduser -identity Blackjl -title "Sr Major Project Manager"
set-aduser -identity Geresbc -title "Sr Project Manager"
set-aduser -identity UttechMJ -title "Director"
set-aduser -identity TurneyBK -title "Sr Technical Manager"
set-aduser -identity BalchaDM -title "Sr Designer"
set-aduser -identity Urankaaj -title "Sr Engineer"
set-aduser -identity Tholete -title "Sr Specialist"
set-aduser -identity Bridgecj -title "Project Engineer"
set-aduser -identity Althoumj -title "Staff Engineer"
set-aduser -identity JankeyRW -title "Sr Engineer"
set-aduser -identity Rogersja -title "Sr Specialist"
set-aduser -identity Jon.Beskin -title "Designer"
set-aduser -identity MastanEJ -title "Staff Architect"
set-aduser -identity KeehnGA -title "Specialist"
set-aduser -identity Tielldm -title "Project Assistant"
set-aduser -identity Mclauge -title "Document Controls Coordinator"
set-aduser -identity Waynepj -title "Project Assistant"
set-aduser -identity FryNL -title "Project Assistant"
set-aduser -identity WitzkeTR -title "Document Controls Coordinator"
set-aduser -identity Lowryma -title "Project Assistant"
set-aduser -identity cookke -title "Document Controls Coordinator"
set-aduser -identity Stahlcw -title "Document Controls Coordinator"
set-aduser -identity Chihakaa -title "Sr Engineer"
set-aduser -identity Micheljf -title "Staff Engineer"
set-aduser -identity GatsakAB -title "Engineer"
set-aduser -identity Olesicka -title "Accounting Generalist II"
set-aduser -identity YoungCS -title "Inspector"
set-aduser -identity Pricewf -title "Inspector"
set-aduser -identity Slabyja -title "Inspector"
set-aduser -identity RedmonJM -title "Sr Engineer"
set-aduser -identity Ecksteha -title "Sr Engineer"
set-aduser -identity Walterdl -title "Sr Specialist"
set-aduser -identity Shogresc -title "Sr Specialist"
set-aduser -identity AldridBC -title "Specialist"
set-aduser -identity GrelewJF -title "Sr Discipline Manager"
set-aduser -identity GeorgeM -title "Project Engineer"
set-aduser -identity BundeE -title "Sr Specialist"
set-aduser -identity DeakinJR -title "Engineer"
set-aduser -identity SmarTJ -title "Project Engineer"
set-aduser -identity ZatoWA -title "Sr Specialist"
set-aduser -identity MakinsAP -title "Sr Engineer"

===
title
==

set-aduser -identity Torosiaa -title "Staff Engineer"
set-aduser -identity Clougheg -title "Designer"
set-aduser -identity Rossjw -title "Project Engineer"
set-aduser -identity AtkinsJD -title "Sr Engineer"
set-aduser -identity Krakovlj -title "Specialist"
set-aduser -identity Saivem -title "Engineer"
set-aduser -identity Lytlemp -title "Sr Specialist"
set-aduser -identity Bordonra -title "Project Engineer"
set-aduser -identity Rothrj -title "Sr Specialist"
set-aduser -identity TodaroTA -title "IS Generalist II"
set-aduser -identity Hilbercr -title "Accounting Generalist I"
set-aduser -identity DyeSL -title ""
set-aduser -identity Melilllm -title ""
set-aduser -identity ShivelME -title "Marketing Manager II"
set-aduser -identity Jennifer.Valek -title "Accounting Specialist II"
set-aduser -identity Schmidrc -title "IT Generalist II"
set-aduser -identity Olschlre -title "IT Generalist II"
set-aduser -identity Payneke -title "Accounting Generalist I"
set-aduser -identity Leonarcm -title "Accounting Specialist II"
set-aduser -identity McMastKA -title "Accounting Generalist I"
set-aduser -identity Zdolshtl -title "Accounting Manager I"

---

set-aduser -identity Torosiaa -department "400.01 CLE Mechanical"
set-aduser -identity Clougheg -department "400.01 CLE Mechanical"
set-aduser -identity Rossjw -department "350.01 CLE Process"
set-aduser -identity AtkinsJD -department "400.01 CLE Mechanical"
set-aduser -identity Krakovlj -department "400.01 CLE Mechanical"
set-aduser -identity Saivem -department "400.01 CLE Mechanical"
set-aduser -identity Lytlemp -department "400.01 CLE Mechanical"
set-aduser -identity Bordonra -department "350.01 CLE Process"
set-aduser -identity Rothrj -department "400.01 CLE Mechanical"
set-aduser -identity TodaroTA -department "720.01 CLE MIS"
set-aduser -identity Hilbercr -department "720.01 CLE MIS"
set-aduser -identity DyeSL -department "710.01 CLE Human Resources"
set-aduser -identity Melilllm -department "710.01 CLE Human Resources"
set-aduser -identity ShivelME -department "760.01 CLE Marketing"
set-aduser -identity Jennifer.Valek -department "750.01 CLE Accounting"
set-aduser -identity Schmidrc -department "740.01 CLE Information Technology"
set-aduser -identity Olschlre -department "740.01 CLE Information Technology"
set-aduser -identity Payneke -department "750.01 CLE Accounting"
set-aduser -identity Leonarcm -department "750.01 CLE Accounting"
set-aduser -identity McMastKA -department "750.01 CLE Accounting"
set-aduser -identity Zdolshtl -department "750.01 CLE Accounting"
set-aduser -identity Kathleen.Anderson -department "750.01 CLE Accounting"
set-aduser -identity Chris.Puleo -department "750.01 CLE Accounting"
set-aduser -identity Anthony.Gigante -department "750.01 CLE Accounting"
set-aduser -identity Josh.Rice -department "750.01 CLE Accounting"
set-aduser -identity David.Hempfling -department "930.01 CLE Business Development"
set-aduser -identity Szalkomg -department "740.01 CLE Information Technology"
set-aduser -identity Ledinrr -department "799.01 CLE Corporate Directors"
set-aduser -identity OconnoDP -department "799.01 CLE Corporate Directors"
set-aduser -identity Bill.Celian -department "870.03 TOL Construction Management"
set-aduser -identity michael.ratcliff -department "870.27 PIT Construction Management"
set-aduser -identity Glenn.Bettens -department "870.02 CHI Construction Management"
set-aduser -identity LeugerRJ -department "870.02 CHI Construction Management"
set-aduser -identity Buzz.Seydel -department "870.02 CHI Construction Management"
set-aduser -identity Denise.SetteurSpurio -department "720.01 CLE MIS"
set-aduser -identity KuzmaJS -department "425.02 CHI Piping"
set-aduser -identity Jackie.Kolling -department "100.27 PIT Structural"
set-aduser -identity Tim.Saunders -department "100.06 BUF Structural"
set-aduser -identity victor.guerrero -department "425.02 CHI Piping"
set-aduser -identity Dom.Seriosa -department "425.02 CHI Piping"
set-aduser -identity Jimmy.Wood -department "425.02 CHI Piping"
set-aduser -identity Samantha.Sopher -department "650.27 PIT Instrumentation & Controls"
set-aduser -identity Nick.Trout -department "650.05 ASH Controls"
set-aduser -identity StarkCJ -department "425.03 TOL Piping"
set-aduser -identity WalterSM -department "425.03 TOL Piping"
set-aduser -identity Joe.Angeski -department "400.27 PIT Mechanical"
set-aduser -identity Tyler.Baird -department "50.01 CLE Architectural"
set-aduser -identity Bradley.Cearing -department "425.08 IND Piping"
set-aduser -identity rob.hattabaugh -department "900.08 IND SPMs"
set-aduser -identity Dankoww -department "750.01 CLE Accounting"
set-aduser -identity Ledinje -department "720.01 CLE MIS"
set-aduser -identity Blairtg -department "740.01 CLE Information Technology"
set-aduser -identity Rob.Tibbitts -department "780.01 CLE Legal"
set-aduser -identity StonemPJ -department "760.01 CLE Marketing"
set-aduser -identity HillMG -department "715.02 CHI Workforce Development"
set-aduser -identity Jeff.Hollinshead -department "475.01 CLE Automation"
set-aduser -identity Matt.Wisniewski -department "650.03 TOL Controls"
set-aduser -identity Micah.Karns -department "650.27 PIT Instrumentation & Controls"
set-aduser -identity craig.anderson -department "350.27 PIT Process"
set-aduser -identity Prakash.Patel -department "100.27 PIT Structural"
set-aduser -identity Jim.Grady -department "840.02 CHI Procurement"
set-aduser -identity DavisJM -department "650.02 CHI Controls"
set-aduser -identity Jim.Perry -department "600.27 PIT Electrical"
set-aduser -identity Tristan.Griffith -department "100.05 ASH Structural"
set-aduser -identity Darren.Gilbert -department "600.01 CLE Electrical"
set-aduser -identity Sam.Bennett -department "670.01 CLE Power"
set-aduser -identity Avionne.Weaver -department "475.01 CLE Automation"
set-aduser -identity Emmanuel.Paredes -department "50.02 CHI Architectural"
set-aduser -identity Justin.Otero -department "350.01 CLE Process"
set-aduser -identity Micayla.Moldenke -department "350.01 CLE Process"
set-aduser -identity Kevin.Bollinger -department "100.05 ASH Structural"
set-aduser -identity Nathen.Stevenson -department "600.01 CLE Electrical"
set-aduser -identity Molly.Green -department "100.27 PIT Structural"
set-aduser -identity Connor.Loughlin -department "400.02 CHI Mechanical"
set-aduser -identity Jackie.Luong -department "400.02 CHI Mechanical"
set-aduser -identity Jim.Irmis -department "600.02 CHI Electrical"
set-aduser -identity Jen.Smith -department "600.02 CHI Electrical"
set-aduser -identity Harold.Kropp -department "400.06 BUF Mechanical"
set-aduser -identity Kaleb.Myers -department "650.03 TOL Controls"
set-aduser -identity Christian.Kanfeld -department "650.03 TOL Controls"
set-aduser -identity Max.Martin -department "650.27 PIT Instrumentation & Controls"
set-aduser -identity Noah.Blain -department "650.05 ASH Controls"
set-aduser -identity Ashama.Babooram -department "425.05 ASH Piping"
set-aduser -identity Tanner.Drees -department "425.03 TOL Piping"
set-aduser -identity CookCC -department "425.03 TOL Piping"
set-aduser -identity Jason.Riehl -department "400.28 MAD Mechanical"
set-aduser -identity James.Probstfeld -department "100.28 MAD Structural"
set-aduser -identity Kendall.Welling -department "100.28 MAD Structural"
set-aduser -identity joseph.kalic -department "425.01 CLE Piping"
set-aduser -identity Janet.Honeywell -department "350.02 CHI Process"
set-aduser -identity Robert.Adamski -department "350.02 CHI Process"
set-aduser -identity Victor.Sibiga -department "350.02 CHI Process"
set-aduser -identity Brian.Mariska -department "350.02 CHI Process"
set-aduser -identity Julian.CoutoCarter -department "100.08 IND Structural"
set-aduser -identity Matthew.Sands -department "400.01 CLE Mechanical"
set-aduser -identity Wesley.McCurdy -department "400.01 CLE Mechanical"
set-aduser -identity Jonathan.Yang -department "400.01 CLE Mechanical"
set-aduser -identity Christina.Wagner -department "710.01 CLE Human Resources"
set-aduser -identity Caitlyn.Sullivan -department "710.02 CHI Human Resources"
set-aduser -identity Keith.Luttell -department "125.08 IND Asset Integrity"
set-aduser -identity Allen.Beeler -department "125.08 IND Asset Integrity"
set-aduser -identity Dylan.McNamee -department "125.08 IND Asset Integrity"
set-aduser -identity thomas.twardowski -department "125.08 IND Asset Integrity"
set-aduser -identity Doug.Quasny -department "125.08 IND Asset Integrity"
set-aduser -identity Gise.VanBaren -department "125.08 IND Asset Integrity"
set-aduser -identity Lawrence.Amerson -department "475.01 CLE Automation"
set-aduser -identity Sherkoh.Anz -department "600.03 TOL Electrical"
set-aduser -identity Justin.Viola -department "425.27 PIT Piping"
set-aduser -identity jason.lamb -department "740.01 CLE Information Technology"
set-aduser -identity Michael.Vargas -department "740.02 CHI Information Technology"
set-aduser -identity Greg.Pertle -department "900.02 CHI SPM"
set-aduser -identity Jackie.Morris -department "760.01 CLE Marketing"
set-aduser -identity Keyana.Williams -department "760.01 CLE Marketing"
set-aduser -identity Podhorrl -department "740.01 CLE Information Technology"
set-aduser -identity Wendelce -department "799.02 CHI Corporate Directors"
set-aduser -identity KlockoKL -department "810.03 TOL Document Controls"
set-aduser -identity elaine.molinengo -department "810.27 PIT Document Controls"
set-aduser -identity Laurie.Jones -department "820.02 CHI Project Controls"
set-aduser -identity Sam.Blood -department "820.27 PIT Project Controls"
set-aduser -identity Yvonne.Hunter -department "820.02 CHI Project Controls"
set-aduser -identity Taryn.McCuan -department "820.02 CHI Project Controls"
set-aduser -identity Jeff.Zunich -department "400.01 CLE Mechanical"
set-aduser -identity Michael.Deinhammer -department "800.02 CHI PMs"
set-aduser -identity Francisco.Alvarez -department "800.06 BUF PMs"
set-aduser -identity Brad.Ingram -department "800.03 TOL PMs"
set-aduser -identity Gary.Row -department "800.03 TOL PMs"
set-aduser -identity Jeff.Fesko -department "800.27 PIT PMs"
set-aduser -identity Zach.Sadowski -department "800.27 PIT PMs"
set-aduser -identity Shawn.Rudy -department "800.27 PIT PMs"
set-aduser -identity Justin.Pistininzi -department "800.27 PIT PMs"
set-aduser -identity Chris.Moran -department "800.01 CLE PMs"
set-aduser -identity Quenton.Strickland -department "800.02 CHI PMs"
set-aduser -identity Mario.Hernandez -department "800.08 IND PMs"
set-aduser -identity Patrick.Keenan -department "800.06 BUF PMs"
set-aduser -identity Otto.Wenzel -department "800.08 IND PMs"
set-aduser -identity Kory.Siverd -department "800.01 CLE PMs"
set-aduser -identity Mike.Picardi -department "899.01 CLE SMMs"
set-aduser -identity BellTR -department "800.02 CHI PMs"
set-aduser -identity Todd.Alfonso -department "800.01 CLE PMs"
set-aduser -identity Greg.Rice -department "800.05 ASH PMs"
set-aduser -identity Nedrowj -department "820.03 TOL Project Controls"
set-aduser -identity James.Korba -department "900.08 IND SPMs"
set-aduser -identity Bryan.Thomas -department "890.01 CLE Health & Safety"
set-aduser -identity Cindy.Smith -department "100.01 CLE Structural"
set-aduser -identity John.Mickinkle -department "400.06 BUF Mechanical"
set-aduser -identity Mark.Santillana -department "425.02 CHI Piping"
set-aduser -identity Johnsoje -department "425.02 CHI Piping"
set-aduser -identity CostanJL -department "650.03 TOL Controls"
set-aduser -identity NortsTR -department "425.03 TOL Piping"
set-aduser -identity John.Hayes -department "425.03 TOL Piping"
set-aduser -identity Doug.Stieb -department "425.03 TOL Piping"
set-aduser -identity Justin.Walters -department "400.01 CLE Mechanical"
set-aduser -identity Matt.Bedee -department "50.01 CLE Architectural"
set-aduser -identity Samantha.Fox -department "930.27 PIT Business Development"
set-aduser -identity Matt.Morgan -department "870.03 TOL Construction Management"
set-aduser -identity Ed.Curtis -department "870.02 CHI Construction Management"
set-aduser -identity Dozier.Young -department "100.27 PIT Structural"
set-aduser -identity Igor.Moskalow -department "100.01 CLE Structural"
set-aduser -identity Kathy.Olle -department "100.01 CLE Structural"
set-aduser -identity ViancoME -department "670.01 CLE Power"
set-aduser -identity Chris.Muntz -department "100.27 PIT Structural"
set-aduser -identity Dane.Rasmussen -department "100.27 PIT Structural"
set-aduser -identity Shawn.Lichter -department "600.02 CHI Electrical"
set-aduser -identity Patricia.Krupp -department "475.01 CLE Automation"
set-aduser -identity Tom.Hoffman -department "425.02 CHI Piping"
set-aduser -identity Jim.Marshall -department "600.27 PIT Electrical"
set-aduser -identity Nathan.Ingram -department "600.27 PIT Electrical"
set-aduser -identity Greg.Furgala -department "425.06 BUF Piping"
set-aduser -identity Eric.Mizer -department "425.27 PIT Piping"
set-aduser -identity Michael.Sarver -department "425.27 PIT Piping"
set-aduser -identity norm.jaworski -department "425.01 CLE Piping"
set-aduser -identity Joe.Limon -department "650.02 CHI Controls"
set-aduser -identity KruppBE -department "600.01 CLE Electrical"
set-aduser -identity Ashwin.Patel -department "100.02 CHI Structural"
set-aduser -identity Li.Yan -department "100.02 CHI Structural"
set-aduser -identity Jim.Harrold -department "100.01 CLE Structural"
set-aduser -identity Josh.Ritchey -department "100.01 CLE Structural"
set-aduser -identity Wyatt.Suntala -department "100.01 CLE Structural"
set-aduser -identity Mike.Pollino -department "100.01 CLE Structural"
set-aduser -identity Dennis.Fundzak -department "600.01 CLE Electrical"
set-aduser -identity Daniel.Devadoss -department "600.01 CLE Electrical"
set-aduser -identity Eric.Whittaker -department "600.01 CLE Electrical"
set-aduser -identity Jason.Jamil -department "600.01 CLE Electrical"
set-aduser -identity Jalpan.Soni -department "600.02 CHI Electrical"
set-aduser -identity Lenny.Laird -department "100.27 PIT Structural"
set-aduser -identity Ashley.Langford -department "100.27 PIT Structural"
set-aduser -identity Dan.Heberer -department "400.02 CHI Mechanical"
set-aduser -identity Adam.Smith -department "100.06 BUF Structural"
set-aduser -identity Hans.Paal -department "600.27 PIT Electrical"
set-aduser -identity BihlJC -department "650.05 ASH Controls"
set-aduser -identity Kent.Mansfield -department "425.05 ASH Piping"
set-aduser -identity Nick.Doney -department "400.27 PIT Mechanical"
set-aduser -identity Alex.Dunaway -department "400.27 PIT Mechanical"
set-aduser -identity Wes.Stewart -department "400.27 PIT Mechanical"
set-aduser -identity Oscar.Crawford -department "350.02 CHI Process"
set-aduser -identity Roger.Hieser -department "350.02 CHI Process"
set-aduser -identity Andy.Minderman -department "400.01 CLE Mechanical"
set-aduser -identity Jack.Ziegler -department "350.01 CLE Process"
set-aduser -identity Adin.Mann -department "400.01 CLE Mechanical"
set-aduser -identity Thomas.McKeown -department "400.01 CLE Mechanical"
set-aduser -identity Wiszjl -department "740.02 CHI Information Technology"
set-aduser -identity Tony.Nuzzo -department "899.27 PIT SMMs"
set-aduser -identity Glen.Hoppe -department "350.02 CHI Process"
set-aduser -identity Marisha.Baldwin -department "820.02 CHI Project Controls"
set-aduser -identity Russ.Kosis -department "820.27 PIT Project Controls"
set-aduser -identity Bob.Smering -department "900.06 BUF SPM"
set-aduser -identity David.Schmidt -department "900.01 CLE SPM"
set-aduser -identity Kevin.Moore -department "900.27 PIT SPMs"
set-aduser -identity Joseph.Julian -department "900.27 PIT SPMs"
set-aduser -identity John.Rotroff -department "900.08 IND SPMs"
set-aduser -identity David.Woodnorth -department "900.02 CHI SPM"
set-aduser -identity Curtis.Merow -department "100.27 PIT Structural"
set-aduser -identity Roger.LeMond -department "400.02 CHI Mechanical"
set-aduser -identity Stephen.Wagner -department "425.02 CHI Piping"
set-aduser -identity Nestor.Hiso -department "425.02 CHI Piping"
set-aduser -identity Mike.Robinson -department "650.27 PIT Instrumentation & Controls"
set-aduser -identity Carmen.Carr -department "650.05 ASH Controls"
set-aduser -identity Camden.Olsen -department "425.27 PIT Piping"
set-aduser -identity Chris.Soprano -department "425.01 CLE Piping"
set-aduser -identity Mike.Paulic -department "425.01 CLE Piping"
set-aduser -identity Kenneth.Dudzik -department "425.08 IND Piping"
set-aduser -identity Bob.Wargo -department "400.27 PIT Mechanical"
set-aduser -identity WilsonCA -department "350.02 CHI Process"
set-aduser -identity Steve.Coons -department "400.02 CHI Mechanical"
set-aduser -identity Nitin.Mahajan -department "400.27 PIT Mechanical"
set-aduser -identity Wisniesp -department "740.03 TOL Information Technology"
set-aduser -identity Les.Ciciora -department "350.02 CHI Process"
set-aduser -identity Steve.Maggiano -department "600.01 CLE Electrical"
set-aduser -identity Nenet.Bautista -department "425.02 CHI Piping"
set-aduser -identity Chris.Hennessey -department "100.27 PIT Structural"
set-aduser -identity Thomas.Paprocki -department "650.02 CHI Controls"
set-aduser -identity ThompsCJ -department "125.01 CLE Asset Integrity"
set-aduser -identity Lowrydp -department "699.03 TOL Operations Mgmt"
set-aduser -identity YoungKE -department "710.01 CLE Human Resources"
set-aduser -identity Aslanigm -department "685.01 CLE Virtual Design"
set-aduser -identity HayesRJ -department "699.02 CHI Operations Mgmt"
set-aduser -identity Bob.Necciai -department "699.27 PIT Operations Mgmt"

---
mgr

---


set-aduser -identity David.Hempfling -manager Bob.Necciai
set-aduser -identity Ledinrr -manager Ledinrr
set-aduser -identity Bill.Celian -manager Waltonjs
set-aduser -identity michael.ratcliff -manager Nitin.Mahajan
set-aduser -identity Glenn.Bettens -manager WrightPJ
set-aduser -identity LeugerRJ -manager WrightPJ
set-aduser -identity Buzz.Seydel -manager WrightPJ
set-aduser -identity KuzmaJS -manager TurneyBK
set-aduser -identity Jackie.Kolling -manager Chris.Hennessey
set-aduser -identity Tim.Saunders -manager Mjoenge
set-aduser -identity victor.guerrero -manager KuzmaJS
set-aduser -identity Dom.Seriosa -manager KuzmaJS
set-aduser -identity Jimmy.Wood -manager KuzmaJS
set-aduser -identity Samantha.Sopher -manager Micah.Karns
set-aduser -identity Nick.Trout -manager Endersmd
set-aduser -identity StarkCJ -manager Schrinmj
set-aduser -identity WalterSM -manager Schrinmj
set-aduser -identity Joe.Angeski -manager Nitin.Mahajan
set-aduser -identity Tyler.Baird -manager DavidsRJ
set-aduser -identity Bradley.Cearing -manager LantinZL
set-aduser -identity rob.hattabaugh -manager Lowrydp
set-aduser -identity Jeff.Hollinshead -manager Sansonac
set-aduser -identity Matt.Wisniewski -manager Waltonjs
set-aduser -identity Micah.Karns -manager Nitin.Mahajan
set-aduser -identity craig.anderson -manager Nitin.Mahajan
set-aduser -identity Prakash.Patel -manager Nitin.Mahajan
set-aduser -identity Jim.Grady -manager WrightPJ
set-aduser -identity DavisJM -manager Liuy
set-aduser -identity Jim.Perry -manager Nitin.Mahajan
set-aduser -identity Tristan.Griffith -manager Walterac
set-aduser -identity Darren.Gilbert -manager KruppBE
set-aduser -identity Sam.Bennett -manager KruppBE
set-aduser -identity Avionne.Weaver -manager Jeff.Hollinshead
set-aduser -identity Emmanuel.Paredes -manager DavidsRJ
set-aduser -identity Kevin.Bollinger -manager Walterac
set-aduser -identity Nathen.Stevenson -manager KruppBE
set-aduser -identity Molly.Green -manager Chris.Hennessey
set-aduser -identity Connor.Loughlin -manager Hurstdl
set-aduser -identity Jackie.Luong -manager Hurstdl
set-aduser -identity Jim.Irmis -manager Jalpan.Soni
set-aduser -identity Jen.Smith -manager Jalpan.Soni
set-aduser -identity Harold.Kropp -manager Adamsjk
set-aduser -identity Kaleb.Myers -manager Matt.Wisniewski
set-aduser -identity Christian.Kanfeld -manager Matt.Wisniewski
set-aduser -identity Max.Martin -manager Micah.Karns
set-aduser -identity Noah.Blain -manager Endersmd
set-aduser -identity Ashama.Babooram -manager Forresmd
set-aduser -identity Tanner.Drees -manager Schrinmj
set-aduser -identity CookCC -manager Schrinmj
set-aduser -identity Jason.Riehl -manager UttechMJ
set-aduser -identity James.Probstfeld -manager UttechMJ
set-aduser -identity Kendall.Welling -manager UttechMJ
set-aduser -identity joseph.kalic -manager Mckenzrl
set-aduser -identity Janet.Honeywell -manager HodepeTL
set-aduser -identity Robert.Adamski -manager HodepeTL
set-aduser -identity Victor.Sibiga -manager HodepeTL
set-aduser -identity Brian.Mariska -manager HodepeTL
set-aduser -identity Julian.CoutoCarter -manager LantinZL
set-aduser -identity Christina.Wagner -manager YoungKE
set-aduser -identity Keith.Luttell -manager GrelewJF
set-aduser -identity Allen.Beeler -manager GrelewJF
set-aduser -identity Dylan.McNamee -manager GrelewJF
set-aduser -identity thomas.twardowski -manager GrelewJF
set-aduser -identity Doug.Quasny -manager GrelewJF
set-aduser -identity Gise.VanBaren -manager GrelewJF
set-aduser -identity Lawrence.Amerson -manager Jeff.Hollinshead
set-aduser -identity Sherkoh.Anz -manager Sweenejw
set-aduser -identity Justin.Viola -manager Nitin.Mahajan
set-aduser -identity Greg.Pertle -manager HayesRJ
set-aduser -identity KlockoKL -manager Fishertl
set-aduser -identity elaine.molinengo -manager Tony.Nuzzo
set-aduser -identity Laurie.Jones -manager FaulknAM
set-aduser -identity Sam.Blood -manager Tony.Nuzzo
set-aduser -identity Yvonne.Hunter -manager FaulknAM
set-aduser -identity Taryn.McCuan -manager FaulknAM
set-aduser -identity Michael.Deinhammer -manager Geresbc
set-aduser -identity Francisco.Alvarez -manager Bob.Smering
set-aduser -identity Brad.Ingram -manager Lenharbd
set-aduser -identity Gary.Row -manager Lenharbd
set-aduser -identity Jeff.Fesko -manager PiperCR
set-aduser -identity Zach.Sadowski -manager PiperCR
set-aduser -identity Shawn.Rudy -manager PiperCR
set-aduser -identity Justin.Pistininzi -manager PiperCR
set-aduser -identity Chris.Moran -manager David.Schmidt
set-aduser -identity Quenton.Strickland -manager David.Woodnorth
set-aduser -identity Mario.Hernandez -manager James.Korba
set-aduser -identity Patrick.Keenan -manager Weinhejr
set-aduser -identity Otto.Wenzel -manager John.Rotroff
set-aduser -identity Kory.Siverd -manager Khaterjm
set-aduser -identity Mike.Picardi -manager Khaterjm
set-aduser -identity BellTR -manager Walterja
set-aduser -identity Todd.Alfonso -manager Mayerkm
set-aduser -identity Greg.Rice -manager Hoggeml
set-aduser -identity Nedrowj -manager Mclaugma
set-aduser -identity James.Korba -manager Lowrydp
set-aduser -identity Bryan.Thomas -manager Sextonte
set-aduser -identity Cindy.Smith -manager Sansonac
set-aduser -identity John.Mickinkle -manager Adamsjk
set-aduser -identity Mark.Santillana -manager KuzmaJS
set-aduser -identity Johnsoje -manager KuzmaJS
set-aduser -identity CostanJL -manager Matt.Wisniewski
set-aduser -identity NortsTR -manager Schrinmj
set-aduser -identity John.Hayes -manager Schrinmj
set-aduser -identity Doug.Stieb -manager Schrinmj
set-aduser -identity Matt.Bedee -manager DavidsRJ
set-aduser -identity Samantha.Fox -manager Bob.Necciai
set-aduser -identity Matt.Morgan -manager Waltonjs
set-aduser -identity Ed.Curtis -manager HayesRJ
set-aduser -identity Dozier.Young -manager Chris.Hennessey
set-aduser -identity Igor.Moskalow -manager Sansonac
set-aduser -identity Kathy.Olle -manager Sansonac
set-aduser -identity ViancoME -manager KruppBE
set-aduser -identity Chris.Muntz -manager Chris.Hennessey
set-aduser -identity Dane.Rasmussen -manager Chris.Hennessey
set-aduser -identity Shawn.Lichter -manager Jalpan.Soni
set-aduser -identity Patricia.Krupp -manager Jeff.Hollinshead
set-aduser -identity Tom.Hoffman -manager KuzmaJS
set-aduser -identity Jim.Marshall -manager Jim.Perry
set-aduser -identity Nathan.Ingram -manager Jim.Perry
set-aduser -identity Greg.Furgala -manager Bealmk
set-aduser -identity Eric.Mizer -manager Nitin.Mahajan
set-aduser -identity Michael.Sarver -manager Nitin.Mahajan
set-aduser -identity norm.jaworski -manager Mckenzrl
set-aduser -identity Joe.Limon -manager Liuy
set-aduser -identity KruppBE -manager Sansonac
set-aduser -identity Ashwin.Patel -manager Shkurtav
set-aduser -identity Li.Yan -manager Shkurtav
set-aduser -identity Jim.Harrold -manager Sansonac
set-aduser -identity Josh.Ritchey -manager Sansonac
set-aduser -identity Wyatt.Suntala -manager Sansonac
set-aduser -identity Mike.Pollino -manager Sansonac
set-aduser -identity Dennis.Fundzak -manager KruppBE
set-aduser -identity Daniel.Devadoss -manager KruppBE
set-aduser -identity Eric.Whittaker -manager KruppBE
set-aduser -identity Jason.Jamil -manager KruppBE
set-aduser -identity Jalpan.Soni -manager TurneyBK
set-aduser -identity Lenny.Laird -manager Chris.Hennessey
set-aduser -identity Ashley.Langford -manager Chris.Hennessey
set-aduser -identity Dan.Heberer -manager Hurstdl
set-aduser -identity Adam.Smith -manager Mjoenge
set-aduser -identity Hans.Paal -manager Jim.Perry
set-aduser -identity BihlJC -manager Endersmd
set-aduser -identity Kent.Mansfield -manager Forresmd
set-aduser -identity Nick.Doney -manager Nitin.Mahajan
set-aduser -identity Alex.Dunaway -manager Nitin.Mahajan
set-aduser -identity Wes.Stewart -manager Nitin.Mahajan
set-aduser -identity Oscar.Crawford -manager HodepeTL
set-aduser -identity Roger.Hieser -manager HodepeTL
set-aduser -identity Tony.Nuzzo -manager Bob.Necciai
set-aduser -identity Glen.Hoppe -manager HodepeTL
set-aduser -identity Marisha.Baldwin -manager FaulknAM
set-aduser -identity Russ.Kosis -manager Nitin.Mahajan
set-aduser -identity Bob.Smering -manager Bob.Necciai
set-aduser -identity David.Schmidt -manager Bob.Necciai
set-aduser -identity Kevin.Moore -manager Bob.Necciai
set-aduser -identity Joseph.Julian -manager Bob.Necciai
set-aduser -identity John.Rotroff -manager Lowrydp
set-aduser -identity David.Woodnorth -manager HayesRJ
set-aduser -identity Curtis.Merow -manager Chris.Hennessey
set-aduser -identity Roger.LeMond -manager Hurstdl
set-aduser -identity Stephen.Wagner -manager KuzmaJS
set-aduser -identity Nestor.Hiso -manager KuzmaJS
set-aduser -identity Mike.Robinson -manager Micah.Karns
set-aduser -identity Carmen.Carr -manager Endersmd
set-aduser -identity Camden.Olsen -manager Nitin.Mahajan
set-aduser -identity Chris.Soprano -manager Mckenzrl
set-aduser -identity Mike.Paulic -manager Mckenzrl
set-aduser -identity Kenneth.Dudzik -manager LantinZL
set-aduser -identity Bob.Wargo -manager Nitin.Mahajan
set-aduser -identity WilsonCA -manager HodepeTL
set-aduser -identity Steve.Coons -manager Hurstdl
set-aduser -identity Nitin.Mahajan -manager Bob.Necciai
set-aduser -identity Les.Ciciora -manager HodepeTL
set-aduser -identity Steve.Maggiano -manager KruppBE
set-aduser -identity Nenet.Bautista -manager KuzmaJS
set-aduser -identity Chris.Hennessey -manager Nitin.Mahajan
set-aduser -identity Thomas.Paprocki -manager Liuy
set-aduser -identity ThompsCJ -manager Jackmawr

get-aduser bill.cloyes

set-aduser -identity jason.lamb -manager thomas.blair -department "740.01 CLE Information Technology" -office Cleveland -title "IT Manager"



===














set-aduser -identity jasono.lambo -manager michael.vargas -department "999.99 XXX Fun Dept" -office Detroit -title "IT Smarty Pants"


set-aduser -identity bob dole -manager george washington -department "dasdfsadf" -office asdfasdf -title "asdfasdf"





set-aduser -identity AAD_2667cee107c0 -department "999.98 Service Account"
set-aduser -identity ChicagoAC -department "999.98 Service Account"
set-aduser -identity ClevelandAC -department "999.98 Service Account"
set-aduser -identity Administrator -department "999.98 Service Account"
set-aduser -identity D365admin -department "999.98 Service Account"
set-aduser -identity EXCH_2013_ADMIN -department "999.98 Service Account"
set-aduser -identity CLE-AllPersonnel -department "999.98 Service Account"
set-aduser -identity ASHMgmt-Schedule -department "999.98 Service Account"
set-aduser -identity ASHRM-Conf10 -department "999.98 Service Account"
set-aduser -identity ASHRM-Conf11 -department "999.98 Service Account"
set-aduser -identity ASHRM-2-ConfRm2 -department "999.98 Service Account"
set-aduser -identity ASHRM-2-MainConfRm -department "999.98 Service Account"
set-aduser -identity ASHRM-3-ConfRm3 -department "999.98 Service Account"
set-aduser -identity AUVIK.ADMIN -department "999.98 Service Account"
set-aduser -identity BackAdmin -department "999.98 Service Account"
set-aduser -identity Barracuda -department "999.98 Service Account"
set-aduser -identity BASF650 -department "999.98 Service Account"
set-aduser -identity BUF-ConfRMWest -department "999.98 Service Account"
set-aduser -identity buf_viewsonic -department "999.98 Service Account"
set-aduser -identity CAS_379a1f30a6b94acc -department "999.98 Service Account"
set-aduser -identity CHI-Mgmt-Schedule -department "999.98 Service Account"
set-aduser -identity CHI-RM-2A-Main -department "999.98 Service Account"
set-aduser -identity CHI-RM-2B-NorthCent -department "999.98 Service Account"
set-aduser -identity CHI-RM-2C-NECtr -department "999.98 Service Account"
set-aduser -identity CHI-RM-2D-SouthEnd -department "999.98 Service Account"
set-aduser -identity CHI-RM-2E-NorthEnd -department "999.98 Service Account"
set-aduser -identity CHIRM-3A-TrainingCtr -department "999.98 Service Account"
set-aduser -identity CHI-MADSocial -department "999.98 Service Account"
set-aduser -identity ciscounity -department "999.98 Service Account"
set-aduser -identity CiscoASA -department "999.98 Service Account"
set-aduser -identity CiscoUM -department "999.98 Service Account"
set-aduser -identity CLE-ConferenceA1 -department "999.98 Service Account"
set-aduser -identity CLE-ConferenceA2 -department "999.98 Service Account"
set-aduser -identity CLE-ConferenceB1 -department "999.98 Service Account"
set-aduser -identity CLE-ConferenceB2 -department "999.98 Service Account"
set-aduser -identity CLE-ConferenceBoardR -department "999.98 Service Account"
set-aduser -identity CLE-ConferenceC1 -department "999.98 Service Account"
set-aduser -identity CLE-ConferenceC2 -department "999.98 Service Account"
set-aduser -identity CLE-ConferenceD1 -department "999.98 Service Account"
set-aduser -identity CLE-ConferenceD2 -department "999.98 Service Account"
set-aduser -identity CLE-ConferenceDevelo -department "999.98 Service Account"
set-aduser -identity CLE-ConferenceMain -department "999.98 Service Account"
set-aduser -identity CLEMgmt-Schedule -department "999.98 Service Account"
set-aduser -identity CLESocial -department "999.98 Service Account"
set-aduser -identity "Cleveland Garage Rec" -department "999.98 Service Account"
set-aduser -identity cluadmin -department "999.98 Service Account"
set-aduser -identity contactus -department "999.98 Service Account"
set-aduser -identity CopierLDAP -department "999.98 Service Account"
set-aduser -identity CORMgmt-Schedule -department "999.98 Service Account"
set-aduser -identity csmadmin -department "999.98 Service Account"
set-aduser -identity cwshr -department "999.98 Service Account"
set-aduser -identity cwsldap -department "999.98 Service Account"
set-aduser -identity cwsaccoutning -department "999.98 Service Account"
set-aduser -identity cwsemp -department "999.98 Service Account"
set-aduser -identity cwsit -department "999.98 Service Account"
set-aduser -identity cwslicense -department "999.98 Service Account"
set-aduser -identity cwsmarketing -department "999.98 Service Account"
set-aduser -identity cwsmgt -department "999.98 Service Account"
set-aduser -identity DHCPUser -department "999.98 Service Account"
set-aduser -identity SM_fd69bfe6c6984ca8b -department "999.98 Service Account"
set-aduser -identity EFI -department "999.98 Service Account"
set-aduser -identity EXCH_ENT_ADMIN -department "999.98 Service Account"
set-aduser -identity "$EUS000-1DENN9A7O2UR" -department "999.98 Service Account"
set-aduser -identity SM_d4dad2f06c604a869 -department "999.98 Service Account"
set-aduser -identity testfilters -department "999.98 Service Account"
set-aduser -identity Frame_svc -department "999.98 Service Account"
set-aduser -identity MiddoughGVM -department "999.98 Service Account"
set-aduser -identity GM-Schedule -department "999.98 Service Account"
set-aduser -identity Guest -department "999.98 Service Account"
set-aduser -identity HealthMailbox42923ab -department "999.98 Service Account"
set-aduser -identity HealthMailbox68adf93 -department "999.98 Service Account"
set-aduser -identity HealthMailbox8346c63 -department "999.98 Service Account"
set-aduser -identity HealthMailbox89c6a6e -department "999.98 Service Account"
set-aduser -identity HealthMailbox8a69ec0 -department "999.98 Service Account"
set-aduser -identity HealthMailboxad940d0 -department "999.98 Service Account"
set-aduser -identity HealthMailboxb09b595 -department "999.98 Service Account"
set-aduser -identity HealthMailboxb9f62af -department "999.98 Service Account"
set-aduser -identity HealthMailboxc7bf349 -department "999.98 Service Account"
set-aduser -identity HealthMailboxca69030 -department "999.98 Service Account"
set-aduser -identity HealthMailboxe7124da -department "999.98 Service Account"
set-aduser -identity HealthyByDesign -department "999.98 Service Account"
set-aduser -identity Help-Accounting -department "999.98 Service Account"
set-aduser -identity Help-AccountsPayable -department "999.98 Service Account"
set-aduser -identity Help-CAD -department "999.98 Service Account"
set-aduser -identity Help-CLEOffice -department "999.98 Service Account"
set-aduser -identity Help-EHS -department "999.98 Service Account"
set-aduser -identity Help-ExpenseReports -department "999.98 Service Account"
set-aduser -identity Help-HR -department "999.98 Service Account"
set-aduser -identity HELP-IT -department "999.98 Service Account"
set-aduser -identity Help-MAPP -department "999.98 Service Account"
set-aduser -identity Help-Marketing -department "999.98 Service Account"
set-aduser -identity Help-MIS -department "999.98 Service Account"
set-aduser -identity Help-Newforma -department "999.98 Service Account"
set-aduser -identity Help-PA -department "999.98 Service Account"
set-aduser -identity Help-Payroll -department "999.98 Service Account"
set-aduser -identity Help-PCA -department "999.98 Service Account"
set-aduser -identity Help-Quality -department "999.98 Service Account"
set-aduser -identity Help-Registrations -department "999.98 Service Account"
set-aduser -identity Help-TALENT -department "999.98 Service Account"
set-aduser -identity Help-Training -department "999.98 Service Account"
set-aduser -identity ISAADMIN -department "999.98 Service Account"
set-aduser -identity IUSR_ASHDC01 -department "999.98 Service Account"
set-aduser -identity IUSR_ATLDC01 -department "999.98 Service Account"
set-aduser -identity IUSR_BUFDC01 -department "999.98 Service Account"
set-aduser -identity IUSR_CLEFP01 -department "999.98 Service Account"
set-aduser -identity IUSR_CORDC01 -department "999.98 Service Account"
set-aduser -identity IUSR_DETDC01 -department "999.98 Service Account"
set-aduser -identity IUSR_HOUDC01 -department "999.98 Service Account"
set-aduser -identity IUSR_NWIDC01 -department "999.98 Service Account"
set-aduser -identity IUSR_PHLDC01 -department "999.98 Service Account"
set-aduser -identity IUSR_TOLDC01 -department "999.98 Service Account"
set-aduser -identity IWAM_ASHDC01 -department "999.98 Service Account"
set-aduser -identity IWAM_ATLDC01 -department "999.98 Service Account"
set-aduser -identity IWAM_BUFDC01 -department "999.98 Service Account"
set-aduser -identity IWAM_CLEFP01 -department "999.98 Service Account"
set-aduser -identity IWAM_CORDC01 -department "999.98 Service Account"
set-aduser -identity IWAM_DETDC01 -department "999.98 Service Account"
set-aduser -identity IWAM_HOUDC01 -department "999.98 Service Account"
set-aduser -identity IWAM_NWIDC01 -department "999.98 Service Account"
set-aduser -identity IWAM_PHLDC01 -department "999.98 Service Account"
set-aduser -identity IWAM_TOLDC01 -department "999.98 Service Account"
set-aduser -identity krbtgt -department "999.98 Service Account"
set-aduser -identity ldap -department "999.98 Service Account"
set-aduser -identity ldapuser -department "999.98 Service Account"
set-aduser -identity AllUsers -department "999.98 Service Account"
set-aduser -identity logosadmin -department "999.98 Service Account"
set-aduser -identity mailrestore -department "999.98 Service Account"
set-aduser -identity mcpc -department "999.98 Service Account"
set-aduser -identity TOL-DC -department "999.98 Service Account"
set-aduser -identity SM_91f987aa99254c5eb -department "999.98 Service Account"
set-aduser -identity movere_svc -department "999.98 Service Account"
set-aduser -identity MSOL_afb020929ed2 -department "999.98 Service Account"
set-aduser -identity testnet -department "999.98 Service Account"
set-aduser -identity netadmin -department "999.98 Service Account"
set-aduser -identity newforma -department "999.98 Service Account"
set-aduser -identity nwiscan -department "999.98 Service Account"
set-aduser -identity omdas -department "999.98 Service Account"
set-aduser -identity omaa -department "999.98 Service Account"
set-aduser -identity sqlsvc -department "999.98 Service Account"
set-aduser -identity OMC -department "999.98 Service Account"
set-aduser -identity Operations -department "999.98 Service Account"
set-aduser -identity PITSocial -department "999.98 Service Account"
set-aduser -identity Pix4D -department "999.98 Service Account"
set-aduser -identity ALT -department "999.98 Service Account"
set-aduser -identity SCAdmin -department "999.98 Service Account"
set-aduser -identity Scanner -department "999.98 Service Account"
set-aduser -identity SCCMADMIN -department "999.98 Service Account"
set-aduser -identity SCOMAdmin -department "999.98 Service Account"
set-aduser -identity stanley -department "999.98 Service Account"
set-aduser -identity tseq -department "999.98 Service Account"
set-aduser -identity pinnacleseries -department "999.98 Service Account"
set-aduser -identity AdskServer -department "999.98 Service Account"
set-aduser -identity LMServer -department "999.98 Service Account"
set-aduser -identity office365 -department "999.98 Service Account"
set-aduser -identity panuserid -department "999.98 Service Account"
set-aduser -identity wugadmin -department "999.98 Service Account"
set-aduser -identity scvmmservice -department "999.98 Service Account"
set-aduser -identity sftpuser -department "999.98 Service Account"
set-aduser -identity DeploymentShare -department "999.98 Service Account"
set-aduser -identity SharpLDAP -department "999.98 Service Account"
set-aduser -identity Software -department "999.98 Service Account"
set-aduser -identity SP_Admin -department "999.98 Service Account"
set-aduser -identity SP_SQL -department "999.98 Service Account"
set-aduser -identity SQL.BACKUP -department "999.98 Service Account"
set-aduser -identity SQLAdmin -department "999.98 Service Account"
set-aduser -identity ITA-SQLAdmin -department "999.98 Service Account"
set-aduser -identity SRV.MONITOR -department "999.98 Service Account"
set-aduser -identity SAVADMIN -department "999.98 Service Account"
set-aduser -identity SM_e98e65fb29a945a7b -department "999.98 Service Account"
set-aduser -identity SM_afab0ffd0d0c46869 -department "999.98 Service Account"
set-aduser -identity SM_3f7b817bc88d49558 -department "999.98 Service Account"
set-aduser -identity SM_f62c0ca7fc054bceb -department "999.98 Service Account"
set-aduser -identity SM_3be36b40d9ac4234b -department "999.98 Service Account"
set-aduser -identity SM_cdf4ce9b91074b748 -department "999.98 Service Account"
set-aduser -identity CiscoTest -department "999.98 Service Account"
set-aduser -identity sccmtest -department "999.98 Service Account"
set-aduser -identity testit -department "999.98 Service Account"
set-aduser -identity TOLMgmt-Schedule -department "999.98 Service Account"
set-aduser -identity TOL-RM-Focus-1 -department "999.98 Service Account"
set-aduser -identity TOL-RM-Focus-2 -department "999.98 Service Account"
set-aduser -identity TOL-RM-Conf1East -department "999.98 Service Account"
set-aduser -identity TOL-RM-Conf1Main -department "999.98 Service Account"
set-aduser -identity TOL-RM-Conf2East -department "999.98 Service Account"
set-aduser -identity TOL-RM-Conf2Main -department "999.98 Service Account"
set-aduser -identity Utility -department "999.98 Service Account"
set-aduser -identity wandynadmin -department "999.98 Service Account"
set-aduser -identity wirelessaccess -department "999.98 Service Account"
set-aduser -identity wiseguy -department "999.98 Service Account"
set-aduser -identity Won!Middough -department "999.98 Service Account"
set-aduser -identity WVD_svc -department "999.98 Service Account"
set-aduser -identity MicrostationJ -department "999.98 Service Account"
set-aduser -identity VMManager -department "999.98 Service Account"




get-aduser -Identity "$EUS000-1DENN9A7O2UR"


set-aduser -identity robert_davidson -department "050.01 CLE Architectural"
set-aduser -identity Ed.Matthews -department "100.27 PIT Structural"
set-aduser -identity curtis.beaudoin -department "125.08 IND Inspector"
set-aduser -identity andrew.gallagher -department "400.01 CLE Mechanical"
set-aduser -identity Terrance.Scott -department "400.01 CLE Mechanical"
set-aduser -identity peter.jug -department "400.02 CHI Mechanical"
set-aduser -identity Jerry.Kominek -department "400.03 TOL Mechanical"
set-aduser -identity NowelsNT -department "400.03 TOL Mechanical"
set-aduser -identity frankhds -department "400.03 TOL Mechanical"
set-aduser -identity VenegaKJ -department "400.05 ASH Mechanical"
set-aduser -identity Christopher.Walike -department "400.06 BUF Mechanical"
set-aduser -identity Kil.Smith -department "425.01 CLE Piping"
set-aduser -identity tyler.robbins -department "425.27 PIT Piping"
set-aduser -identity Jay.Veerasammy -department "600.01 CLE Electrical"
set-aduser -identity Jeff.Zimmerman -department "600.01 CLE Electrical"
set-aduser -identity DiFranG -department "699.01 CLE Overhead"
set-aduser -identity Heather.Judson -department "710.01 CLE Human Resources"
set-aduser -identity EuckerRE -department "710.01 CLE Marketing"
set-aduser -identity jill_ledin -department "720.01 CLE MIS"
set-aduser -identity jami.tondra -department "800.27 PIT PM"
set-aduser -identity simon.perez -department "800.28 MAD PM"
set-aduser -identity cathy.sullivan -department "810.02 CHI Document Control"
set-aduser -identity Elena.Graupera -department "810.08 IND Document Control"
set-aduser -identity patrick.conner -department "820.02 CHI Project Controls"
set-aduser -identity todd.chaney -department "820.05 ASH Project Controls"
set-aduser -identity ryan.byers -department "821.02 CHI Estimating"
set-aduser -identity bob_smering -department "900.06 BUF SPM"
set-aduser -identity Timothy.McDonald -department "930.01 CLE Business Development"
set-aduser -identity gary_mjoen -department "400.01 CLE Mechanical"


Add-ADGroupMember -identity "cle_740" -Members jasono.lambo

=== 12/21/22


Add-ADGroupMember -identity "IT Test Presidents" -Members George.Washington
Add-ADGroupMember -identity "IT Test Presidents" -Members John.adams
Add-ADGroupMember -identity "IT Test Presidents" -Members Thomas.jefferson
Add-ADGroupMember -identity "IT Test Presidents" -Members James.Madison
Add-ADGroupMember -identity "IT Test Presidents" -Members James.Monroe
Add-ADGroupMember -identity "IT Test Presidents" -Members John.QAdams
Add-ADGroupMember -identity "IT Test Presidents" -Members Andrew.Jackson
Add-ADGroupMember -identity "IT Test Presidents" -Members Martin.VanBuren
Add-ADGroupMember -identity "IT Test Presidents" -Members Williams.Harrison
Add-ADGroupMember -identity "IT Test Presidents" -Members John.Tyler
Add-ADGroupMember -identity "IT Test Presidents" -Members James.Polk
Add-ADGroupMember -identity "IT Test Presidents" -Members Zachery.Taylor
Add-ADGroupMember -identity "IT Test Presidents" -Members Millard.Fillmore
Add-ADGroupMember -identity "IT Test Presidents" -Members Franklin.Pierce
Add-ADGroupMember -identity "IT Test Presidents" -Members James.Buchanan
Add-ADGroupMember -identity "IT Test Presidents" -Members Abraham.Lincoln
Add-ADGroupMember -identity "IT Test Presidents" -Members Andrew.Johnson
Add-ADGroupMember -identity "IT Test Presidents" -Members Ulysses.Grant
Add-ADGroupMember -identity "IT Test Presidents" -Members Rutherford.Hayes
Add-ADGroupMember -identity "IT Test Presidents" -Members James.Garfield
Add-ADGroupMember -identity "IT Test Presidents" -Members Chester.Arthur
Add-ADGroupMember -identity "IT Test Presidents" -Members Grover.Cleveland
Add-ADGroupMember -identity "IT Test Presidents" -Members Benjamin.Harrison
Add-ADGroupMember -identity "IT Test Presidents" -Members William.McKinley
Add-ADGroupMember -identity "IT Test Presidents" -Members Theodore.Roosevelt
Add-ADGroupMember -identity "IT Test Presidents" -Members William.Taft
Add-ADGroupMember -identity "IT Test Presidents" -Members Woodrow.Wilson
Add-ADGroupMember -identity "IT Test Presidents" -Members Warren.Harding
Add-ADGroupMember -identity "IT Test Presidents" -Members Calvin.Coolidge
Add-ADGroupMember -identity "IT Test Presidents" -Members Herbert.Hoover
Add-ADGroupMember -identity "IT Test Presidents" -Members Franklin.Roosevelt
Add-ADGroupMember -identity "IT Test Presidents" -Members Harry.Truman
Add-ADGroupMember -identity "IT Test Presidents" -Members Dwight.Eisenhower
Add-ADGroupMember -identity "IT Test Presidents" -Members John.Kennedy
Add-ADGroupMember -identity "IT Test Presidents" -Members Lyndon.Johnson
Add-ADGroupMember -identity "IT Test Presidents" -Members Richard.Nixon
Add-ADGroupMember -identity "IT Test Presidents" -Members Gerald.Ford
Add-ADGroupMember -identity "IT Test Presidents" -Members James.Carter
Add-ADGroupMember -identity "IT Test Presidents" -Members Ronald.Regan
Add-ADGroupMember -identity "IT Test Presidents" -Members George.HWBush
Add-ADGroupMember -identity "IT Test Presidents" -Members Bill.Clinton
Add-ADGroupMember -identity "IT Test Presidents" -Members George.WBush
Add-ADGroupMember -identity "IT Test Presidents" -Members Barrack.Obama
Add-ADGroupMember -identity "IT Test Presidents" -Members Donald.Trump
Add-ADGroupMember -identity "IT Test Presidents" -Members Joe.Biden


===


new-aduser - john.doe -office Pittsburgh -department "425.27 PIT Piping" -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"
New-ADUser -Name “John Doe" -GivenName John -Surname Doe -SamAccountName john.doe -UserPrincipalName john.doe@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "John Doe" -office Pittsburgh -department "425.27 PIT Piping" -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"

new-aduser -identity john.doe -office Pittsburgh -department "425.27 PIT Piping" -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"

Add-ADGroupMember -identity "cad applications" -Members bill.clinton 
Add-ADGroupMember -identity "cad_user" -Members bill.clinton


new-aduser -identity john.doe -office Pittsburgh -department "425.27 PIT Piping" -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"
Add-ADGroupMember -identity "cad applications" -Members john.doe
Add-ADGroupMember -identity "cad_user" -Members john.doe

-===


Add-ADGroupMember -identity MIDD -Members George.Washington
Add-ADGroupMember -identity "MIDD" -Members John.adams
Add-ADGroupMember -identity "MIDD" -Members Thomas.jefferson
Add-ADGroupMember -identity "MIDD" -Members James.Madison
Add-ADGroupMember -identity "MIDD" -Members James.Monroe
Add-ADGroupMember -identity "MIDD" -Members John.QAdams
Add-ADGroupMember -identity "MIDD" -Members Andrew.Jackson
Add-ADGroupMember -identity "MIDD" -Members Martin.VanBuren
Add-ADGroupMember -identity "MIDD" -Members Williams.Harrison
Add-ADGroupMember -identity "MIDD" -Members John.Tyler
Add-ADGroupMember -identity "MIDD" -Members James.Polk
Add-ADGroupMember -identity "MIDD" -Members Zachery.Taylor
Add-ADGroupMember -identity "MIDD" -Members Millard.Fillmore
Add-ADGroupMember -identity "MIDD" -Members Franklin.Pierce
Add-ADGroupMember -identity "MIDD" -Members James.Buchanan
Add-ADGroupMember -identity "MIDD" -Members Abraham.Lincoln
Add-ADGroupMember -identity "MIDD" -Members Andrew.Johnson
Add-ADGroupMember -identity "MIDD" -Members Ulysses.Grant
Add-ADGroupMember -identity "MIDD" -Members Rutherford.Hayes
Add-ADGroupMember -identity "MIDD" -Members James.Garfield
Add-ADGroupMember -identity "MIDD" -Members Chester.Arthur
Add-ADGroupMember -identity "MIDD" -Members Grover.Cleveland
Add-ADGroupMember -identity "MIDD" -Members Benjamin.Harrison
Add-ADGroupMember -identity "MIDD" -Members William.McKinley
Add-ADGroupMember -identity "MIDD" -Members Theodore.Roosevelt
Add-ADGroupMember -identity "MIDD" -Members William.Taft
Add-ADGroupMember -identity "MIDD" -Members Woodrow.Wilson
Add-ADGroupMember -identity "MIDD" -Members Warren.Harding
Add-ADGroupMember -identity "MIDD" -Members Calvin.Coolidge
Add-ADGroupMember -identity "MIDD" -Members Herbert.Hoover
Add-ADGroupMember -identity "MIDD" -Members Franklin.Roosevelt
Add-ADGroupMember -identity "MIDD" -Members Harry.Truman
Add-ADGroupMember -identity "MIDD" -Members Dwight.Eisenhower
Add-ADGroupMember -identity "MIDD" -Members John.Kennedy
Add-ADGroupMember -identity "MIDD" -Members Lyndon.Johnson
Add-ADGroupMember -identity "MIDD" -Members Richard.Nixon
Add-ADGroupMember -identity "MIDD" -Members Gerald.Ford
Add-ADGroupMember -identity "MIDD" -Members James.Carter
Add-ADGroupMember -identity "MIDD" -Members Ronald.Regan
Add-ADGroupMember -identity "MIDD" -Members George.HWBush
Add-ADGroupMember -identity "MIDD" -Members Bill.Clinton
Add-ADGroupMember -identity "MIDD" -Members George.WBush
Add-ADGroupMember -identity "MIDD" -Members Barrack.Obama
Add-ADGroupMember -identity "MIDD" -Members Donald.Trump
Add-ADGroupMember -identity "MIDD" -Members Joe.Biden


Set-ADObject "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Replace @{msExchHideFromAddressLists=$true}

path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"
Set-ADGroup -Identity "it test presidents" -

$users = get-adobject -filter {objectclass -eq "user"} -searchbase "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"

foreach ($User in $users)
{
    Set-ADObject $user -replace @{msExchHideFromAddressLists=$true}
   # Set-ADObject $user -clear ShowinAddressBook
}

get-adobject -identity "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"

set-aduser -Identity william.taft -replace @{msExchHideFromAddressLists=$true}
Get-ADUser -Identity william.taft -properties msExchHideFromAddressLists

Get-ADUser -Filter * -SearchBase "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -properties msExchHideFromAddressLists

get-aduser -identity johnny.test


set-aduser -userprinciplename Abraham.Lincoln@middough.com -office "indianapolis"
set-aduser -identity andrew.jackson -office $null

new-adgroup -name "Client Account Plans-CAP-Refining_mod" -SamAccountName "Client Account Plans-CAP-Refining_mod" -displayname "ClientAccountPlans-CAP-Refining_mod" -path "OU=Business Developmenet,OU=S Drive Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -GroupCategory Security -GroupScope Global
new-adgroup -name "Client Account Plans-CAP-Agribusiness_mod" -SamAccountName "ClientAccountPlans-CAP-Agribusiness_mod" -displayname "Client Account Plans-CAP-Agribusiness_mod" -path "OU=Business Developmenet,OU=S Drive Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -GroupCategory Security -GroupScope Global
new-adgroup -name "Client Account Plans-CAP-Chemical_mod" -SamAccountName "ClientAccountPlans-CAP-Chemical_mod" -displayname "Client Account Plans-CAP-Chemical_mod" -path "OU=Business Developmenet,OU=S Drive Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -GroupCategory Security -GroupScope Global
new-adgroup -name "Client Account Plans-CAP-Food_mod" -SamAccountName "ClientAccountPlans-CAP-Food_mod" -displayname "Client Account Plans-CAP-Food_mod" -path "OU=Business Developmenet,OU=S Drive Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -GroupCategory Security -GroupScope Global
new-adgroup -name "Client Account Plans-CAP-Metals_mod" -SamAccountName "ClientAccountPlans-CAP-Metals_mod" -displayname "Client Account Plans-CAP-Metals_mod" -path "OU=Business Developmenet,OU=S Drive Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -GroupCategory Security -GroupScope Global
new-adgroup -name "Client Account Plans-CAP-MFG_mod" -SamAccountName "ClientAccountPlans-CAP-MFG_mod" -displayname "Client Account Plans-CAP-MFG_mod" -path "OU=Business Developmenet,OU=S Drive Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -GroupCategory Security -GroupScope Global
new-adgroup -name "Client Account Plans-CAP-Pharma_mod" -SamAccountName "ClientAccountPlans-CAP-Pharma_mod" -displayname "Client Account Plans-CAP-Pharma_mod" -path "OU=Business Developmenet,OU=S Drive Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -GroupCategory Security -GroupScope Global
new-adgroup -name "Client Account Plans-CAP-Power_mod" -SamAccountName "ClientAccountPlans-CAP-Power_mod" -displayname "Client Account Plans-CAP-Power_mod" -path "OU=Business Developmenet,OU=S Drive Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -GroupCategory Security -GroupScope Global



OU=Business Development,OU=S Drive Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL
OU=Business Development,OU=S Drive Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL

New-ADUser -Name “Jason1 Lamb1" -GivenName Jason1 -Surname Lamb1 -SamAccountName jason1.lamb1 -UserPrincipalName jason1.lamb1@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -displayname "Jason1 Lamb1" -department "050.01 CLE Architectural" -office "Pittsburgh" -manager "Jason.Lamb" -state "OH" -initials JL -StreetAddress "123 Fun St" -City "Cleveland" -PostalCode "44114"
New-ADUser -Name “jason2 lamb2" -GivenName jason2 -Surname lamb2 -SamAccountName jason2.lamb2 -UserPrincipalName jason2.lamb2@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -displayname "jason2 lamb2" -department "050.01 CLE Architectural" -office "Pittsburgh" -manager "Jason.Lamb" -state "OH" -initials JL -StreetAddress "123 Fun St" -City "Cleveland" -PostalCode "44114" 
set-aduser jason2.lamb2 -Replace @{c="US";co="United States";countrycode=840}
New-ADUser -Name “jason3 lamb3" -GivenName jason3 -Surname lamb3 -SamAccountName jason3.lamb3 -UserPrincipalName jason3.lamb3@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -displayname "jason3 lamb3" -department "050.01 CLE Architectural" -office "Pittsburgh" -manager "Jason.Lamb" -state "OH" -initials JL -StreetAddress "123 Fun St" -City "Cleveland" -PostalCode "44114" -title "good title"
set-aduser jason3.lamb3 -Replace @{c="US";co="United States";countrycode=840}
New-ADUser -Name “jason4 lamb4" -GivenName jason4 -Surname lamb4 -SamAccountName jason4.lamb4 -UserPrincipalName jason4.lamb4@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -displayname "jason4 lamb4" -department "050.01 CLE Architectural" -office "Pittsburgh" -manager "Jason.Lamb" -state "OH" -initials JL -StreetAddress "123 Fun St" -City "Cleveland" -PostalCode "44114" -title "good title" -company "Middough"
set-aduser jason4.lamb4 -Replace @{c="US";co="United States";countrycode=840}
Add-ADGroupMember 

get-aduser -identity jason.lamb


remove-aduser -identity John.QAdams
remove-aduser -identity Andrew.Jackson
remove-aduser -identity Martin.VanBuren
remove-aduser -identity Williams.Harrison
remove-aduser -identity John.Tyler
remove-aduser -identity James.Polk
remove-aduser -identity Zachery.Taylor
remove-aduser -identity Millard.Fillmore
remove-aduser -identity Franklin.Pierce
remove-aduser -identity James.Buchanan
remove-aduser -identity Abraham.Lincoln
remove-aduser -identity Andrew.Johnson
remove-aduser -identity Ulysses.Grant
remove-aduser -identity Rutherford.Hayes
remove-aduser -identity James.Garfield
remove-aduser -identity Chester.Arthur
remove-aduser -identity Grover.Cleveland
remove-aduser -identity Benjamin.Harrison
remove-aduser -identity William.McKinley
remove-aduser -identity Theodore.Roosevelt
remove-aduser -identity William.Taft
remove-aduser -identity Woodrow.Wilson
remove-aduser -identity Warren.Harding
remove-aduser -identity Calvin.Coolidge
remove-aduser -identity Herbert.Hoover
remove-aduser -identity Franklin.Roosevelt
remove-aduser -identity Harry.Truman
remove-aduser -identity Dwight.Eisenhower
remove-aduser -identity John.Kennedy
remove-aduser -identity Lyndon.Johnson
remove-aduser -identity Richard.Nixon
remove-aduser -identity Gerald.Ford
remove-aduser -identity James.Carter
remove-aduser -identity Ronald.Regan
remove-aduser -identity George.HWBush
remove-aduser -identity Bill.Clinton
remove-aduser -identity George.WBush
remove-aduser -identity Barrack.Obama
remove-aduser -identity Donald.Trump
remove-aduser -identity Joe.Biden
remove-aduser -identity John.QAdams
remove-aduser -identity Martin.VanBuren
remove-aduser -identity George.HWBush
remove-aduser -identity George.WBush
remove-aduser -Identity george.washington
remove-aduser -Identity james.madison
remove-aduser -Identity james.monroe
remove-aduser -Identity john.adams
remove-aduser -Identity thomas.jefferson
remove-aduser -Identity william.harrison


===




New-ADUser -Name “John Adams" -GivenName "John" -Surname "Adams" -displayname "John Adams" -SamAccountName "john.adams" -path "OU=100,OU=CLE,OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "john.adams@middough.com" -department "100.01 CLE Structural" -office "Cleveland" -state "OH" -initials "JA" -StreetAddress "1901 E 13th St, Ste 400" -City "Cleveland" -PostalCode "44114" -title "Tester" -company "Middough" -manager "Jasono.Lambo"
set-aduser "john.adams" -Replace @{c="US";co="United States";countrycode=840}

Add-ADGroupMember -identity "3D Connection Navigator Driver" -Members 670
Add-ADGroupMember -identity "Anchor Designer" -Members 670
Add-ADGroupMember -identity "Chicago Citrix" -Members 670
Add-ADGroupMember -identity "Citrix ICA Web Client 10.200" -Members 670
Add-ADGroupMember -identity "ComCheck" -Members 670
Add-ADGroupMember -identity "CompuTrace" -Members 670
Add-ADGroupMember -identity "Costwork test" -Members 670
Add-ADGroupMember -identity "Cummins Power Suite" -Members 670
Add-ADGroupMember -identity "Easy Power 9.7" -Members 670
Add-ADGroupMember -identity "Easy Power 9.8" -Members 670
Add-ADGroupMember -identity "Electrc_LoadCalc 2008" -Members 670
Add-ADGroupMember -identity "Enhanced Smartloop" -Members 670
Add-ADGroupMember -identity "ETAP 14" -Members 670
Add-ADGroupMember -identity "Fisher Autodraw" -Members 670
Add-ADGroupMember -identity "Fisher Control Specification Manager" -Members 670
Add-ADGroupMember -identity "Fisher Firstvue" -Members 670
Add-ADGroupMember -identity "Fisher Spec Mngr 2.11.15" -Members 670
Add-ADGroupMember -identity "GE Specifiers Guide" -Members 670
Add-ADGroupMember -identity "Kohler Generator" -Members 670
Add-ADGroupMember -identity "Kohler Power Solution Center" -Members 670
Add-ADGroupMember -identity "Microsoft Access Database Engine 2010" -Members 670
Add-ADGroupMember -identity "Navisworks Exporters 2014" -Members 670
Add-ADGroupMember -identity "Navisworks Manage 2015" -Members 670
Add-ADGroupMember -identity "Navisworks Manage 2016 SP2" -Members 670
Add-ADGroupMember -identity "Navisworks Simulate 2015" -Members 670
Add-ADGroupMember -identity "Navisworks Simulate 2015 SP 2 & 3" -Members 670
Add-ADGroupMember -identity "Navisworks Simulate 2016 SP2" -Members 670
Add-ADGroupMember -identity "PCWRITE" -Members 670
Add-ADGroupMember -identity "PLS-CADD 13.2" -Members 670
Add-ADGroupMember -identity "Pnet4" -Members 670
Add-ADGroupMember -identity "Product Design Suite 2015" -Members 670
Add-ADGroupMember -identity "Product Design Suite 2016 Electrical" -Members 670
Add-ADGroupMember -identity "PXMenus" -Members 670
Add-ADGroupMember -identity "RAM Structural Revit Link" -Members 670
Add-ADGroupMember -identity "RAP DG Tool" -Members 670
Add-ADGroupMember -identity "Raster Design 2015" -Members 670
Add-ADGroupMember -identity "Revit 2014" -Members 670
Add-ADGroupMember -identity "Revit 2016 SP2" -Members 670
Add-ADGroupMember -identity "Revit Update Release 4" -Members 670
Add-ADGroupMember -identity "Revit UR9" -Members 670
Add-ADGroupMember -identity "Rockwell Automation CenterONE" -Members 670
Add-ADGroupMember -identity "Schneider Electric LayoutFAST" -Members 670
Add-ADGroupMember -identity "SEL Applications" -Members 670
Add-ADGroupMember -identity "SKM Power Tools" -Members 670
Add-ADGroupMember -identity "SmartPlant Instrumentation" -Members 670
Add-ADGroupMember -identity "Smartplant Instrumentation 2013" -Members 670
Add-ADGroupMember -identity "Smartplant Instrumentation 2013 Administration" -Members 670
Add-ADGroupMember -identity "Tekla Bimsight" -Members 670
Add-ADGroupMember -identity "Trace Calc Pro 2.7" -Members 670
Add-ADGroupMember -identity "TraceCalc Pro" -Members 670
Add-ADGroupMember -identity "ValSpeQ" -Members 670
Add-ADGroupMember -identity "Valspeq v4.02.1" -Members 670
Add-ADGroupMember -identity "Visual Lighting" -Members 670
Add-ADGroupMember -identity "Walbridge Website Client ActiveX" -Members 670
Add-ADGroupMember -identity "Navisworks Manage 2016 (Local)" -Members 670
Add-ADGroupMember -identity "Navisworks Simulate 2016 (Local)" -Members 670
Add-ADGroupMember -identity "Raster Design 2016 (Local)" -Members 670
Add-ADGroupMember -identity "Smartplant Registry Import (CLE)" -Members 670

remove-adgroupmember -Identity cle_600 -members StalteDE,GlivarJJ,Sebekjj,Gaertnmj,ViancoME,Yoergerw,Sam.Bennett
add-adgroupmember -Identity cle_600 -members StalteDE,GlivarJJ,Sebekjj,Gaertnmj,ViancoME,Yoergerw,Sam.Bennett


New-ADUser -Name “James Polk" -GivenName "James" -Surname "Polk" -displayname "James Polk" -SamAccountName "james.polk" -path "OU=100,OU=NWI,OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "james.polk@middough.com" -email "james.polk@middough.com" -officephone "219-706-5290" -department "100.08 IND Structural" -office "Indiana" -state "IN" -initials "JP" -StreetAddress "1433 E 83rd Ave, Ste 100" -City "Merrillville" -PostalCode "46410" -title "Tester" -company "Middough" -manager "Jasono.Lambo"


New-ADUser -Name “Zach Rojas" -GivenName "Zach" -Surname "Rojas" -displayname "Zach Rojas" -SamAccountName "zach.rojas" -path "OU=050,OU=CHI,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "zach.rojas@middough.com" -email "zach.rojas@middough.com" -officephone "630-756-7020" -department "50.02 CHI Architectural" -office "Chicago" -state "IL" -initials "ZR" -StreetAddress "700 Commerce Dr, Ste 200" -City "Oak Brook" -PostalCode "60523" -title "Intern" -company "Middough" -manager "DavidsRJ"
New-ADUser -Name “Kayan Kartoum" -GivenName "Kayan" -Surname "Kartoum" -displayname "Kayan Kartoum" -SamAccountName "kayan.kartoum" -path "OU=650,OU=CHI,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "kayan.kartoum@middough.com" -email "kayan.kartoum@middough.com" -officephone "630-756-7019" -department "650.02 CHI I&C" -office "Chicago" -state "IL" -initials "KK" -StreetAddress "700 Commerce Dr, Ste 200" -City "Oak Brook" -PostalCode "60523" -title "Engineer" -company "Middough" -manager "Liuy"
New-ADUser -Name “Andrew Russ" -GivenName "Andrew" -Surname "Russ" -displayname "Andrew Russ" -SamAccountName "andrew.russ" -path "OU=350,OU=CHI,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "andrew.russ@middough.com" -email "andrew.russ@middough.com" -officephone "630-756-7018" -department "350.02 CHI Process" -office "Chicago" -state "IL" -initials "AR" -StreetAddress "700 Commerce Dr, Ste 200" -City "Oak Brook" -PostalCode "60523" -title "Intern" -company "Middough" -manager "HodepeTL"
New-ADUser -Name “Rami Abualkheir" -GivenName "Rami" -Surname "Abualkheir" -displayname "Rami Abualkheir" -SamAccountName "rami.abualkheir" -path "OU=600,OU=CHI,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "rami.abualkheir@middough.com" -email "rami.abualkheir@middough.com" -officephone "630-756-7017" -department "600.02 CHI Electrical" -office "Chicago" -state "IL" -initials "RA" -StreetAddress "700 Commerce Dr, Ste 200" -City "Oak Brook" -PostalCode "60523" -title "Intern" -company "Middough" -manager "Jalpan.Soni"
New-ADUser -Name “Logan Bez" -GivenName "Logan" -Surname "Bez" -displayname "Logan Bez" -SamAccountName "logan.bez" -path "OU=100,OU=CHI,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "logan.bez@middough.com" -email "logan.bez@middough.com" -officephone "630-756-7016" -department "100.02 CHI Structural" -office "Chicago" -state "IL" -initials "LB" -StreetAddress "700 Commerce Dr, Ste 200" -City "Oak Brook" -PostalCode "60523" -title "Intern" -company "Middough" -manager "Shkurtav"


set-aduser "zach.rojas" -Replace @{c="US";co="United States";countrycode=840}
set-aduser "kayan.kartoum" -Replace @{c="US";co="United States";countrycode=840}
set-aduser "andrew.russ" -Replace @{c="US";co="United States";countrycode=840}
set-aduser "rami.abualkheir" -Replace @{c="US";co="United States";countrycode=840}
set-aduser "logan.bez" -Replace @{c="US";co="United States";countrycode=840}

Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members zach.rojas
Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members kayan.kartoum
Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members andrew.russ
Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members rami.abualkheir
Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members logan.bez


 Add-ADGroupMember -identity "CAD Applications" -members zach.rojas ;Add-ADGroupMember -identity "Engineering_Dept" -members zach.rojas ; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members zach.rojas
  Add-ADGroupMember -identity "CAD Applications" -members zach.rojas; Add-ADGroupMember -identity "Engineering_Dept" -members zach.rojas; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members zach.rojas

   Add-ADGroupMember -identity "CAD Applications" -members kayan.kartoum; Add-ADGroupMember -identity "Engineering_Dept" -members kayan.kartoum; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members kayan.kartoum
 Add-ADGroupMember -identity "CAD Applications" -members andrew.russ; Add-ADGroupMember -identity "Engineering_Dept" -members andrew.russ; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members andrew.russ
 Add-ADGroupMember -identity "CAD Applications" -members rami.abualkheir; Add-ADGroupMember -identity "Engineering_Dept" -members rami.abualkheir; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members rami.abualkheir
 Add-ADGroupMember -identity "CAD Applications" -members logan.bez; Add-ADGroupMember -identity "Engineering_Dept" -members logan.bez; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members logan.bez
 Add-ADGroupMember -identity CHI_050 -members zach.rojas
 Add-ADGroupMember -identity CHI_650 -members kayan.kartoum
 Add-ADGroupMember -identity CHI_350 -members andrew.russ
 Add-ADGroupMember -identity CHI_600 -members rami.abualkheir
 Add-ADGroupMember -identity CHI_100 -members logan.bez

Middough0515

New-ADUser -Name “Andrew Javier" -GivenName "Andrew" -Surname "Javier" -displayname "Andrew Javier" -SamAccountName "andrew.javier" -path "OU=650,OU=CHI,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "andrew.javier@middough.com" -email "andrew.javier@middough.com" -officephone "630-756-7026" -department "650.02 CHI I&C" -office "Chicago" -state "IL" -initials "AJ" -StreetAddress "700 Commerce Dr, Ste 200" -City "Oak Brook" -PostalCode "60523" -title "Intern" -company "Middough" -manager "Liuy";set-aduser "andrew.javier" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members andrew.javier; Add-ADGroupMember -identity "CAD Applications" -members andrew.javier; Add-ADGroupMember -identity "Engineering_Dept" -members andrew.javier; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members andrew.javier; Add-ADGroupMember -identity CHI_650 -members andrew.javier

New-ADUser -Name “Zachery Taylor" -GivenName "Zachery" -Surname "Taylor" -displayname "Zachery Taylor" -SamAccountName "zachery.taylor" -path "OU=100,OU=PIT,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "zachery.taylor@middough.com" -email "zachery.taylor@middough.com" -officephone "216-367-1843" -department "100.27 PIT Structural" -office "Pittsburgh" -state "PA" -initials "ZT" -StreetAddress "2000 Westinghouse Dr, Ste 202" -City "Cranberry Township" -PostalCode "16066" -title "Tester" -company "Middough" -manager "Jasono.Lambo";set-aduser "zachery.taylor" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members zachery.taylor; Add-ADGroupMember -identity "CAD Applications" -members zachery.taylor; Add-ADGroupMember -identity "Engineering_Dept" -members zachery.taylor; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members zachery.taylor; Add-ADGroupMember -identity PIT_100 -members zachery.taylor
New-ADUser -Name “Millard Fillmore" -GivenName "Millard" -Surname "Fillmore" -displayname "Millard Fillmore" -SamAccountName "millard.fillmore" -path "OU=100,OU=MAD,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "millard.fillmore@middough.com" -email "millard.fillmore@middough.com" -officephone "608-835-5430" -department "100.28 MAD Structural" -office "Madison" -state "WI" -initials "MF" -StreetAddress "2801 Crossroads Dr, Ste 2200" -City "Madison" -PostalCode "53718" -title "Tester" -company "Middough" -manager "Jasono.Lambo";set-aduser "millard.fillmore" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members millard.fillmore;; Add-ADGroupMember -identity MAD_100 -members millard.fillmore

new-item -path U:\Chicago\650\Andrew.Javier -itemtype directory
set-acl -path U:\Chicago\650\Andrew.Javier -AclObject.SetAccessRuleProtection($true, $true)

$ACL = Get-Acl -Path "U:\Chicago\650\Andrew.Javier"; $ACL.SetAccessRuleProtection($false,$false)
$ACL = Get-ACL -Path "U:\Chicago\650\Andrew.Javier"; $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("midd"); $ACL.RemoveAccessRule($AccessRule); $ACL | Set-Acl -Path "U:\Chicago\650\Andrew.Javier"

Get-ACL -Path "U:\Chicago\650\Andrew.Javier"


New-ADUser -Name “Hayden Nigro" -GivenName "Hayden" -Surname "Nigro" -displayname "Hayden Nigro" -SamAccountName "hayden.nigro" -path "OU=,OU=MAD,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "hayden.nigro@middough.com" -email "hayden.nigro@middough.com" -officephone "608-835-" -department "400.28 MAD Mechanical" -office "Madison" -state "WI" -initials "HN" -StreetAddress "2801 Crossroads Dr, Ste 2200" -City "Madison" -PostalCode "53718" -title "Intern" -company "Middough" -manager "UttechMJ";set-aduser "hayden.nigro" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members hayden.nigro; Add-ADGroupMember -identity "CAD Applications" -members hayden.nigro; Add-ADGroupMember -identity "Engineering_Dept" -members hayden.nigro; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members hayden.nigro; Add-ADGroupMember -identity MAD_ -members hayden.nigro
New-ADUser -Name “Hayden Nigro" -GivenName "Hayden" -Surname "Nigro" -displayname "Hayden Nigro" -SamAccountName "hayden.nigro" -path "OU=,OU=MAD,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "hayden.nigro@middough.com" -email "hayden.nigro@middough.com" -officephone "" -department "400.28 MAD Mechanical" -office "Madison" -state "WI" -initials "HN" -StreetAddress "2801 Crossroads Dr, Ste 2200" -City "Madison" -PostalCode "53718" -title "Intern" -company "Middough" -manager "UttechMJ";set-aduser "hayden.nigro" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members hayden.nigro; Add-ADGroupMember -identity "CAD Applications" -members hayden.nigro; Add-ADGroupMember -identity "Engineering_Dept" -members hayden.nigro; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members hayden.nigro; Add-ADGroupMember -identity MAD_ -members hayden.nigro

Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members RadtkeAJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Adam.Smith
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Walterac
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Adin.Mann
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Chihakaa
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Polcynam
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Perlaaj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members FaulknAM
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Urankaaj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Shkurtav
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members AugisAV
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members MakinsAP
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Andy.Minderman
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Nashad
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Sansonac
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Torosiaa
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members TerryAM
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Ashwin.Patel
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Avionne.Weaver
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Palmerbj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members AldridBC
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Geresbc
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Thompsba
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Troutbd
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Bill.Celian
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Cloyeswg
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Bob.Necciai
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Bob.Smering
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members brad.daugharthy
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Brad.Ingram
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Bradley.Cearing
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members SosterBM
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Lenharbd
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members SmithBM
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members KruppBE
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members TurneyBK
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members KeaneBM
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members RawsonBY
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Caitlyn.Sullivan
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Wendelce
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Carmen.Carr
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members ThompsCJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Bridgecj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members CookCC
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Stahlcw
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Pondca
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Hoppelcl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Chris.Moran
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Chris.Muntz
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Chris.Puleo
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Hilbercr
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Leonarcm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members RyanCD
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Warnecm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members YoungCS
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Cindy.Smith
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members PiperCR
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Connor.Loughlin
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members WilsonCA
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Curtis.Merow
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Lowrydp
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Tielldm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Daniel.Devadoss
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Durkindp
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members OconnoDP
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Rectordj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Stagerdj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Darren.Gilbert
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Bridendj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Hurstdl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members MayareD
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Reamerda
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members David.Schmidt
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members David.Woodnorth
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members GuptaDK
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members BalchaDM
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members PericD
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Dom.Seriosa
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Failindj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members StalteDE
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Doug.Quasny
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members elaine.molinengo
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Elena.Graupera
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members MastanEJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members GonzalED
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Eric.Mizer
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Eric.Whittaker
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members pendleet
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members ReedEL
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Zapataem
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Dreiergp
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members OlsonGA
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Gary.Row
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members KeehnGA
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Aslanigm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Browngt
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Hlavacgm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members RoweGF
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Streitgj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Gise.VanBaren
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Glen.Hoppe
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Greg.Pertle
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members HollanGA
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members PrudenGA
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Seibolgr
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Harold.Kropp
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Ecksteha
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Jackie.Kolling
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Jalpan.Soni
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Adamsjk
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Blackjl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Carnsjj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Darbyjd
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members GlivarJJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members GoodJP
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members James.Korba
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members James.Probstfeld
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members James.Rossi
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Sebekjj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Weinhejr
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Janet.Honeywell
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members davisjl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Jason.Jamil
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members jason.lamb
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Jason.Riehl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Jeff.Fesko
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Frederjw
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Jeff.Hollinshead
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Slabyja
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Jeff.Zunich
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members KuzmaJS
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members BihlJC
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Waltonjs
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Jennifer.Valek
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Kasickjc
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Pazdanjw
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Wiszjl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Ledinje
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Jim.Grady
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Jim.Harrold
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Johnsoje
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Kilbyjw
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Jim.Perry
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Joe.Angeski
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Berdysjf
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members DavisJM
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Micheljf
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Rossjw
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members John.Rotroff
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Sweenejw
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Jon.Beskin
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members AtkinsJD
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members GrelewJF
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Halljl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members JaraczJP
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Joseph.Julian
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Khaterjm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members RedmonJM
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Walterja
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members DeakinJR
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members MillerJK
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members WraseJW
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Julian.CoutoCarter
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members BettinJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Devriejc
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Justin.Pistininzi
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Rogersja
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Justin.Walters
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Kaleb.Myers
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Mayerkm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members YoungKE
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Braunske
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Kathy.Olle
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Keith.Luttell
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members McMastKA
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Kendall.Welling
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Kenneth.Dudzik
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members PutnamKA
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members SefcikKP
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Flanertk
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Kent.Mansfield
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Kevin.Bollinger
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Grubbkl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Kevin.Moore
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Payneke
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Winklekm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Olesicka
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Newmankj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Stephekt
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Cussenkg
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Lesleylr
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Laurie.Jones
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Krakovlj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Lenny.Laird
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Les.Ciciora
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Li.Yan
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Joschtlc
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Melilllm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Reganlm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members ShivelME
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Meyersmj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Bealmk
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Friedmm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Gaertnmj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Hoggeml
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members MullenMA
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Mark.Santillana
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Sulzbamd
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Whitema
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Saivem
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members GeorgeM
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Matt.Bedee
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Matt.Wisniewski
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Althoumj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Hammonmr
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Max.Martin
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members PorterMR
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Micah.Karns
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Michael.Deinhammer
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Endersmd
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Fonsecmj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Forresmd
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Garetymw
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members HillMG
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members JimeneMJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Lytlemp
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Mclaugma
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members michael.ratcliff
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Robertmd
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Salowma
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Schrinmj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Sebonimj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members SmithMJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members UttechMJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Michael.Vargas
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members ViancoME
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Wheatmd
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Mike.Paulic
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Mike.Picardi
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Mike.Pollino
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Szalkomg
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Lowryma
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members FryNL
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Millerne
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Nathan.Ingram
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members StolleNW
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Ziskonm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Nathen.Stevenson
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Nenet.Bautista
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Nestor.Hiso
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Nick.Trout
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Nitin.Mahajan
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Noah.Blain
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Otto.Wenzel
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Patricia.Krupp
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Flaughpl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Patrick.Keenan
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Granatpj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Bowlinpa
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members StonemPJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Waynepj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Sortispd
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members WrightPJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Quenton.Strickland
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Peacerj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Bonerich
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members HayesRJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Johnsora
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Mckenzrl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Yoergerw
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Gravesrm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Robert.Adamski
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Bordonra
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members DavidsRJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members GawronRT
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members JankeyRW
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Olschlre
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Podhorrl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Schmidrc
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Strosnrl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Vidrare
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Weiganrk
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Rothrj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Roger.Hieser
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Ledinrr
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Russ.Kosis
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Overhorj
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Witzkerm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Sam.Bennett
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Sam.Blood
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Munjesr
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Feeneysm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Hilenssr
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members CarneySP
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Wisniesp
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Shawn.Rudy
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members DyeSL
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Stephen.Wagner
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members WeinheSG
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Bogaersm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Shogresc
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Sinhask
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members SilajSM
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members reynoltl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Zdolshtl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Tanner.Drees
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members BellTR
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Riedeltw
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Koniectl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Blairtg
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Thomas.McKeown
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Thomas.Paprocki
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Pienostm
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Wickerth
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Tim.Saunders
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Tholete
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Palmertp
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members WitzkeTR
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members HodepeTL
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Todd.Alfonso
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Voytkotl
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Tony.Nuzzo
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Keyta
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members CullerTL
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Tristan.Griffith
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members BrownTJ
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Victor.Sibiga
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Dankoww
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Wes.Stewart
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Pricewf
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Rabquewa
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members WinterWF
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members ZatoWA
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Kordahyk
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Liuy
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members Zach.Sadowski
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members LantinZL
Add-ADGroupMember -identity "O365 MS Teams Audio Conf w dial-out to USA-CAN" -members HitesZH

Add-ADGroupMember -identity "Bluebeam w-o CAD" -members allison.hassig,Ashama.Babooram,BellTR,Blackjl,Bob.Smering,Bogaersm,Bonerich,CarneySP,cathy.sullivan,Chris.Moran,craig.anderson,David.Schmidt,David.Woodnorth,elaine.molinengo,FaulknAM,Frederjw,GawronRT,Greg.Pertle,Hoggeml,James.Korba,James.Rossi,jeff.caldwell,jeremy.smith,John.Rotroff,john.seaman,Joschtlc,Justin.Pistininzi,Kent.Mansfield,Kevin.Moore,Laurie.Jones,Lowrydp,Lowryma,Marisha.Baldwin,mark.seifried,Matt.Wisniewski,Meyersmj,michael.aldarondo,michael.ratcliff,MullenMA,Nashad,Otto.Wenzel,patrick.conner,PutnamKA,Quenton.Strickland,rob.hattabaugh,Russ.Kosis,ryan.byers,Salowma,Sam.Blood,Sebonimj,Sextonte,SilajSM,Sortispd,Streitgj,todd.chaney,Tony.Nuzzo,Walterja

Add-ADGroupMember -identity "CAD w-o Bluebeam" -members aaliyah.briggs,alex.higgins,alexis.belbis,andrew.javier,andrew.russ,ben.cash,Blairtg,bob.lawrie,brad.daugharthy,Clougheg,CostanJL,Dan.Heberer,dennis.chibisov,Dozier.Young,Elvis.Presley,Eric.Whittaker,ethan.miller,Fishertl,Forresmd,Gary.Stamper,Greg.Furgala,hayden.nigro,Hoyecl,hunter.voithofer,Isai.Delarca,jack.middleton,jeff.malek,Jen.Smith,Joe.Limon,jonathan.vernon,joshua.hines,Kil.Smith,logan.bez,luke.grupp,Magrumlp,matt.locher,michael.paden,nicholas.tipton,Nitin.Mahajan,Olschlre,Paul.Tremonti,Pricewf,rami.abualkheir,Reamerda,Robert.Wellert,Slabyja,spanky,Steve.Coons,Testop,Thomas.Paprocki,trevor.misch,Walterdl,WalterSM,Wickerth,Wilkinvp,William.Foster,WitzkeTR,YoungCS,Zach.Densmore,zach.rojas,Zapataem

Add-ADGroupMember -identity "CAD with Bluebeam" -members RadtkeAJ, adam.clark,Adam.Smith,Adamsjk,Adin.Mann,AldridBC,Alex.Dunaway,alex.lutz,Allen.Beeler,Althoumj,andrew.gallagher,Andy.Minderman,Ashwin.Patel,Aslanigm,AtkinsJD,AugisAV,autumn.erme,Autumn.Hatcher,Avionne.Weaver,BalchaDM,Bealmk,ben.mccoy,Berdysjf,BettinJ,BihlJC,Bordonra,Bowlinpa,Brad.Ingram,Bradley.Cearing,Braunske,Brian.Mariska,brian.young,Bridendj,Bridgecj,Browngt,BrownTJ,bryan.king,carlton.powell,Carmen.Carr,Carnsjj,chad.zimmerman,Chihakaa,chris.arevalo,Chris.Hennessey,Chris.Muntz,Chris.Soprano,Christian.Kanfeld,Cindy.Smith,Cloyeswg,Connor.Loughlin,CookCC,Cuculirj,curtis.beaudoin,Curtis.Merow,Cussenkg,Dane.Rasmussen,Daniel.Devadoss,Darbyjd,Darren.Gilbert,DavidsRJ,davisjl,DavisJM,DeakinJR,Dennis.Fundzak,Dom.Seriosa,Doug.Quasny,Doug.Stieb,Dreiergp,drew.zimmerman,Durkindp,Dylan.McNamee,Ecksteha,Ed.Matthews,Emmanuel.Paredes,Endersmd,Eric.Mizer,erik.cooley,Failindj,Feeneysm,Flaughpl,Fonsecmj,Friedmm,Gaertnmj,Garetymw,GeorgeM,Geresbc,Gise.VanBaren,Glen.Hoppe,GlivarJJ,GonzalED,GoodJP,Granatpj,GrelewJF,Grubbkl,GuptaDK,Halljl,Hammonmr,Hans.Paal,Harold.Kropp,Hilenssr,HitesZH,Hlavacgm,HodepeTL,HollanGA,Hoppelcl,Hurstdl,Igor.Moskalow,Jack.Ziegler,Jackie.Kolling,Jackie.Luong,Jalpan.Soni,James.Probstfeld,jamie.jurin,Janet.Honeywell,JankeyRW,JaraczJP,Jarrett.Feasley,Jason.Jamil,Jason.Riehl,Jasono.Lambo,Jay.Veerasammy,Jeff.Fesko,Jeff.Hollinshead,Jeff.Zunich,jim.bender,jim.bereda,jim.binder,Jim.Harrold,Jim.Marshall,JimeneMJ,Jimmy.Wood,Joe.Angeski,joe.restivo,Joe.Rybicki,Joe.Weiner,Johnsoje,Johnsora,Jon.Beskin,Jonathan.Yang,joseph.imre,joseph.kalic,Josh.Ritchey,Julian.CoutoCarter,Justin.Otero,Justin.Viola,Justin.Walters,Kaleb.Myers,Kasickjc,Kathy.Olle,kauveh.aynafshar,kayan.kartoum,KeaneBM,KeehnGA,Keith.Luttell,Kendall.Welling,Kenneth.Dudzik,Kevin.Bollinger,Keyta,Khaterjm,Kilbyjw,Koniectl,Kordahyk,Kory.Siverd,Krakovlj,KruppBE,KuzmaJS,kyle.linares,LantinZL,lauren.weinberg,Lawrence.Amerson,Lenharbd,Lenny.Laird,Les.Ciciora,Lesleylr,Li.Yan,Liuy,Lonnie.Stump,Lytlemp,MakinsAP,Mark.Santillana,MastanEJ,Matt.Bedee,Matthew.Sands,Max.Martin,MayareD,Mayerkm,Mckenzrl,Micah.Karns,michael.marcinko,Michael.Sarver,Micheljf,Mike.Paulic,Mike.Picardi,Mike.Pollino,Mike.Robinson,MillerJK,Millerne,Mitchekd,Molly.Green,Munjesr,Myra.Parayno,Nathan.Ingram,Nathen.Stevenson,Nenet.Bautista,Nestor.Hiso,Newmankj,nicholas.briggs,nicholas.trudeau,nick.arnold,Nick.Trout,Noah.Blain,norm.jaworski,OlsonGA,Overhorj,Palmerbj,Palmertp,Patricia.Krupp,Patrick.Keenan,Pazdanjw,Peacerj,pendleet,PericD,peter.jug,Pienostm,PiperCR,Polcynam,Pondca,PorterMR,PrudenGA,Rabquewa,RawsonBY,Rectordj,RedmonJM,ReedEL,Reganlm,reynoltl,Richard.Genser,Robert.Adamski,Robertmd,Roger.Hieser,Rogersja,Rossjw,Rothrj,RoweGF,RyanCD,Saivem,Sam.Bennett,Sansonac,Santiago.Villegas,Schmidrc,Schrinmj,Sebekjj,SefcikKP,Seibolgr,Shawn.Rudy,Sherkoh.Anz,Shkurtav,Shogresc,Sinhask,SmithMJ,SosterBM,Stagerdj,Stahlcw,StalteDE,Stephekt,Stephen.Wagner,Steve.Maggiano,StolleNW,Strosnrl,Sulzbamd,sumita.pol,Sweenejw,Tanner.Drees,TerryAM,Tholete,Thomas.McKeown,thomas.twardowski,Thompsba,ThompsCJ,Tielldm,Tim.Saunders,tom.webster,Torosiaa,Tristan.Griffith,Troutbd,TurneyBK,Tyler.Baird,Urankaaj,ViancoME,victor.guerrero,Victor.Sibiga,Vidrare,Voytkotl,Walterac,Waltonjs,Warnecm,Waynepj,Weiganrk,Weinhejr,WeinheSG,Wes.Stewart,Wesley.McCurdy,Wheatmd,Whitema,WilsonCA,WinterWF,Wisniesp,Witzkerm,WraseJW,Wyatt.Suntala,Yoergerw,Zach.Sadowski,ZatoWA,Ziskonm

set-aduser -identity alex.lutz -manager Endersmd #michael enders
set-aduser -identity ethan.miller -manager Endersmd
set-aduser -identity joshua.hines -manager Endersmd
set-aduser -identity max.martin -manager Endersmd
set-aduser -identity sumita.pol -manager Endersmd
set-aduser -identity mike.robinson -manager Endersmd

set-aduser -identity alex.dunaway -manager Bob.Necciai
set-aduser -identity chris.hennessey -manager Bob.Necciai
set-aduser -identity craig.anderson -manager Bob.Necciai
set-aduser -identity eric.mizer -manager Bob.Necciai
set-aduser -identity jim.binder -manager Bob.Necciai
set-aduser -identity jim.perry -manager Bob.Necciai
set-aduser -identity joe.angeski -manager Bob.Necciai
set-aduser -identity justin.viola -manager Bob.Necciai
set-aduser -identity michael.ratcliff -manager Bob.Necciai
set-aduser -identity michael.sarver -manager Bob.Necciai
set-aduser -identity prakash.patel -manager Bob.Necciai
set-aduser -identity russ.kosis -manager Bob.Necciai
set-aduser -identity bob.wargo -manager Bob.Necciai
set-aduser -identity wes.stewart -manager Bob.Necciai

set-aduser -identity Strosnrl -manager mark.seifried
set-aduser -identity Sortispd -manager mark.seifried
set-aduser -identity Mayerkm -manager mark.seifried
set-aduser -identity Khaterjm -manager mark.seifried
set-aduser -identity Frederjw -manager mark.seifried
set-aduser -identity Weinhejr -manager mark.seifried
set-aduser -identity David.Schmidt -manager mark.seifried
set-aduser -identity Bob.Smering -manager mark.seifried
set-aduser -identity Sansonac -manager mark.seifried

set-aduser -identity AugisAV -manager Khaterjm
set-aduser -identity Cloyeswg -manager Khaterjm
set-aduser -identity brian.young -manager Khaterjm
set-aduser -identity KruppBE -manager Khaterjm
set-aduser -identity RawsonBY -manager Khaterjm
set-aduser -identity Hoppelcl -manager Khaterjm
set-aduser -identity Cindy.Smith -manager Khaterjm
set-aduser -identity Aslanigm -manager Khaterjm
set-aduser -identity Hlavacgm -manager Khaterjm
set-aduser -identity Igor.Moskalow -manager Khaterjm
set-aduser -identity Kordahyk -manager Khaterjm
set-aduser -identity Jeff.Hollinshead -manager Khaterjm
set-aduser -identity Kasickjc -manager Khaterjm
set-aduser -identity Jim.Harrold -manager Khaterjm
set-aduser -identity Kilbyjw -manager Khaterjm
set-aduser -identity Berdysjf -manager Khaterjm
set-aduser -identity Josh.Ritchey -manager Khaterjm
set-aduser -identity Kathy.Olle -manager Khaterjm
set-aduser -identity SefcikKP -manager Khaterjm
set-aduser -identity Friedmm -manager Khaterjm
set-aduser -identity Matt.Bedee -manager Khaterjm
set-aduser -identity Mike.Pollino -manager Khaterjm
set-aduser -identity Mckenzrl -manager Khaterjm
set-aduser -identity Hilenssr -manager Khaterjm
set-aduser -identity Pienostm -manager Khaterjm
set-aduser -identity Voytkotl -manager Khaterjm
set-aduser -identity Wyatt.Suntala -manager Khaterjm

set-aduser -identity brian.young -manager Mike.Pollino
set-aduser -identity RawsonBY -manager Mike.Pollino
set-aduser -identity Hoppelcl -manager Mike.Pollino
set-aduser -identity Cindy.Smith -manager Mike.Pollino
set-aduser -identity Hlavacgm -manager Mike.Pollino
set-aduser -identity Igor.Moskalow -manager Mike.Pollino
set-aduser -identity Kordahyk -manager Mike.Pollino
set-aduser -identity Kilbyjw -manager Mike.Pollino
set-aduser -identity Berdysjf -manager Mike.Pollino
set-aduser -identity Josh.Ritchey -manager Mike.Pollino
set-aduser -identity Kathy.Olle -manager Mike.Pollino
set-aduser -identity SefcikKP -manager Mike.Pollino
set-aduser -identity Friedmm -manager Mike.Pollino
set-aduser -identity Hilenssr -manager Mike.Pollino
set-aduser -identity Pienostm -manager Mike.Pollino
set-aduser -identity Voytkotl -manager Mike.Pollino
set-aduser -identity Wyatt.Suntala -manager Mike.Pollino

set-aduser -identity john.adams -clear 


set-ADUser -Name “Lindsay Kaminski" -GivenName "Lindsay" -Surname "Kaminski" -displayname "Lindsay Kaminski" -SamAccountName "lindsay.kaminski" -path "OU=710,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "lindsay.kaminski@middough.com" -email "lindsay.kaminski@middough.com" -officephone "" -department "710.01 CLE HR" -office "Cleveland" -state "OH" -initials "LK" -StreetAddress "1901 E 13th St, Ste 400" -City "Cleveland" -PostalCode "44114" -title "HR Specialist" -company "Middough" -manager "YoungKE";


Add-ADGroupMember -identity "SSO" -Members Robert.Kirkpatrick
Add-ADGroupMember -identity "SSO" -Members Tyler.Baird
Add-ADGroupMember -identity "SSO" -Members KeehnGA
Add-ADGroupMember -identity "SSO" -Members brian.young
Add-ADGroupMember -identity "SSO" -Members Jon.Beskin
Add-ADGroupMember -identity "SSO" -Members MastanEJ
Add-ADGroupMember -identity "SSO" -Members zach.rojas
Add-ADGroupMember -identity "SSO" -Members DavidsRJ
Add-ADGroupMember -identity "SSO" -Members Sansonac
Add-ADGroupMember -identity "SSO" -Members RawsonBY
Add-ADGroupMember -identity "SSO" -Members Hoppelcl
Add-ADGroupMember -identity "SSO" -Members Cindy.Smith
Add-ADGroupMember -identity "SSO" -Members Hlavacgm
Add-ADGroupMember -identity "SSO" -Members Igor.Moskalow
Add-ADGroupMember -identity "SSO" -Members Kordahyk
Add-ADGroupMember -identity "SSO" -Members Kilbyjw
Add-ADGroupMember -identity "SSO" -Members Berdysjf
Add-ADGroupMember -identity "SSO" -Members Josh.Ritchey
Add-ADGroupMember -identity "SSO" -Members Kathy.Olle
Add-ADGroupMember -identity "SSO" -Members SefcikKP
Add-ADGroupMember -identity "SSO" -Members Friedmm
Add-ADGroupMember -identity "SSO" -Members Hilenssr
Add-ADGroupMember -identity "SSO" -Members Pienostm
Add-ADGroupMember -identity "SSO" -Members Voytkotl
Add-ADGroupMember -identity "SSO" -Members Wyatt.Suntala
Add-ADGroupMember -identity "SSO" -Members AugisAV
Add-ADGroupMember -identity "SSO" -Members Cloyeswg
Add-ADGroupMember -identity "SSO" -Members KruppBE
Add-ADGroupMember -identity "SSO" -Members TurneyBK
Add-ADGroupMember -identity "SSO" -Members logan.bez
Add-ADGroupMember -identity "SSO" -Members Braunske
Add-ADGroupMember -identity "SSO" -Members Bridendj
Add-ADGroupMember -identity "SSO" -Members Cussenkg
Add-ADGroupMember -identity "SSO" -Members Emmanuel.Paredes
Add-ADGroupMember -identity "SSO" -Members Ashwin.Patel
Add-ADGroupMember -identity "SSO" -Members RyanCD
Add-ADGroupMember -identity "SSO" -Members SmithMJ
Add-ADGroupMember -identity "SSO" -Members Santiago.Villegas
Add-ADGroupMember -identity "SSO" -Members WraseJW
Add-ADGroupMember -identity "SSO" -Members Li.Yan
Add-ADGroupMember -identity "SSO" -Members drew.zimmerman
Add-ADGroupMember -identity "SSO" -Members Shkurtav
Add-ADGroupMember -identity "SSO" -Members Granatpj
Add-ADGroupMember -identity "SSO" -Members HitesZH
Add-ADGroupMember -identity "SSO" -Members Pondca
Add-ADGroupMember -identity "SSO" -Members Robertmd
Add-ADGroupMember -identity "SSO" -Members Stagerdj
Add-ADGroupMember -identity "SSO" -Members Vidrare
Add-ADGroupMember -identity "SSO" -Members Wheatmd
Add-ADGroupMember -identity "SSO" -Members Wickerth
Add-ADGroupMember -identity "SSO" -Members GuptaDK
Add-ADGroupMember -identity "SSO" -Members nicholas.tipton
Add-ADGroupMember -identity "SSO" -Members Walterac
Add-ADGroupMember -identity "SSO" -Members Kevin.Bollinger
Add-ADGroupMember -identity "SSO" -Members Tristan.Griffith
Add-ADGroupMember -identity "SSO" -Members Johnsora
Add-ADGroupMember -identity "SSO" -Members GoodJP
Add-ADGroupMember -identity "SSO" -Members ben.mccoy
Add-ADGroupMember -identity "SSO" -Members Palmertp
Add-ADGroupMember -identity "SSO" -Members Tim.Saunders
Add-ADGroupMember -identity "SSO" -Members Adam.Smith
Add-ADGroupMember -identity "SSO" -Members aaliyah.briggs
Add-ADGroupMember -identity "SSO" -Members Julian.CoutoCarter
Add-ADGroupMember -identity "SSO" -Members MakinsAP
Add-ADGroupMember -identity "SSO" -Members michael.marcinko
Add-ADGroupMember -identity "SSO" -Members Joe.Rybicki
Add-ADGroupMember -identity "SSO" -Members LantinZL
Add-ADGroupMember -identity "SSO" -Members Chris.Hennessey
Add-ADGroupMember -identity "SSO" -Members Prakash.Patel
Add-ADGroupMember -identity "SSO" -Members nick.arnold
Add-ADGroupMember -identity "SSO" -Members Richard.Genser
Add-ADGroupMember -identity "SSO" -Members Molly.Green
Add-ADGroupMember -identity "SSO" -Members luke.grupp
Add-ADGroupMember -identity "SSO" -Members bryan.king
Add-ADGroupMember -identity "SSO" -Members Jackie.Kolling
Add-ADGroupMember -identity "SSO" -Members Lenny.Laird
Add-ADGroupMember -identity "SSO" -Members Ed.Matthews
Add-ADGroupMember -identity "SSO" -Members Curtis.Merow
Add-ADGroupMember -identity "SSO" -Members Chris.Muntz
Add-ADGroupMember -identity "SSO" -Members Dane.Rasmussen
Add-ADGroupMember -identity "SSO" -Members James.Probstfeld
Add-ADGroupMember -identity "SSO" -Members Kendall.Welling
Add-ADGroupMember -identity "SSO" -Members Pricewf
Add-ADGroupMember -identity "SSO" -Members Slabyja
Add-ADGroupMember -identity "SSO" -Members YoungCS
Add-ADGroupMember -identity "SSO" -Members curtis.beaudoin
Add-ADGroupMember -identity "SSO" -Members Allen.Beeler
Add-ADGroupMember -identity "SSO" -Members kyle.linares
Add-ADGroupMember -identity "SSO" -Members Keith.Luttell
Add-ADGroupMember -identity "SSO" -Members Dylan.McNamee
Add-ADGroupMember -identity "SSO" -Members Doug.Quasny
Add-ADGroupMember -identity "SSO" -Members Lonnie.Stump
Add-ADGroupMember -identity "SSO" -Members thomas.twardowski
Add-ADGroupMember -identity "SSO" -Members Gise.VanBaren
Add-ADGroupMember -identity "SSO" -Members GrelewJF
Add-ADGroupMember -identity "SSO" -Members Bordonra
Add-ADGroupMember -identity "SSO" -Members Justin.Otero
Add-ADGroupMember -identity "SSO" -Members Rossjw
Add-ADGroupMember -identity "SSO" -Members Jack.Ziegler
Add-ADGroupMember -identity "SSO" -Members Robert.Adamski
Add-ADGroupMember -identity "SSO" -Members Chihakaa
Add-ADGroupMember -identity "SSO" -Members Les.Ciciora
Add-ADGroupMember -identity "SSO" -Members Roger.Hieser
Add-ADGroupMember -identity "SSO" -Members Janet.Honeywell
Add-ADGroupMember -identity "SSO" -Members Glen.Hoppe
Add-ADGroupMember -identity "SSO" -Members Brian.Mariska
Add-ADGroupMember -identity "SSO" -Members Micheljf
Add-ADGroupMember -identity "SSO" -Members andrew.russ
Add-ADGroupMember -identity "SSO" -Members Victor.Sibiga
Add-ADGroupMember -identity "SSO" -Members Joe.Weiner
Add-ADGroupMember -identity "SSO" -Members WilsonCA
Add-ADGroupMember -identity "SSO" -Members HodepeTL
Add-ADGroupMember -identity "SSO" -Members tom.webster
Add-ADGroupMember -identity "SSO" -Members Jason.Riehl
Add-ADGroupMember -identity "SSO" -Members AtkinsJD
Add-ADGroupMember -identity "SSO" -Members Clougheg
Add-ADGroupMember -identity "SSO" -Members andrew.gallagher
Add-ADGroupMember -identity "SSO" -Members Krakovlj
Add-ADGroupMember -identity "SSO" -Members Lytlemp
Add-ADGroupMember -identity "SSO" -Members Wesley.McCurdy
Add-ADGroupMember -identity "SSO" -Members Thomas.McKeown
Add-ADGroupMember -identity "SSO" -Members michael.paden
Add-ADGroupMember -identity "SSO" -Members Rothrj
Add-ADGroupMember -identity "SSO" -Members Torosiaa
Add-ADGroupMember -identity "SSO" -Members Justin.Walters
Add-ADGroupMember -identity "SSO" -Members Jeff.Zunich
Add-ADGroupMember -identity "SSO" -Members Aslanigm
Add-ADGroupMember -identity "SSO" -Members alexis.belbis
Add-ADGroupMember -identity "SSO" -Members Steve.Coons
Add-ADGroupMember -identity "SSO" -Members GonzalED
Add-ADGroupMember -identity "SSO" -Members Dan.Heberer
Add-ADGroupMember -identity "SSO" -Members peter.jug
Add-ADGroupMember -identity "SSO" -Members Connor.Loughlin
Add-ADGroupMember -identity "SSO" -Members Jackie.Luong
Add-ADGroupMember -identity "SSO" -Members RoweGF
Add-ADGroupMember -identity "SSO" -Members Hurstdl
Add-ADGroupMember -identity "SSO" -Members Failindj
Add-ADGroupMember -identity "SSO" -Members Harold.Kropp
Add-ADGroupMember -identity "SSO" -Members John.Mickinkle
Add-ADGroupMember -identity "SSO" -Members Nashad
Add-ADGroupMember -identity "SSO" -Members Sulzbamd
Add-ADGroupMember -identity "SSO" -Members WeinheSG
Add-ADGroupMember -identity "SSO" -Members Sortispd
Add-ADGroupMember -identity "SSO" -Members Adamsjk
Add-ADGroupMember -identity "SSO" -Members chris.arevalo
Add-ADGroupMember -identity "SSO" -Members DeakinJR
Add-ADGroupMember -identity "SSO" -Members GeorgeM
Add-ADGroupMember -identity "SSO" -Members Joe.Angeski
Add-ADGroupMember -identity "SSO" -Members Alex.Dunaway
Add-ADGroupMember -identity "SSO" -Members Bob.Wargo
Add-ADGroupMember -identity "SSO" -Members Matthew.Sands
Add-ADGroupMember -identity "SSO" -Members hayden.nigro
Add-ADGroupMember -identity "SSO" -Members Althoumj
Add-ADGroupMember -identity "SSO" -Members BalchaDM
Add-ADGroupMember -identity "SSO" -Members Bridgecj
Add-ADGroupMember -identity "SSO" -Members nicholas.briggs
Add-ADGroupMember -identity "SSO" -Members JankeyRW
Add-ADGroupMember -identity "SSO" -Members joseph.kalic
Add-ADGroupMember -identity "SSO" -Members Mike.Paulic
Add-ADGroupMember -identity "SSO" -Members Rogersja
Add-ADGroupMember -identity "SSO" -Members Chris.Soprano
Add-ADGroupMember -identity "SSO" -Members Tholete
Add-ADGroupMember -identity "SSO" -Members ThompsCJ
Add-ADGroupMember -identity "SSO" -Members Urankaaj
Add-ADGroupMember -identity "SSO" -Members Jeff.Hollinshead
Add-ADGroupMember -identity "SSO" -Members Nenet.Bautista
Add-ADGroupMember -identity "SSO" -Members ben.cash
Add-ADGroupMember -identity "SSO" -Members victor.guerrero
Add-ADGroupMember -identity "SSO" -Members Nestor.Hiso
Add-ADGroupMember -identity "SSO" -Members Johnsoje
Add-ADGroupMember -identity "SSO" -Members MayareD
Add-ADGroupMember -identity "SSO" -Members Pazdanjw
Add-ADGroupMember -identity "SSO" -Members Mark.Santillana
Add-ADGroupMember -identity "SSO" -Members Gary.Stamper
Add-ADGroupMember -identity "SSO" -Members Stephen.Wagner
Add-ADGroupMember -identity "SSO" -Members WinterWF
Add-ADGroupMember -identity "SSO" -Members Jimmy.Wood
Add-ADGroupMember -identity "SSO" -Members KuzmaJS
Add-ADGroupMember -identity "SSO" -Members Waltonjs
Add-ADGroupMember -identity "SSO" -Members BettinJ
Add-ADGroupMember -identity "SSO" -Members Browngt
Add-ADGroupMember -identity "SSO" -Members BrownTJ
Add-ADGroupMember -identity "SSO" -Members KeaneBM
Add-ADGroupMember -identity "SSO" -Members CookCC
Add-ADGroupMember -identity "SSO" -Members Tanner.Drees
Add-ADGroupMember -identity "SSO" -Members autumn.erme
Add-ADGroupMember -identity "SSO" -Members Feeneysm
Add-ADGroupMember -identity "SSO" -Members Fonsecmj
Add-ADGroupMember -identity "SSO" -Members Hammonmr
Add-ADGroupMember -identity "SSO" -Members reynoltl
Add-ADGroupMember -identity "SSO" -Members John.Hayes
Add-ADGroupMember -identity "SSO" -Members Hoyecl
Add-ADGroupMember -identity "SSO" -Members joseph.imre
Add-ADGroupMember -identity "SSO" -Members JimeneMJ
Add-ADGroupMember -identity "SSO" -Members jack.middleton
Add-ADGroupMember -identity "SSO" -Members Munjesr
Add-ADGroupMember -identity "SSO" -Members NortsTR
Add-ADGroupMember -identity "SSO" -Members Peacerj
Add-ADGroupMember -identity "SSO" -Members PorterMR
Add-ADGroupMember -identity "SSO" -Members RadtkeAJ
Add-ADGroupMember -identity "SSO" -Members Reamerda
Add-ADGroupMember -identity "SSO" -Members Rectordj
Add-ADGroupMember -identity "SSO" -Members Reinerjm
Add-ADGroupMember -identity "SSO" -Members Seibolgr
Add-ADGroupMember -identity "SSO" -Members StarkCJ
Add-ADGroupMember -identity "SSO" -Members Doug.Stieb
Add-ADGroupMember -identity "SSO" -Members StolleNW
Add-ADGroupMember -identity "SSO" -Members TerryAM
Add-ADGroupMember -identity "SSO" -Members Thompsba
Add-ADGroupMember -identity "SSO" -Members Troutbd
Add-ADGroupMember -identity "SSO" -Members WalterSM
Add-ADGroupMember -identity "SSO" -Members Warnecm
Add-ADGroupMember -identity "SSO" -Members Wilkinvp
Add-ADGroupMember -identity "SSO" -Members Witzkerm
Add-ADGroupMember -identity "SSO" -Members Ziskonm
Add-ADGroupMember -identity "SSO" -Members Schrinmj
Add-ADGroupMember -identity "SSO" -Members Ashama.Babooram
Add-ADGroupMember -identity "SSO" -Members Bowlinpa
Add-ADGroupMember -identity "SSO" -Members Steve.Caproni
Add-ADGroupMember -identity "SSO" -Members Flaughpl
Add-ADGroupMember -identity "SSO" -Members Forresmd
Add-ADGroupMember -identity "SSO" -Members Grubbkl
Add-ADGroupMember -identity "SSO" -Members Halljl
Add-ADGroupMember -identity "SSO" -Members Autumn.Hatcher
Add-ADGroupMember -identity "SSO" -Members HollanGA
Add-ADGroupMember -identity "SSO" -Members Kent.Mansfield
Add-ADGroupMember -identity "SSO" -Members MillerJK
Add-ADGroupMember -identity "SSO" -Members Darbyjd
Add-ADGroupMember -identity "SSO" -Members Greg.Furgala
Add-ADGroupMember -identity "SSO" -Members Bealmk
Add-ADGroupMember -identity "SSO" -Members Bradley.Cearing
Add-ADGroupMember -identity "SSO" -Members Kenneth.Dudzik
Add-ADGroupMember -identity "SSO" -Members ZatoWA
Add-ADGroupMember -identity "SSO" -Members chad.zimmerman
Add-ADGroupMember -identity "SSO" -Members Wes.Stewart
Add-ADGroupMember -identity "SSO" -Members jim.binder
Add-ADGroupMember -identity "SSO" -Members erik.cooley
Add-ADGroupMember -identity "SSO" -Members Eric.Mizer
Add-ADGroupMember -identity "SSO" -Members Michael.Sarver
Add-ADGroupMember -identity "SSO" -Members nicholas.trudeau
Add-ADGroupMember -identity "SSO" -Members Justin.Viola
Add-ADGroupMember -identity "SSO" -Members Lawrence.Amerson
Add-ADGroupMember -identity "SSO" -Members Patricia.Krupp
Add-ADGroupMember -identity "SSO" -Members joe.restivo
Add-ADGroupMember -identity "SSO" -Members Avionne.Weaver
Add-ADGroupMember -identity "SSO" -Members Kasickjc
Add-ADGroupMember -identity "SSO" -Members Cuculirj
Add-ADGroupMember -identity "SSO" -Members Daniel.Devadoss
Add-ADGroupMember -identity "SSO" -Members Dennis.Fundzak
Add-ADGroupMember -identity "SSO" -Members Jason.Jamil
Add-ADGroupMember -identity "SSO" -Members jamie.jurin
Add-ADGroupMember -identity "SSO" -Members Steve.Maggiano
Add-ADGroupMember -identity "SSO" -Members Palmerbj
Add-ADGroupMember -identity "SSO" -Members carlton.powell
Add-ADGroupMember -identity "SSO" -Members PrudenGA
Add-ADGroupMember -identity "SSO" -Members SosterBM
Add-ADGroupMember -identity "SSO" -Members Stephekt
Add-ADGroupMember -identity "SSO" -Members Nathen.Stevenson
Add-ADGroupMember -identity "SSO" -Members Jay.Veerasammy
Add-ADGroupMember -identity "SSO" -Members Weiganrk
Add-ADGroupMember -identity "SSO" -Members Eric.Whittaker
Add-ADGroupMember -identity "SSO" -Members Jim.Harrold
Add-ADGroupMember -identity "SSO" -Members rami.abualkheir
Add-ADGroupMember -identity "SSO" -Members OlsonGA
Add-ADGroupMember -identity "SSO" -Members Myra.Parayno
Add-ADGroupMember -identity "SSO" -Members Sinhask
Add-ADGroupMember -identity "SSO" -Members Jen.Smith
Add-ADGroupMember -identity "SSO" -Members Jalpan.Soni
Add-ADGroupMember -identity "SSO" -Members Sherkoh.Anz
Add-ADGroupMember -identity "SSO" -Members Garetymw
Add-ADGroupMember -identity "SSO" -Members lauren.weinberg
Add-ADGroupMember -identity "SSO" -Members Sweenejw
Add-ADGroupMember -identity "SSO" -Members PericD
Add-ADGroupMember -identity "SSO" -Members Jarrett.Feasley
Add-ADGroupMember -identity "SSO" -Members Overhorj
Add-ADGroupMember -identity "SSO" -Members jim.bereda
Add-ADGroupMember -identity "SSO" -Members trevor.misch
Add-ADGroupMember -identity "SSO" -Members jim.bender
Add-ADGroupMember -identity "SSO" -Members Nathan.Ingram
Add-ADGroupMember -identity "SSO" -Members Jim.Marshall
Add-ADGroupMember -identity "SSO" -Members hunter.voithofer
Add-ADGroupMember -identity "SSO" -Members sumita.pol
Add-ADGroupMember -identity "SSO" -Members ethan.miller
Add-ADGroupMember -identity "SSO" -Members Matt.Bedee
Add-ADGroupMember -identity "SSO" -Members Mike.Pollino
Add-ADGroupMember -identity "SSO" -Members AldridBC
Add-ADGroupMember -identity "SSO" -Members DavisJM
Add-ADGroupMember -identity "SSO" -Members Ecksteha
Add-ADGroupMember -identity "SSO" -Members andrew.javier
Add-ADGroupMember -identity "SSO" -Members kayan.kartoum
Add-ADGroupMember -identity "SSO" -Members Joe.Limon
Add-ADGroupMember -identity "SSO" -Members Thomas.Paprocki
Add-ADGroupMember -identity "SSO" -Members RedmonJM
Add-ADGroupMember -identity "SSO" -Members Shogresc
Add-ADGroupMember -identity "SSO" -Members Liuy
Add-ADGroupMember -identity "SSO" -Members kauveh.aynafshar
Add-ADGroupMember -identity "SSO" -Members CostanJL
Add-ADGroupMember -identity "SSO" -Members davisjl
Add-ADGroupMember -identity "SSO" -Members Durkindp
Add-ADGroupMember -identity "SSO" -Members Christian.Kanfeld
Add-ADGroupMember -identity "SSO" -Members Koniectl
Add-ADGroupMember -identity "SSO" -Members Lesleylr
Add-ADGroupMember -identity "SSO" -Members Kaleb.Myers
Add-ADGroupMember -identity "SSO" -Members Polcynam
Add-ADGroupMember -identity "SSO" -Members TaylorTR
Add-ADGroupMember -identity "SSO" -Members Matt.Wisniewski
Add-ADGroupMember -identity "SSO" -Members BihlJC
Add-ADGroupMember -identity "SSO" -Members Noah.Blain
Add-ADGroupMember -identity "SSO" -Members Carmen.Carr
Add-ADGroupMember -identity "SSO" -Members matt.locher
Add-ADGroupMember -identity "SSO" -Members Millerne
Add-ADGroupMember -identity "SSO" -Members Nick.Trout
Add-ADGroupMember -identity "SSO" -Members Endersmd
Add-ADGroupMember -identity "SSO" -Members jeff.ritter
Add-ADGroupMember -identity "SSO" -Members alex.lutz
Add-ADGroupMember -identity "SSO" -Members Max.Martin
Add-ADGroupMember -identity "SSO" -Members Mike.Robinson
Add-ADGroupMember -identity "SSO" -Members joshua.hines
Add-ADGroupMember -identity "SSO" -Members alex.higgins
Add-ADGroupMember -identity "SSO" -Members jonathan.vernon
Add-ADGroupMember -identity "SSO" -Members Sam.Bennett
Add-ADGroupMember -identity "SSO" -Members Gaertnmj
Add-ADGroupMember -identity "SSO" -Members GlivarJJ
Add-ADGroupMember -identity "SSO" -Members Sebekjj
Add-ADGroupMember -identity "SSO" -Members StalteDE
Add-ADGroupMember -identity "SSO" -Members ViancoME
Add-ADGroupMember -identity "SSO" -Members Yoergerw
Add-ADGroupMember -identity "SSO" -Members William.Foster
Add-ADGroupMember -identity "SSO" -Members adam.clark
Add-ADGroupMember -identity "SSO" -Members Mckenzrl
Add-ADGroupMember -identity "SSO" -Members mark.seifried
Add-ADGroupMember -identity "SSO" -Members HayesRJ
Add-ADGroupMember -identity "SSO" -Members Lowrydp
Add-ADGroupMember -identity "SSO" -Members rob.hattabaugh
Add-ADGroupMember -identity "SSO" -Members Bob.Necciai
Add-ADGroupMember -identity "SSO" -Members melissa.foster
Add-ADGroupMember -identity "SSO" -Members YoungKE
Add-ADGroupMember -identity "SSO" -Members Melilllm
Add-ADGroupMember -identity "SSO" -Members zech.zupancic
Add-ADGroupMember -identity "SSO" -Members Caitlyn.Sullivan
Add-ADGroupMember -identity "SSO" -Members DyeSL
Add-ADGroupMember -identity "SSO" -Members HillMG
Add-ADGroupMember -identity "SSO" -Members Hilbercr
Add-ADGroupMember -identity "SSO" -Members Denise.SetteurSpurio
Add-ADGroupMember -identity "SSO" -Members Ledinje
Add-ADGroupMember -identity "SSO" -Members Podhorrl
Add-ADGroupMember -identity "SSO" -Members Szalkomg
Add-ADGroupMember -identity "SSO" -Members Blairtg
Add-ADGroupMember -identity "SSO" -Members brad.daugharthy
Add-ADGroupMember -identity "SSO" -Members Olschlre
Add-ADGroupMember -identity "SSO" -Members Schmidrc
Add-ADGroupMember -identity "SSO" -Members Michael.Vargas
Add-ADGroupMember -identity "SSO" -Members Wiszjl
Add-ADGroupMember -identity "SSO" -Members Wisniesp
Add-ADGroupMember -identity "SSO" -Members Anthony.Gigante
Add-ADGroupMember -identity "SSO" -Members Leonarcm
Add-ADGroupMember -identity "SSO" -Members Olesicka
Add-ADGroupMember -identity "SSO" -Members Payneke
Add-ADGroupMember -identity "SSO" -Members Chris.Puleo
Add-ADGroupMember -identity "SSO" -Members Josh.Rice
Add-ADGroupMember -identity "SSO" -Members Zdolshtl
Add-ADGroupMember -identity "SSO" -Members Dankoww
Add-ADGroupMember -identity "SSO" -Members Kathleen.Anderson
Add-ADGroupMember -identity "SSO" -Members Jennifer.Valek
Add-ADGroupMember -identity "SSO" -Members StonemPJ
Add-ADGroupMember -identity "SSO" -Members Jackie.Morris
Add-ADGroupMember -identity "SSO" -Members Keyana.Williams
Add-ADGroupMember -identity "SSO" -Members Rob.Tibbitts
Add-ADGroupMember -identity "SSO" -Members Ledinrr
Add-ADGroupMember -identity "SSO" -Members OconnoDP
Add-ADGroupMember -identity "SSO" -Members Wendelce
Add-ADGroupMember -identity "SSO" -Members Chris.Moran
Add-ADGroupMember -identity "SSO" -Members Kory.Siverd
Add-ADGroupMember -identity "SSO" -Members Todd.Alfonso
Add-ADGroupMember -identity "SSO" -Members Andy.Minderman
Add-ADGroupMember -identity "SSO" -Members ReedEL
Add-ADGroupMember -identity "SSO" -Members Quenton.Strickland
Add-ADGroupMember -identity "SSO" -Members CarneySP
Add-ADGroupMember -identity "SSO" -Members Bonerich
Add-ADGroupMember -identity "SSO" -Members BellTR
Add-ADGroupMember -identity "SSO" -Members Carnsjj
Add-ADGroupMember -identity "SSO" -Members Brad.Ingram
Add-ADGroupMember -identity "SSO" -Members Newmankj
Add-ADGroupMember -identity "SSO" -Members Gary.Row
Add-ADGroupMember -identity "SSO" -Members SmithBM
Add-ADGroupMember -identity "SSO" -Members GawronRT
Add-ADGroupMember -identity "SSO" -Members JaraczJP
Add-ADGroupMember -identity "SSO" -Members Patrick.Keenan
Add-ADGroupMember -identity "SSO" -Members Mario.Hernandez
Add-ADGroupMember -identity "SSO" -Members Otto.Wenzel
Add-ADGroupMember -identity "SSO" -Members Michael.Deinhammer
Add-ADGroupMember -identity "SSO" -Members Jeff.Fesko
Add-ADGroupMember -identity "SSO" -Members Justin.Pistininzi
Add-ADGroupMember -identity "SSO" -Members Shawn.Rudy
Add-ADGroupMember -identity "SSO" -Members Zach.Sadowski
Add-ADGroupMember -identity "SSO" -Members Keyta
Add-ADGroupMember -identity "SSO" -Members Meyersmj
Add-ADGroupMember -identity "SSO" -Members Joschtlc
Add-ADGroupMember -identity "SSO" -Members cathy.sullivan
Add-ADGroupMember -identity "SSO" -Members cookke
Add-ADGroupMember -identity "SSO" -Members FryNL
Add-ADGroupMember -identity "SSO" -Members Lowryma
Add-ADGroupMember -identity "SSO" -Members Magrumlp
Add-ADGroupMember -identity "SSO" -Members Mclauge
Add-ADGroupMember -identity "SSO" -Members pendleet
Add-ADGroupMember -identity "SSO" -Members Stahlcw
Add-ADGroupMember -identity "SSO" -Members Tielldm
Add-ADGroupMember -identity "SSO" -Members Waynepj
Add-ADGroupMember -identity "SSO" -Members WitzkeTR
Add-ADGroupMember -identity "SSO" -Members Reganlm
Add-ADGroupMember -identity "SSO" -Members Elena.Graupera
Add-ADGroupMember -identity "SSO" -Members elaine.molinengo
Add-ADGroupMember -identity "SSO" -Members Riedeltw
Add-ADGroupMember -identity "SSO" -Members Marisha.Baldwin
Add-ADGroupMember -identity "SSO" -Members patrick.conner
Add-ADGroupMember -identity "SSO" -Members Laurie.Jones
Add-ADGroupMember -identity "SSO" -Members FaulknAM
Add-ADGroupMember -identity "SSO" -Members Devriejc
Add-ADGroupMember -identity "SSO" -Members Gravesrm
Add-ADGroupMember -identity "SSO" -Members Zapataem
Add-ADGroupMember -identity "SSO" -Members Mclaugma
Add-ADGroupMember -identity "SSO" -Members todd.chaney
Add-ADGroupMember -identity "SSO" -Members Sam.Blood
Add-ADGroupMember -identity "SSO" -Members Russ.Kosis
Add-ADGroupMember -identity "SSO" -Members PutnamKA
Add-ADGroupMember -identity "SSO" -Members Sebonimj
Add-ADGroupMember -identity "SSO" -Members ryan.byers
Add-ADGroupMember -identity "SSO" -Members CullerTL
Add-ADGroupMember -identity "SSO" -Members allison.hassig
Add-ADGroupMember -identity "SSO" -Members SilajSM
Add-ADGroupMember -identity "SSO" -Members Ed.Curtis
Add-ADGroupMember -identity "SSO" -Members Glenn.Bettens
Add-ADGroupMember -identity "SSO" -Members Buzz.Seydel
Add-ADGroupMember -identity "SSO" -Members Bill.Celian
Add-ADGroupMember -identity "SSO" -Members Matt.Morgan
Add-ADGroupMember -identity "SSO" -Members steven.sharp
Add-ADGroupMember -identity "SSO" -Members Bogaersm
Add-ADGroupMember -identity "SSO" -Members Bryan.Thomas
Add-ADGroupMember -identity "SSO" -Members MullenMA
Add-ADGroupMember -identity "SSO" -Members Mike.Picardi
Add-ADGroupMember -identity "SSO" -Members Khaterjm
Add-ADGroupMember -identity "SSO" -Members Blackjl
Add-ADGroupMember -identity "SSO" -Members Greg.Pertle
Add-ADGroupMember -identity "SSO" -Members Streitgj
Add-ADGroupMember -identity "SSO" -Members WrightPJ
Add-ADGroupMember -identity "SSO" -Members James.Rossi
Add-ADGroupMember -identity "SSO" -Members Weinhejr
Add-ADGroupMember -identity "SSO" -Members PiperCR
Add-ADGroupMember -identity "SSO" -Members UttechMJ
Add-ADGroupMember -identity "SSO" -Members Frederjw
Add-ADGroupMember -identity "SSO" -Members jeff.malek
Add-ADGroupMember -identity "SSO" -Members Mayerkm
Add-ADGroupMember -identity "SSO" -Members David.Schmidt
Add-ADGroupMember -identity "SSO" -Members Strosnrl
Add-ADGroupMember -identity "SSO" -Members Geresbc
Add-ADGroupMember -identity "SSO" -Members Walterja
Add-ADGroupMember -identity "SSO" -Members David.Woodnorth
Add-ADGroupMember -identity "SSO" -Members Dreiergp
Add-ADGroupMember -identity "SSO" -Members Lenharbd
Add-ADGroupMember -identity "SSO" -Members Postacj
Add-ADGroupMember -identity "SSO" -Members Rabquewa
Add-ADGroupMember -identity "SSO" -Members Winklekm
Add-ADGroupMember -identity "SSO" -Members Flanertk
Add-ADGroupMember -identity "SSO" -Members Hoggeml
Add-ADGroupMember -identity "SSO" -Members Salowma
Add-ADGroupMember -identity "SSO" -Members Bob.Smering
Add-ADGroupMember -identity "SSO" -Members jeff.caldwell
Add-ADGroupMember -identity "SSO" -Members James.Korba
Add-ADGroupMember -identity "SSO" -Members John.Rotroff
Add-ADGroupMember -identity "SSO" -Members john.seaman
Add-ADGroupMember -identity "SSO" -Members Joseph.Julian
Add-ADGroupMember -identity "SSO" -Members Kevin.Moore
Add-ADGroupMember -identity "SSO" -Members jeremy.smith
Add-ADGroupMember -identity "SSO" -Members Perlaaj
Add-ADGroupMember -identity "SSO" -Members Samantha.Fox
Add-ADGroupMember -identity "SSO" -Members shannon.owen
Add-ADGroupMember -identity "SSO" -Members jason.lamb

(Get-ADGroup "sso" -Properties *).Member.Count

Get-ADDefaultDomainPasswordPolicy

Add-ADGroupMember -identity "cle_670_mngr" -Members cle_stm_admin
Add-ADGroupMember -identity CHI_820_Mngr -Members chi_stm_admin
Add-ADGroupMember -identity CLE_820_Mngr -Members cle_stm_admin
Add-ADGroupMember -identity NWI_820_Mngr -Members nwi_stm_admin
Add-ADGroupMember -identity PIT_820_Mngr -Members pit_stm_admin
Add-ADGroupMember -identity TOL_820_Mngr -Members tol_stm_admin
Add-ADGroupMember -identity CHI_821_Mngr -Members chi_stm_admin
Add-ADGroupMember -identity CHI_840_Mngr -Members chi_stm_admin
Add-ADGroupMember -identity CLE_840_Mngr -Members cle_stm_admin
Add-ADGroupMember -identity CHI_870_Mngr -Members chi_stm_admin
Add-ADGroupMember -identity CLE_870_Mngr -Members cle_stm_admin
Add-ADGroupMember -identity CHI_899_Mngr -Members chi_stm_admin
Add-ADGroupMember -identity CLE_899_Mngr -Members cle_stm_admin
Add-ADGroupMember -identity ASH_900_Mngr -Members ash_stm_admin
Add-ADGroupMember -identity BUF_900_Mngr -Members buf_stm_admin
Add-ADGroupMember -identity CHI_900_Mngr -Members chi_stm_admin
Add-ADGroupMember -identity CLE_900_Mngr -Members cle_stm_admin
Add-ADGroupMember -identity MAD_900_Mngr -Members mad_stm_admin
Add-ADGroupMember -identity NWI_900_Mngr -Members nwi_stm_admin
Add-ADGroupMember -identity PIT_900_Mngr -Members pit_stm_admin
Add-ADGroupMember -identity TOL_900_Mngr -Members tol_stm_admin

Add-ADGroupMember -identity CHI_930_Mngr -Members chi_699_mngr, chi_799_mngr
Add-ADGroupMember -identity CLE_930_Mngr -Members chi_699_mngr, chi_799_mngr
Add-ADGroupMember -identity PIT_930_Mngr -Members chi_699_mngr, chi_799_mngr


set-aduser -identity cookke -manager Waltonjs
set-aduser -identity FryNL -manager Waltonjs
set-aduser -identity Lowryma -manager Waltonjs
set-aduser -identity Magrumlp -manager Waltonjs
set-aduser -identity Mclauge -manager Waltonjs
set-aduser -identity pendleet -manager Waltonjs
set-aduser -identity Stahlcw -manager Waltonjs
set-aduser -identity Tielldm -manager Waltonjs
set-aduser -identity Waynepj -manager Waltonjs
set-aduser -identity WitzkeTR -manager Waltonjs

set-aduser -identity -manager George.Washington

Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Cloyeswg
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members alex.lutz
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members andrew.gallagher
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Andy.Minderman
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members AtkinsJD
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Avionne.Weaver
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members BalchaDM
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members BettinJ
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Bradley.Cearing
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members brian.young
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Bridendj
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Bridgecj
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members bryan.king
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Chris.Muntz
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Curtis.Merow
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Dane.Rasmussen
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Daniel.Devadoss
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members DeakinJR
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Dennis.Fundzak
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members elaine.molinengo
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Endersmd
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Failindj
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members GoodJP
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Igor.Moskalow
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Jack.Ziegler
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Jackie.Kolling
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members jamie.jurin
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members JankeyRW
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Jason.Jamil
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Jeff.Fesko
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Jeff.Hollinshead
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members jim.bender
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members JimeneMJ
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Josh.Ritchey
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Justin.Otero
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Justin.Viola
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Justin.Walters
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members KeehnGA
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Keyta
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Lenny.Laird
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Lytlemp
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Matt.Bedee
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Mckenzrl
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Michael.Sarver
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Mike.Paulic
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Molly.Green
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Nathan.Ingram
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members nicholas.trudeau
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members nick.arnold
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members PiperCR
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members RawsonBY
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Richard.Genser
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Rogersja
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members SefcikKP
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Shawn.Rudy
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members StolleNW
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Tholete
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Thomas.McKeown
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Tyler.Baird
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Urankaaj
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Voytkotl
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Weiganrk
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Wes.Stewart
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Wesley.McCurdy
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members Wisniesp
Add-ADGroupMember -identity "Autodesk Desktop Connector" -Members michelle.casto


set-aduser -identity brian.young -manager Khaterjm
set-aduser -identity Hoppelcl -manager Khaterjm
set-aduser -identity Cindy.Smith -manager Khaterjm
set-aduser -identity Hlavacgm -manager Khaterjm
set-aduser -identity Igor.Moskalow -manager Khaterjm
set-aduser -identity Kordahyk -manager Khaterjm
set-aduser -identity Kilbyjw -manager Khaterjm
set-aduser -identity Kathy.Olle -manager Khaterjm
set-aduser -identity Friedmm -manager Khaterjm
set-aduser -identity Pienostm -manager Khaterjm
set-aduser -identity Voytkotl -manager Khaterjm

set-aduser -identity Blackjl -title "Sr. Major Projects Manager"
set-aduser -identity Greg.Pertle -title "Sr. Major Projects Manager"
set-aduser -identity Streitgj -title "Sr. Major Projects Manager"
set-aduser -identity WrightPJ -title "Sr. Major Projects Manager"


New-ADUser -Name “Shawn Dishauzi" -GivenName "Shawn" -Surname "Dishauzi" -displayname "Shawn Dishauzi" -SamAccountName "shawn.dishauzi" -path "OU=890,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "shawn.dishauzi@middough.com" -department "890.01 CLE Health & Safety" -office "Cleveland" -state "OH" -initials "SD" -StreetAddress "1901 E 13th St, Ste 400" -City "Cleveland" -PostalCode "44114" -title "Director " -company "Middough" -manager "mark.seifried" ;set-aduser "shawn.dishauzi" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members shawn.dishauzi;; Add-ADGroupMember -identity CLE_890 -members shawn.dishauzi;; Add-ADGroupMember -identity "SSO" -members shawn.dishauzi
New-ADUser -Name “Shawn Dishauzi" -GivenName "Shawn" -Surname "Dishauzi" -displayname "Shawn Dishauzi" -SamAccountName "shawn.dishauzi" -path "OU=890,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "shawn.dishauzi@middough.com" -department "890.01 CLE Health & Safety" -office "Cleveland" -state "OH" -initials "SD" -StreetAddress "1901 E 13th St, Ste 400" -City "Cleveland" -PostalCode "44114" -title "Director " -company "Middough" -manager "mark.seifried"" -officephone "216-367-6226";set-aduser "shawn.dishauzi" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members shawn.dishauzi;; Add-ADGroupMember -identity CLE_890 -members shawn.dishauzi;; Add-ADGroupMember -identity "SSO" -members shawn.dishauzi


set-aduser -Identity shawn.dishauzi -OfficePhone "216-367-6226"

New-ADUser -Name “Shawn Dishauzi" -GivenName "Shawn" -Surname "Dishauzi" -displayname "Shawn Dishauzi" -SamAccountName "shawn.dishauzi" -path "OU=890,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "shawn.dishauzi@middough.com" -department "890.01 CLE Health & Safety" -office "Cleveland" -state "OH" -initials "SD" -StreetAddress "1901 E 13th St, Ste 400" -City "Cleveland" -PostalCode "44114" -title "Director " -company "Middough" -manager "mark.seifried"" -officephone "216-367-6226"


New-ADUser -Name “It Testps" -GivenName "It" -Surname "Testps" -displayname "It Testps" -SamAccountName "it.testps" -path "OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "it.testps@middough.com" -department "740.01 CLE IT" -office "Cleveland" -state "OH" -initials "IT" -StreetAddress "1901 E 13th St, Ste 400" -City "Cleveland" -PostalCode "44114" -title "Test" -company "Middough" -manager "jason.lamb" -officephone "216-367-1234"; set-aduser "it.testps" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members it.testps; Add-ADGroupMember -identity "CAD Applications" -members it.testps; Add-ADGroupMember -identity "Engineering_Dept" -members it.testps; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members it.testps; Add-ADGroupMember -identity CLE_740 -members it.testps;; Add-ADGroupMember -identity "SSO" -members it.testps

New-ADUser -Name “It Testps" -GivenName "It" -Surname "Testps" -displayname "It Testps" -SamAccountName "it.testps" -path "OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "it.testps@middough.com" -department "740.01 CLE IT" -office "Cleveland" -state "OH" -initials "IT" -StreetAddress "1901 E 13th St, Ste 400" -City "Cleveland" -PostalCode "44114" -title "Test" -company "Middough" -manager "jason.lamb" -officephone "216-367-1234";set-aduser "it.testps" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members it.testps; Add-ADGroupMember -identity "CAD Applications" -members it.testps; Add-ADGroupMember -identity "Engineering_Dept" -members it.testps; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members it.testps; Add-ADGroupMember -identity CLE_740 -members it.testps;; Add-ADGroupMember -identity "SSO" -members it.testps
New-ADUser -Name “It Testps" -GivenName "It" -Surname "Testps" -displayname "It Testps" -SamAccountName "it.testps" -path "OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "it.testps@middough.com" -department "740.01 CLE IT" -office "Cleveland" -state "OH" -initials "IT" -StreetAddress "1901 E 13th St, Ste 400" -City "Cleveland" -PostalCode "44114" -title "Test" -company "Middough" -manager "jason.lamb" -officephone "216-367-1234";set-aduser "it.testps" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members it.testps; Add-ADGroupMember -identity "CAD Applications" -members it.testps; Add-ADGroupMember -identity "Engineering_Dept" -members it.testps; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members it.testps; Add-ADGroupMember -identity CLE_740 -members it.testps;; Add-ADGroupMember -identity "SSO" -members it.testps



New-ADUser -Name “Kim Morphew" -GivenName "Kim" -Surname "Morphew" -displayname "Kim Morphew" -SamAccountName "kim.morphew" -path "OU=810,OU=CHI,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "kim.morphew@middough.com" -department "810.02 CHI Document Controls" -office "Chicago" -state "IL" -initials "KM" -StreetAddress "700 Commerce Dr, Ste 200" -City "Oak Brook" -PostalCode "60523" -title "Document Controls Specialist" -company "Middough" -manager "WrightPJ" -officephone "630-756-7110";set-aduser "kim.morphew" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members kim.morphew;; Add-ADGroupMember -identity CHI_810 -members kim.morphew;; Add-ADGroupMember -identity "SSO" -members kim.morphew


New-ADGroup -Name "ORACLE-TC" -SamAccountName ORACLE-TC -GroupCategory Security -GroupScope Global -DisplayName "ORACLE-TC" -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group are RODC Administrators"; Add-ADGroupMember -identity "oracle-tc" -Members cullertl


New-ADGroup -Name ORACLE-WD -SamAccountName ORACLE-WD -GroupCategory Security -GroupScope Global -DisplayName ORACLE-WD -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-WD";  Add-ADGroupMember -identity ORACLE-WD -Members Dankoww
New-ADGroup -Name ORACLE-CL -SamAccountName ORACLE-CL -GroupCategory Security -GroupScope Global -DisplayName ORACLE-CL -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-CL";  Add-ADGroupMember -identity ORACLE-CL -Members Leonarcm
New-ADGroup -Name ORACLE-TZ -SamAccountName ORACLE-TZ -GroupCategory Security -GroupScope Global -DisplayName ORACLE-TZ -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-TZ";  Add-ADGroupMember -identity ORACLE-TZ -Members Zdolshtl
New-ADGroup -Name ORACLE-AG -SamAccountName ORACLE-AG -GroupCategory Security -GroupScope Global -DisplayName ORACLE-AG -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-AG";  Add-ADGroupMember -identity ORACLE-AG -Members Anthony.Gigante
New-ADGroup -Name ORACLE-KO -SamAccountName ORACLE-KO -GroupCategory Security -GroupScope Global -DisplayName ORACLE-KO -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-KO";  Add-ADGroupMember -identity ORACLE-KO -Members Olesicka
New-ADGroup -Name ORACLE-CP -SamAccountName ORACLE-CP -GroupCategory Security -GroupScope Global -DisplayName ORACLE-CP -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-CP";  Add-ADGroupMember -identity ORACLE-CP -Members Chris.Puleo
New-ADGroup -Name ORACLE-KP -SamAccountName ORACLE-KP -GroupCategory Security -GroupScope Global -DisplayName ORACLE-KP -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-KP";  Add-ADGroupMember -identity ORACLE-KP -Members Payneke
New-ADGroup -Name ORACLE-JR -SamAccountName ORACLE-JR -GroupCategory Security -GroupScope Global -DisplayName ORACLE-JR -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-JR";  Add-ADGroupMember -identity ORACLE-JR -Members Josh.Rice
New-ADGroup -Name ORACLE-JL -SamAccountName ORACLE-JL -GroupCategory Security -GroupScope Global -DisplayName ORACLE-JL -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-JL";  Add-ADGroupMember -identity ORACLE-JL -Members Ledinje
New-ADGroup -Name ORACLE-CH -SamAccountName ORACLE-CH -GroupCategory Security -GroupScope Global -DisplayName ORACLE-CH -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-CH";  Add-ADGroupMember -identity ORACLE-CH -Members Hilbercr
New-ADGroup -Name ORACLE-RS -SamAccountName ORACLE-RS -GroupCategory Security -GroupScope Global -DisplayName ORACLE-RS -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-RS";  Add-ADGroupMember -identity ORACLE-RS -Members Rosario.Scibona
New-ADGroup -Name ORACLE-KY -SamAccountName ORACLE-KY -GroupCategory Security -GroupScope Global -DisplayName ORACLE-KY -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-KY";  Add-ADGroupMember -identity ORACLE-KY -Members YoungKE
New-ADGroup -Name ORACLE-LM -SamAccountName ORACLE-LM -GroupCategory Security -GroupScope Global -DisplayName ORACLE-LM -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-LM";  Add-ADGroupMember -identity ORACLE-LM -Members Melilllm
New-ADGroup -Name ORACLE-CS -SamAccountName ORACLE-CS -GroupCategory Security -GroupScope Global -DisplayName ORACLE-CS -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-CS";  Add-ADGroupMember -identity ORACLE-CS -Members Caitlyn.Sullivan
New-ADGroup -Name ORACLE-LK -SamAccountName ORACLE-LK -GroupCategory Security -GroupScope Global -DisplayName ORACLE-LK -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-LK";  Add-ADGroupMember -identity ORACLE-LK -Members Lindsay.Kaminski
New-ADGroup -Name ORACLE-MF -SamAccountName ORACLE-MF -GroupCategory Security -GroupScope Global -DisplayName ORACLE-MF -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE-MF";  Add-ADGroupMember -identity ORACLE-MF -Members melissa.foster


Add-ADGroupMember -identity "CAD Applications" -members logan.cover; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members logan.cover; 


StreetAddress "2000 Westinghouse Dr, Ste 202" -City "Cranberry Township" -PostalCode "16066" -title "Engineer" -company "Middough" -manager "Cloyeswg";;;; Add-ADGroupMember -identity PIT_400 -members matt.sands;; Add-ADGroupMember -identity "SSO" -members matt.sands
set-aduser "matt.sands" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members matt.sands;; Add-ADGroupMember -identity PIT_400 -members matt.sands; Add-ADGroupMember -identity "Engineering_Dept" -members matt.sands; Add-ADGroupMember -identity "SSO" -members matt.sands


set-ADUser -Name “Brandon Magnusen" -GivenName "Brandon" -Surname "Magnusen" -displayname "Brandon Magnusen" -SamAccountName "brandon.magnusen" -path "OU=100,OU=NWI,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "brandon.magnusen@middough.com" -department "100.08 IND Structural" -office "Indiana" -state "IN" -initials "BM" -StreetAddress "1433 E 83rd Ave, Ste 100" -City "Merrillville" -PostalCode "46410" -title "Engineer" -company "Middough" -manager "MakinsAP"
set-aduser "brandon.magnusen" -Replace @{c="US";co="United States";countrycode=840}


set-ADUser -identity "Chihakaa" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Perlaaj" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "FaulknAM" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "allison.hassig" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Shkurtav" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Ashwin.Patel" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "AldridBC" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Geresbc" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "TurneyBK" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Buzz.Seydel" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Caitlyn.Sullivan" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Wendelce" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "cathy.sullivan" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "charlie.amaro" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "RyanCD" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Connor.Loughlin" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "WilsonCA" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Dan.Heberer" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Bridendj" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Hurstdl" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "MayareD" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "David.Woodnorth" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "derek.nyenhuis" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "drew.zimmerman" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Ed.Curtis" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "MastanEJ" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Emmanuel.Paredes" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "GonzalED" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "OlsonGA" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Gary.Stamper" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "RoweGF" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Streitgj" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Glen.Hoppe" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Ecksteha" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Jalpan.Soni" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Blackjl" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "James.Rossi" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Janet.Honeywell" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "KuzmaJS" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Jen.Smith" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Pazdanjw" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Wiszjl" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Johnsoje" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Jimmy.Wood" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Joe.Weiner" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Micheljf" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Jon.Beskin" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "RedmonJM" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Walterja" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "WraseJW" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Braunske" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "kayan.kartoum" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "PutnamKA" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "kim.morphew" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Cussenkg" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Laurie.Jones" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Li.Yan" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Marisha.Baldwin" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Mark.Santillana" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Michael.Deinhammer" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "HillMG" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Sebonimj" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "SmithMJ" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Michael.Vargas" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Myra.Parayno" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Nenet.Bautista" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Nestor.Hiso" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "patrick.conner" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "WrightPJ" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "rich.phillips" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Bonerich" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "HayesRJ" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Robert.Adamski" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "DavidsRJ" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Robert.Kirkpatrick" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "robert.leugers" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "robert_davidson" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Roger.Hieser" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Santiago.Villegas" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "CarneySP" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Stephen.Wagner" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Bogaersm" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Shogresc" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Sinhask" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "SilajSM" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "BellTR" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Thomas.Paprocki" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "HodepeTL" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "victor.guerrero" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Victor.Sibiga" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "WinterWF" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "yafei.liu" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"
set-ADUser -identity "Liuy" -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" -state "IL"


Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members logan.cover
Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members logan.cover 


Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members alex.lutz
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Bob.Necciai
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Chris.Hennessey
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Chris.Muntz
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Curtis.Merow
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Dane.Rasmussen
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Endersmd
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jackie.Kolling
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jeremy.smith
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jim.bender
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Josh.Palyo
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Justin.Pistininzi
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Justin.Viola
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Lenny.Laird
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Michael.Sarver
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Molly.Green
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Nathan.Ingram
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members nicholas.trudeau
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members nick.arnold
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Richard.Genser
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Sam.Blood
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Samantha.Fox
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members sean.godfrey
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members shannon.owen
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Shawn.Rudy
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Wes.Stewart
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members PiperCR
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jeff.Fesko
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jim.Thomas
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Tiffany.Malcom
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jeff.peters

===
1/25/24
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Matt.Bedee
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members rana.kalaji
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Justin.Walters
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Bridgecj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members kevin.kerline
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members norm.jaworski
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members carlton.powell
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members adam.shands
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members brad.daugharthy
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jason.lamb
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Szalkomg
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Olschlre
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Blairtg
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Podhorrl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Schmidrc
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members sam.barnes
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members shawn.dishauzi


1/24/25 User update

set-aduser -identity RadtkeAJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Walterac -manager Lowrydp -title "Tech Manager" -department "100.05 ASH Structural"
set-aduser -identity Adam.Smith -manager Sortispd -title "Discipline Manager" -department "100.06 BUF Structural"
set-aduser -identity adam.clark -manager jamie.jurin -title "Sr. Engineer" -department "670.10 MIN Power"
set-aduser -identity Chihakaa -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Polcynam -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Perlaaj -manager HayesRJ -title "Vice President & BDD" -department "930.02 CHI Business Development"
set-aduser -identity Urankaaj -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity alex.lutz -manager Bob.Necciai -title "Sr. Engineer" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity FaulknAM -manager WrightPJ -title "Discipline Manager" -department "820.02 CHI Project Controls"
set-aduser -identity Allen.Beeler -manager GrelewJF -title "Project Engineer" -department "125.08 IND Asset Integrity"
set-aduser -identity allison.hassig -manager WrightPJ -title "Discipline Manager" -department "840.02 CHI Procurement"
set-aduser -identity Shkurtav -manager TurneyBK -title "Discipline Manager" -department "100.02 CHI Structural"
set-aduser -identity AugisAV -manager Jeff.Hollinshead -title "Project Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity MakinsAP -manager LantinZL -title "Discipline Manager" -department "100.08 IND Structural"
set-aduser -identity andrew.gallagher -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Andy.Minderman -manager Mayerkm -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Nashad -manager Adamsjk -title "Staff Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Anthony.Gigante -manager Dankoww -title "Accounting Specialist" -department "750.01 CLE Accounting"
set-aduser -identity Torosiaa -manager Bridgecj -title "Staff Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Ashama.Babooram -manager Darbyjd -title "Engineer" -department "425.05 ASH Piping"
set-aduser -identity TerryAM -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Ashwin.Patel -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity Bob.Necciai -manager Wendelce -title "Senior Vice President & GM" -department "699.27 PIT Overhead"
set-aduser -identity Autumn.Hatcher -manager Darbyjd -title "Drafter" -department "425.05 ASH Piping"
set-aduser -identity Avionne.Weaver -manager Jeff.Hollinshead -title "Intern" -department "475.01 CLE Automation"
set-aduser -identity Palmerbj -manager KruppBE -title "Designer" -department "600.01 CLE Electrical"
set-aduser -identity ben.mccoy -manager Adam.Smith -title "Engineer" -department "100.06 BUF Structural"
set-aduser -identity Thompsba -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Troutbd -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity AldridBC -manager Liuy -title "Specialist" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Geresbc -manager HayesRJ -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity Bradley.Cearing -manager LantinZL -title "Designer" -department "425.08 IND Piping"
set-aduser -identity brad.daugharthy -manager Podhorrl -title "IT Generalist" -department "740.01 CLE Information Technology"
set-aduser -identity Brad.Ingram -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Lenharbd -manager Lowrydp -title "Sr. Project Director" -department "900.03 TOL SPM"
set-aduser -identity brian.young -manager Khaterjm -title "Sr. Designer" -department "100.01 CLE Structural"
set-aduser -identity SmithBM -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity TurneyBK -manager HayesRJ -title "Sr. Technical Manager" -department "100.02 CHI Structural"
set-aduser -identity KruppBE -manager Khaterjm -title "Sr. Discipline Director" -department "600.01 CLE Electrical"
set-aduser -identity Bryan.Thomas -manager Khaterjm -title "Sr. Specialist" -department "890.01 TOL Health & Safety"
set-aduser -identity RawsonBY -manager SefcikKP -title "Sr. Designer" -department "200.01 CLE Civil"
set-aduser -identity Caitlyn.Sullivan -manager YoungKE -title "Human Resources Manager" -department "710.02 CHI Human Resources"
set-aduser -identity Wendelce -manager Ledinrr -title "Executive Vice President & COO" -department "799.02 CHI Corp Executives"
set-aduser -identity carlton.powell -manager KruppBE -title "Intern" -department "600.01 CLE Electrical"
set-aduser -identity Carmen.Carr -manager Walterac -title "Sr. Specialist" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity cathy.sullivan -manager WrightPJ -title "Document Controls Coordinator" -department "810.02 CHI Document Control"
set-aduser -identity ThompsCJ -manager Mckenzrl -title "Designer" -department "425.01 CLE Piping"
set-aduser -identity chad.zimmerman -manager LantinZL -title "Sr. Specialist" -department "425.08 IND Piping"
set-aduser -identity Hoppelcl -manager Khaterjm -title "Sr. Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity Bridgecj -manager Khaterjm -title "Project Engineer" -department "425.01 CLE Piping"
set-aduser -identity CookCC -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Stahlcw -manager Waltonjs -title "Document Controls Coordinator" -department "810.03 TOL Document Control"
set-aduser -identity Pondca -manager Granatpj -title "Designer" -department "100.03 TOL Structural"
set-aduser -identity matt.locher -manager Walterac -title "Sr. Specialist" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Postacj -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Christian.Kanfeld -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Hilbercr -manager Ledinje -title "IS Generalist" -department "720.01 CLE MIS"
set-aduser -identity Leonarcm -manager Dankoww -title "Accounting Specialist" -department "750.01 CLE Accounting"
set-aduser -identity RyanCD -manager Shkurtav -title "Project Engineer" -department "100.02 CHI Structural"
set-aduser -identity Chris.Hennessey -manager Endersmd -title "Discipline Manager" -department "100.27 PIT Structural"
set-aduser -identity Chris.Muntz -manager Chris.Hennessey -title "Specialist" -department "100.27 PIT Structural"
set-aduser -identity YoungCS -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity Chris.Soprano -manager Mckenzrl -title "Sr. Specialist" -department "425.01 CLE Piping"
set-aduser -identity StarkCJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Warnecm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Chris.Puleo -manager Dankoww -title "Accounting Generalist" -department "750.01 CLE Accounting"
set-aduser -identity Chris.Moran -manager David.Schmidt -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity PiperCR -manager Bob.Necciai -title "Director" -department "899.27 PIT SMM"
set-aduser -identity Hoyecl -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Connor.Loughlin -manager Hurstdl -title "Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity WilsonCA -manager HodepeTL -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Curtis.Merow -manager Chris.Hennessey -title "Sr. Specialist" -department "100.27 PIT Structural"
set-aduser -identity Tielldm -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Dane.Rasmussen -manager Chris.Hennessey -title "Sr. Designer" -department "100.27 PIT Structural"
set-aduser -identity Stagerdj -manager Granatpj -title "Designer" -department "100.03 TOL Structural"
set-aduser -identity Dan.Heberer -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Rectordj -manager Schrinmj -title "Sr. Specialist" -department "425.03 TOL Piping"
set-aduser -identity Daniel.Devadoss -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Durkindp -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Lowrydp -manager Wendelce -title "Senior Vice President & GM" -department "699.03 TOL Overhead"
set-aduser -identity OconnoDP -manager Ledinrr -title "Senior Vice President & CFO" -department "799.01 CLE Corp Executives"
set-aduser -identity Bridendj -manager Shkurtav -title "Sr. Designer" -department "100.02 CHI Structural"
set-aduser -identity Hurstdl -manager TurneyBK -title "Sr. Discipline Manager" -department "400.02 CHI Mechanical"
set-aduser -identity MayareD -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Reamerda -manager Schrinmj -title "Project Engineer" -department "425.03 TOL Piping"
set-aduser -identity David.Schmidt -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity David.Woodnorth -manager HayesRJ -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity BalchaDM -manager Mckenzrl -title "Sr. Designer" -department "425.01 CLE Piping"
set-aduser -identity Denise.SetteurSpurio -manager Ledinje -title "IS Generalist" -department "720.01 CLE MIS"
set-aduser -identity Dennis.Fundzak -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity PericD -manager Walterac -title "Specialist" -department "600.05 ASH Electrical"
set-aduser -identity Failindj -manager Adamsjk -title "Sr. Designer" -department "400.06 BUF Mechanical"
set-aduser -identity StalteDE -manager jamie.jurin -title "Sr. Engineer" -department "670.01 CLE Power"
set-aduser -identity Doug.Stieb -manager Schrinmj -title "Staff Specialist" -department "425.03 TOL Piping"
set-aduser -identity drew.zimmerman -manager Cussenkg -title "Sr. Engineer" -department "200.02 CHI Civil"
set-aduser -identity Dylan.McNamee -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity Ed.Curtis -manager HayesRJ -title "Sr. Construction Manager" -department "870.02 CHI Construction Management"
set-aduser -identity Elena.Graupera -manager LantinZL -title "Document Controls Coordinator" -department "810.08 IND Document Control"
set-aduser -identity MastanEJ -manager DavidsRJ -title "Staff Architect" -department "050.02 CHI Architectural"
set-aduser -identity Emmanuel.Paredes -manager Shkurtav -title "Drafter" -department "100.02 CHI Structural"
set-aduser -identity GonzalED -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Eric.Whittaker -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity ReedEL -manager Mayerkm -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Zapataem -manager Mclaugma -title "Project Controls Coordinator" -department "820.03 TOL Project Controls"
set-aduser -identity Clougheg -manager Bridgecj -title "Designer" -department "400.01 CLE Mechanical"
set-aduser -identity Gary.Stamper -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity OlsonGA -manager Jalpan.Soni -title "Sr. Engineer" -department "600.02 CHI Electrical"
set-aduser -identity Gary.Row -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Dreiergp -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity KeehnGA -manager Matt.Bedee -title "Specialist" -department "050.01 CLE Architectural"
set-aduser -identity Hlavacgm -manager Khaterjm -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity RoweGF -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Browngt -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Streitgj -manager HayesRJ -title "Sr. Major Project Manager" -department "899.02 CHI SMM"
set-aduser -identity Gise.VanBaren -manager GrelewJF -title "Intern" -department "125.08 IND Asset Integrity"
set-aduser -identity Glen.Hoppe -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Seibolgr -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity HollanGA -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity Greg.Furgala -manager Bealmk -title "Sr. Designer" -department "425.06 BUF Piping"
set-aduser -identity PrudenGA -manager KruppBE -title "Sr. Specialist" -department "600.01 CLE Electrical"
set-aduser -identity Buzz.Seydel -manager WrightPJ -title "Construction Manager" -department "870.02 CHI Construction Management"
set-aduser -identity Harold.Kropp -manager Adamsjk -title "Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Igor.Moskalow -manager Khaterjm -title "Designer" -department "100.01 CLE Structural"
set-aduser -identity jack.middleton -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Jackie.Kolling -manager Chris.Hennessey -title "Sr. Designer" -department "100.27 PIT Structural"
set-aduser -identity Jackie.Morris -manager StonemPJ -title "Marketing Manager" -department "760.01 CLE Marketing"
set-aduser -identity Jalpan.Soni -manager TurneyBK -title "Discipline Manager" -department "600.02 CHI Electrical"
set-aduser -identity Jim.Harrold -manager Khaterjm -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity GoodJP -manager Adam.Smith -title "Specialist" -department "100.06 BUF Structural"
set-aduser -identity Adamsjk -manager Sortispd -title "Discipline Manager" -department "400.06 BUF Mechanical"
set-aduser -identity Johnsoje -manager KuzmaJS -title "Specialist" -department "425.02 CHI Piping"
set-aduser -identity Jimmy.Wood -manager KuzmaJS -title "Sr. Designer" -department "425.02 CHI Piping"
set-aduser -identity Darbyjd -manager Walterac -title "Discipline Manager" -department "425.05 ASH Piping"
set-aduser -identity Sebekjj -manager KruppBE -title "Project Engineer" -department "600.01 CLE Electrical"
set-aduser -identity jim.bereda -manager LantinZL -title "Sr. Engineer" -department "600.08 IND Electrical"
set-aduser -identity jim.bender -manager Endersmd -title "Sr. Designer" -department "600.27 PIT Electrical"
set-aduser -identity jamie.jurin -manager Khaterjm -title "Discipline Manager" -department "670.01 CLE Power"
set-aduser -identity Carnsjj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity James.Rossi -manager WrightPJ -title "Major Projects Manager" -department "899.02 CHI SMM"
set-aduser -identity Blackjl -manager HayesRJ -title "Sr. Major Project Manager" -department "899.02 CHI SMM"
set-aduser -identity Weinhejr -manager mark.seifried -title "Director" -department "899.06 BUF SMM"
set-aduser -identity Janet.Honeywell -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity davisjl -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Jarrett.Feasley -manager Sortispd -title "Engineer" -department "600.06 BUF Electrical"
set-aduser -identity Jason.Jamil -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity jason.lamb -manager Blairtg -title "IT Manager" -department "740.01 CLE Information Technology"
set-aduser -identity KuzmaJS -manager TurneyBK -title "Discipline Manager" -department "425.02 CHI Piping"
set-aduser -identity Slabyja -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity Jeff.Zunich -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Waltonjs -manager Lowrydp -title "Sr. Technical Director" -department "425.03 TOL Piping"
set-aduser -identity Reinerjm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Jeff.Hollinshead -manager Khaterjm -title "Discipline Manager" -department "475.01 CLE Automation"
set-aduser -identity BihlJC -manager Walterac -title "Sr. Engineer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity jeff.ritter -manager LantinZL -title "Sr. Engineer" -department "650.08 IND Instrumental & Controls"
set-aduser -identity Jeff.Fesko -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity Frederjw -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity jeff.caldwell -manager rob.hattabaugh -title "Sr. Project Manager" -department "900.08 IND SPM"
set-aduser -identity Jen.Smith -manager Jalpan.Soni -title "Engineer" -department "600.02 CHI Electrical"
set-aduser -identity Jennifer.Valek -manager Zdolshtl -title "Accounting Specialist" -department "750.01 CLE Accounting"
set-aduser -identity Kasickjc -manager Jeff.Hollinshead -title "Sr. Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity jeremy.smith -manager Bob.Necciai -title "Sr. Project Manager" -department "900.27 PIT SPM"
set-aduser -identity Pazdanjw -manager KuzmaJS -title "Staff Specialist" -department "425.02 CHI Piping"
set-aduser -identity Wiszjl -manager Szalkomg -title "IT Generalist" -department "740.02 CHI Information Technology"
set-aduser -identity Ledinje -manager OconnoDP -title "Senior Vice President" -department "720.01 CLE MIS"
set-aduser -identity Kilbyjw -manager Khaterjm -title "Project Engineer" -department "100.01 CLE Structural"
set-aduser -identity Jack.Ziegler -manager Bridgecj -title "Sr. Engineer" -department "350.01 CLE Process"
set-aduser -identity Rossjw -manager Bridgecj -title "Staff Engineer" -department "350.01 CLE Process"
set-aduser -identity Micheljf -manager HodepeTL -title "Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity John.Hayes -manager Schrinmj -title "Specialist" -department "425.03 TOL Piping"
set-aduser -identity Sweenejw -manager Waltonjs -title "Sr. Discipline Manager" -department "600.03 TOL Electrical"
set-aduser -identity John.Rotroff -manager rob.hattabaugh -title "Sr. Project Manager" -department "900.08 IND SPM"
set-aduser -identity john.seaman -manager rob.hattabaugh -title "Sr. Project Manager" -department "900.08 IND SPM"
set-aduser -identity Jon.Beskin -manager DavidsRJ -title "Designer" -department "050.02 CHI Architectural"
set-aduser -identity AtkinsJD -manager Bridgecj -title "Project Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Joe.Weiner -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Joe.Rybicki -manager MakinsAP -title "Designer" -department "100.08 IND Structural"
set-aduser -identity GrelewJF -manager LantinZL -title "Sr. Discipline Manager" -department "125.08 IND Asset Integrity"
set-aduser -identity joseph.kalic -manager Mckenzrl -title "Engineer" -department "425.01 CLE Piping"
set-aduser -identity joseph.imre -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Halljl -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity JaraczJP -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity Khaterjm -manager mark.seifried -title "Director" -department "899.01 CLE SMM"
set-aduser -identity Walterja -manager HayesRJ -title "Sr. Project Director" -department "900.02 CHI SPM"
set-aduser -identity RedmonJM -manager Liuy -title "Sr. Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity WraseJW -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity DeakinJR -manager LantinZL -title "Sr. Engineer" -department "400.08 IND Mechanical"
set-aduser -identity MillerJK -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity Josh.Rice -manager Dankoww -title "Accounting Specialist" -department "750.01 CLE Accounting"
set-aduser -identity Julian.CoutoCarter -manager MakinsAP -title "Sr. Engineer" -department "100.08 IND Structural"
set-aduser -identity Justin.Otero -manager Bridgecj -title "Drafter" -department "350.01 CLE Process"
set-aduser -identity Justin.Walters -manager Bridgecj -title "Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity BettinJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Justin.Viola -manager Mckenzrl -title "Drafter" -department "425.27 PIT Piping"
set-aduser -identity Justin.Pistininzi -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity Devriejc -manager Mclaugma -title "Cost Scheduler" -department "820.03 TOL Project Controls"
set-aduser -identity Kaleb.Myers -manager Matt.Wisniewski -title "Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity cookke -manager Waltonjs -title "Document Controls Coordinator" -department "810.03 TOL Document Control"
set-aduser -identity Mayerkm -manager mark.seifried -title "Sr. Project Director" -department "900.01 CLE SPM"
set-aduser -identity Braunske -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity YoungKE -manager OconnoDP -title "Vice President, Human Resources" -department "710.01 CLE Human Resources"
set-aduser -identity Kathleen.Anderson -manager Zdolshtl -title "Accounting Coordinator" -department "750.01 CLE Accounting"
set-aduser -identity kauveh.aynafshar -manager Matt.Wisniewski -title "Drafter" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity kayan.kartoum -manager Liuy -title "Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Keith.Luttell -manager GrelewJF -title "Sr. Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity Kendall.Welling -manager Shkurtav -title "Engineer" -department "100.28 MAD Structural"
set-aduser -identity SefcikKP -manager Khaterjm -title "Discipline Manager" -department "200.01 CLE Civil"
set-aduser -identity Kenneth.Dudzik -manager LantinZL -title "Sr. Specialist" -department "425.08 IND Piping"
set-aduser -identity PutnamKA -manager FaulknAM -title "Staff Estimator" -department "821.02 CHI Estimating"
set-aduser -identity Kent.Mansfield -manager Darbyjd -title "Sr. Engineer" -department "425.05 ASH Piping"
set-aduser -identity Kevin.Bollinger -manager Walterac -title "Engineer" -department "100.05 ASH Structural"
set-aduser -identity Grubbkl -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity Payneke -manager Dankoww -title "Accounting Generalist" -department "750.01 CLE Accounting"
set-aduser -identity Winklekm -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Keyana.Williams -manager StonemPJ -title "Marketing Generalist" -department "760.01 CLE Marketing"
set-aduser -identity Olesicka -manager Dankoww -title "Accounting Generalist" -department "750.01 CLE Accounting"
set-aduser -identity Kory.Siverd -manager Khaterjm -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Newmankj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Stephekt -manager KruppBE -title "Sr. Specialist" -department "600.01 CLE Electrical"
set-aduser -identity Cussenkg -manager TurneyBK -title "Discipline Manager" -department "200.02 CHI Civil"
set-aduser -identity Lesleylr -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Laurie.Jones -manager FaulknAM -title "Project Controls Coordinator" -department "820.02 CHI Project Controls"
set-aduser -identity Krakovlj -manager Bridgecj -title "Sr. Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Lawrence.Amerson -manager Jeff.Hollinshead -title "Engineer" -department "475.01 CLE Automation"
set-aduser -identity Lenny.Laird -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity Li.Yan -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity Melilllm -manager YoungKE -title "Human Resources Manager" -department "710.01 CLE Human Resources"
set-aduser -identity Reganlm -manager Walterac -title "Project Assistant" -department "810.05 ASH Document Control"
set-aduser -identity Lonnie.Stump -manager GrelewJF -title "Specialist" -department "125.08 IND Asset Integrity"
set-aduser -identity Meyersmj -manager Khaterjm -title "Project Assistant" -department "810.01 CLE Document Control"
set-aduser -identity Mario.Hernandez -manager John.Rotroff -title "Project Manager" -department "800.08 IND PM"
set-aduser -identity Friedmm -manager Khaterjm -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity Sulzbamd -manager Adamsjk -title "Sr. Specialist" -department "400.06 BUF Mechanical"
set-aduser -identity Mark.Santillana -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Bealmk -manager Sortispd -title "Discipline Manager" -department "425.06 BUF Piping"
set-aduser -identity Gaertnmj -manager KruppBE -title "Specialist" -department "600.01 CLE Electrical"
set-aduser -identity mark.seifried -manager Wendelce -title "Senior Vice President & GM" -department "699.01 CLE Overhead"
set-aduser -identity MullenMA -manager Khaterjm -title "Major Projects Manager" -department "899.01 CLE SMM"
set-aduser -identity Hoggeml -manager Lowrydp -title "Sr. Project Manager" -department "900.05 ASH SPM"
set-aduser -identity GeorgeM -manager LantinZL -title "Project Engineer" -department "400.08 IND Mechanical"
set-aduser -identity Matt.Bedee -manager Khaterjm -title "Discipline Manager" -department "050.01 CLE Architectural"
set-aduser -identity Althoumj -manager Mckenzrl -title "Staff Engineer" -department "425.01 CLE Piping"
set-aduser -identity Hammonmr -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Matt.Wisniewski -manager Waltonjs -title "Discipline Manager" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Matt.Morgan -manager Waltonjs -title "Sr. Construction Manager" -department "870.03 TOL Construction Management"
set-aduser -identity PorterMR -manager Schrinmj -title "Designer" -department "425.03 TOL Piping"
set-aduser -identity melissa.foster -manager Melilllm -title "HR Generalist" -department "710.01 CLE Human Resources"
set-aduser -identity SmithMJ -manager Shkurtav -title "Staff Engineer" -department "100.02 CHI Structural"
set-aduser -identity Robertmd -manager Granatpj -title "Specialist" -department "100.03 TOL Structural"
set-aduser -identity Wheatmd -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity michael.marcinko -manager MakinsAP -title "Sr. Specialist" -department "100.08 IND Structural"
set-aduser -identity Lytlemp -manager Bridgecj -title "Staff Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Schrinmj -manager Waltonjs -title "Discipline Manager" -department "425.03 TOL Piping"
set-aduser -identity JimeneMJ -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Fonsecmj -manager Schrinmj -title "Sr. Specialist" -department "425.03 TOL Piping"
set-aduser -identity Michael.Sarver -manager Mckenzrl -title "Sr. Designer" -department "425.27 PIT Piping"
set-aduser -identity Endersmd -manager Bob.Necciai -title "Sr. Technical Manager" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity ViancoME -manager jamie.jurin -title "Sr. Designer" -department "670.01 CLE Power"
set-aduser -identity HillMG -manager OconnoDP -title "Director, Workforce & Corporate Development" -department "715.02 CHI Workforce Development"
set-aduser -identity Szalkomg -manager Blairtg -title "IT Manager" -department "740.01 CLE Information Technology"
set-aduser -identity Michael.Vargas -manager Szalkomg -title "IT Specialist" -department "740.02 CHI Information Technology"
set-aduser -identity Michael.Deinhammer -manager Geresbc -title "Project Manager" -department "800.10 MIN PM"
set-aduser -identity Mclaugma -manager Waltonjs -title "Discipline Manager" -department "820.03 TOL Project Controls"
set-aduser -identity Sebonimj -manager FaulknAM -title "Sr. Staff Specialist" -department "821.02 CHI Estimating"
set-aduser -identity UttechMJ -manager rob.hattabaugh -title "Director" -department "899.28 MAD SMM"
set-aduser -identity Salowma -manager Lowrydp -title "Sr. Project Manager" -department "900.05 ASH SPM"
set-aduser -identity Mike.Picardi -manager Khaterjm -title "Major Projects Manager" -department "899.01 CLE SMM"
set-aduser -identity michelle.casto -manager Bridgecj -title "Sr. Engineer" -department "350.01 CLE Process"
set-aduser -identity Molly.Green -manager Chris.Hennessey -title "Engineer" -department "100.27 PIT Structural"
set-aduser -identity Lowryma -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Myra.Parayno -manager Jalpan.Soni -title "Specialist" -department "600.02 CHI Electrical"
set-aduser -identity Millerne -manager Walterac -title "Designer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity FryNL -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Ziskonm -manager Schrinmj -title "Designer" -department "425.03 TOL Piping"
set-aduser -identity StolleNW -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Nathan.Ingram -manager Endersmd -title "Specialist" -department "600.27 PIT Electrical"
set-aduser -identity Nathen.Stevenson -manager KruppBE -title "Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Nenet.Bautista -manager KuzmaJS -title "Staff Engineer" -department "425.02 CHI Piping"
set-aduser -identity Nestor.Hiso -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity nicholas.tipton -manager Granatpj -title "Intern" -department "100.03 TOL Structural"
set-aduser -identity nick.arnold -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity nicholas.trudeau -manager Mckenzrl -title "Drafter" -department "425.27 PIT Piping"
set-aduser -identity Nick.Trout -manager Walterac -title "Designer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Noah.Blain -manager Walterac -title "Engineer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Otto.Wenzel -manager John.Rotroff -title "Project Manager" -department "800.08 IND PM"
set-aduser -identity Patricia.Krupp -manager Jeff.Hollinshead -title "Sr. Designer" -department "475.01 CLE Automation"
set-aduser -identity Flaughpl -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity Patrick.Keenan -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity patrick.conner -manager FaulknAM -title "Sr. Project Controls Specialist" -department "820.02 CHI Project Controls"
set-aduser -identity Granatpj -manager Waltonjs -title "Sr. Discipline Manager" -department "100.03 TOL Structural"
set-aduser -identity Bowlinpa -manager Darbyjd -title "Sr. Specialist" -department "425.05 ASH Piping"
set-aduser -identity StonemPJ -manager OconnoDP -title "Marketing Director" -department "760.01 CLE Marketing"
set-aduser -identity Sortispd -manager mark.seifried -title "Sr. Technical Director" -department "400.06 BUF Mechanical"
set-aduser -identity WrightPJ -manager HayesRJ -title "Sr. Major Project Manager" -department "899.02 CHI SMM"
set-aduser -identity Peacerj -manager Schrinmj -title "Specialist" -department "425.03 TOL Piping"
set-aduser -identity Johnsora -manager Walterac -title "Sr. Specialist" -department "100.05 ASH Structural"
set-aduser -identity Richard.Genser -manager Chris.Hennessey -title "Designer" -department "100.27 PIT Structural"
set-aduser -identity Mckenzrl -manager Khaterjm -title "Discipline Manager" -department "425.01 CLE Piping"
set-aduser -identity Yoergerw -manager KruppBE -title "Sr. Designer" -department "600.01 CLE Electrical"
set-aduser -identity HayesRJ -manager Wendelce -title "Senior Vice President & GM" -department "699.02 CHI Overhead"
set-aduser -identity Bonerich -manager Walterja -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity Gravesrm -manager Mclaugma -title "Project Controls Coordinator" -department "820.03 TOL Project Controls"
set-aduser -identity Vidrare -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity Bordonra -manager Bridgecj -title "Project Engineer" -department "350.01 CLE Process"
set-aduser -identity Robert.Adamski -manager HodepeTL -title "Engineer" -department "350.02 CHI Process"
set-aduser -identity Robert.Kirkpatrick -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity JankeyRW -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity Weiganrk -manager KruppBE -title "Sr. Designer" -department "600.01 CLE Electrical"
set-aduser -identity rob.hattabaugh -manager Wendelce -title "Vice President & GM" -department "699.08 IND Overhead"
set-aduser -identity Olschlre -manager Podhorrl -title "IT Generalist" -department "740.01 CLE Information Technology"
set-aduser -identity Schmidrc -manager Szalkomg -title "IT Generalist" -department "740.01 CLE Information Technology"
set-aduser -identity Podhorrl -manager Blairtg -title "IT Manager" -department "740.01 CLE Information Technology"
set-aduser -identity Rob.Tibbitts -manager OconnoDP -title "Director, Corporate Counsel" -department "780.01 CLE Legal"
set-aduser -identity GawronRT -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity Strosnrl -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Bob.Smering -manager mark.seifried -title "Sr. Project Manager" -department "900.06 BUF SPM"
set-aduser -identity DavidsRJ -manager TurneyBK -title "Sr. Discipline Manager" -department "050.02 CHI Architectural"
set-aduser -identity Rothrj -manager Bridgecj -title "Sr. Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Roger.Hieser -manager HodepeTL -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Cuculirj -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Ledinrr -manager Ledinrr -title "Chairman" -department "799.01 CLE Corp Executives"
set-aduser -identity Overhorj -manager Sortispd -title "Specialist" -department "600.06 BUF Electrical"
set-aduser -identity Samantha.Fox -manager Bob.Necciai -title "Business Development Director" -department "930.27 PIT Business Development"
set-aduser -identity Sam.Bennett -manager KruppBE -title "Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Sam.Blood -manager PiperCR -title "Project Controls Coordinator" -department "820.27 PIT Project Controls"
set-aduser -identity Santiago.Villegas -manager Shkurtav -title "Designer" -department "100.02 CHI Structural"
set-aduser -identity Munjesr -manager Schrinmj -title "Staff Engineer" -department "425.03 TOL Piping"
set-aduser -identity Feeneysm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Wisniesp -manager Szalkomg -title "IT Generalist" -department "740.03 TOL Information Technology"
set-aduser -identity CarneySP -manager WrightPJ -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity shannon.owen -manager Bob.Necciai -title "Business Development Manager" -department "930.27 PIT Business Development"
set-aduser -identity Shawn.Rudy -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity Mike.Paulic -manager Mckenzrl -title "Sr. Specialist" -department "425.01 CLE Piping"
set-aduser -identity WeinheSG -manager Adamsjk -title "Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Stephen.Wagner -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Shogresc -manager Liuy -title "Sr. Specialist" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Bogaersm -manager HayesRJ -title "Sr. Quality Director" -department "880.02 CHI Quality"
set-aduser -identity Sinhask -manager Jalpan.Soni -title "Sr. Engineer" -department "600.02 CHI Electrical"
set-aduser -identity sumita.pol -manager Jeff.Hollinshead -title "Sr. Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity SilajSM -manager WrightPJ -title "Procurement Agent" -department "840.02 CHI Procurement"
set-aduser -identity HodepeTL -manager TurneyBK -title "Discipline Manager" -department "350.02 CHI Process"
set-aduser -identity Zdolshtl -manager Dankoww -title "Accounting Manager" -department "750.01 CLE Accounting"
set-aduser -identity reynoltl -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Tanner.Drees -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity BellTR -manager Walterja -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity Riedeltw -manager Khaterjm -title "Discipline Manager" -department "820.01 CLE Project Controls"
set-aduser -identity Koniectl -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity TaylorTR -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Pienostm -manager Khaterjm -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity Voytkotl -manager Khaterjm -title "Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity Wickerth -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity thomas.twardowski -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity Thomas.McKeown -manager Bridgecj -title "Sr. Designer" -department "400.01 CLE Mechanical"
set-aduser -identity Thomas.Paprocki -manager Liuy -title "Staff Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Blairtg -manager OconnoDP -title "IT Director" -department "740.01 CLE Information Technology"
set-aduser -identity Tholete -manager Mckenzrl -title "Sr. Specialist" -department "425.01 CLE Piping"
set-aduser -identity Tim.Saunders -manager Adam.Smith -title "Designer" -department "100.06 BUF Structural"
set-aduser -identity Palmertp -manager Adam.Smith -title "Sr. Specialist" -department "100.06 BUF Structural"
set-aduser -identity Keyta -manager Khaterjm -title "Project Assistant" -department "810.01 CLE Document Control"
set-aduser -identity CullerTL -manager Khaterjm -title "Sr. Procurement Agent" -department "840.01 CLE Procurement"
set-aduser -identity trevor.misch -manager LantinZL -title "Intern" -department "600.08 IND Electrical"
set-aduser -identity Tristan.Griffith -manager Walterac -title "Drafter" -department "100.05 ASH Structural"
set-aduser -identity Tyler.Baird -manager Matt.Bedee -title "Designer" -department "050.01 CLE Architectural"
set-aduser -identity BrownTJ -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Victor.Sibiga -manager HodepeTL -title "Engineer" -department "350.02 CHI Process"
set-aduser -identity victor.guerrero -manager KuzmaJS -title "Designer" -department "425.02 CHI Piping"
set-aduser -identity Wilkinvp -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Dankoww -manager OconnoDP -title "Accounting Director" -department "750.01 CLE Accounting"
set-aduser -identity Wesley.McCurdy -manager Bridgecj -title "Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Wes.Stewart -manager Endersmd -title "Project Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Pricewf -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity WinterWF -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity ZatoWA -manager LantinZL -title "Sr. Specialist" -department "425.08 IND Piping"
set-aduser -identity William.Foster -manager jamie.jurin -title "Engineer" -department "670.02 CHI Power"
set-aduser -identity Bill.Celian -manager Waltonjs -title "Construction Manager" -department "870.03 TOL Construction Management"
set-aduser -identity Rabquewa -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Kordahyk -manager Khaterjm -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity Liuy -manager TurneyBK -title "Discipline Manager" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity LantinZL -manager rob.hattabaugh -title "Tech Manager" -department "100.08 IND Structural"
set-aduser -identity HitesZH -manager Granatpj -title "Engineer" -department "100.03 TOL Structural"
set-aduser -identity Charlie.Amaro -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Clint.Poca -manager Sweenejw -title "Sr. Specialist" -department "600.03 TOL Electrical"
set-aduser -identity Gary.Kieley -manager Bealmk -title "Specialist" -department "425.06 BUF Piping"
set-aduser -identity Jim.Thomas -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity Joe.Andras -manager rob.hattabaugh -title "Project Manager" -department "800.08 IND PM"
set-aduser -identity Josh.Palyo -manager Endersmd -title "Sr. Engineer" -department "350.27 PIT Process"
set-aduser -identity kim.morphew -manager WrightPJ -title "Document Controls Specialist" -department "810.02 CHI Document Control"
set-aduser -identity Lela.Conley -manager GrelewJF -title "Inspection Coordinator" -department "125.08 IND Asset Integrity"
set-aduser -identity Lindsay.Kaminski -manager YoungKE -title "HR Specialist" -department "710.01 CLE Human Resources"
set-aduser -identity Logan.Cover -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity Mikey.McClelland -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity norm.jaworski -manager Mckenzrl -title "Sr. Designer" -department "425.01 CLE Piping"
set-aduser -identity robert.leugers -manager WrightPJ -title "Sr. Construction Superintendent" -department "870.02 CHI Construction Management"
set-aduser -identity Rosario.Scibona -manager Ledinje -title "IS Manager" -department "720.01 CLE MIS"
set-aduser -identity Sam.Barnes -manager Ledinrr -title "President & CEO" -department "799.01 CLE Corp Executives"
set-aduser -identity sean.godfrey -manager Bridgecj -title "Sr. Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Shawn.Dishauzi -manager mark.seifried -title "EHS Director" -department "890.01 CLE Health & Safety"
set-aduser -identity Tiffany.Malcom -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"

===
CHI 1/30/24

Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Caitlyn.Sullivan
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members HillMG
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Janet.Honeywell
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Ecksteha
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members kayan.kartoum
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Bogaersm
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members HayesRJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Joe.Weiner
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jalpan.Soni
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Bonerich
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Sinhask
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Ashwin.Patel
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members victor.guerrero
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members DavidsRJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Walterja
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Pazdanjw
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members CarneySP
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members David.Woodnorth
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Marisha.Baldwin
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Shogresc
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Sebonimj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Roger.Hieser
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members allison.hassig
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Mark.Santillana
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Bridendj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Robert.Kirkpatrick
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members OlsonGA
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Michael.Vargas
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Wiszjl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members FaulknAM
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Perlaaj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Robert.Adamski
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members kim.morphew
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members rich.phillips
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members HodepeTL
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members RoweGF
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members WilsonCA
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Myra.Parayno
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members William.Foster
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members cathy.sullivan
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Shkurtav
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Santiago.Villegas
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members MayareD
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members derek.nyenhuis
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Thomas.Paprocki
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Johnsoje
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members WinterWF
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Victor.Sibiga
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Blackjl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Chihakaa
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Nestor.Hiso
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members patrick.conner
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members drew.zimmerman
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Michael.Deinhammer
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jen.Smith
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Braunske
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Geresbc
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members GonzalED
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members James.Rossi
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jimmy.Wood
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Dan.Heberer
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jon.Beskin
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members AldridBC
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members PutnamKA
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Streitgj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members SmithMJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Ed.Curtis
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Emmanuel.Paredes
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members UttechMJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members robert.leugers
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members charlie.amaro
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members yafei.liu
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Cussenkg
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Micheljf
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Laurie.Jones
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Wendelce
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members WrightPJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members WraseJW
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members MastanEJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members TurneyBK
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Gary.Stamper
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Glen.Hoppe
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members BellTR
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members KuzmaJS
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Li.Yan
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members RyanCD
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Hurstdl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members RedmonJM
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Liuy
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Nenet.Bautista
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Connor.Loughlin
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Stephen.Wagner

===

TOL 1/31/24

Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Rabquewa
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Lenharbd
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Dreiergp
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members HitesZH
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Granatpj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Pondca
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Stagerdj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Wheatmd
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Vidrare
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Wickerth
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Robertmd
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jack.middleton
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members joseph.imre
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Doug.Stieb
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Tanner.Drees
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members John.Hayes
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members CookCC
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members StolleNW
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members BettinJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members PorterMR
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members BrownTJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members TerryAM
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members JimeneMJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members RadtkeAJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Reamerda
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Seibolgr
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Munjesr
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Wilkinvp
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Peacerj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members reynoltl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Fonsecmj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Feeneysm
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Browngt
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Troutbd
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Warnecm
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Hammonmr
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Rectordj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Schrinmj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Waltonjs
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Hoyecl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members clint.poca
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Mitchekd
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Garetymw
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Sweenejw
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Whitema
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members kauveh.aynafshar
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Christian.Kanfeld
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Kaleb.Myers
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Matt.Wisniewski
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Polcynam
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Lesleylr
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Koniectl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Durkindp
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members davisjl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Lowrydp
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Wisniesp
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Brad.Ingram
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members SmithBM
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Newmankj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Carnsjj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members FryNL
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Stahlcw
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Tielldm
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Waynepj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Lowryma
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Zapataem
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Devriejc
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Gravesrm
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Mclaugma
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members steven.sharp
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members nicholas.tipton

===

2/2/24 IND

Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members GeorgeM
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members lela.conley
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Bradley.Cearing
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members logan.cover
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Keith.Luttell
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members rob.hattabaugh
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Elena.Graupera
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members travis.culver
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Otto.Wenzel
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members john.seaman
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members ZatoWA
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Julian.CoutoCarter
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members klimka.grubbe
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members LantinZL
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members brandon.magnusen
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members shane.gulvas
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members joe.andras
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members John.Rotroff
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Mario.Hernandez
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Joe.Rybicki
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Kenneth.Dudzik
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members MakinsAP
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jeff.caldwell
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members DeakinJR
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jeff.ritter
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members michael.marcinko
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Dylan.McNamee
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members GrelewJF
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Allen.Beeler
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members chad.zimmerman
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jim.bereda
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Gise.VanBaren
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members sebastian.dewitt
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members mikey.mcclelland
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Lonnie.Stump
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members trevor.misch
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members thomas.twardowski


===
2/5/24
New-ADUser -Name “Jacob Hutchens" -GivenName "Jacob" -Surname "Hutchens" -displayname "Jacob Hutchens" -SamAccountName "jacob.hutchens" -path "OU=125,OU=TOL,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "jacob.hutchens@middough.com" -department "125.03 TOL Asset Integrity" -office "Toledo" -state "OH" -initials "JH" -StreetAddress "580 Longbow Dr, Ste 101" -City "Maumee" -PostalCode "43537" -title "Inspector " -company "Middough" -manager "GrelewJF";
set-aduser "jacob.hutchens" -Replace @{c="US";co="United States";countrycode=840};
Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members jacob.hutchens;; 
Add-ADGroupMember -identity TOL_125 -members jacob.hutchens;; 
Add-ADGroupMember -identity "SSO" -members jacob.hutchens
New-ADUser -Name “Brent Prazer" -GivenName "Brent" -Surname "Prazer" -displayname "Brent Prazer" -SamAccountName "brent.prazer" -path "OU=890,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "brent.prazer@middough.com" -department "890.01 CLE Health & Safety " -office "Cleveland" -state "OH" -initials "BP" -StreetAddress "1901 E 13th St, Ste 400" -City "Cleveland" -PostalCode "44114" -title "Sr. Technical Manager" -company "Middough" -manager "mark.seifried";
set-aduser "brent.prazer" -Replace @{c="US";co="United States";countrycode=840};
Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members brent.prazer;; 
Add-ADGroupMember -identity CLE_890 -members brent.prazer;; 
Add-ADGroupMember -identity "SSO" -members brent.prazer
New-ADUser -Name “Renee Morgan" -GivenName "Renee" -Surname "Morgan" -displayname "Renee Morgan" -SamAccountName "renee.morgan" -path "OU=600,OU=BUF,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "renee.morgan@middough.com" -department "600.06 BUF Electrical " -office "Buffalo" -state "NY" -initials "RM" -StreetAddress "2420 Sweet Home Rd, Ste 110" -City "Amherst" -PostalCode "14228" -title "Discipline Manager" -company "Middough" -manager "SortisPD";
set-aduser "renee.morgan" -Replace @{c="US";co="United States";countrycode=840};
Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members renee.morgan;; 
Add-ADGroupMember -identity BUF_600 -members renee.morgan; 
Add-ADGroupMember -identity "Engineering_Dept" -members renee.morgan; 
Add-ADGroupMember -identity "SSO" -members renee.morgan

===

2/6/24 
BUF
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jeff.martis2
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Nashad
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Weinhejr
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Bob.Smering
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members ben.mccoy
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Adam.Smith
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Tim.Saunders
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members GoodJP
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Palmertp
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jeff.martis2
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Harold.Kropp
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members WeinheSG
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Sulzbamd
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Nashad
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Failindj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Adamsjk
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Sortispd
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members gary.kieley
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Greg.Furgala
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Bealmk
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jarrett.Feasley
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Overhorj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Patrick.Keenan
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members GawronRT
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members JaraczJP

MAD
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members UttechMJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Kendall.Welling
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members adam.clark
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members clint.downey


ASH
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Hoggeml
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Salowma
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Clougheg
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Tristan.Griffith
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Kevin.Bollinger
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Johnsora
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Walterac
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members VenegaKJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Autumn.Hatcher
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Ashama.Babooram
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Kent.Mansfield
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members MillerJK
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members HollanGA
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Flaughpl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Bowlinpa
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Darbyjd
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Halljl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Grubbkl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Forresmd
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members PericD
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members matt.locher
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Nick.Trout
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Noah.Blain
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Carmen.Carr
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members BihlJC
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Millerne
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Reganlm

===

2/7/24 CLE

Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Tyler.Baird
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members KeehnGA
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members brian.young
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Igor.Moskalow
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jim.Harrold
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Pienostm
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Friedmm
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Kilbyjw
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Voytkotl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Kordahyk
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Hlavacgm
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Hoppelcl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Lenny.Laird
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members YoungCS
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Slabyja
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Pricewf
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members RawsonBY
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members SefcikKP
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members michelle.casto
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jack.Ziegler
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Justin.Otero
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Bordonra
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Rossjw
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members andrew.gallagher
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Thomas.McKeown
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jeff.Zunich
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Wesley.McCurdy
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members AtkinsJD
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Krakovlj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Rothrj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Lytlemp
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Torosiaa
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members joseph.kalic
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Chris.Soprano
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Mike.Paulic
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members ThompsCJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members BalchaDM
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members JankeyRW
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Urankaaj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Mckenzrl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Althoumj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Tholete
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Lawrence.Amerson
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Avionne.Weaver
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Patricia.Krupp
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jeff.Hollinshead
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Nathen.Stevenson
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jason.Jamil
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Sam.Bennett
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Eric.Whittaker
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Daniel.Devadoss
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members KruppBE
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members PrudenGA
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Stephekt
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Cuculirj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Sebekjj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Yoergerw
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Weiganrk
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Gaertnmj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Palmerbj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members sumita.pol
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Dennis.Fundzak
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members AugisAV
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Kasickjc
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jamie.jurin
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members ViancoME
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members StalteDE
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members mark.seifried
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members lindsay.kaminski
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members melissa.foster
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members YoungKE
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Melilllm
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members rosario.scibona
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Denise.SetteurSpurio
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Hilbercr
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Ledinje
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Anthony.Gigante
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Kathleen.Anderson
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Josh.Rice
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Chris.Puleo
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Zdolshtl
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Leonarcm
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Payneke
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Olesicka
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Dankoww
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jennifer.Valek
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Keyana.Williams
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Jackie.Morris
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members StonemPJ
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Rob.Tibbitts
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members OconnoDP
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Ledinrr
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Kory.Siverd
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Chris.Moran
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Andy.Minderman
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members ReedEL
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Keyta
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Meyersmj
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Riedeltw
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members CullerTL
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Mike.Picardi
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Khaterjm
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members David.Schmidt
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Frederjw
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Mayerkm
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members Strosnrl

===

2/20/24
New-ADUser -Name “Jeren Lemanek" -GivenName "Jeren" -Surname "Lemanek" -displayname "Jeren Lemanek" -SamAccountName "jeren.lemanek" -path "OU=760,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "jeren.lemanek@middough.com" -department "760.01 CLE Marketing " -office "Cleveland" -state "OH" -initials "JL" -StreetAddress "1901 E 13th St, Ste 400" -City "Cleveland" -PostalCode "44114" -title "Intern" -company "Middough" -manager "StonemPJ";set-aduser "jeren.lemanek" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members jeren.lemanek;; Add-ADGroupMember -identity CLE_760 -members jeren.lemanek;; Add-ADGroupMember -identity "SSO" -members jeren.lemanek; Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jeren.lemanek;
New-ADUser -Name “Deb Semego" -GivenName "Deb" -Surname "Semego" -displayname "Deb Semego" -SamAccountName "deb.semego" -path "OU=810,OU=PIT,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "deb.semego@middough.com" -department "810.27 PIT Document Controls" -office "Pittsburgh" -state "PA" -initials "DS" -StreetAddress "2000 Westinghouse Dr, Ste 202" -City "Cranberry Township" -PostalCode "16066" -title "Document Controls Coordinator" -company "Middough" -manager "PiperCR";set-aduser "deb.semego" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members deb.semego; Add-ADGroupMember -identity "CAD Applications" -members deb.semego; Add-ADGroupMember -identity "Engineering_Dept" -members deb.semego; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members deb.semego; Add-ADGroupMember -identity PIT_810 -members deb.semego;; Add-ADGroupMember -identity "SSO" -members deb.semego; Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members deb.semego;

---

2/28/24

set-aduser -identity Failindj -manager Adamsjk -title "Sr Designer" -department "400.06 BUF Mechanical"
set-aduser -identity Harold.Kropp -manager Adamsjk -title "Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity jeff.martis2 -manager Adamsjk -title "Sr Designer" -department "400.06 BUF Mechanical"
set-aduser -identity Nashad -manager Adamsjk -title "Staff Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Sulzbamd -manager Adamsjk -title "Sr Specialist" -department "400.06 BUF Mechanical"
set-aduser -identity WeinheSG -manager Adamsjk -title "Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity HillMG -manager sam.barnes -title "Director" -department "715.02 CHI Workforce Development"
set-aduser -identity Wendelce -manager sam.barnes -title "Executive Vice President & COO" -department "799.02 CHI Corp Executives"
set-aduser -identity Ledinje -manager sam.barnes -title "Senior Vice President" -department "720.01 CLE MIS"
set-aduser -identity Blairtg -manager sam.barnes -title "Director" -department "740.01 CLE Information Technology"
set-aduser -identity StonemPJ -manager sam.barnes -title "Director" -department "760.01 CLE Marketing"
set-aduser -identity Rob.Tibbitts -manager sam.barnes -title "Director" -department "780.01 CLE Legal"
set-aduser -identity OconnoDP -manager sam.barnes -title "Senior Vice President & CFO" -department "799.01 CLE Corp Executives"
set-aduser -identity YoungKE -manager sam.barnes -title "Vice President, Human Resources" -department "710.01 CLE Human Resources"
set-aduser -identity Greg.Furgala -manager Bealmk -title "Sr Designer" -department "425.06 BUF Piping"
set-aduser -identity gary.kieley -manager Bealmk -title "Specialist" -department "425.06 BUF Piping"
set-aduser -identity Tyler.Baird -manager Matt.Bedee -title "Designer" -department "050.01 CLE Architectural"
set-aduser -identity KeehnGA -manager Matt.Bedee -title "Specialist" -department "050.01 CLE Architectural"
set-aduser -identity jason.lamb -manager Blairtg -title "IT Manager " -department "740.01 CLE Information Technology"
set-aduser -identity Podhorrl -manager Blairtg -title "IT Manager " -department "740.01 CLE Information Technology"
set-aduser -identity Szalkomg -manager Blairtg -title "IT Manager " -department "740.01 CLE Information Technology"
set-aduser -identity Wisniesp -manager Blairtg -title "IT Generalist " -department "740.03 TOL Information Technology"
set-aduser -identity AtkinsJD -manager Bridgecj -title "Project Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Clougheg -manager Bridgecj -title "Designer" -department "400.01 CLE Mechanical"
set-aduser -identity andrew.gallagher -manager Bridgecj -title "Sr Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Krakovlj -manager Bridgecj -title "Sr Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Lytlemp -manager Bridgecj -title "Staff Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Wesley.McCurdy -manager Bridgecj -title "Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Thomas.McKeown -manager Bridgecj -title "Sr Designer" -department "400.01 CLE Mechanical"
set-aduser -identity Rothrj -manager Bridgecj -title "Sr Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Torosiaa -manager Bridgecj -title "Staff Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Justin.Walters -manager Bridgecj -title "Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Jeff.Zunich -manager Bridgecj -title "Sr Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity drew.zimmerman -manager Cussenkg -title "Sr Engineer" -department "200.02 CHI Civil"
set-aduser -identity Anthony.Gigante -manager Dankoww -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity Leonarcm -manager Dankoww -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity Olesicka -manager Dankoww -title "Accounting Generalist " -department "750.01 CLE Accounting"
set-aduser -identity Payneke -manager Dankoww -title "Accounting Generalist " -department "750.01 CLE Accounting"
set-aduser -identity Chris.Puleo -manager Dankoww -title "Accounting Generalist " -department "750.01 CLE Accounting"
set-aduser -identity Josh.Rice -manager Dankoww -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity Zdolshtl -manager Dankoww -title "Accounting Manager " -department "750.01 CLE Accounting"
set-aduser -identity Ashama.Babooram -manager Darbyjd -title "Engineer" -department "425.05 ASH Piping"
set-aduser -identity Bowlinpa -manager Darbyjd -title "Sr Specialist" -department "425.05 ASH Piping"
set-aduser -identity Flaughpl -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity Grubbkl -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity Halljl -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity Autumn.Hatcher -manager Darbyjd -title "Drafter" -department "425.05 ASH Piping"
set-aduser -identity HollanGA -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity Kent.Mansfield -manager Darbyjd -title "Sr Engineer" -department "425.05 ASH Piping"
set-aduser -identity MillerJK -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity Jon.Beskin -manager DavidsRJ -title "Designer" -department "050.02 CHI Architectural"
set-aduser -identity MastanEJ -manager DavidsRJ -title "Staff Architect" -department "050.02 CHI Architectural"
set-aduser -identity Chris.Hennessey -manager Endersmd -title "Discipline Manager" -department "100.27 PIT Structural"
set-aduser -identity chris.edwards -manager Endersmd -title "Sr Engineer" -department "350.27 PIT Process"
set-aduser -identity josh.palyo -manager Endersmd -title "Sr Engineer" -department "350.27 PIT Process"
set-aduser -identity sean.godfrey -manager Endersmd -title "Sr Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity matt.sands -manager Endersmd -title "Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Wes.Stewart -manager Endersmd -title "Project Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Michael.Sarver -manager Endersmd -title "Sr Designer" -department "425.27 PIT Piping"
set-aduser -identity nicholas.trudeau -manager Endersmd -title "Drafter" -department "425.27 PIT Piping"
set-aduser -identity Justin.Viola -manager Endersmd -title "Drafter" -department "425.27 PIT Piping"
set-aduser -identity jim.bender -manager Endersmd -title "Sr Designer" -department "600.27 PIT Electrical"
set-aduser -identity Nathan.Ingram -manager Endersmd -title "Specialist" -department "600.27 PIT Electrical"
set-aduser -identity alex.lutz -manager Endersmd -title "Sr Engineer" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity patrick.conner -manager FaulknAM -title "Sr Project Controls Specialist" -department "820.02 CHI Project Controls"
set-aduser -identity Laurie.Jones -manager FaulknAM -title "Project Controls Coordinator" -department "820.02 CHI Project Controls"
set-aduser -identity rich.phillips -manager FaulknAM -title "Staff Estimator" -department "821.02 CHI Estimating"
set-aduser -identity PutnamKA -manager FaulknAM -title "Staff Estimator" -department "821.02 CHI Estimating"
set-aduser -identity Michael.Deinhammer -manager Geresbc -title "Project Manager" -department "800.10 MIN PM"
set-aduser -identity HitesZH -manager Granatpj -title "Engineer" -department "100.03 TOL Structural"
set-aduser -identity Pondca -manager Granatpj -title "Designer" -department "100.03 TOL Structural"
set-aduser -identity Robertmd -manager Granatpj -title "Specialist" -department "100.03 TOL Structural"
set-aduser -identity Stagerdj -manager Granatpj -title "Designer" -department "100.03 TOL Structural"
set-aduser -identity nicholas.tipton -manager Granatpj -title "Intern" -department "100.03 TOL Structural"
set-aduser -identity Vidrare -manager Granatpj -title "Sr Designer" -department "100.03 TOL Structural"
set-aduser -identity Wheatmd -manager Granatpj -title "Sr Designer" -department "100.03 TOL Structural"
set-aduser -identity Wickerth -manager Granatpj -title "Sr Designer" -department "100.03 TOL Structural"
set-aduser -identity Pricewf -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity Slabyja -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity YoungCS -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity Allen.Beeler -manager GrelewJF -title "Project Engineer " -department "125.08 IND Asset Integrity"
set-aduser -identity lela.conley -manager GrelewJF -title "Inspection Coordinator " -department "125.08 IND Asset Integrity"
set-aduser -identity logan.cover -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity travis.culver -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity klimka.grubbe -manager GrelewJF -title "Inspection Coordinator " -department "125.08 IND Asset Integrity"
set-aduser -identity Keith.Luttell -manager GrelewJF -title "Sr Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity mikey.mcclelland -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity Dylan.McNamee -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity Lonnie.Stump -manager GrelewJF -title "Specialist" -department "125.08 IND Asset Integrity"
set-aduser -identity thomas.twardowski -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity Gise.VanBaren -manager GrelewJF -title "Intern" -department "125.08 IND Asset Integrity"
set-aduser -identity LantinZL -manager rob.hattabaugh -title "Sr Technical Manager" -department "100.08 IND Structural"
set-aduser -identity GrelewJF -manager rob.hattabaugh -title "Sr Discipline Manager" -department "125.08 IND Asset Integrity"
set-aduser -identity joe.andras -manager rob.hattabaugh -title "Project Manager" -department "800.08 IND PM"
set-aduser -identity jeff.caldwell -manager rob.hattabaugh -title "Sr Project Manager" -department "900.08 IND SPM"
set-aduser -identity John.Rotroff -manager rob.hattabaugh -title "Sr Project Manager" -department "900.08 IND SPM"
set-aduser -identity john.seaman -manager rob.hattabaugh -title "Sr Project Manager" -department "900.08 IND SPM"
set-aduser -identity UttechMJ -manager rob.hattabaugh -title "Director" -department "899.28 MAD SMM"
set-aduser -identity DavidsRJ -manager HayesRJ -title "Director" -department "050.02 CHI Architectural"
set-aduser -identity TurneyBK -manager HayesRJ -title "Sr Technical Manager" -department "100.02 CHI Structural"
set-aduser -identity Roger.Hieser -manager HayesRJ -title "Sr Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Hurstdl -manager HayesRJ -title "Sr Discipline Manager" -department "400.02 CHI Mechanical"
set-aduser -identity Sebonimj -manager HayesRJ -title "Sr Staff Specialist" -department "821.02 CHI Estimating"
set-aduser -identity Ed.Curtis -manager HayesRJ -title "Sr Construction Manager" -department "870.02 CHI Construction Management"
set-aduser -identity Bogaersm -manager HayesRJ -title "Director" -department "880.02 CHI Quality"
set-aduser -identity Blackjl -manager HayesRJ -title "Sr Major Project Manager" -department "899.02 CHI SMM"
set-aduser -identity Streitgj -manager HayesRJ -title "Sr Major Project Manager" -department "899.02 CHI SMM"
set-aduser -identity WrightPJ -manager HayesRJ -title "Sr Major Project Manager" -department "899.02 CHI SMM"
set-aduser -identity Geresbc -manager HayesRJ -title "Sr Project Manager" -department "900.02 CHI SPM"
set-aduser -identity Walterja -manager HayesRJ -title "Director" -department "900.02 CHI SPM"
set-aduser -identity David.Woodnorth -manager HayesRJ -title "Sr Project Manager" -department "900.02 CHI SPM"
set-aduser -identity Perlaaj -manager HayesRJ -title "Vice President & BDD" -department "930.02 CHI Business Development"
set-aduser -identity nick.arnold -manager Chris.Hennessey -title "Sr Engineer" -department "100.27 PIT Structural"
set-aduser -identity jason.clouse -manager Chris.Hennessey -title "Engineer" -department "100.27 PIT Structural"
set-aduser -identity Richard.Genser -manager Chris.Hennessey -title "Designer" -department "100.27 PIT Structural"
set-aduser -identity Molly.Green -manager Chris.Hennessey -title "Engineer" -department "100.27 PIT Structural"
set-aduser -identity Jackie.Kolling -manager Chris.Hennessey -title "Sr Designer" -department "100.27 PIT Structural"
set-aduser -identity Lenny.Laird -manager Chris.Hennessey -title "Sr Engineer" -department "100.27 PIT Structural"
set-aduser -identity Curtis.Merow -manager Chris.Hennessey -title "Sr Specialist" -department "100.27 PIT Structural"
set-aduser -identity Chris.Muntz -manager Chris.Hennessey -title "Specialist" -department "100.27 PIT Structural"
set-aduser -identity Dane.Rasmussen -manager Chris.Hennessey -title "Sr Designer" -department "100.27 PIT Structural"
set-aduser -identity Robert.Adamski -manager HodepeTL -title "Engineer" -department "350.02 CHI Process"
set-aduser -identity charlie.amaro -manager HodepeTL -title "Sr Engineer" -department "350.02 CHI Process"
set-aduser -identity Chihakaa -manager HodepeTL -title "Sr Engineer" -department "350.02 CHI Process"
set-aduser -identity Janet.Honeywell -manager HodepeTL -title "Sr Engineer" -department "350.02 CHI Process"
set-aduser -identity Glen.Hoppe -manager HodepeTL -title "Sr Engineer" -department "350.02 CHI Process"
set-aduser -identity Robert.Kirkpatrick -manager HodepeTL -title "Sr Engineer" -department "350.02 CHI Process"
set-aduser -identity Micheljf -manager HodepeTL -title "Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Victor.Sibiga -manager HodepeTL -title "Engineer" -department "350.02 CHI Process"
set-aduser -identity Bordonra -manager HodepeTL -title "Project Engineer" -department "350.01 CLE Process"
set-aduser -identity michelle.casto -manager HodepeTL -title "Sr Engineer" -department "350.01 CLE Process"
set-aduser -identity Justin.Otero -manager HodepeTL -title "Drafter" -department "350.01 CLE Process"
set-aduser -identity Rossjw -manager HodepeTL -title "Staff Engineer" -department "350.01 CLE Process"
set-aduser -identity Jack.Ziegler -manager HodepeTL -title "Sr Engineer" -department "350.01 CLE Process"
set-aduser -identity Lawrence.Amerson -manager Jeff.Hollinshead -title "Engineer" -department "475.01 CLE Automation"
set-aduser -identity Patricia.Krupp -manager Jeff.Hollinshead -title "Sr Designer" -department "475.01 CLE Automation"
set-aduser -identity Avionne.Weaver -manager Jeff.Hollinshead -title "Intern" -department "475.01 CLE Automation"
set-aduser -identity AugisAV -manager Jeff.Hollinshead -title "Project Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity Kasickjc -manager Jeff.Hollinshead -title "Sr Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity sumita.pol -manager Jeff.Hollinshead -title "Sr Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity rana.kalaji -manager CookCC -title "Engineer" -department "100.01 CLE Structural"
set-aduser -identity GonzalED -manager Hurstdl -title "Sr Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Dan.Heberer -manager Hurstdl -title "Sr Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity yafei.liu -manager Hurstdl -title "Sr Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Connor.Loughlin -manager Hurstdl -title "Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity RoweGF -manager Hurstdl -title "Sr Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity adam.shands -manager jamie.jurin -title "Sr Engineer" -department "670.01 CLE Power"
set-aduser -identity StalteDE -manager jamie.jurin -title "Sr Engineer" -department "670.01 CLE Power"
set-aduser -identity ViancoME -manager jamie.jurin -title "Sr Designer" -department "670.01 CLE Power"
set-aduser -identity adam.clark -manager jamie.jurin -title "Sr Engineer" -department "670.10 MIN Power"
set-aduser -identity Matt.Bedee -manager Khaterjm -title "Discipline Manager" -department "050.01 CLE Architectural"
set-aduser -identity Friedmm -manager Khaterjm -title "Sr Engineer" -department "100.01 CLE Structural"
set-aduser -identity Jim.Harrold -manager Khaterjm -title "Sr Engineer" -department "100.01 CLE Structural"
set-aduser -identity Hlavacgm -manager Khaterjm -title "Sr Engineer" -department "100.01 CLE Structural"
set-aduser -identity Kilbyjw -manager Khaterjm -title "Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity Kordahyk -manager Khaterjm -title "Sr Engineer" -department "100.01 CLE Structural"
set-aduser -identity Igor.Moskalow -manager Khaterjm -title "Designer" -department "100.01 CLE Structural"
set-aduser -identity Pienostm -manager Khaterjm -title "Sr Engineer" -department "100.01 CLE Structural"
set-aduser -identity Voytkotl -manager Khaterjm -title "Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity brian.young -manager Khaterjm -title "Sr Designer" -department "100.01 CLE Structural"
set-aduser -identity SefcikKP -manager Khaterjm -title "Discipline Manager" -department "200.01 CLE Civil"
set-aduser -identity Bridgecj -manager Khaterjm -title "Discipline Manager" -department "400.01 CLE Mechanical"
set-aduser -identity Mckenzrl -manager Khaterjm -title "Discipline Manager" -department "425.01 CLE Piping"
set-aduser -identity Jeff.Hollinshead -manager Khaterjm -title "Discipline Manager" -department "475.01 CLE Automation"
set-aduser -identity jamie.jurin -manager Khaterjm -title "Discipline Manager" -department "670.01 CLE Power"
set-aduser -identity Kory.Siverd -manager Khaterjm -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Keyta -manager Khaterjm -title "Project Assistant" -department "810.01 CLE Document Control"
set-aduser -identity Meyersmj -manager Khaterjm -title "Project Assistant" -department "810.01 CLE Document Control"
set-aduser -identity Riedeltw -manager Khaterjm -title "Discipline Manager" -department "820.01 CLE Project Controls"
set-aduser -identity CullerTL -manager Khaterjm -title "Sr Procurement Agent" -department "840.01 CLE Procurement"
set-aduser -identity MullenMA -manager Khaterjm -title "Major Projects Manager" -department "899.01 CLE SMM"
set-aduser -identity Mike.Picardi -manager Khaterjm -title "Major Projects Manager" -department "899.01 CLE SMM"
set-aduser -identity Bryan.Thomas -manager Khaterjm -title "Sr Specialist" -department "890.01 TOL Health & Safety"
set-aduser -identity Sam.Bennett -manager KruppBE -title "Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Cuculirj -manager KruppBE -title "Sr Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Daniel.Devadoss -manager KruppBE -title "Sr Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Gaertnmj -manager KruppBE -title "Specialist" -department "600.01 CLE Electrical"
set-aduser -identity Palmerbj -manager KruppBE -title "Designer" -department "600.01 CLE Electrical"
set-aduser -identity carlton.powell -manager KruppBE -title "Intern" -department "600.01 CLE Electrical"
set-aduser -identity PrudenGA -manager KruppBE -title "Sr Specialist" -department "600.01 CLE Electrical"
set-aduser -identity Sebekjj -manager KruppBE -title "Project Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Stephekt -manager KruppBE -title "Sr Specialist" -department "600.01 CLE Electrical"
set-aduser -identity Nathen.Stevenson -manager KruppBE -title "Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Weiganrk -manager KruppBE -title "Sr Designer" -department "600.01 CLE Electrical"
set-aduser -identity Eric.Whittaker -manager KruppBE -title "Sr Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Yoergerw -manager KruppBE -title "Sr Designer" -department "600.01 CLE Electrical"
set-aduser -identity victor.guerrero -manager KuzmaJS -title "Designer" -department "425.02 CHI Piping"
set-aduser -identity Nestor.Hiso -manager KuzmaJS -title "Sr Specialist" -department "425.02 CHI Piping"
set-aduser -identity Johnsoje -manager KuzmaJS -title "Specialist" -department "425.02 CHI Piping"
set-aduser -identity MayareD -manager KuzmaJS -title "Sr Specialist" -department "425.02 CHI Piping"
set-aduser -identity Pazdanjw -manager KuzmaJS -title "Staff Specialist" -department "425.02 CHI Piping"
set-aduser -identity Mark.Santillana -manager KuzmaJS -title "Sr Specialist" -department "425.02 CHI Piping"
set-aduser -identity Gary.Stamper -manager KuzmaJS -title "Sr Specialist" -department "425.02 CHI Piping"
set-aduser -identity Stephen.Wagner -manager KuzmaJS -title "Sr Specialist" -department "425.02 CHI Piping"
set-aduser -identity WinterWF -manager KuzmaJS -title "Sr Specialist" -department "425.02 CHI Piping"
set-aduser -identity Jimmy.Wood -manager KuzmaJS -title "Sr Designer" -department "425.02 CHI Piping"
set-aduser -identity Michael.Vargas -manager jason.lamb -title "IT Specialist " -department "740.02 CHI Information Technology"
set-aduser -identity Wiszjl -manager jason.lamb -title "IT Generalist " -department "740.02 CHI Information Technology"
set-aduser -identity Schmidrc -manager jason.lamb -title "IT Generalist " -department "740.01 CLE Information Technology"
set-aduser -identity MakinsAP -manager LantinZL -title "Discipline Manager" -department "100.08 IND Structural"
set-aduser -identity DeakinJR -manager LantinZL -title "Sr Engineer" -department "400.08 IND Mechanical"
set-aduser -identity GeorgeM -manager LantinZL -title "Project Engineer" -department "400.08 IND Mechanical"
set-aduser -identity Bradley.Cearing -manager LantinZL -title "Designer" -department "425.08 IND Piping"
set-aduser -identity Kenneth.Dudzik -manager LantinZL -title "Sr Specialist" -department "425.08 IND Piping"
set-aduser -identity ZatoWA -manager LantinZL -title "Sr Specialist" -department "425.08 IND Piping"
set-aduser -identity chad.zimmerman -manager LantinZL -title "Sr Specialist" -department "425.08 IND Piping"
set-aduser -identity jim.bereda -manager LantinZL -title "Sr Engineer" -department "600.08 IND Electrical"
set-aduser -identity trevor.misch -manager LantinZL -title "Intern" -department "600.08 IND Electrical"
set-aduser -identity jeff.ritter -manager LantinZL -title "Sr Engineer" -department "650.08 IND Instrumental & Controls"
set-aduser -identity Elena.Graupera -manager LantinZL -title "Document Controls Coordinator" -department "810.08 IND Document Control"
set-aduser -identity Hilbercr -manager Ledinje -title "IS Generalist " -department "720.01 CLE MIS"
set-aduser -identity rosario.scibona -manager Ledinje -title "IS Manager " -department "720.01 CLE MIS"
set-aduser -identity Denise.SetteurSpurio -manager Ledinje -title "IS Generalist " -department "720.01 CLE MIS"
set-aduser -identity sam.barnes -manager Ledinrr -title "President" -department "799.01 CLE Corp Executives"
set-aduser -identity Ledinrr -manager Ledinrr -title "Chairman" -department "799.01 CLE Corp Executives"
set-aduser -identity Carnsjj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Brad.Ingram -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Newmankj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Gary.Row -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity SmithBM -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity AldridBC -manager Liuy -title "Specialist" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity kayan.kartoum -manager Liuy -title "Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Thomas.Paprocki -manager Liuy -title "Staff Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity RedmonJM -manager Liuy -title "Sr Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Shogresc -manager Liuy -title "Sr Specialist" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Walterac -manager OconnoDP -title "Tech Manager" -department "100.05 ASH Structural"
set-aduser -identity Hoggeml -manager OconnoDP -title "Sr Project Manager" -department "900.05 ASH SPM"
set-aduser -identity Salowma -manager OconnoDP -title "Sr Project Manager" -department "900.05 ASH SPM"
set-aduser -identity Waltonjs -manager OconnoDP -title "Director" -department "425.03 TOL Piping"
set-aduser -identity Dreiergp -manager OconnoDP -title "Sr Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Lenharbd -manager OconnoDP -title "Director" -department "900.03 TOL SPM"
set-aduser -identity Postacj -manager OconnoDP -title "Sr Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Rabquewa -manager OconnoDP -title "Sr Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Winklekm -manager OconnoDP -title "Sr Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Julian.CoutoCarter -manager MakinsAP -title "Sr Engineer" -department "100.08 IND Structural"
set-aduser -identity sebastian.dewitt -manager MakinsAP -title "Intern" -department "100.08 IND Structural"
set-aduser -identity brandon.magnusen -manager MakinsAP -title "Engineer" -department "100.08 IND Structural"
set-aduser -identity michael.marcinko -manager MakinsAP -title "Sr Specialist" -department "100.08 IND Structural"
set-aduser -identity Joe.Rybicki -manager MakinsAP -title "Designer" -department "100.08 IND Structural"
set-aduser -identity Althoumj -manager Mckenzrl -title "Staff Engineer" -department "425.01 CLE Piping"
set-aduser -identity BalchaDM -manager Mckenzrl -title "Sr Designer" -department "425.01 CLE Piping"
set-aduser -identity JankeyRW -manager Mckenzrl -title "Sr Engineer" -department "425.01 CLE Piping"
set-aduser -identity norm.jaworski -manager Mckenzrl -title "Sr Designer" -department "425.01 CLE Piping"
set-aduser -identity joseph.kalic -manager Mckenzrl -title "Engineer" -department "425.01 CLE Piping"
set-aduser -identity kevin.kerline -manager Mckenzrl -title "Sr Engineer" -department "425.01 CLE Piping"
set-aduser -identity Mike.Paulic -manager Mckenzrl -title "Sr Specialist" -department "425.01 CLE Piping"
set-aduser -identity Chris.Soprano -manager Mckenzrl -title "Sr Specialist" -department "425.01 CLE Piping"
set-aduser -identity Tholete -manager Mckenzrl -title "Sr Specialist" -department "425.01 CLE Piping"
set-aduser -identity ThompsCJ -manager Mckenzrl -title "Designer" -department "425.01 CLE Piping"
set-aduser -identity Urankaaj -manager Mckenzrl -title "Sr Engineer" -department "425.01 CLE Piping"
set-aduser -identity Devriejc -manager Mclaugma -title "Cost Scheduler" -department "820.03 TOL Project Controls"
set-aduser -identity Gravesrm -manager Mclaugma -title "Project Controls Coordinator" -department "820.03 TOL Project Controls"
set-aduser -identity Zapataem -manager Mclaugma -title "Project Controls Coordinator" -department "820.03 TOL Project Controls"
set-aduser -identity melissa.foster -manager Melilllm -title "HR Generalist " -department "710.01 CLE Human Resources"
set-aduser -identity Endersmd -manager Bob.Necciai -title "Sr Technical Manager" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity PiperCR -manager Bob.Necciai -title "Director" -department "899.27 PIT SMM"
set-aduser -identity jeremy.smith -manager Bob.Necciai -title "Sr Project Manager" -department "900.27 PIT SPM"
set-aduser -identity Samantha.Fox -manager Bob.Necciai -title "Business Development Director" -department "930.27 PIT Business Development"
set-aduser -identity shannon.owen -manager Bob.Necciai -title "Business Development Manager" -department "930.27 PIT Business Development"
set-aduser -identity Dankoww -manager OconnoDP -title "Vice President, Finance" -department "750.01 CLE Accounting"
set-aduser -identity Justin.Pistininzi -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity jim.thomas -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity Sam.Blood -manager PiperCR -title "Project Controls Coordinator " -department "820.27 PIT Project Controls"
set-aduser -identity Jeff.Fesko -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity tiffany.malcom -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity Shawn.Rudy -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity brad.daugharthy -manager Podhorrl -title "IT Generalist " -department "740.01 CLE Information Technology"
set-aduser -identity Olschlre -manager Podhorrl -title "IT Generalist " -department "740.01 CLE Information Technology"
set-aduser -identity shane.gulvas -manager John.Rotroff -title "Project Manager" -department "800.08 IND PM"
set-aduser -identity Mario.Hernandez -manager John.Rotroff -title "Project Manager" -department "800.08 IND PM"
set-aduser -identity Otto.Wenzel -manager John.Rotroff -title "Project Manager" -department "800.08 IND PM"
set-aduser -identity Chris.Moran -manager David.Schmidt -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity BettinJ -manager Schrinmj -title "Sr Designer" -department "425.03 TOL Piping"
set-aduser -identity BrownTJ -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Browngt -manager Schrinmj -title "Sr Engineer" -department "425.03 TOL Piping"
set-aduser -identity CookCC -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Tanner.Drees -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Feeneysm -manager Schrinmj -title "Sr Engineer" -department "425.03 TOL Piping"
set-aduser -identity Fonsecmj -manager Schrinmj -title "Sr Specialist" -department "425.03 TOL Piping"
set-aduser -identity Hammonmr -manager Schrinmj -title "Sr Engineer" -department "425.03 TOL Piping"
set-aduser -identity reynoltl -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity John.Hayes -manager Schrinmj -title "Specialist" -department "425.03 TOL Piping"
set-aduser -identity Hoyecl -manager Schrinmj -title "Sr Designer" -department "425.03 TOL Piping"
set-aduser -identity joseph.imre -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity JimeneMJ -manager Schrinmj -title "Sr Engineer" -department "425.03 TOL Piping"
set-aduser -identity jack.middleton -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Munjesr -manager Schrinmj -title "Staff Engineer" -department "425.03 TOL Piping"
set-aduser -identity Peacerj -manager Schrinmj -title "Specialist" -department "425.03 TOL Piping"
set-aduser -identity PorterMR -manager Schrinmj -title "Designer" -department "425.03 TOL Piping"
set-aduser -identity RadtkeAJ -manager Schrinmj -title "Sr Designer" -department "425.03 TOL Piping"
set-aduser -identity Reamerda -manager Schrinmj -title "Project Engineer" -department "425.03 TOL Piping"
set-aduser -identity Rectordj -manager Schrinmj -title "Sr Specialist" -department "425.03 TOL Piping"
set-aduser -identity Reinerjm -manager Schrinmj -title "Sr Engineer" -department "425.03 TOL Piping"
set-aduser -identity Seibolgr -manager Schrinmj -title "Sr Designer" -department "425.03 TOL Piping"
set-aduser -identity StarkCJ -manager Schrinmj -title "Sr Designer" -department "425.03 TOL Piping"
set-aduser -identity Doug.Stieb -manager Schrinmj -title "Staff Specialist" -department "425.03 TOL Piping"
set-aduser -identity StolleNW -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity TerryAM -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Thompsba -manager Schrinmj -title "Sr Designer" -department "425.03 TOL Piping"
set-aduser -identity Troutbd -manager Schrinmj -title "Sr Engineer" -department "425.03 TOL Piping"
set-aduser -identity Warnecm -manager Schrinmj -title "Sr Engineer" -department "425.03 TOL Piping"
set-aduser -identity Wilkinvp -manager Schrinmj -title "Sr Engineer" -department "425.03 TOL Piping"
set-aduser -identity Ziskonm -manager Schrinmj -title "Designer" -department "425.03 TOL Piping"
set-aduser -identity RawsonBY -manager SefcikKP -title "Specialist" -department "200.01 CLE Civil"
set-aduser -identity Andy.Minderman -manager mark.seifried -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity ReedEL -manager mark.seifried -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Sortispd -manager mark.seifried -title "Director" -department "400.06 BUF Mechanical"
set-aduser -identity Weinhejr -manager mark.seifried -title "Director" -department "899.06 BUF SMM"
set-aduser -identity Bob.Smering -manager mark.seifried -title "Sr Project Manager" -department "900.06 BUF SPM"
set-aduser -identity Hoppelcl -manager mark.seifried -title "Sr Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity brent.prazer -manager mark.seifried -title "Sr Technical Manager" -department "100.01 CLE Structural"
set-aduser -identity KruppBE -manager mark.seifried -title "Sr Discipline Director" -department "600.01 CLE Electrical"
set-aduser -identity Shawn.Dishauzi -manager mark.seifried -title "Director" -department "890.01 CLE Health & Safety"
set-aduser -identity Khaterjm -manager mark.seifried -title "Director" -department "899.01 CLE SMM"
set-aduser -identity Frederjw -manager mark.seifried -title "Sr Project Manager" -department "900.01 CLE SPM"
set-aduser -identity David.Schmidt -manager mark.seifried -title "Sr Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Strosnrl -manager mark.seifried -title "Sr Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Braunske -manager Shkurtav -title "Sr Engineer" -department "100.02 CHI Structural"
set-aduser -identity Bridendj -manager Shkurtav -title "Sr Designer" -department "100.02 CHI Structural"
set-aduser -identity Emmanuel.Paredes -manager Shkurtav -title "Drafter" -department "100.02 CHI Structural"
set-aduser -identity Ashwin.Patel -manager Shkurtav -title "Sr Engineer" -department "100.02 CHI Structural"
set-aduser -identity RyanCD -manager Shkurtav -title "Project Engineer" -department "100.02 CHI Structural"
set-aduser -identity SmithMJ -manager Shkurtav -title "Staff Engineer" -department "100.02 CHI Structural"
set-aduser -identity Santiago.Villegas -manager Shkurtav -title "Designer" -department "100.02 CHI Structural"
set-aduser -identity WraseJW -manager Shkurtav -title "Sr Engineer" -department "100.02 CHI Structural"
set-aduser -identity Li.Yan -manager Shkurtav -title "Sr Engineer" -department "100.02 CHI Structural"
set-aduser -identity Kendall.Welling -manager Shkurtav -title "Engineer" -department "100.28 MAD Structural"
set-aduser -identity GoodJP -manager Adam.Smith -title "Specialist" -department "100.06 BUF Structural"
set-aduser -identity ben.mccoy -manager Adam.Smith -title "Engineer" -department "100.06 BUF Structural"
set-aduser -identity Palmertp -manager Adam.Smith -title "Sr Specialist" -department "100.06 BUF Structural"
set-aduser -identity Tim.Saunders -manager Adam.Smith -title "Designer" -department "100.06 BUF Structural"
set-aduser -identity OlsonGA -manager Jalpan.Soni -title "Sr Engineer" -department "600.02 CHI Electrical"
set-aduser -identity Myra.Parayno -manager Jalpan.Soni -title "Specialist" -department "600.02 CHI Electrical"
set-aduser -identity Sinhask -manager Jalpan.Soni -title "Sr Engineer" -department "600.02 CHI Electrical"
set-aduser -identity Jen.Smith -manager Jalpan.Soni -title "Engineer" -department "600.02 CHI Electrical"
set-aduser -identity Adam.Smith -manager Sortispd -title "Discipline Manager" -department "100.06 BUF Structural"
set-aduser -identity Adamsjk -manager Sortispd -title "Discipline Manager" -department "400.06 BUF Mechanical"
set-aduser -identity Bealmk -manager Sortispd -title "Discipline Manager" -department "425.06 BUF Piping"
set-aduser -identity Jarrett.Feasley -manager Sortispd -title "Engineer" -department "600.06 BUF Electrical"
set-aduser -identity renee.morgan -manager Sortispd -title "Discipline Manager" -department "600.06 BUF Electrical"
set-aduser -identity Overhorj -manager Sortispd -title "Specialist" -department "600.06 BUF Electrical"
set-aduser -identity Jackie.Morris -manager StonemPJ -title "Marketing Manager " -department "760.01 CLE Marketing"
set-aduser -identity Keyana.Williams -manager StonemPJ -title "Marketing Generalist " -department "760.01 CLE Marketing"
set-aduser -identity clint.poca -manager Sweenejw -title "Sr Specialist" -department "600.03 TOL Electrical"
set-aduser -identity Shkurtav -manager TurneyBK -title "Sr Discipline Manager" -department "100.02 CHI Structural"
set-aduser -identity Cussenkg -manager TurneyBK -title "Discipline Manager" -department "200.02 CHI Civil"
set-aduser -identity HodepeTL -manager TurneyBK -title "Discipline Manager" -department "350.02 CHI Process"
set-aduser -identity KuzmaJS -manager TurneyBK -title "Discipline Manager" -department "425.02 CHI Piping"
set-aduser -identity Jalpan.Soni -manager TurneyBK -title "Discipline Manager" -department "600.02 CHI Electrical"
set-aduser -identity Liuy -manager TurneyBK -title "Discipline Manager" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity William.Foster -manager TurneyBK -title "Engineer" -department "670.02 CHI Power"
set-aduser -identity clint.downey -manager UttechMJ -title "Project Manager" -department "800.28 MAD PM"
set-aduser -identity Kevin.Bollinger -manager Walterac -title "Engineer" -department "100.05 ASH Structural"
set-aduser -identity Tristan.Griffith -manager Walterac -title "Drafter" -department "100.05 ASH Structural"
set-aduser -identity Johnsora -manager Walterac -title "Sr Specialist" -department "100.05 ASH Structural"
set-aduser -identity Darbyjd -manager Walterac -title "Discipline Manager" -department "425.05 ASH Piping"
set-aduser -identity PericD -manager Walterac -title "Specialist" -department "600.05 ASH Electrical"
set-aduser -identity BihlJC -manager Walterac -title "Sr Engineer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Noah.Blain -manager Walterac -title "Engineer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Carmen.Carr -manager Walterac -title "Sr Specialist" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity matt.locher -manager Walterac -title "Sr Specialist" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Millerne -manager Walterac -title "Designer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Nick.Trout -manager Walterac -title "Designer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Reganlm -manager Walterac -title "Project Assistant" -department "810.05 ASH Document Control"
set-aduser -identity Bonerich -manager Walterja -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity BellTR -manager Walterja -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity Granatpj -manager Waltonjs -title "Sr Discipline Manager" -department "100.03 TOL Structural"
set-aduser -identity Schrinmj -manager Waltonjs -title "Discipline Manager" -department "425.03 TOL Piping"
set-aduser -identity Sweenejw -manager Waltonjs -title "Sr Discipline Manager" -department "600.03 TOL Electrical"
set-aduser -identity Matt.Wisniewski -manager Waltonjs -title "Discipline Manager" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity cookke -manager Waltonjs -title "Document Controls Coordinator" -department "810.03 TOL Document Control"
set-aduser -identity FryNL -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Lowryma -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Stahlcw -manager Waltonjs -title "Document Controls Coordinator" -department "810.03 TOL Document Control"
set-aduser -identity Tielldm -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Mclaugma -manager Waltonjs -title "Discipline Manager" -department "820.03 TOL Project Controls"
set-aduser -identity Bill.Celian -manager Waltonjs -title "Construction Manager" -department "870.03 TOL Construction Management"
set-aduser -identity Matt.Morgan -manager Waltonjs -title "Sr Construction Manager" -department "870.03 TOL Construction Management"
set-aduser -identity GawronRT -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity JaraczJP -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity Patrick.Keenan -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity HayesRJ -manager Wendelce -title "Senior Vice President & GM" -department "699.02 CHI Overhead"
set-aduser -identity mark.seifried -manager Wendelce -title "Senior Vice President & GM" -department "699.01 CLE Overhead"
set-aduser -identity rob.hattabaugh -manager Wendelce -title "Vice President & GM" -department "699.08 IND Overhead"
set-aduser -identity Bob.Necciai -manager Wendelce -title "Senior Vice President & GM" -department "699.27 PIT Overhead"
set-aduser -identity Lowrydp -manager Wendelce -title "Senior Vice President & GM" -department "699.03 TOL Overhead"
set-aduser -identity kauveh.aynafshar -manager Matt.Wisniewski -title "Designer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity davisjl -manager Matt.Wisniewski -title "Sr Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Durkindp -manager Matt.Wisniewski -title "Sr Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Christian.Kanfeld -manager Matt.Wisniewski -title "Sr Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Koniectl -manager Matt.Wisniewski -title "Sr Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Lesleylr -manager Matt.Wisniewski -title "Sr Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Kaleb.Myers -manager Matt.Wisniewski -title "Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Polcynam -manager Matt.Wisniewski -title "Sr Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity TaylorTR -manager Matt.Wisniewski -title "Sr Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity CarneySP -manager WrightPJ -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity kim.morphew -manager WrightPJ -title "Document Controls Specialist " -department "810.02 CHI Document Control"
set-aduser -identity cathy.sullivan -manager WrightPJ -title "Document Controls Coordinator" -department "810.02 CHI Document Control"
set-aduser -identity FaulknAM -manager WrightPJ -title "Discipline Manager" -department "820.02 CHI Project Controls"
set-aduser -identity allison.hassig -manager WrightPJ -title "Discipline Manager" -department "840.02 CHI Procurement"
set-aduser -identity SilajSM -manager WrightPJ -title "Procurement Agent" -department "840.02 CHI Procurement"
set-aduser -identity robert.leugers -manager WrightPJ -title "Sr Construct Supt" -department "870.02 CHI Construction Management"
set-aduser -identity Buzz.Seydel -manager WrightPJ -title "Construction Manager" -department "870.02 CHI Construction Management"
set-aduser -identity James.Rossi -manager WrightPJ -title "Major Projects Manager" -department "899.02 CHI SMM"
set-aduser -identity Caitlyn.Sullivan -manager YoungKE -title "Human Resources Manager " -department "710.02 CHI Human Resources"
set-aduser -identity lindsay.kaminski -manager YoungKE -title "HR Specialist " -department "710.01 CLE Human Resources"
set-aduser -identity Melilllm -manager YoungKE -title "Human Resources Manager " -department "710.01 CLE Human Resources"
set-aduser -identity jeff.peters -manager YoungKE -title "Human Resources Manager " -department "710.27 PIT Human Resources"
set-aduser -identity Kathleen.Anderson -manager Zdolshtl -title "Accounting Coordinator" -department "750.01 CLE Accounting"
set-aduser -identity Jennifer.Valek -manager Zdolshtl -title "Accounting Specialist " -department "750.01 CLE Accounting"

===

set-aduser -identity Walterac -manager Lowrydp -title "Tech Manager" -department "100.05 ASH Structural"
set-aduser -identity Hoggeml -manager Lowrydp -title "Sr Project Manager" -department "900.05 ASH SPM"
set-aduser -identity Salowma -manager Lowrydp -title "Sr Project Manager" -department "900.05 ASH SPM"
set-aduser -identity Waltonjs -manager Lowrydp -title "Director" -department "425.03 TOL Piping"
set-aduser -identity Dreiergp -manager Lowrydp -title "Sr Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Lenharbd -manager Lowrydp -title "Director" -department "900.03 TOL SPM"
set-aduser -identity Postacj -manager Lowrydp -title "Sr Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Rabquewa -manager Lowrydp -title "Sr Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Winklekm -manager Lowrydp -title "Sr Project Manager" -department "900.03 TOL SPM"

===
:: 3/11/24 HR update ran on 3/27/24 with minor changes to recent promotion alerts

set-aduser -identity RadtkeAJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity adam.clark -manager jamie.jurin -title "Sr. Engineer" -department "670.10 MIN Power"
set-aduser -identity adam.shands -manager jamie.jurin -title "Sr. Engineer" -department "670.01 CLE Power"
set-aduser -identity Adam.Smith -manager Sortispd -title "Discipline Manager" -department "100.06 BUF Structural"
set-aduser -identity Walterac -manager Lowrydp -title "Tech Manager" -department "100.05 ASH Structural"
set-aduser -identity Chihakaa -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Polcynam -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Perlaaj -manager HayesRJ -title "Vice President & BDD" -department "930.02 CHI Business Development"
set-aduser -identity FaulknAM -manager WrightPJ -title "Discipline Manager" -department "820.02 CHI Project Controls"
set-aduser -identity alex.lutz -manager Endersmd -title "Sr. Engineer" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity Urankaaj -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity Allen.Beeler -manager GrelewJF -title "Project Engineer " -department "125.08 IND Asset Integrity"
set-aduser -identity allison.hassig -manager WrightPJ -title "Discipline Manager" -department "840.02 CHI Procurement"
set-aduser -identity Shkurtav -manager TurneyBK -title "Sr. Discipline Manager" -department "100.02 CHI Structural"
set-aduser -identity AugisAV -manager Jeff.Hollinshead -title "Project Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity andrew.gallagher -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity MakinsAP -manager LantinZL -title "Discipline Manager" -department "100.08 IND Structural"
set-aduser -identity Andy.Minderman -manager mark.seifried -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Anthony.Gigante -manager Dankoww -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity Nashad -manager Adamsjk -title "Staff Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Torosiaa -manager Bridgecj -title "Staff Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Ashama.Babooram -manager Darbyjd -title "Engineer" -department "425.05 ASH Piping"
set-aduser -identity TerryAM -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Ashwin.Patel -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity Bob.Necciai -manager Wendelce -title "Senior Vice President & GM" -department "699.27 PIT Overhead"
set-aduser -identity Autumn.Hatcher -manager Darbyjd -title "Drafter" -department "425.05 ASH Piping"
set-aduser -identity Avionne.Weaver -manager Jeff.Hollinshead -title "Intern" -department "475.01 CLE Automation"
set-aduser -identity Palmerbj -manager KruppBE -title "Designer" -department "600.01 CLE Electrical"
set-aduser -identity AldridBC -manager Liuy -title "Specialist" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Geresbc -manager HayesRJ -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity ben.mccoy -manager Adam.Smith -title "Engineer" -department "100.06 BUF Structural"
set-aduser -identity Thompsba -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Troutbd -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Bradley.Cearing -manager LantinZL -title "Designer" -department "425.08 IND Piping"
set-aduser -identity brad.daugharthy -manager Podhorrl -title "IT Generalist " -department "740.01 CLE Information Technology"
set-aduser -identity Brad.Ingram -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Lenharbd -manager Lowrydp -title "Director" -department "900.03 TOL SPM"
set-aduser -identity brandon.magnusen -manager MakinsAP -title "Engineer" -department "100.08 IND Structural"
set-aduser -identity brent.prazer -manager mark.seifried -title "Sr. Technical Manager" -department "100.01 CLE Structural"
set-aduser -identity brian.young -manager brent.prazer -title "Sr. Designer" -department "100.01 CLE Structural"
set-aduser -identity SmithBM -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity bryan.king -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity KruppBE -manager mark.seifried -title "Sr. Discipline Director" -department "600.01 CLE Electrical"
set-aduser -identity Bryan.Thomas -manager Shawn.Dishauzi -title "Sr. Specialist" -department "890.01 TOL Health & Safety"
set-aduser -identity TurneyBK -manager HayesRJ -title "Sr. Technical Manager" -department "100.02 CHI Structural"
set-aduser -identity RawsonBY -manager SefcikKP -title "Specialist" -department "200.01 CLE Civil"
set-aduser -identity Caitlyn.Sullivan -manager YoungKE -title "Human Resources Manager" -department "710.02 CHI Human Resources"
set-aduser -identity Wendelce -manager sam.barnes -title "Executive Vice President & COO" -department "799.02 CHI Corp Executives"
set-aduser -identity carlton.powell -manager KruppBE -title "Intern" -department "600.01 CLE Electrical"
set-aduser -identity Carmen.Carr -manager Walterac -title "Sr. Specialist" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity cathy.sullivan -manager WrightPJ -title "Document Controls Coordinator" -department "810.02 CHI Document Control"
set-aduser -identity ThompsCJ -manager Mckenzrl -title "Designer" -department "425.01 CLE Piping"
set-aduser -identity chad.zimmerman -manager LantinZL -title "Sr. Specialist" -department "425.08 IND Piping"
set-aduser -identity charlie.amaro -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Bridgecj -manager brent.prazer -title "Discipline Manager" -department "400.01 CLE Mechanical"
set-aduser -identity CookCC -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Hoppelcl -manager brent.prazer -title "Sr. Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity Stahlcw -manager Waltonjs -title "Document Controls Coordinator" -department "810.03 TOL Document Control"
set-aduser -identity Pondca -manager Granatpj -title "Designer" -department "100.03 TOL Structural"
set-aduser -identity matt.locher -manager Walterac -title "Sr. Specialist" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Postacj -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Christian.Kanfeld -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Hilbercr -manager Ledinje -title "IS Generalist " -department "720.01 CLE MIS"
set-aduser -identity Leonarcm -manager Dankoww -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity chris.edwards -manager Endersmd -title "Sr. Engineer" -department "350.27 PIT Process"
set-aduser -identity Chris.Hennessey -manager Endersmd -title "Discipline Manager" -department "100.27 PIT Structural"
set-aduser -identity Chris.Moran -manager David.Schmidt -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Chris.Muntz -manager Chris.Hennessey -title "Specialist" -department "100.27 PIT Structural"
set-aduser -identity Chris.Puleo -manager Dankoww -title "Accounting Generalist " -department "750.01 CLE Accounting"
set-aduser -identity RyanCD -manager Shkurtav -title "Project Engineer" -department "100.02 CHI Structural"
set-aduser -identity Chris.Soprano -manager Mckenzrl -title "Sr. Specialist" -department "425.01 CLE Piping"
set-aduser -identity StarkCJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Warnecm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity YoungCS -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity PiperCR -manager Bob.Necciai -title "Director" -department "899.27 PIT SMM"
set-aduser -identity clint.downey -manager UttechMJ -title "Project Manager" -department "800.28 MAD PM"
set-aduser -identity clint.poca -manager Sweenejw -title "Sr. Specialist" -department "600.03 TOL Electrical"
set-aduser -identity Hoyecl -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Connor.Loughlin -manager Hurstdl -title "Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity WilsonCA -manager HayesRJ -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Curtis.Merow -manager Chris.Hennessey -title "Sr. Specialist" -department "100.27 PIT Structural"
set-aduser -identity Tielldm -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Dane.Rasmussen -manager Chris.Hennessey -title "Sr. Designer" -department "100.27 PIT Structural"
set-aduser -identity Daniel.Devadoss -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Durkindp -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Dan.Heberer -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Lowrydp -manager Wendelce -title "Senior Vice President & GM" -department "699.03 TOL Overhead"
set-aduser -identity OconnoDP -manager sam.barnes -title "Senior Vice President & CFO" -department "799.01 CLE Corp Executives"
set-aduser -identity Rectordj -manager Schrinmj -title "Sr. Specialist" -department "425.03 TOL Piping"
set-aduser -identity dan.sarata -manager Adam.Smith -title "Sr. Engineer" -department "100.06 BUF Structural"
set-aduser -identity Stagerdj -manager Granatpj -title "Designer" -department "100.03 TOL Structural"
set-aduser -identity Bridendj -manager Shkurtav -title "Sr. Designer" -department "100.02 CHI Structural"
set-aduser -identity Hurstdl -manager HayesRJ -title "Sr. Discipline Manager" -department "400.02 CHI Mechanical"
set-aduser -identity MayareD -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Reamerda -manager Schrinmj -title "Project Engineer" -department "425.03 TOL Piping"
set-aduser -identity David.Schmidt -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity David.Woodnorth -manager HayesRJ -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity deb.semego -manager PiperCR -title "Document Controls Coordinator" -department "810.27 PIT Document Control"
set-aduser -identity BalchaDM -manager Mckenzrl -title "Sr. Designer" -department "425.01 CLE Piping"
set-aduser -identity Denise.SetteurSpurio -manager Ledinje -title "IS Generalist " -department "720.01 CLE MIS"
set-aduser -identity PericD -manager Walterac -title "Specialist" -department "600.05 ASH Electrical"
set-aduser -identity Failindj -manager Adamsjk -title "Sr. Designer" -department "400.06 BUF Mechanical"
set-aduser -identity StalteDE -manager jamie.jurin -title "Sr. Engineer" -department "670.01 CLE Power"
set-aduser -identity Doug.Stieb -manager Schrinmj -title "Staff Specialist" -department "425.03 TOL Piping"
set-aduser -identity drew.zimmerman -manager Cussenkg -title "Sr. Engineer" -department "200.02 CHI Civil"
set-aduser -identity Dylan.McNamee -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity Ed.Curtis -manager HayesRJ -title "Sr. Construction Manager" -department "870.02 CHI Construction Management"
set-aduser -identity Elena.Graupera -manager LantinZL -title "Document Controls Coordinator" -department "810.08 IND Document Control"
set-aduser -identity MastanEJ -manager DavidsRJ -title "Staff Architect" -department "050.02 CHI Architectural"
set-aduser -identity Emmanuel.Paredes -manager Shkurtav -title "Drafter" -department "100.02 CHI Structural"
set-aduser -identity GonzalED -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Eric.Whittaker -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity ReedEL -manager mark.seifried -title "Sr. Project Manager" -department "800.01 CLE PM"
set-aduser -identity Zapataem -manager Mclaugma -title "Project Controls Coordinator" -department "820.03 TOL Project Controls"
set-aduser -identity Clougheg -manager Bridgecj -title "Designer" -department "400.01 CLE Mechanical"
set-aduser -identity Dreiergp -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity gary.kieley -manager Bealmk -title "Specialist" -department "425.06 BUF Piping"
set-aduser -identity OlsonGA -manager Jalpan.Soni -title "Sr. Engineer" -department "600.02 CHI Electrical"
set-aduser -identity Gary.Row -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Gary.Stamper -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity KeehnGA -manager Matt.Bedee -title "Specialist" -department "050.01 CLE Architectural"
set-aduser -identity Browngt -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Hlavacgm -manager brent.prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity RoweGF -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Streitgj -manager HayesRJ -title "Sr. Major Project Manager" -department "899.02 CHI SMM"
set-aduser -identity Gise.VanBaren -manager GrelewJF -title "Intern" -department "125.08 IND Asset Integrity"
set-aduser -identity Glen.Hoppe -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Greg.Furgala -manager Bealmk -title "Sr. Designer" -department "425.06 BUF Piping"
set-aduser -identity HollanGA -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity PrudenGA -manager KruppBE -title "Sr. Specialist" -department "600.01 CLE Electrical"
set-aduser -identity Seibolgr -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Buzz.Seydel -manager WrightPJ -title "Construction Manager" -department "870.02 CHI Construction Management"
set-aduser -identity Harold.Kropp -manager Adamsjk -title "Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Igor.Moskalow -manager brent.prazer -title "Designer" -department "100.01 CLE Structural"
set-aduser -identity jack.middleton -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Jackie.Kolling -manager Chris.Hennessey -title "Sr. Designer" -department "100.27 PIT Structural"
set-aduser -identity Jackie.Morris -manager StonemPJ -title "Marketing Manager " -department "760.01 CLE Marketing"
set-aduser -identity Jalpan.Soni -manager TurneyBK -title "Discipline Manager" -department "600.02 CHI Electrical"
set-aduser -identity Adamsjk -manager Sortispd -title "Discipline Manager" -department "400.06 BUF Mechanical"
set-aduser -identity jim.bender -manager Endersmd -title "Sr. Designer" -department "600.27 PIT Electrical"
set-aduser -identity jim.bereda -manager LantinZL -title "Sr. Engineer" -department "600.08 IND Electrical"
set-aduser -identity Blackjl -manager HayesRJ -title "Sr. Major Project Manager" -department "899.02 CHI SMM"
set-aduser -identity Carnsjj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Darbyjd -manager Walterac -title "Discipline Manager" -department "425.05 ASH Piping"
set-aduser -identity GoodJP -manager Adam.Smith -title "Specialist" -department "100.06 BUF Structural"
set-aduser -identity Jim.Harrold -manager brent.prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity Johnsoje -manager KuzmaJS -title "Specialist" -department "425.02 CHI Piping"
set-aduser -identity jamie.jurin -manager brent.prazer -title "Discipline Manager" -department "670.01 CLE Power"
set-aduser -identity James.Rossi -manager WrightPJ -title "Major Projects Manager" -department "899.02 CHI SMM"
set-aduser -identity Sebekjj -manager KruppBE -title "Project Engineer" -department "600.01 CLE Electrical"
set-aduser -identity jim.thomas -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity Weinhejr -manager mark.seifried -title "Director" -department "899.06 BUF SMM"
set-aduser -identity Jimmy.Wood -manager KuzmaJS -title "Sr. Designer" -department "425.02 CHI Piping"
set-aduser -identity Janet.Honeywell -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity davisjl -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Jarrett.Feasley -manager Sortispd -title "Engineer" -department "600.06 BUF Electrical"
set-aduser -identity jason.clouse -manager Chris.Hennessey -title "Engineer" -department "100.27 PIT Structural"
set-aduser -identity jason.lamb -manager Blairtg -title "IT Manager " -department "740.01 CLE Information Technology"
set-aduser -identity KuzmaJS -manager TurneyBK -title "Discipline Manager" -department "425.02 CHI Piping"
set-aduser -identity BihlJC -manager Walterac -title "Sr. Engineer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity jeff.caldwell -manager rob.hattabaugh -title "Sr. Project Manager" -department "900.08 IND SPM"
set-aduser -identity Jeff.Fesko -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity Frederjw -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Jeff.Hollinshead -manager brent.prazer -title "Discipline Manager" -department "475.01 CLE Automation"
set-aduser -identity jeff.martis2 -manager Adamsjk -title "Sr. Designer" -department "400.06 BUF Mechanical"
set-aduser -identity jeff.peters -manager YoungKE -title "Human Resources Manager " -department "710.27 PIT Human Resources"
set-aduser -identity Reinerjm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity jeff.ritter -manager LantinZL -title "Sr. Engineer" -department "650.08 IND Instrumental & Controls"
set-aduser -identity Slabyja -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity Waltonjs -manager Lowrydp -title "Director" -department "425.03 TOL Piping"
set-aduser -identity Jeff.Zunich -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Jen.Smith -manager Jalpan.Soni -title "Engineer" -department "600.02 CHI Electrical"
set-aduser -identity Jennifer.Valek -manager Zdolshtl -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity Kasickjc -manager Jeff.Hollinshead -title "Sr. Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity jeremy.smith -manager Bob.Necciai -title "Sr. Project Manager" -department "900.27 PIT SPM"
set-aduser -identity Pazdanjw -manager KuzmaJS -title "Staff Specialist" -department "425.02 CHI Piping"
set-aduser -identity Wiszjl -manager jason.lamb -title "IT Generalist " -department "740.02 CHI Information Technology"
set-aduser -identity Ledinje -manager sam.barnes -title "Senior Vice President " -department "720.01 CLE MIS"
set-aduser -identity Kilbyjw -manager brent.prazer -title "Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity john.genau -manager Hurstdl -title "Project Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity John.Hayes -manager Schrinmj -title "Specialist" -department "425.03 TOL Piping"
set-aduser -identity Micheljf -manager HodepeTL -title "Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Rossjw -manager brent.prazer -title "Staff Engineer" -department "350.01 CLE Process"
set-aduser -identity John.Rotroff -manager rob.hattabaugh -title "Sr. Project Manager" -department "900.08 IND SPM"
set-aduser -identity john.seaman -manager rob.hattabaugh -title "Sr. Project Manager" -department "900.08 IND SPM"
set-aduser -identity john.spahr -manager Sweenejw -title "Drafter" -department "600.03 TOL Electrical"
set-aduser -identity Sweenejw -manager Waltonjs -title "Sr. Discipline Manager" -department "600.03 TOL Electrical"
set-aduser -identity Jack.Ziegler -manager brent.prazer -title "Sr. Engineer" -department "350.01 CLE Process"
set-aduser -identity AtkinsJD -manager Bridgecj -title "Project Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Jon.Beskin -manager DavidsRJ -title "Designer" -department "050.02 CHI Architectural"
set-aduser -identity joe.andras -manager rob.hattabaugh -title "Project Manager" -department "800.08 IND PM"
set-aduser -identity GrelewJF -manager rob.hattabaugh -title "Sr. Discipline Manager" -department "125.08 IND Asset Integrity"
set-aduser -identity Halljl -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity joseph.imre -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity JaraczJP -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity joseph.kalic -manager Mckenzrl -title "Engineer" -department "425.01 CLE Piping"
set-aduser -identity Khaterjm -manager mark.seifried -title "Director" -department "899.01 CLE SMM"
set-aduser -identity RedmonJM -manager Liuy -title "Sr. Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Joe.Rybicki -manager MakinsAP -title "Designer" -department "100.08 IND Structural"
set-aduser -identity Walterja -manager HayesRJ -title "Director" -department "900.02 CHI SPM"
set-aduser -identity DeakinJR -manager LantinZL -title "Sr. Engineer" -department "400.08 IND Mechanical"
set-aduser -identity MillerJK -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity josh.palyo -manager Endersmd -title "Sr. Engineer" -department "350.27 PIT Process"
set-aduser -identity Josh.Rice -manager Dankoww -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity WraseJW -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity Julian.CoutoCarter -manager MakinsAP -title "Sr. Engineer" -department "100.08 IND Structural"
set-aduser -identity BettinJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Devriejc -manager Mclaugma -title "Cost Scheduler" -department "820.03 TOL Project Controls"
set-aduser -identity Justin.Otero -manager brent.prazer -title "Drafter" -department "350.01 CLE Process"
set-aduser -identity Justin.Pistininzi -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity Justin.Viola -manager Endersmd -title "Drafter" -department "425.27 PIT Piping"
set-aduser -identity Justin.Walters -manager Bridgecj -title "Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Kaleb.Myers -manager Matt.Wisniewski -title "Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity cookke -manager Waltonjs -title "Document Controls Coordinator" -department "810.03 TOL Document Control"
set-aduser -identity Braunske -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity YoungKE -manager sam.barnes -title "Vice President, Human Resources" -department "710.01 CLE Human Resources"
set-aduser -identity Kathleen.Anderson -manager Zdolshtl -title "Accounting Coordinator" -department "750.01 CLE Accounting"
set-aduser -identity kauveh.aynafshar -manager Matt.Wisniewski -title "Designer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity kayan.kartoum -manager Liuy -title "Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Keith.Luttell -manager GrelewJF -title "Sr. Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity Kendall.Welling -manager Shkurtav -title "Engineer" -department "100.28 MAD Structural"
set-aduser -identity Kenneth.Dudzik -manager LantinZL -title "Sr. Specialist" -department "425.08 IND Piping"
set-aduser -identity PutnamKA -manager FaulknAM -title "Staff Estimator" -department "821.02 CHI Estimating"
set-aduser -identity SefcikKP -manager brent.prazer -title "Discipline Manager" -department "200.01 CLE Civil"
set-aduser -identity Kent.Mansfield -manager Darbyjd -title "Sr. Engineer" -department "425.05 ASH Piping"
set-aduser -identity Kevin.Bollinger -manager Walterac -title "Engineer" -department "100.05 ASH Structural"
set-aduser -identity Grubbkl -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity kevin.kerline -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity Payneke -manager Dankoww -title "Accounting Generalist " -department "750.01 CLE Accounting"
set-aduser -identity Winklekm -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Keyana.Williams -manager StonemPJ -title "Marketing Generalist " -department "760.01 CLE Marketing"
set-aduser -identity kim.morphew -manager WrightPJ -title "Document Controls Specialist " -department "810.02 CHI Document Control"
set-aduser -identity Olesicka -manager Dankoww -title "Accounting Generalist " -department "750.01 CLE Accounting"
set-aduser -identity klimka.grubbe -manager GrelewJF -title "Inspection Coordinator " -department "125.08 IND Asset Integrity"
set-aduser -identity Kory.Siverd -manager Khaterjm -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Newmankj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Stephekt -manager KruppBE -title "Sr. Specialist" -department "600.01 CLE Electrical"
set-aduser -identity Cussenkg -manager TurneyBK -title "Discipline Manager" -department "200.02 CHI Civil"
set-aduser -identity Lesleylr -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Laurie.Jones -manager FaulknAM -title "Project Controls Coordinator" -department "820.02 CHI Project Controls"
set-aduser -identity Lawrence.Amerson -manager Jeff.Hollinshead -title "Engineer" -department "475.01 CLE Automation"
set-aduser -identity Krakovlj -manager Bridgecj -title "Sr. Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity lela.conley -manager GrelewJF -title "Inspection Coordinator " -department "125.08 IND Asset Integrity"
set-aduser -identity Lenny.Laird -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity Li.Yan -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity lindsay.kaminski -manager YoungKE -title "HR Specialist " -department "710.01 CLE Human Resources"
set-aduser -identity Melilllm -manager YoungKE -title "Human Resources Manager " -department "710.01 CLE Human Resources"
set-aduser -identity Reganlm -manager Walterac -title "Project Assistant" -department "810.05 ASH Document Control"
set-aduser -identity logan.cover -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity Lonnie.Stump -manager GrelewJF -title "Specialist" -department "125.08 IND Asset Integrity"
set-aduser -identity luke.potter -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity Meyersmj -manager Khaterjm -title "Project Assistant" -department "810.01 CLE Document Control"
set-aduser -identity Mario.Hernandez -manager John.Rotroff -title "Project Manager" -department "800.08 IND PM"
set-aduser -identity Bealmk -manager Sortispd -title "Discipline Manager" -department "425.06 BUF Piping"
set-aduser -identity Friedmm -manager brent.prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity Gaertnmj -manager KruppBE -title "Specialist" -department "600.01 CLE Electrical"
set-aduser -identity Hoggeml -manager Lowrydp -title "Sr. Project Director" -department "900.05 ASH SPM"
set-aduser -identity MullenMA -manager Khaterjm -title "Major Projects Manager" -department "899.01 CLE SMM"
set-aduser -identity Mark.Santillana -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity mark.seifried -manager Wendelce -title "Senior Vice President & GM" -department "699.01 CLE Overhead"
set-aduser -identity Sulzbamd -manager Adamsjk -title "Sr. Specialist" -department "400.06 BUF Mechanical"
set-aduser -identity GeorgeM -manager LantinZL -title "Project Engineer" -department "400.08 IND Mechanical"
set-aduser -identity Althoumj -manager Mckenzrl -title "Staff Engineer" -department "425.01 CLE Piping"
set-aduser -identity Matt.Bedee -manager brent.prazer -title "Discipline Manager" -department "050.01 CLE Architectural"
set-aduser -identity Hammonmr -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Matt.Morgan -manager Waltonjs -title "Sr. Construction Manager" -department "870.03 TOL Construction Management"
set-aduser -identity matt.sands -manager Endersmd -title "Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Matt.Wisniewski -manager Waltonjs -title "Discipline Manager" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity melissa.foster -manager Melilllm -title "HR Generalist " -department "710.01 CLE Human Resources"
set-aduser -identity PorterMR -manager Schrinmj -title "Designer" -department "425.03 TOL Piping"
set-aduser -identity Michael.Deinhammer -manager Geresbc -title "Project Manager" -department "800.10 MIN PM"
set-aduser -identity Endersmd -manager Bob.Necciai -title "Sr. Technical Manager" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity Fonsecmj -manager Schrinmj -title "Sr. Specialist" -department "425.03 TOL Piping"
set-aduser -identity HillMG -manager sam.barnes -title "Director" -department "715.02 CHI Workforce Development"
set-aduser -identity JimeneMJ -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Lytlemp -manager Bridgecj -title "Staff Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity michael.marcinko -manager MakinsAP -title "Sr. Specialist" -department "100.08 IND Structural"
set-aduser -identity Mclaugma -manager Waltonjs -title "Discipline Manager" -department "820.03 TOL Project Controls"
set-aduser -identity Robertmd -manager Granatpj -title "Specialist" -department "100.03 TOL Structural"
set-aduser -identity Salowma -manager Lowrydp -title "Sr. Project Manager" -department "900.05 ASH SPM"
set-aduser -identity Michael.Sarver -manager Endersmd -title "Sr. Designer" -department "425.27 PIT Piping"
set-aduser -identity Schrinmj -manager Waltonjs -title "Discipline Manager" -department "425.03 TOL Piping"
set-aduser -identity Sebonimj -manager HayesRJ -title "Sr. Staff Specialist" -department "821.02 CHI Estimating"
set-aduser -identity SmithMJ -manager Shkurtav -title "Staff Engineer" -department "100.02 CHI Structural"
set-aduser -identity Szalkomg -manager Blairtg -title "IT Manager " -department "740.01 CLE Information Technology"
set-aduser -identity UttechMJ -manager rob.hattabaugh -title "Director" -department "899.28 MAD SMM"
set-aduser -identity Michael.Vargas -manager jason.lamb -title "IT Specialist " -department "740.02 CHI Information Technology"
set-aduser -identity ViancoME -manager jamie.jurin -title "Sr. Designer" -department "670.01 CLE Power"
set-aduser -identity Wheatmd -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity Mike.Picardi -manager Khaterjm -title "Major Projects Manager" -department "899.01 CLE SMM"
set-aduser -identity michelle.casto -manager brent.prazer -title "Sr. Engineer" -department "350.01 CLE Process"
set-aduser -identity Molly.Green -manager Chris.Hennessey -title "Engineer" -department "100.27 PIT Structural"
set-aduser -identity Lowryma -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Myra.Parayno -manager Jalpan.Soni -title "Specialist" -department "600.02 CHI Electrical"
set-aduser -identity FryNL -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Millerne -manager Walterac -title "Designer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Nathan.Ingram -manager Endersmd -title "Specialist" -department "600.27 PIT Electrical"
set-aduser -identity StolleNW -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Nathen.Stevenson -manager KruppBE -title "Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Nestor.Hiso -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity nick.arnold -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity nicholas.tipton -manager Granatpj -title "Intern" -department "100.03 TOL Structural"
set-aduser -identity nicholas.trudeau -manager Endersmd -title "Drafter" -department "425.27 PIT Piping"
set-aduser -identity Nick.Trout -manager Walterac -title "Designer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Noah.Blain -manager Walterac -title "Engineer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity norm.jaworski -manager Mckenzrl -title "Sr. Designer" -department "425.01 CLE Piping"
set-aduser -identity Otto.Wenzel -manager John.Rotroff -title "Project Manager" -department "800.08 IND PM"
set-aduser -identity Patricia.Krupp -manager Jeff.Hollinshead -title "Sr. Designer" -department "475.01 CLE Automation"
set-aduser -identity patrick.conner -manager FaulknAM -title "Sr. Project Controls Specialist" -department "820.02 CHI Project Controls"
set-aduser -identity Flaughpl -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity Patrick.Keenan -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity Granatpj -manager Waltonjs -title "Sr. Discipline Manager" -department "100.03 TOL Structural"
set-aduser -identity Bowlinpa -manager Darbyjd -title "Sr. Specialist" -department "425.05 ASH Piping"
set-aduser -identity StonemPJ -manager sam.barnes -title "Director" -department "760.01 CLE Marketing"
set-aduser -identity Sortispd -manager mark.seifried -title "Director" -department "400.06 BUF Mechanical"
set-aduser -identity WrightPJ -manager HayesRJ -title "Sr. Major Project Manager" -department "899.02 CHI SMM"
set-aduser -identity rana.kalaji -manager brent.prazer -title "Engineer" -department "100.01 CLE Structural"
set-aduser -identity renee.morgan -manager Sortispd -title "Discipline Manager" -department "600.06 BUF Electrical"
set-aduser -identity Peacerj -manager Schrinmj -title "Specialist" -department "425.03 TOL Piping"
set-aduser -identity Bonerich -manager Walterja -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity rick.dugan -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Richard.Genser -manager Chris.Hennessey -title "Designer" -department "100.27 PIT Structural"
set-aduser -identity HayesRJ -manager Wendelce -title "Senior Vice President & GM" -department "699.02 CHI Overhead"
set-aduser -identity Johnsora -manager Walterac -title "Sr. Specialist" -department "100.05 ASH Structural"
set-aduser -identity Mckenzrl -manager brent.prazer -title "Discipline Manager" -department "425.01 CLE Piping"
set-aduser -identity rich.phillips -manager FaulknAM -title "Staff Estimator" -department "821.02 CHI Estimating"
set-aduser -identity Yoergerw -manager KruppBE -title "Sr. Designer" -department "600.01 CLE Electrical"
set-aduser -identity Gravesrm -manager Mclaugma -title "Project Controls Coordinator" -department "820.03 TOL Project Controls"
set-aduser -identity Robert.Adamski -manager HodepeTL -title "Project Engineer " -department "350.02 CHI Process"
set-aduser -identity Bordonra -manager brent.prazer -title "Project Engineer" -department "350.01 CLE Process"
set-aduser -identity DavidsRJ -manager HayesRJ -title "Director" -department "050.02 CHI Architectural"
set-aduser -identity GawronRT -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity rob.hattabaugh -manager Wendelce -title "Vice President & GM" -department "699.08 IND Overhead"
set-aduser -identity JankeyRW -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity Robert.Kirkpatrick -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity robert.leugers -manager WrightPJ -title "Sr. Construct Supt" -department "870.02 CHI Construction Management"
set-aduser -identity Olschlre -manager Podhorrl -title "IT Generalist " -department "740.01 CLE Information Technology"
set-aduser -identity Podhorrl -manager Blairtg -title "IT Manager " -department "740.01 CLE Information Technology"
set-aduser -identity Schmidrc -manager jason.lamb -title "IT Generalist " -department "740.01 CLE Information Technology"
set-aduser -identity Bob.Smering -manager mark.seifried -title "Sr. Project Manager" -department "900.06 BUF SPM"
set-aduser -identity Strosnrl -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Rob.Tibbitts -manager sam.barnes -title "Director" -department "780.01 CLE Legal"
set-aduser -identity Vidrare -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity Weiganrk -manager KruppBE -title "Sr. Designer" -department "600.01 CLE Electrical"
set-aduser -identity Rothrj -manager Bridgecj -title "Sr. Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Roger.Hieser -manager HayesRJ -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Cuculirj -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Ledinrr -manager Ledinrr -title "Chairman" -department "799.01 CLE Corp Executives"
set-aduser -identity rosario.scibona -manager Ledinje -title "IS Manager " -department "720.01 CLE MIS"
set-aduser -identity Overhorj -manager Sortispd -title "Specialist" -department "600.06 BUF Electrical"
set-aduser -identity Samantha.Fox -manager Bob.Necciai -title "Business Development Director" -department "930.27 PIT Business Development"
set-aduser -identity sam.barnes -manager Ledinrr -title "President" -department "799.01 CLE Corp Executives"
set-aduser -identity Sam.Bennett -manager KruppBE -title "Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Sam.Blood -manager PiperCR -title "Project Controls Coordinator " -department "820.27 PIT Project Controls"
set-aduser -identity Santiago.villegas -manager Shkurtav -title "Designer" -department "100.02 CHI Structural"
set-aduser -identity Munjesr -manager Schrinmj -title "Staff Engineer" -department "425.03 TOL Piping"
set-aduser -identity Feeneysm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity CarneySP -manager WrightPJ -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity sean.godfrey -manager Endersmd -title "Sr. Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Wisniesp -manager Blairtg -title "IT Generalist " -department "740.03 TOL Information Technology"
set-aduser -identity sebastian.dewitt -manager MakinsAP -title "Intern" -department "100.08 IND Structural"
set-aduser -identity shane.gulvas -manager John.Rotroff -title "Project Manager" -department "800.08 IND PM"
set-aduser -identity shannon.owen -manager Bob.Necciai -title "Business Development Manager" -department "930.27 PIT Business Development"
set-aduser -identity Shawn.Dishauzi -manager mark.seifried -title "Director" -department "890.01 CLE Health & Safety"
set-aduser -identity Shawn.Rudy -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity sherkoh.anz -manager Sweenejw -title "Engineer" -department "600.03 TOL Electrical"
set-aduser -identity Mike.Paulic -manager Mckenzrl -title "Sr. Specialist" -department "425.01 CLE Piping"
set-aduser -identity Steve.Maggiano -manager KruppBE -title "Staff Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Stephen.Wagner -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity WeinheSG -manager Adamsjk -title "Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Bogaersm -manager HayesRJ -title "Director" -department "880.02 CHI Quality"
set-aduser -identity Shogresc -manager Liuy -title "Sr. Specialist" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Sinhask -manager Jalpan.Soni -title "Sr. Engineer" -department "600.02 CHI Electrical"
set-aduser -identity sumita.pol -manager Jeff.Hollinshead -title "Sr. Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity SilajSM -manager WrightPJ -title "Procurement Agent" -department "840.02 CHI Procurement"
set-aduser -identity HodepeTL -manager TurneyBK -title "Discipline Manager" -department "350.02 CHI Process"
set-aduser -identity Zdolshtl -manager Dankoww -title "Accounting Manager " -department "750.01 CLE Accounting"
set-aduser -identity reynoltl -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Tanner.Drees -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity BellTR -manager Walterja -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity Riedeltw -manager Khaterjm -title "Discipline Manager" -department "820.01 CLE Project Controls"
set-aduser -identity Koniectl -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity TaylorTR -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Blairtg -manager sam.barnes -title "Director" -department "740.01 CLE Information Technology"
set-aduser -identity Thomas.McKeown -manager Bridgecj -title "Sr. Designer" -department "400.01 CLE Mechanical"
set-aduser -identity Thomas.Paprocki -manager Liuy -title "Staff Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Pienostm -manager brent.prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity thomas.twardowski -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity Voytkotl -manager brent.prazer -title "Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity Wickerth -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity tiffany.malcom -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity Tholete -manager Mckenzrl -title "Sr. Specialist" -department "425.01 CLE Piping"
set-aduser -identity Palmertp -manager Adam.Smith -title "Sr. Specialist" -department "100.06 BUF Structural"
set-aduser -identity Tim.Saunders -manager Adam.Smith -title "Designer" -department "100.06 BUF Structural"
set-aduser -identity Keyta -manager Khaterjm -title "Project Assistant" -department "810.01 CLE Document Control"
set-aduser -identity CullerTL -manager Khaterjm -title "Sr. Procurement Agent" -department "840.01 CLE Procurement"
set-aduser -identity travis.culver -manager GrelewJF -title "Inspector" -department "125.08 IND Asset Integrity"
set-aduser -identity trenton.vicker -manager Jalpan.Soni -title "Engineer" -department "600.02 CHI Electrical"
set-aduser -identity trevor.misch -manager LantinZL -title "Intern" -department "600.08 IND Electrical"
set-aduser -identity Tristan.Griffith -manager Walterac -title "Drafter" -department "100.05 ASH Structural"
set-aduser -identity Tyler.Baird -manager Matt.Bedee -title "Designer" -department "050.01 CLE Architectural"
set-aduser -identity BrownTJ -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity victor.guerrero -manager KuzmaJS -title "Designer" -department "425.02 CHI Piping"
set-aduser -identity Victor.Sibiga -manager HodepeTL -title "Engineer" -department "350.02 CHI Process"
set-aduser -identity Wilkinvp -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Dankoww -manager OconnoDP -title "Vice President, Finance" -department "750.01 CLE Accounting"
set-aduser -identity Wesley.McCurdy -manager Bridgecj -title "Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Wes.Stewart -manager Endersmd -title "Project Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Bill.Celian -manager Waltonjs -title "Construction Manager" -department "870.03 TOL Construction Management"
set-aduser -identity William.Foster -manager TurneyBK -title "Engineer" -department "670.02 CHI Power"
set-aduser -identity Pricewf -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity Rabquewa -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity WinterWF -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity ZatoWA -manager LantinZL -title "Sr. Specialist" -department "425.08 IND Piping"
set-aduser -identity Kordahyk -manager brent.prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity yafei.liu -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Liuy -manager TurneyBK -title "Discipline Manager" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity LantinZL -manager rob.hattabaugh -title "Sr. Technical Manager" -department "100.08 IND Structural"
set-aduser -identity HitesZH -manager Granatpj -title "Engineer" -department "100.03 TOL Structural"


===

# 4/4/24

add-ADGroupMember -Identity "Ashland Forecast Directory Access" -Members ASH_100_Mngr
add-ADGroupMember -Identity "Ashland Forecast Directory Access" -Members ASH_350_Mngr
add-ADGroupMember -Identity "Ashland Forecast Directory Access" -Members ASH_400_Mngr
add-ADGroupMember -Identity "Ashland Forecast Directory Access" -Members ASH_425_Mngr
add-ADGroupMember -Identity "Ashland Forecast Directory Access" -Members ASH_600_Mngr
add-ADGroupMember -Identity "Ashland Forecast Directory Access" -Members ASH_650_Mngr
add-ADGroupMember -Identity "Ashland Forecast Directory Access" -Members ASH_690_Mngr
add-ADGroupMember -Identity "Ashland Forecast Directory Access" -Members ASH_699_Mngr
add-ADGroupMember -Identity "Ashland Forecast Directory Access" -Members ASH_800_Mngr
add-ADGroupMember -Identity "Ashland Forecast Directory Access" -Members ASH_810_Mngr
add-ADGroupMember -Identity "Ashland Forecast Directory Access" -Members ASH_820_Mngr
add-ADGroupMember -Identity "Ashland Forecast Directory Access" -Members ASH_900_Mngr
add-ADGroupMember -Identity "Buffalo Forecast Directory Access" -Members BUF_100_Mngr
add-ADGroupMember -Identity "Buffalo Forecast Directory Access" -Members BUF_350_Mngr
add-ADGroupMember -Identity "Buffalo Forecast Directory Access" -Members BUF_400_Mngr
add-ADGroupMember -Identity "Buffalo Forecast Directory Access" -Members BUF_425_Mngr
add-ADGroupMember -Identity "Buffalo Forecast Directory Access" -Members BUF_600_Mngr
add-ADGroupMember -Identity "Buffalo Forecast Directory Access" -Members BUF_650_Mngr
add-ADGroupMember -Identity "Buffalo Forecast Directory Access" -Members BUF_699_Mngr
add-ADGroupMember -Identity "Buffalo Forecast Directory Access" -Members BUF_800_Mngr
add-ADGroupMember -Identity "Buffalo Forecast Directory Access" -Members BUF_810_Mngr
add-ADGroupMember -Identity "Buffalo Forecast Directory Access" -Members BUF_900_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_050_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_100_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_200_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_350_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_400_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_425_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_600_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_650_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_670_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_699_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_710_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_740_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_799_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_800_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_810_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_820_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_821_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_840_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_870_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_880_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_897_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_899_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_900_Mngr
add-ADGroupMember -Identity "Chicago Forecast Directory Access" -Members CHI_930_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_035_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_050_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_100_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_125_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_200_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_300_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_350_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_400_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_425_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_450_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_475_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_600_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_650_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_670_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_699_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_710_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_720_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_740_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_750_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_760_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_780_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_790_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_799_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_800_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_810_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_820_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_821_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_840_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_870_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_890_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_897_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_899_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_900_Mngr
add-ADGroupMember -Identity "Cleveland Forecast Directory Access" -Members CLE_930_Mngr
add-ADGroupMember -Identity "Madison Forecast Directory Access" -Members MAD_100_Mngr
add-ADGroupMember -Identity "Madison Forecast Directory Access" -Members MAD_350_Mngr
add-ADGroupMember -Identity "Madison Forecast Directory Access" -Members MAD_400_Mngr
add-ADGroupMember -Identity "Madison Forecast Directory Access" -Members MAD_600_Mngr
add-ADGroupMember -Identity "Madison Forecast Directory Access" -Members MAD_650_Mngr
add-ADGroupMember -Identity "Madison Forecast Directory Access" -Members MAD_670_Mngr
add-ADGroupMember -Identity "Madison Forecast Directory Access" -Members MAD_800_Mngr
add-ADGroupMember -Identity "Madison Forecast Directory Access" -Members MAD_899_Mngr
add-ADGroupMember -Identity "Madison Forecast Directory Access" -Members MAD_900_Mngr
add-ADGroupMember -Identity "Indiana Forecast Directory Access" -Members NWI_100_Mngr
add-ADGroupMember -Identity "Indiana Forecast Directory Access" -Members NWI_125_Mngr
add-ADGroupMember -Identity "Indiana Forecast Directory Access" -Members NWI_350_Mngr
add-ADGroupMember -Identity "Indiana Forecast Directory Access" -Members NWI_400_Mngr
add-ADGroupMember -Identity "Indiana Forecast Directory Access" -Members NWI_425_Mngr
add-ADGroupMember -Identity "Indiana Forecast Directory Access" -Members NWI_600_Mngr
add-ADGroupMember -Identity "Indiana Forecast Directory Access" -Members NWI_650_Mngr
add-ADGroupMember -Identity "Indiana Forecast Directory Access" -Members NWI_699_Mngr
add-ADGroupMember -Identity "Indiana Forecast Directory Access" -Members NWI_800_Mngr
add-ADGroupMember -Identity "Indiana Forecast Directory Access" -Members NWI_810_Mngr
add-ADGroupMember -Identity "Indiana Forecast Directory Access" -Members NWI_820_Mngr
add-ADGroupMember -Identity "Indiana Forecast Directory Access" -Members NWI_900_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_100_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_350_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_400_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_425_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_600_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_650_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_699_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_710_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_800_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_810_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_820_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_870_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_899_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_900_Mngr
add-ADGroupMember -Identity "Pittsburgh Forecast Directory Access" -Members PIT_930_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_100_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_350_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_400_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_425_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_600_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_650_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_690_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_699_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_800_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_810_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_820_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_870_Mngr
add-ADGroupMember -Identity "Toledo Forecast Directory Access" -Members TOL_900_Mngr

add-ADGroupMember -Identity PIT_930_Mngr -Members jason.lamb


New-ADUser -Name “Jordan Unmuth" -GivenName "Jordan" -Surname "Unmuth" -displayname "Jordan Unmuth" -SamAccountName "jordan.unmuth" -path "OU=600,OU=MAD,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "jordan.unmuth@middough.com" -department "600.28 MAD Electrical" -office "Madison" -state "WI" -initials "JU" -StreetAddress "2801 Crossroads Dr, Ste 2200" -City "Madison" -PostalCode "53718" -title "Senior Engineer" -company "Middough" -manager "LantinZL";set-aduser "jordan.unmuth" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members jordan.unmuth; Add-ADGroupMember -identity "CAD Applications" -members jordan.unmuth; Add-ADGroupMember -identity "Engineering_Dept" -members jordan.unmuth; Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members jordan.unmuth; Add-ADGroupMember -identity MAD_600 -members jordan.unmuth; Add-ADGroupMember -identity "Engineering_Dept" -members jordan.unmuth; Add-ADGroupMember -identity "SSO" -members jordan.unmuth; Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jordan.unmuth;;

4/18/24

Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members jordan.unmuth; 
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members jordan.unmuth;;

===

4/22/24
set-aduser -identity Adamsjk -manager Sortispd -title "Discipline Manager" -department "400.06 BUF Mechanical"
set-aduser -identity Robert.Adamski -manager HodepeTL -title "Project Engineer " -department "350.02 CHI Process"
set-aduser -identity AldridBC -manager Liuy -title "Specialist" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity raya.Alhamzeh -manager CookCC -title "Engineer" -department "100.01 CLE Structural"
set-aduser -identity Althoumj -manager Mckenzrl -title "Staff Engineer" -department "425.01 CLE Piping"
set-aduser -identity charlie.amaro -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Lawrence.Amerson -manager brent.prazer -title "Engineer" -department "475.01 CLE Automation"
set-aduser -identity Kathleen.Anderson -manager Zdolshtl -title "Accounting Coordinator" -department "750.01 CLE Accounting"
set-aduser -identity joe.andras -manager rob.hattabaugh -title "Project Manager" -department "800.08 NWI PM"
set-aduser -identity sherkoh.anz -manager Sweenejw -title "Engineer" -department "600.03 TOL Electrical"
set-aduser -identity nick.arnold -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity AtkinsJD -manager Bridgecj -title "Project Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity kauveh.aynafshar -manager Matt.Wisniewski -title "Designer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Ashama.Babooram -manager Darbyjd -title "Engineer" -department "425.05 ASH Piping"
set-aduser -identity Tyler.Baird -manager Matt.Bedee -title "Designer" -department "050.01 CLE Architectural"
set-aduser -identity BalchaDM -manager Mckenzrl -title "Sr. Designer" -department "425.01 CLE Piping"
set-aduser -identity sam.barnes -manager Ledinrr -title "CEO & President" -department "799.01 CLE Corp Executives"
set-aduser -identity Bealmk -manager Sortispd -title "Discipline Manager" -department "425.06 BUF Piping"
set-aduser -identity Matt.Bedee -manager brent.prazer -title "Discipline Manager" -department "050.01 CLE Architectural"
set-aduser -identity Allen.Beeler -manager GrelewJF -title "Project Engineer " -department "125.08 NWI Asset Integrity"
set-aduser -identity jim.bender -manager Endersmd -title "Sr. Designer" -department "600.27 PIT Electrical"
set-aduser -identity Sam.Bennett -manager KruppBE -title "Engineer" -department "600.01 CLE Electrical"
set-aduser -identity jim.bereda -manager LantinZL -title "Sr. Engineer" -department "600.08 NWI Electrical"
set-aduser -identity Jon.Beskin -manager DavidsRJ -title "Designer" -department "050.02 CHI Architectural"
set-aduser -identity BettinJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Charu.Bhat -manager HayesRJ -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity BihlJC -manager Walterac -title "Sr. Engineer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Blackjl -manager HayesRJ -title "Sr. Major Projects Manager" -department "899.02 CHI SMM"
set-aduser -identity Noah.Blain -manager Walterac -title "Engineer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Blairtg -manager sam.barnes -title "Director" -department "740.01 CLE Information Technology"
set-aduser -identity Sam.Blood -manager PiperCR -title "Project Controls Coordinator " -department "820.27 PIT Project Controls"
set-aduser -identity Bogaersm -manager HayesRJ -title "Director" -department "880.02 CHI Quality"
set-aduser -identity Kevin.Bollinger -manager Walterac -title "Engineer" -department "100.05 ASH Structural"
set-aduser -identity Bonerich -manager Walterja -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity Bordonra -manager brent.prazer -title "Project Engineer" -department "350.01 CLE Process"
set-aduser -identity Bowlinpa -manager Darbyjd -title "Sr. Specialist" -department "425.05 ASH Piping"
set-aduser -identity Braunske -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity Bridendj -manager Shkurtav -title "Sr. Designer" -department "100.02 CHI Structural"
set-aduser -identity Bridgecj -manager brent.prazer -title "Discipline Manager" -department "400.01 CLE Mechanical"
set-aduser -identity BrownTJ -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Browngt -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity jeff.caldwell -manager rob.hattabaugh -title "Sr. Project Manager" -department "900.08 NWI SPM"
set-aduser -identity CarneySP -manager WrightPJ -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity Carnsjj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Carmen.Carr -manager Walterac -title "Sr. Specialist" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Bill.Celian -manager Waltonjs -title "Construction Manager" -department "870.03 TOL Construction Management"
set-aduser -identity Chihakaa -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity adam.clark -manager jamie.jurin -title "Sr. Engineer" -department "670.10 MIN Power"
set-aduser -identity Clougheg -manager Bridgecj -title "Designer" -department "400.01 CLE Mechanical"
set-aduser -identity jason.clouse -manager Chris.Hennessey -title "Engineer" -department "100.27 PIT Structural"
set-aduser -identity lela.conley -manager GrelewJF -title "Inspection Coordinator " -department "125.08 NWI Asset Integrity"
set-aduser -identity patrick.conner -manager FaulknAM -title "Sr. Project Controls Specialist" -department "820.02 CHI Project Controls"
set-aduser -identity cookke -manager Waltonjs -title "Document Controls Coordinator" -department "810.03 TOL Document Control"
set-aduser -identity Steve.Coons -manager Hurstdl -title "Sr. Staff Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Julian.CoutoCarter -manager MakinsAP -title "Sr. Engineer" -department "100.08 NWI Structural"
set-aduser -identity logan.cover -manager GrelewJF -title "Inspector" -department "125.08 NWI Asset Integrity"
set-aduser -identity Cuculirj -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity CullerTL -manager Khaterjm -title "Procurement Manager" -department "840.01 CLE Procurement"
set-aduser -identity travis.culver -manager GrelewJF -title "Inspector" -department "125.08 NWI Asset Integrity"
set-aduser -identity Cussenkg -manager TurneyBK -title "Discipline Manager" -department "200.02 CHI Civil"
set-aduser -identity Dankoww -manager OconnoDP -title "Vice President, Finance" -department "750.01 CLE Accounting"
set-aduser -identity Darbyjd -manager Walterac -title "Discipline Manager" -department "425.05 ASH Piping"
set-aduser -identity brad.daugharthy -manager Podhorrl -title "IT Generalist " -department "740.01 CLE Information Technology"
set-aduser -identity DavidsRJ -manager HayesRJ -title "Director" -department "050.02 CHI Architectural"
set-aduser -identity davisjl -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Jose.DeJesus -manager KruppBE -title "Specialist" -department "600.01 CLE Electrical"
set-aduser -identity DeakinJR -manager LantinZL -title "Sr. Engineer" -department "400.08 NWI Mechanical"
set-aduser -identity Michael.Deinhammer -manager Geresbc -title "Project Manager" -department "800.10 MIN PM"
set-aduser -identity Daniel.Devadoss -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Devriejc -manager Mclaugma -title "Cost Scheduler" -department "820.03 TOL Project Controls"
set-aduser -identity sebastian.dewitt -manager MakinsAP -title "Intern" -department "100.08 NWI Structural"
set-aduser -identity Shawn.Dishauzi -manager mark.seifried -title "Director" -department "890.01 CLE Health & Safety"
set-aduser -identity clint.downey -manager UttechMJ -title "Project Manager" -department "800.28 MAD PM"
set-aduser -identity Tanner.Drees -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Kenneth.Dudzik -manager LantinZL -title "Sr. Specialist" -department "425.08 NWI Piping"
set-aduser -identity rick.dugan -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Durkindp -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity chris.edwards -manager Endersmd -title "Sr. Engineer" -department "350.27 PIT Process"
set-aduser -identity Endersmd -manager Bob.Necciai -title "Sr. Technical Manager" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity Failindj -manager Adamsjk -title "Sr. Designer" -department "400.06 BUF Mechanical"
set-aduser -identity FaulknAM -manager WrightPJ -title "Discipline Manager" -department "820.02 CHI Project Controls"
set-aduser -identity Jarrett.Feasley -manager renee.morgan -title "Engineer" -department "600.06 BUF Electrical"
set-aduser -identity Feeneysm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Jeff.Fesko -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity Flaughpl -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity Fonsecmj -manager Schrinmj -title "Sr. Specialist" -department "425.03 TOL Piping"
set-aduser -identity melissa.foster -manager Melilllm -title "HR Generalist " -department "710.01 CLE Human Resources"
set-aduser -identity Samantha.Fox -manager Bob.Necciai -title "Business Development Director" -department "930.27 PIT Business Development"
set-aduser -identity Frederjw -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Friedmm -manager brent.prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity FryNL -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Greg.Furgala -manager Bealmk -title "Sr. Designer" -department "425.06 BUF Piping"
set-aduser -identity Gaertnmj -manager KruppBE -title "Specialist" -department "600.01 CLE Electrical"
set-aduser -identity andrew.gallagher -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity BellTR -manager Walterja -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity GawronRT -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity john.genau -manager Hurstdl -title "Project Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Richard.Genser -manager Chris.Hennessey -title "Designer" -department "100.27 PIT Structural"
set-aduser -identity GeorgeM -manager LantinZL -title "Project Engineer" -department "400.08 NWI Mechanical"
set-aduser -identity Geresbc -manager HayesRJ -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity Anthony.Gigante -manager Dankoww -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity sean.godfrey -manager Ray.Shore -title "Sr. Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity GonzalED -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity GoodJP -manager Adam.Smith -title "Specialist" -department "100.06 BUF Structural"
set-aduser -identity Granatpj -manager Waltonjs -title "Sr. Discipline Manager" -department "100.03 TOL Structural"
set-aduser -identity Gravesrm -manager Mclaugma -title "Project Controls Coordinator" -department "820.03 TOL Project Controls"
set-aduser -identity Molly.Green -manager Chris.Hennessey -title "Engineer" -department "100.27 PIT Structural"
set-aduser -identity GrelewJF -manager rob.hattabaugh -title "Sr. Discipline Manager" -department "125.08 NWI Asset Integrity"
set-aduser -identity Tristan.Griffith -manager Walterac -title "Drafter" -department "100.05 ASH Structural"
set-aduser -identity Grubbkl -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity klimka.grubbe -manager GrelewJF -title "Inspection Coordinator " -department "125.08 NWI Asset Integrity"
set-aduser -identity victor.guerrero -manager KuzmaJS -title "Designer" -department "425.02 CHI Piping"
set-aduser -identity shane.gulvas -manager John.Rotroff -title "Project Manager" -department "800.08 NWI PM"
set-aduser -identity Halljl -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity Abdallah.Hamad -manager Endersmd -title "Sr. Engineer" -department "600.27 PIT Electrical"
set-aduser -identity Hammonmr -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Jim.Harrold -manager brent.prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity reynoltl -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity allison.hassig -manager WrightPJ -title "Discipline Manager" -department "840.02 CHI Procurement"
set-aduser -identity Autumn.Hatcher -manager Darbyjd -title "Drafter" -department "425.05 ASH Piping"
set-aduser -identity rob.hattabaugh -manager Wendelce -title "Vice President & GM" -department "699.08 NWI Overhead"
set-aduser -identity HayesRJ -manager Wendelce -title "Senior Vice President & GM" -department "699.02 CHI Overhead"
set-aduser -identity John.Hayes -manager Schrinmj -title "Specialist" -department "425.03 TOL Piping"
set-aduser -identity Dan.Heberer -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Chris.Hennessey -manager Endersmd -title "Discipline Manager" -department "100.27 PIT Structural"
set-aduser -identity Mario.Hernandez -manager John.Rotroff -title "Project Manager" -department "800.08 NWI PM"
set-aduser -identity Roger.Hieser -manager HayesRJ -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Hilbercr -manager Ledinje -title "IS Generalist " -department "720.01 CLE MIS"
set-aduser -identity HillMG -manager sam.barnes -title "Director" -department "715.02 CHI Workforce Development"
set-aduser -identity Nestor.Hiso -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity HitesZH -manager Granatpj -title "Engineer" -department "100.03 TOL Structural"
set-aduser -identity Hlavacgm -manager brent.prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity HodepeTL -manager TurneyBK -title "Discipline Manager" -department "350.02 CHI Process"
set-aduser -identity Hoggeml -manager Lowrydp -title "Director" -department "900.05 ASH SPM"
set-aduser -identity HollanGA -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity Jeff.Hollinshead -manager brent.prazer -title "Staff Engineer" -department "475.01 CLE Automation"
set-aduser -identity Glen.Hoppe -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Hoppelcl -manager brent.prazer -title "Sr. Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity Hoyecl -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Hurstdl -manager HayesRJ -title "Sr. Discipline Manager" -department "400.02 CHI Mechanical"
set-aduser -identity joseph.imre -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Nathan.Ingram -manager Endersmd -title "Specialist" -department "600.27 PIT Electrical"
set-aduser -identity Brad.Ingram -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity JankeyRW -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity JaraczJP -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity norm.jaworski -manager Mckenzrl -title "Sr. Designer" -department "425.01 CLE Piping"
set-aduser -identity JimeneMJ -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Johnsora -manager Walterac -title "Sr. Specialist" -department "100.05 ASH Structural"
set-aduser -identity Johnsoje -manager KuzmaJS -title "Specialist" -department "425.02 CHI Piping"
set-aduser -identity jamie.jurin -manager brent.prazer -title "Discipline Manager" -department "670.01 CLE Power"
set-aduser -identity rana.kalaji -manager brent.prazer -title "Engineer" -department "100.01 CLE Structural"
set-aduser -identity joseph.kalic -manager Mckenzrl -title "Engineer" -department "425.01 CLE Piping"
set-aduser -identity lindsay.kaminski -manager YoungKE -title "HR Specialist " -department "710.01 CLE Human Resources"
set-aduser -identity Christian.Kanfeld -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity kayan.kartoum -manager Liuy -title "Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Kasickjc -manager brent.prazer -title "Sr. Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity KeehnGA -manager Matt.Bedee -title "Specialist" -department "050.01 CLE Architectural"
set-aduser -identity Patrick.Keenan -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity kevin.kerline -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity Keyta -manager Khaterjm -title "Project Assistant" -department "810.01 CLE Document Control"
set-aduser -identity Khaterjm -manager mark.seifried -title "Director" -department "899.01 CLE SMM"
set-aduser -identity gary.kieley -manager Bealmk -title "Specialist" -department "425.06 BUF Piping"
set-aduser -identity Kilbyjw -manager brent.prazer -title "Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity bryan.king -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity Robert.Kirkpatrick -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Jackie.Kolling -manager Chris.Hennessey -title "Sr. Designer" -department "100.27 PIT Structural"
set-aduser -identity Koniectl -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Kordahyk -manager brent.prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity Krakovlj -manager Bridgecj -title "Sr. Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Harold.Kropp -manager Adamsjk -title "Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Patricia.Krupp -manager brent.prazer -title "Sr. Designer" -department "475.01 CLE Automation"
set-aduser -identity KruppBE -manager mark.seifried -title "Sr. Discipline Director" -department "600.01 CLE Electrical"
set-aduser -identity KuzmaJS -manager TurneyBK -title "Discipline Manager" -department "425.02 CHI Piping"
set-aduser -identity Lenny.Laird -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity jason.lamb -manager Blairtg -title "IT Manager " -department "740.01 CLE Information Technology"
set-aduser -identity LantinZL -manager rob.hattabaugh -title "Sr. Technical Manager" -department "100.08 NWI Structural"
set-aduser -identity Ledinje -manager sam.barnes -title "Senior Vice President" -department "720.01 CLE MIS"
set-aduser -identity Ledinrr -manager Ledinrr -title "Chairman" -department "799.01 CLE Corp Executives"
set-aduser -identity jeren.lemanek -manager StonemPJ -title "Intern" -department "760.01 CLE Marketing"
set-aduser -identity Lenharbd -manager Lowrydp -title "Director" -department "900.03 TOL SPM"
set-aduser -identity Leonarcm -manager Dankoww -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity Lesleylr -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity robert.leugers -manager WrightPJ -title "Sr. Construct Supt" -department "870.02 CHI Construction Management"
set-aduser -identity yafei.liu -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Liuy -manager TurneyBK -title "Discipline Manager" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity matt.locher -manager Walterac -title "Sr. Specialist" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Connor.Loughlin -manager Hurstdl -title "Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Lowrydp -manager Wendelce -title "Senior Vice President & GM" -department "699.03 TOL Overhead"
set-aduser -identity Lowryma -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Keith.Luttell -manager GrelewJF -title "Sr. Inspector" -department "125.08 NWI Asset Integrity"
set-aduser -identity alex.lutz -manager Endersmd -title "Sr. Engineer" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity Lytlemp -manager Bridgecj -title "Staff Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Steve.Maggiano -manager KruppBE -title "Staff Engineer" -department "600.01 CLE Electrical"
set-aduser -identity brandon.magnusen -manager MakinsAP -title "Engineer" -department "100.08 NWI Structural"
set-aduser -identity MakinsAP -manager LantinZL -title "Discipline Manager" -department "100.08 NWI Structural"
set-aduser -identity tiffany.malcom -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity jeff.martis2 -manager Adamsjk -title "Sr. Designer" -department "400.06 BUF Mechanical"
set-aduser -identity MastanEJ -manager DavidsRJ -title "Staff Architect" -department "050.02 CHI Architectural"
set-aduser -identity MayareD -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity ben.mccoy -manager Adam.Smith -title "Engineer" -department "100.06 BUF Structural"
set-aduser -identity Wesley.McCurdy -manager Bridgecj -title "Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Mckenzrl -manager brent.prazer -title "Discipline Manager" -department "425.01 CLE Piping"
set-aduser -identity Thomas.McKeown -manager Bridgecj -title "Sr. Designer" -department "400.01 CLE Mechanical"
set-aduser -identity Mclaugma -manager Waltonjs -title "Discipline Manager" -department "820.03 TOL Project Controls"
set-aduser -identity Dylan.McNamee -manager GrelewJF -title "Inspector" -department "125.08 NWI Asset Integrity"
set-aduser -identity Elena.Graupera -manager LantinZL -title "Document Controls Coordinator" -department "810.08 NWI Document Control"
set-aduser -identity Melilllm -manager YoungKE -title "Human Resources Manager " -department "710.01 CLE Human Resources"
set-aduser -identity Curtis.Merow -manager Chris.Hennessey -title "Sr. Specialist" -department "100.27 PIT Structural"
set-aduser -identity Meyersmj -manager Khaterjm -title "Project Assistant" -department "810.01 CLE Document Control"
set-aduser -identity jack.middleton -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity MillerJK -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity Millerne -manager Walterac -title "Designer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Andy.Minderman -manager mark.seifried -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity trevor.misch -manager LantinZL -title "Intern" -department "600.08 NWI Electrical"
set-aduser -identity Chris.Moran -manager David.Schmidt -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity renee.morgan -manager Sortispd -title "Discipline Manager" -department "600.06 BUF Electrical"
set-aduser -identity Matt.Morgan -manager Waltonjs -title "Sr. Construction Manager" -department "870.03 TOL Construction Management"
set-aduser -identity kim.morphew -manager WrightPJ -title "Document Controls Specialist " -department "810.02 CHI Document Control"
set-aduser -identity Jackie.Morris -manager StonemPJ -title "Marketing Manager " -department "760.01 CLE Marketing"
set-aduser -identity MullenMA -manager Khaterjm -title "Major Projects Manager" -department "899.01 CLE SMM"
set-aduser -identity Munjesr -manager Schrinmj -title "Staff Engineer" -department "425.03 TOL Piping"
set-aduser -identity Chris.Muntz -manager Chris.Hennessey -title "Specialist" -department "100.27 PIT Structural"
set-aduser -identity Kaleb.Myers -manager Matt.Wisniewski -title "Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Nashad -manager Adamsjk -title "Staff Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Bob.Necciai -manager Wendelce -title "Senior Vice President & GM" -department "699.27 PIT Overhead"
set-aduser -identity Newmankj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity OconnoDP -manager sam.barnes -title "Senior Vice President & CFO" -department "799.01 CLE Corp Executives"
set-aduser -identity Olesicka -manager Dankoww -title "Accounting Generalist" -department "750.01 CLE Accounting"
set-aduser -identity Olschlre -manager Podhorrl -title "IT Generalist " -department "740.01 CLE Information Technology"
set-aduser -identity OlsonGA -manager Jalpan.Soni -title "Sr. Engineer" -department "600.02 CHI Electrical"
set-aduser -identity Jeremias.Ortiz -manager Schrinmj -title "Designer" -department "425.03 TOL Piping"
set-aduser -identity Justin.Otero -manager brent.prazer -title "Drafter" -department "350.01 CLE Process"
set-aduser -identity Overhorj -manager renee.morgan -title "Specialist" -department "600.06 BUF Electrical"
set-aduser -identity shannon.owen -manager Bob.Necciai -title "Business Development Director" -department "930.27 PIT Business Development"
set-aduser -identity Palmertp -manager Adam.Smith -title "Sr. Specialist" -department "100.06 BUF Structural"
set-aduser -identity Palmerbj -manager KruppBE -title "Designer" -department "600.01 CLE Electrical"
set-aduser -identity josh.palyo -manager Endersmd -title "Sr. Engineer" -department "350.27 PIT Process"
set-aduser -identity Thomas.Paprocki -manager Liuy -title "Staff Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Myra.Parayno -manager Jalpan.Soni -title "Specialist" -department "600.02 CHI Electrical"
set-aduser -identity Emmanuel.Paredes -manager Shkurtav -title "Drafter" -department "100.02 CHI Structural"
set-aduser -identity Ashwin.Patel -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity Mike.Paulic -manager Mckenzrl -title "Sr. Specialist" -department "425.01 CLE Piping"
set-aduser -identity Payneke -manager Dankoww -title "Accounting Generalist" -department "750.01 CLE Accounting"
set-aduser -identity Pazdanjw -manager KuzmaJS -title "Staff Specialist" -department "425.02 CHI Piping"
set-aduser -identity Peacerj -manager Schrinmj -title "Specialist" -department "425.03 TOL Piping"
set-aduser -identity PericD -manager Walterac -title "Specialist" -department "600.05 ASH Electrical"
set-aduser -identity Perlaaj -manager HayesRJ -title "Vice President & BDD" -department "930.02 CHI Business Development"
set-aduser -identity jeff.peters -manager YoungKE -title "Human Resources Manager " -department "710.27 PIT Human Resources"
set-aduser -identity rich.phillips -manager FaulknAM -title "Staff Estimator" -department "821.02 CHI Estimating"
set-aduser -identity Mike.Picardi -manager Khaterjm -title "Major Projects Manager" -department "899.01 CLE SMM"
set-aduser -identity Pienostm -manager brent.prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity PiperCR -manager Bob.Necciai -title "Director" -department "899.27 PIT SMM"
set-aduser -identity Justin.Pistininzi -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity clint.poca -manager Sweenejw -title "Sr. Specialist" -department "600.03 TOL Electrical"
set-aduser -identity Podhorrl -manager Blairtg -title "IT Manager " -department "740.01 CLE Information Technology"
set-aduser -identity sumita.pol -manager brent.prazer -title "Sr. Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity Polcynam -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity PorterMR -manager Schrinmj -title "Designer" -department "425.03 TOL Piping"
set-aduser -identity Postacj -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity luke.potter -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity brent.prazer -manager mark.seifried -title "Sr. Technical Manager" -department "100.01 CLE Structural"
set-aduser -identity Pricewf -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity PrudenGA -manager KruppBE -title "Sr. Specialist" -department "600.01 CLE Electrical"
set-aduser -identity Chris.Puleo -manager Dankoww -title "Accounting Generalist" -department "750.01 CLE Accounting"
set-aduser -identity PutnamKA -manager FaulknAM -title "Staff Estimator" -department "821.02 CHI Estimating"
set-aduser -identity Rabquewa -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity RadtkeAJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Dane.Rasmussen -manager Chris.Hennessey -title "Sr. Designer" -department "100.27 PIT Structural"
set-aduser -identity Reamerda -manager Schrinmj -title "Project Engineer" -department "425.03 TOL Piping"
set-aduser -identity Rectordj -manager Schrinmj -title "Sr. Specialist" -department "425.03 TOL Piping"
set-aduser -identity RedmonJM -manager Liuy -title "Sr. Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity ReedEL -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Reganlm -manager Walterac -title "Project Assistant" -department "810.05 ASH Document Control"
set-aduser -identity Reinerjm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Josh.Rice -manager Dankoww -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity jeff.ritter -manager LantinZL -title "Sr. Engineer" -department "650.08 NWI Instrumental & Controls"
set-aduser -identity Robertmd -manager Granatpj -title "Specialist" -department "100.03 TOL Structural"
set-aduser -identity Rossjw -manager brent.prazer -title "Staff Engineer" -department "350.01 CLE Process"
set-aduser -identity James.Rossi -manager WrightPJ -title "Major Projects Manager" -department "899.02 CHI SMM"
set-aduser -identity Rothrj -manager Bridgecj -title "Sr. Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity John.Rotroff -manager rob.hattabaugh -title "Sr. Project Manager" -department "900.08 NWI SPM"
set-aduser -identity Gary.Row -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity RoweGF -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Shawn.Rudy -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity RyanCD -manager Shkurtav -title "Project Engineer" -department "100.02 CHI Structural"
set-aduser -identity Joe.Rybicki -manager MakinsAP -title "Designer" -department "100.08 NWI Structural"
set-aduser -identity Salowma -manager Lowrydp -title "Sr. Project Manager" -department "900.05 ASH SPM"
set-aduser -identity matt.sands -manager Ray.Shore -title "Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Mark.Santillana -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity dan.sarata -manager Adam.Smith -title "Sr. Engineer" -department "100.06 BUF Structural"
set-aduser -identity Michael.Sarver -manager Endersmd -title "Sr. Designer" -department "425.27 PIT Piping"
set-aduser -identity Tim.Saunders -manager Adam.Smith -title "Designer" -department "100.06 BUF Structural"
set-aduser -identity Schmidrc -manager jason.lamb -title "IT Generalist " -department "740.01 CLE Information Technology"
set-aduser -identity David.Schmidt -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Schrinmj -manager Waltonjs -title "Discipline Manager" -department "425.03 TOL Piping"
set-aduser -identity rosario.scibona -manager Ledinje -title "IS Manager " -department "720.01 CLE MIS"
set-aduser -identity john.seaman -manager rob.hattabaugh -title "Sr. Project Manager" -department "900.08 NWI SPM"
set-aduser -identity Sebekjj -manager KruppBE -title "Project Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Sebonimj -manager HayesRJ -title "Sr. Staff Specialist" -department "821.02 CHI Estimating"
set-aduser -identity SefcikKP -manager brent.prazer -title "Discipline Manager" -department "200.01 CLE Civil"
set-aduser -identity Seibolgr -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity mark.seifried -manager Wendelce -title "Senior Vice President & GM" -department "699.01 CLE Overhead"
set-aduser -identity deb.semego -manager PiperCR -title "Document Controls Coordinator" -department "810.27 PIT Document Control"
set-aduser -identity Denise.SetteurSpurio -manager Ledinje -title "IS Generalist " -department "720.01 CLE MIS"
set-aduser -identity Buzz.Seydel -manager WrightPJ -title "Construction Manager" -department "870.02 CHI Construction Management"
set-aduser -identity adam.shands -manager jamie.jurin -title "Sr. Engineer" -department "670.01 CLE Power"
set-aduser -identity Shkurtav -manager TurneyBK -title "Sr. Discipline Manager" -department "100.02 CHI Structural"
set-aduser -identity Shogresc -manager Liuy -title "Sr. Specialist" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Ray.Shore -manager Endersmd -title "Discipline Manager" -department "400.27 PIT Mechanical"
set-aduser -identity Victor.Sibiga -manager HodepeTL -title "Engineer" -department "350.02 CHI Process"
set-aduser -identity SilajSM -manager WrightPJ -title "Procurement Agent" -department "840.02 CHI Procurement"
set-aduser -identity Sinhask -manager Jalpan.Soni -title "Sr. Engineer" -department "600.02 CHI Electrical"
set-aduser -identity Kory.Siverd -manager Khaterjm -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Slabyja -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity Bob.Smering -manager mark.seifried -title "Sr. Project Manager" -department "900.06 BUF SPM"
set-aduser -identity Adam.Smith -manager Sortispd -title "Discipline Manager" -department "100.06 BUF Structural"
set-aduser -identity SmithMJ -manager Shkurtav -title "Staff Engineer" -department "100.02 CHI Structural"
set-aduser -identity SmithBM -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Jalpan.Soni -manager TurneyBK -title "Discipline Manager" -department "600.02 CHI Electrical"
set-aduser -identity Chris.Soprano -manager Mckenzrl -title "Sr. Specialist" -department "425.01 CLE Piping"
set-aduser -identity Sortispd -manager mark.seifried -title "Director" -department "400.06 BUF Mechanical"
set-aduser -identity Stagerdj -manager Granatpj -title "Designer" -department "100.03 TOL Structural"
set-aduser -identity Stahlcw -manager Waltonjs -title "Document Controls Coordinator" -department "810.03 TOL Document Control"
set-aduser -identity StalteDE -manager jamie.jurin -title "Sr. Engineer" -department "670.01 CLE Power"
set-aduser -identity Gary.Stamper -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity StarkCJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Nathen.Stevenson -manager KruppBE -title "Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Wes.Stewart -manager Ray.Shore -title "Project Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Doug.Stieb -manager Schrinmj -title "Staff Specialist" -department "425.03 TOL Piping"
set-aduser -identity StolleNW -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity StonemPJ -manager sam.barnes -title "Director" -department "760.01 CLE Marketing"
set-aduser -identity Streitgj -manager HayesRJ -title "Sr. Major Projects Manager" -department "899.02 CHI SMM"
set-aduser -identity Strosnrl -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Lonnie.Stump -manager GrelewJF -title "Specialist" -department "125.08 NWI Asset Integrity"
set-aduser -identity Caitlyn.Sullivan -manager YoungKE -title "Human Resources Manager " -department "710.02 CHI Human Resources"
set-aduser -identity cathy.sullivan -manager WrightPJ -title "Document Controls Coordinator" -department "810.02 CHI Document Control"
set-aduser -identity Sulzbamd -manager Adamsjk -title "Sr. Specialist" -department "400.06 BUF Mechanical"
set-aduser -identity Sweenejw -manager Waltonjs -title "Sr. Discipline Manager" -department "600.03 TOL Electrical"
set-aduser -identity Szalkomg -manager Blairtg -title "IT Manager " -department "740.01 CLE Information Technology"
set-aduser -identity TaylorTR -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity TerryAM -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Tholete -manager Mckenzrl -title "Sr. Specialist" -department "425.01 CLE Piping"
set-aduser -identity jim.thomas -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity Bryan.Thomas -manager Shawn.Dishauzi -title "Sr. Specialist" -department "890.01 TOL Health & Safety"
set-aduser -identity ThompsCJ -manager Mckenzrl -title "Designer" -department "425.01 CLE Piping"
set-aduser -identity Thompsba -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Rob.Tibbitts -manager sam.barnes -title "Director" -department "780.01 CLE Legal"
set-aduser -identity Tielldm -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity nicholas.tipton -manager Granatpj -title "Intern" -department "100.03 TOL Structural"
set-aduser -identity Torosiaa -manager Bridgecj -title "Staff Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Nick.Trout -manager Walterac -title "Designer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Troutbd -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity nicholas.trudeau -manager Endersmd -title "Drafter" -department "425.27 PIT Piping"
set-aduser -identity TurneyBK -manager HayesRJ -title "Sr. Technical Manager" -department "100.02 CHI Structural"
set-aduser -identity jordan.unmuth -manager LantinZL -title "Sr. Engineer" -department "600.28 MAD Electrical"
set-aduser -identity Urankaaj -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity UttechMJ -manager rob.hattabaugh -title "Director" -department "899.28 MAD SMM"
set-aduser -identity Jennifer.Valek -manager Zdolshtl -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity Gise.VanBaren -manager GrelewJF -title "Intern" -department "125.08 NWI Asset Integrity"
set-aduser -identity Michael.Vargas -manager jason.lamb -title "IT Specialist " -department "740.02 CHI Information Technology"
set-aduser -identity ViancoME -manager jamie.jurin -title "Sr. Designer" -department "670.01 CLE Power"
set-aduser -identity trenton.vicker -manager Jalpan.Soni -title "Engineer" -department "600.02 CHI Electrical"
set-aduser -identity Vidrare -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity Santiago.villegas -manager Shkurtav -title "Designer" -department "100.02 CHI Structural"
set-aduser -identity Justin.Viola -manager Endersmd -title "Drafter" -department "425.27 PIT Piping"
set-aduser -identity Voytkotl -manager brent.prazer -title "Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity Stephen.Wagner -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Walterac -manager Lowrydp -title "Tech Manager" -department "100.05 ASH Structural"
set-aduser -identity Walterja -manager HayesRJ -title "Director" -department "900.02 CHI SPM"
set-aduser -identity Justin.Walters -manager Bridgecj -title "Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Waltonjs -manager Lowrydp -title "Director" -department "425.03 TOL Piping"
set-aduser -identity Warnecm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Avionne.Weaver -manager brent.prazer -title "Intern" -department "475.01 CLE Automation"
set-aduser -identity Weiganrk -manager KruppBE -title "Sr. Designer" -department "600.01 CLE Electrical"
set-aduser -identity WeinheSG -manager Adamsjk -title "Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Weinhejr -manager mark.seifried -title "Director" -department "899.06 BUF SMM"
set-aduser -identity Kendall.Welling -manager Shkurtav -title "Engineer" -department "100.28 MAD Structural"
set-aduser -identity Wendelce -manager sam.barnes -title "Executive Vice President & COO" -department "799.02 CHI Corp Executives"
set-aduser -identity Otto.Wenzel -manager John.Rotroff -title "Project Manager" -department "800.08 NWI PM"
set-aduser -identity Wheatmd -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity Eric.Whittaker -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Wickerth -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity Wilkinvp -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Keyana.Williams -manager StonemPJ -title "Marketing Generalist " -department "760.01 CLE Marketing"
set-aduser -identity WilsonCA -manager HayesRJ -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Winklekm -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity WinterWF -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Matt.Wisniewski -manager Waltonjs -title "Discipline Manager" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Wisniesp -manager jason.lamb -title "IT Generalist " -department "740.03 TOL Information Technology"
set-aduser -identity Wiszjl -manager jason.lamb -title "IT Generalist " -department "740.02 CHI Information Technology"
set-aduser -identity Jimmy.Wood -manager KuzmaJS -title "Sr. Designer" -department "425.02 CHI Piping"
set-aduser -identity David.Woodnorth -manager HayesRJ -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity WraseJW -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity WrightPJ -manager HayesRJ -title "Sr. Major Projects Manager" -department "899.02 CHI SMM"
set-aduser -identity Li.Yan -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity Yoergerw -manager KruppBE -title "Sr. Designer" -department "600.01 CLE Electrical"
set-aduser -identity brian.young -manager brent.prazer -title "Sr. Specialist" -department "100.01 CLE Structural"
set-aduser -identity YoungCS -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity YoungKE -manager sam.barnes -title "Vice President, Human Resources" -department "710.01 CLE Human Resources"
set-aduser -identity Zapataem -manager Mclaugma -title "Project Controls Coordinator" -department "820.03 TOL Project Controls"
set-aduser -identity ZatoWA -manager LantinZL -title "Sr. Specialist" -department "425.08 NWI Piping"
set-aduser -identity Zdolshtl -manager Dankoww -title "Accounting Manager" -department "750.01 CLE Accounting"
set-aduser -identity Jack.Ziegler -manager brent.prazer -title "Sr. Engineer" -department "350.01 CLE Process"
set-aduser -identity drew.zimmerman -manager Cussenkg -title "Sr. Engineer" -department "200.02 CHI Civil"
set-aduser -identity chad.zimmerman -manager LantinZL -title "Sr. Specialist" -department "425.08 NWI Piping"
set-aduser -identity Jeff.Zunich -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"


042324

add-ADGroupMember -Identity "Cleveland Tech Members" -Members Tyler.Baird
add-ADGroupMember -Identity "Cleveland Tech Members" -Members KeehnGA
add-ADGroupMember -Identity "Cleveland Tech Members" -Members andrew.gallagher
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Torosiaa
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Bridgecj
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Clougheg
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Jeff.Zunich
add-ADGroupMember -Identity "Cleveland Tech Members" -Members AtkinsJD
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Justin.Walters
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Krakovlj
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Lytlemp
add-ADGroupMember -Identity "Cleveland Tech Members" -Members rick.dugan
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Rothrj
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Thomas.McKeown
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Pricewf
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Slabyja
add-ADGroupMember -Identity "Cleveland Tech Members" -Members YoungCS
add-ADGroupMember -Identity "Cleveland Tech Members" -Members raya.Alhamzeh
add-ADGroupMember -Identity "Cleveland Tech Members" -Members adam.shands
add-ADGroupMember -Identity "Cleveland Tech Members" -Members StalteDE
add-ADGroupMember -Identity "Cleveland Tech Members" -Members ViancoME
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Sam.Bennett
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Cuculirj
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Jose.DeJesus
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Daniel.Devadoss
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Gaertnmj
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Steve.Maggiano
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Palmerbj
add-ADGroupMember -Identity "Cleveland Tech Members" -Members PrudenGA
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Sebekjj
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Nathen.Stevenson
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Weiganrk
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Eric.Whittaker
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Yoergerw
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Althoumj
add-ADGroupMember -Identity "Cleveland Tech Members" -Members BalchaDM
add-ADGroupMember -Identity "Cleveland Tech Members" -Members JankeyRW
add-ADGroupMember -Identity "Cleveland Tech Members" -Members norm.jaworski
add-ADGroupMember -Identity "Cleveland Tech Members" -Members joseph.kalic
add-ADGroupMember -Identity "Cleveland Tech Members" -Members kevin.kerline
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Mike.Paulic
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Chris.Soprano
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Tholete
add-ADGroupMember -Identity "Cleveland Tech Members" -Members ThompsCJ
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Urankaaj
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Lawrence.Amerson
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Matt.Bedee
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Bordonra
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Wesley.McCurdy
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Friedmm
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Jim.Harrold
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Hlavacgm
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Jeff.Hollinshead
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Hoppelcl
add-ADGroupMember -Identity "Cleveland Tech Members" -Members jamie.jurin
add-ADGroupMember -Identity "Cleveland Tech Members" -Members rana.kalaji
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Kasickjc
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Kilbyjw
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Kordahyk
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Patricia.Krupp
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Mckenzrl
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Justin.Otero
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Pienostm
add-ADGroupMember -Identity "Cleveland Tech Members" -Members sumita.pol
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Rossjw
add-ADGroupMember -Identity "Cleveland Tech Members" -Members SefcikKP
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Voytkotl
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Avionne.Weaver
add-ADGroupMember -Identity "Cleveland Tech Members" -Members brian.young
add-ADGroupMember -Identity "Cleveland Tech Members" -Members Jack.Ziegler
add-ADGroupMember -Identity "Cleveland Tech Members" -Members KruppBE
add-ADGroupMember -Identity "Cleveland Tech Members" -Members brent.prazer
add-ADGroupMember -Identity "Cleveland Tech Members" -Members mark.seifried

===

5/20/24

set-aduser -identity jeff.caldwell -manager mark.seifried
set-aduser -identity joe.andras -manager mark.seifried
set-aduser -identity John.Rotroff -manager mark.seifried
set-aduser -identity john.seaman -manager mark.seifried
set-aduser -identity GrelewJF -manager mark.seifried
set-aduser -identity UttechMJ -manager mark.seifried
set-aduser -identity LantinZL -manager mark.seifried

Jeff.Caldwell@Middough.com
joe.andras@Middough.com
John.Rotroff@Middough.com
john.seaman@middough.com
Joseph.Grelewicz@Middough.com
Michael.Uttech@Middough.com
Zachary.Lanting@Middough.com

---

5/22/24

add-ADGroupMember -Identity "Cleveland Tech Members" -Members mark.seifried
New-ADUser -Name “John Q Adams" -GivenName John -Surname Q Adams -SamAccountName John.QAdams -UserPrincipalName John.QAdams@middough.com -path "OU=TEST,OU=740,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"-displayname "John Q Adams"

6/3/24
set-aduser -identity mark.seifried -department "699.01 CLE Management"
set-aduser -identity HayesRJ  -department "699.02 CHI Management"
set-aduser -identity Lowrydp  -department "699.03 TOL Management"
set-aduser -identity Bob.Necciai -department "699.27 PIT Management"

set-aduser -identity mark.seifried -manager "sam.barnes"
set-aduser -identity HayesRJ -manager "sam.barnes"
set-aduser -identity Lowrydp -manager "sam.barnes"
set-aduser -identity Bob.Necciai -manager "sam.barnes"


===

6/6/24

set-aduser -identity Adamsjk -manager Sortispd -title "Discipline Manager" -department "400.06 BUF Mechanical"
set-aduser -identity Robert.Adamski -manager HodepeTL -title "Project Engineer III" -department "350.02 CHI Process"
set-aduser -identity Will.Aikens -manager Hurstdl -title "Intern" -department "400.02 CHI Mechanical"
set-aduser -identity AldridBC -manager Liuy -title "Specialist" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity raya.Alhamzeh -manager Hoppelcl -title "Engineer" -department "100.01 CLE Structural"
set-aduser -identity Althoumj -manager Mckenzrl -title "Staff Engineer" -department "425.01 CLE Piping"
set-aduser -identity Lawrence.Amerson -manager Brent.Prazer -title "Engineer" -department "475.01 CLE Automation"
set-aduser -identity Kathleen.Anderson -manager Zdolshtl -title "Accounting Coordinator" -department "750.01 CLE Accounting"
set-aduser -identity Jayden.Andras -manager GrelewJF -title "Intern" -department "125.08 NWI Asset Integrity"
set-aduser -identity joe.andras -manager John.Rotroff -title "Project Manager" -department "800.08 NWI PM"
set-aduser -identity sherkoh.anz -manager Sweenejw -title "Engineer" -department "600.03 TOL Electrical"
set-aduser -identity nick.arnold -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity AtkinsJD -manager Bridgecj -title "Project Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity kauveh.aynafshar -manager Matt.Wisniewski -title "Designer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Ashama.Babooram -manager Darbyjd -title "Engineer" -department "425.05 ASH Piping"
set-aduser -identity Tyler.Baird -manager Matt.Bedee -title "Designer" -department "050.01 CLE Architectural"
set-aduser -identity BalchaDM -manager Mckenzrl -title "Specialist" -department "425.01 CLE Piping"
set-aduser -identity sam.barnes -manager Ledinrr -title "President & CEO" -department "799.01 CLE Corporate Executives"
set-aduser -identity Bealmk -manager Sortispd -title "Discipline Manager" -department "425.06 BUF Piping"
set-aduser -identity Matt.Bedee -manager Brent.Prazer -title "Discipline Manager" -department "050.01 CLE Architectural"
set-aduser -identity Lillian.Bennett -manager HodepeTL -title "Engineer" -department "350.02 CHI Process"
set-aduser -identity Sam.Bennett -manager KruppBE -title "Engineer" -department "600.01 CLE Electrical"
set-aduser -identity jim.bereda -manager LantinZL -title "Sr. Engineer" -department "600.08 NWI Electrical"
set-aduser -identity Clark.Bernauer -manager alex.lutz -title "Intern" -department "650.27 CLE Instrumental & Controls"
set-aduser -identity Jon.Beskin -manager DavidsRJ -title "Sr. Designer" -department "050.02 CHI Architectural"
set-aduser -identity BettinJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Charu.Bhat -manager HayesRJ -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity BihlJC -manager Walterac -title "Sr. Engineer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Blackjl -manager HayesRJ -title "Sr. Major Projects Manager" -department "899.02 CHI SMM"
set-aduser -identity Noah.Blain -manager Walterac -title "Engineer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Blairtg -manager sam.barnes -title "Director, IT" -department "740.01 CLE Information Technology"
set-aduser -identity Sam.Blood -manager PiperCR -title "Project Controls Specialist" -department "820.27 PIT Project Controls"
set-aduser -identity Bogaersm -manager sam.barnes -title "Vice President, Quality" -department "705.08 CHI Quality"
set-aduser -identity Kevin.Bollinger -manager Walterac -title "Engineer" -department "100.05 ASH Structural"
set-aduser -identity Bonerich -manager Walterja -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity Bordonra -manager Brent.Prazer -title "Project Engineer" -department "350.01 CLE Process"
set-aduser -identity Bowlinpa -manager Darbyjd -title "Sr. Specialist" -department "425.05 ASH Piping"
set-aduser -identity Braunske -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity Bridendj -manager Shkurtav -title "Sr. Designer" -department "100.02 CHI Structural"
set-aduser -identity Bridgecj -manager Brent.Prazer -title "Discipline Manager" -department "400.01 CLE Mechanical"
set-aduser -identity Browngt -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity BrownTJ -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity jeff.caldwell -manager Lowrydp -title "Sr. Project Manager" -department "900.05 ASH SPM"
set-aduser -identity CarneySP -manager WrightPJ -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity Carnsjj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Carmen.Carr -manager Walterac -title "Sr. Specialist" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Ben.Cash -manager KuzmaJS -title "Intern" -department "425.02 CHI Piping"
set-aduser -identity Bill.Celian -manager Waltonjs -title "Construction Manager" -department "870.03 TOL Construction Management"
set-aduser -identity Chihakaa -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Merrill.Childs -manager HodepeTL -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity adam.clark -manager jamie.jurin -title "Sr. Engineer" -department "670.10 MIN Power"
set-aduser -identity Clougheg -manager Bridgecj -title "Designer" -department "400.01 CLE Mechanical"
set-aduser -identity jason.clouse -manager Chris.Hennessey -title "Engineer" -department "100.27 PIT Structural"
set-aduser -identity lela.conley -manager GrelewJF -title "Inspection Coordinator " -department "125.08 NWI Asset Integrity"
set-aduser -identity patrick.conner -manager FaulknAM -title "Sr. Project Controls Specialist" -department "820.02 CHI Project Controls"
set-aduser -identity cookke -manager Waltonjs -title "Document Controls Coordinator" -department "810.03 TOL Document Control"
set-aduser -identity Steve.Coons -manager Hurstdl -title "Sr. Staff Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity logan.cover -manager GrelewJF -title "Inspector" -department "125.08 NWI Asset Integrity"
set-aduser -identity CullerTL -manager Khaterjm -title "Procurement Manager" -department "840.01 CLE Procurement"
set-aduser -identity travis.culver -manager GrelewJF -title "Inspector" -department "125.08 NWI Asset Integrity"
set-aduser -identity Cussenkg -manager TurneyBK -title "Discipline Manager" -department "200.02 CHI Civil"
set-aduser -identity Dankoww -manager OconnoDP -title "Vice President, Finance" -department "750.01 CLE Accounting"
set-aduser -identity Darbyjd -manager Walterac -title "Discipline Manager" -department "425.05 ASH Piping"
set-aduser -identity brad.daugharthy -manager Podhorrl -title "IT Generalist " -department "740.01 CLE Information Technology"
set-aduser -identity DavidsRJ -manager HayesRJ -title "Director" -department "050.02 CHI Architectural"
set-aduser -identity davisjl -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Jose.DeJesus -manager KruppBE -title "Specialist" -department "600.01 CLE Electrical"
set-aduser -identity DeakinJR -manager LantinZL -title "Sr. Engineer" -department "400.08 NWI Mechanical"
set-aduser -identity Michael.Deinhammer -manager Geresbc -title "Project Manager" -department "800.10 MIN PM"
set-aduser -identity Daniel.Devadoss -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Devriejc -manager Mclaugma -title "Cost Scheduler" -department "820.03 TOL Project Controls"
set-aduser -identity sebastian.dewitt -manager MakinsAP -title "Intern" -department "100.08 NWI Structural"
set-aduser -identity Shawn.Dishauzi -manager sam.barnes -title "Director, Safety" -department "785.01 CLE Health & Safety"
set-aduser -identity clint.downey -manager UttechMJ -title "Project Manager" -department "800.28 MAD PM"
set-aduser -identity Tanner.Drees -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Kenneth.Dudzik -manager LantinZL -title "Sr. Specialist" -department "425.08 NWI Piping"
set-aduser -identity rick.dugan -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Durkindp -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity chris.edwards -manager Endersmd -title "Sr. Engineer" -department "350.27 PIT Process"
set-aduser -identity Endersmd -manager Bob.Necciai -title "Sr. Technical Manager" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity Failindj -manager Adamsjk -title "Sr. Designer" -department "400.06 BUF Mechanical"
set-aduser -identity FaulknAM -manager WrightPJ -title "Discipline Manager" -department "820.02 CHI Project Controls"
set-aduser -identity Feeneysm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Jeff.Fesko -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity Flaughpl -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity Fonsecmj -manager Schrinmj -title "Sr. Specialist" -department "425.03 TOL Piping"
set-aduser -identity Samantha.Fox -manager sam.barnes -title "Business Development Director" -department "930.27 PIT Business Development"
set-aduser -identity Frederjw -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Friedmm -manager Brent.Prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity FryNL -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Greg.Furgala -manager Bealmk -title "Sr. Designer" -department "425.06 BUF Piping"
set-aduser -identity andrew.gallagher -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity BellTR -manager Walterja -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity GawronRT -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity john.genau -manager Hurstdl -title "Project Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Richard.Genser -manager Chris.Hennessey -title "Designer" -department "100.27 PIT Structural"
set-aduser -identity GeorgeM -manager LantinZL -title "Project Engineer" -department "400.08 NWI Mechanical"
set-aduser -identity Geresbc -manager HayesRJ -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity Anthony.Gigante -manager Dankoww -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity Philip.Goldberg -manager Bridgecj -title "Intern" -department "400.01 CLE Mechanical"
set-aduser -identity GonzalED -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity GoodJP -manager Adam.Smith -title "Specialist" -department "100.06 BUF Structural"
set-aduser -identity Granatpj -manager Waltonjs -title "Sr. Discipline Manager" -department "100.03 TOL Structural"
set-aduser -identity Gravesrm -manager Mclaugma -title "Project Controls Coordinator" -department "820.03 TOL Project Controls"
set-aduser -identity Molly.Green -manager Chris.Hennessey -title "Engineer" -department "100.27 PIT Structural"
set-aduser -identity GrelewJF -manager mark.seifried -title "Sr. Discipline Manager" -department "125.08 NWI Asset Integrity"
set-aduser -identity Tristan.Griffith -manager Walterac -title "Drafter" -department "100.05 ASH Structural"
set-aduser -identity Grubbkl -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity klimka.grubbe -manager GrelewJF -title "Inspection Coordinator " -department "125.08 NWI Asset Integrity"
set-aduser -identity victor.guerrero -manager KuzmaJS -title "Designer" -department "425.02 CHI Piping"
set-aduser -identity shane.gulvas -manager John.Rotroff -title "Project Manager" -department "800.08 NWI PM"
set-aduser -identity Halljl -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity Abdallah.Hamad -manager Endersmd -title "Sr. Engineer" -department "600.27 PIT Electrical"
set-aduser -identity Hammonmr -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity reynoltl -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity allison.hassig -manager WrightPJ -title "Discipline Manager" -department "840.02 CHI Procurement"
set-aduser -identity Autumn.Hatcher -manager Darbyjd -title "Drafter" -department "425.05 ASH Piping"
set-aduser -identity John.Hayes -manager Schrinmj -title "Specialist" -department "425.03 TOL Piping"
set-aduser -identity HayesRJ -manager sam.barnes -title "Senior Vice President & GM" -department "699.02 CHI Management"
set-aduser -identity Dan.Heberer -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Chris.Hennessey -manager Endersmd -title "Discipline Manager" -department "100.27 PIT Structural"
set-aduser -identity Roger.Hieser -manager HayesRJ -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Hilbercr -manager Ledinje -title "IS Generalist " -department "720.01 CLE MIS"
set-aduser -identity HillMG -manager sam.barnes -title "Director, Talent" -department "715.02 CHI Workforce Development"
set-aduser -identity Nestor.Hiso -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity HitesZH -manager Granatpj -title "Sr. Engineer" -department "100.03 TOL Structural"
set-aduser -identity Hlavacgm -manager Brent.Prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity HodepeTL -manager TurneyBK -title "Discipline Manager" -department "350.02 CHI Process"
set-aduser -identity Hoggeml -manager Lowrydp -title "Director" -department "900.05 ASH SPM"
set-aduser -identity Jeff.Hollinshead -manager Brent.Prazer -title "Staff Engineer" -department "475.01 CLE Automation"
set-aduser -identity Glen.Hoppe -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Hoppelcl -manager Brent.Prazer -title "Sr. Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity Hoyecl -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Hurstdl -manager HayesRJ -title "Sr. Discipline Manager" -department "400.02 CHI Mechanical"
set-aduser -identity joseph.imre -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Nathan.Ingram -manager Endersmd -title "Specialist" -department "600.27 PIT Electrical"
set-aduser -identity JankeyRW -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity JaraczJP -manager Weinhejr -title "Major Projects Manager" -department "899.06 BUF SMM"
set-aduser -identity norm.jaworski -manager Mckenzrl -title "Sr. Designer" -department "425.01 CLE Piping"
set-aduser -identity JimeneMJ -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Johnsoje -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Johnsora -manager Walterac -title "Sr. Specialist" -department "100.05 ASH Structural"
set-aduser -identity Zach.Johnson -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity jamie.jurin -manager Brent.Prazer -title "Discipline Manager" -department "670.01 CLE Power"
set-aduser -identity rana.kalaji -manager Brent.Prazer -title "Engineer" -department "100.01 CLE Structural"
set-aduser -identity joseph.kalic -manager Mckenzrl -title "Engineer" -department "425.01 CLE Piping"
set-aduser -identity lindsay.kaminski -manager YoungKE -title "HR Specialist " -department "710.01 CLE Human Resources"
set-aduser -identity Christian.Kanfeld -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity kayan.kartoum -manager Liuy -title "Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Kasickjc -manager Brent.Prazer -title "Sr. Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity Patrick.Keenan -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity kevin.kerline -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity Keyta -manager Khaterjm -title "Project Assistant" -department "810.01 CLE Document Control"
set-aduser -identity Khaterjm -manager mark.seifried -title "Director" -department "899.01 CLE SMM"
set-aduser -identity gary.kieley -manager Bealmk -title "Specialist" -department "425.06 BUF Piping"
set-aduser -identity Kilbyjw -manager Brent.Prazer -title "Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity Jackie.Kolling -manager Chris.Hennessey -title "Sr. Designer" -department "100.27 PIT Structural"
set-aduser -identity Koniectl -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Kordahyk -manager Brent.Prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity Krakovlj -manager Bridgecj -title "Sr. Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Harold.Kropp -manager Adamsjk -title "Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity KruppBE -manager mark.seifried -title "Sr. Discipline Director" -department "600.01 CLE Electrical"
set-aduser -identity Patricia.Krupp -manager Brent.Prazer -title "Sr. Designer" -department "475.01 CLE Automation"
set-aduser -identity KuzmaJS -manager TurneyBK -title "Discipline Manager" -department "425.02 CHI Piping"
set-aduser -identity Austin.Lackritz -manager Mckenzrl -title "Intern" -department "425.01 CLE Piping"
set-aduser -identity Lenny.Laird -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity jason.lamb -manager Blairtg -title "IT Manager " -department "740.01 CLE Information Technology"
set-aduser -identity LantinZL -manager mark.seifried -title "Sr. Technical Manager" -department "100.08 NWI Structural"
set-aduser -identity Ledinje -manager sam.barnes -title "Senior Vice President" -department "720.01 CLE MIS"
set-aduser -identity Ledinrr -title "Chairman" -department "799.01 CLE Corporate Executives"
set-aduser -identity jeren.lemanek -manager StonemPJ -title "Intern" -department "760.01 CLE Marketing"
set-aduser -identity Lenharbd -manager Lowrydp -title "Director" -department "900.03 TOL SPM"
set-aduser -identity Leonarcm -manager Dankoww -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity Lesleylr -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity robert.leugers -manager WrightPJ -title "Sr. Construct Supt" -department "870.02 CHI Construction Management"
set-aduser -identity yafei.liu -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Liuy -manager TurneyBK -title "Discipline Manager" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity matt.locher -manager Walterac -title "Sr. Specialist" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Connor.Loughlin -manager Hurstdl -title "Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Lowrydp -manager sam.barnes -title "Senior Vice President & GM" -department "699.03 TOL Management"
set-aduser -identity Lowryma -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Eric.Lufi -manager KruppBE -title "Intern" -department "600.01 CLE Electrical"
set-aduser -identity Keith.Luttell -manager GrelewJF -title "Sr. Inspector" -department "125.08 NWI Asset Integrity"
set-aduser -identity alex.lutz -manager Endersmd -title "Discipline Manager" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity Lytlemp -manager Bridgecj -title "Staff Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Steve.Maggiano -manager KruppBE -title "Staff Engineer" -department "600.01 CLE Electrical"
set-aduser -identity brandon.magnusen -manager MakinsAP -title "Engineer" -department "100.08 NWI Structural"
set-aduser -identity MakinsAP -manager LantinZL -title "Discipline Manager" -department "100.08 NWI Structural"
set-aduser -identity tiffany.malcom -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity jeff.martis2 -manager Adamsjk -title "Sr. Designer" -department "400.06 BUF Mechanical"
set-aduser -identity MastanEJ -manager DavidsRJ -title "Staff Architect" -department "050.02 CHI Architectural"
set-aduser -identity MayareD -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity ben.mccoy -manager Adam.Smith -title "Engineer" -department "100.06 BUF Structural"
set-aduser -identity Wesley.McCurdy -manager Ray.Shore -title "Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Mckenzrl -manager Brent.Prazer -title "Discipline Manager" -department "425.01 CLE Piping"
set-aduser -identity Mclaugma -manager Waltonjs -title "Discipline Manager" -department "820.03 TOL Project Controls"
set-aduser -identity Dylan.McNamee -manager GrelewJF -title "Inspector" -department "125.08 NWI Asset Integrity"
set-aduser -identity Elena.Graupera -manager LantinZL -title "Document Controls Coordinator" -department "810.08 NWI Document Control"
set-aduser -identity Melilllm -manager YoungKE -title "Human Resources Manager " -department "710.01 CLE Human Resources"
set-aduser -identity Curtis.Merow -manager Chris.Hennessey -title "Sr. Specialist" -department "100.27 PIT Structural"
set-aduser -identity Meyersmj -manager Khaterjm -title "Project Assistant" -department "810.01 CLE Document Control"
set-aduser -identity jack.middleton -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity MillerJK -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity Millerne -manager Walterac -title "Designer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Andy.Minderman -manager mark.seifried -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity trevor.misch -manager LantinZL -title "Intern" -department "600.08 NWI Electrical"
set-aduser -identity Chris.Moran -manager David.Schmidt -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Matt.Morgan -manager Waltonjs -title "Sr. Construction Manager" -department "870.03 TOL Construction Management"
set-aduser -identity renee.morgan -manager Sortispd -title "Discipline Manager" -department "600.06 BUF Electrical"
set-aduser -identity kim.morphew -manager WrightPJ -title "Document Controls Specialist " -department "810.02 CHI Document Control"
set-aduser -identity Jackie.Morris -manager StonemPJ -title "Marketing Manager " -department "760.01 CLE Marketing"
set-aduser -identity MullenMA -manager Khaterjm -title "Major Projects Manager" -department "899.01 CLE SMM"
set-aduser -identity Munjesr -manager Schrinmj -title "Staff Engineer" -department "425.03 TOL Piping"
set-aduser -identity Chris.Muntz -manager Chris.Hennessey -title "Specialist" -department "100.27 PIT Structural"
set-aduser -identity Kaleb.Myers -manager Matt.Wisniewski -title "Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Nashad -manager Adamsjk -title "Staff Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Bob.Necciai -manager sam.barnes -title "Senior Vice President & GM" -department "699.27 PIT Management"
set-aduser -identity Newmankj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity OconnoDP -manager sam.barnes -title "Senior Vice President & CFO" -department "799.01 CLE Corporate Executives"
set-aduser -identity Olesicka -manager Dankoww -title "Accounting Generalist " -department "750.01 CLE Accounting"
set-aduser -identity Olschlre -manager Podhorrl -title "IT Generalist " -department "740.01 CLE Information Technology"
set-aduser -identity OlsonGA -manager Jalpan.Soni -title "Sr. Engineer" -department "600.02 CHI Electrical"
set-aduser -identity antania.orr -manager HodepeTL -title "Intern" -department "350.28 MAD Process"
set-aduser -identity Jeremias.Ortiz -manager Schrinmj -title "Designer" -department "425.03 TOL Piping"
set-aduser -identity Justin.Otero -manager Brent.Prazer -title "Drafter" -department "350.01 CLE Process"
set-aduser -identity Overhorj -manager Renee.Morgan -title "Specialist" -department "600.06 BUF Electrical"
set-aduser -identity shannon.owen -manager sam.barnes -title "Business Development Director" -department "930.27 PIT Business Development"
set-aduser -identity Palmerbj -manager KruppBE -title "Designer" -department "600.01 CLE Electrical"
set-aduser -identity Palmertp -manager Adam.Smith -title "Sr. Specialist" -department "100.06 BUF Structural"
set-aduser -identity josh.palyo -manager Endersmd -title "Sr. Engineer" -department "350.27 PIT Process"
set-aduser -identity Thomas.Paprocki -manager Liuy -title "Staff Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Myra.Parayno -manager Jalpan.Soni -title "Specialist" -department "600.02 CHI Electrical"
set-aduser -identity Ashwin.Patel -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity Mike.Paulic -manager Mckenzrl -title "Sr. Specialist" -department "425.01 CLE Piping"
set-aduser -identity Payneke -manager Dankoww -title "Accounting Generalist " -department "750.01 CLE Accounting"
set-aduser -identity Peacerj -manager Schrinmj -title "Specialist" -department "425.03 TOL Piping"
set-aduser -identity PericD -manager Walterac -title "Specialist" -department "600.05 ASH Electrical"
set-aduser -identity Perlaaj -manager sam.barnes -title "Vice President" -department "930.02 CHI Business Development"
set-aduser -identity jeff.peters -manager YoungKE -title "Human Resources Manager" -department "710.27 PIT Human Resources"
set-aduser -identity rich.phillips -manager FaulknAM -title "Staff Estimator" -department "821.02 CHI Estimating"
set-aduser -identity Mike.Picardi -manager Khaterjm -title "Major Projects Manager" -department "899.01 CLE SMM"
set-aduser -identity Pienostm -manager Brent.Prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity PiperCR -manager Bob.Necciai -title "Director" -department "899.27 PIT SMM"
set-aduser -identity Justin.Pistininzi -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity clint.poca -manager Sweenejw -title "Sr. Specialist" -department "600.03 TOL Electrical"
set-aduser -identity Podhorrl -manager Blairtg -title "IT Manager " -department "740.01 CLE Information Technology"
set-aduser -identity sumita.pol -manager Brent.Prazer -title "Sr. Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity Polcynam -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Keya.Porch -manager Shkurtav -title "Intern" -department "100.02 CHI Structural"
set-aduser -identity PorterMR -manager Schrinmj -title "Designer" -department "425.03 TOL Piping"
set-aduser -identity Postacj -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity luke.potter -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity brent.prazer -manager mark.seifried -title "Sr. Technical Manager" -department "100.01 CLE Structural"
set-aduser -identity Pricewf -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity PrudenGA -manager KruppBE -title "Sr. Specialist" -department "600.01 CLE Electrical"
set-aduser -identity Chris.Puleo -manager Dankoww -title "Accounting Generalist " -department "750.01 CLE Accounting"
set-aduser -identity PutnamKA -manager FaulknAM -title "Staff Estimator" -department "821.02 CHI Estimating"
set-aduser -identity Nikola.Rabljenovic -manager Brent.Prazer -title "Intern" -department "475.01 CLE Automation"
set-aduser -identity Rabquewa -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity RadtkeAJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Reamerda -manager Schrinmj -title "Project Engineer" -department "425.03 TOL Piping"
set-aduser -identity Rectordj -manager Schrinmj -title "Sr. Specialist" -department "425.03 TOL Piping"
set-aduser -identity RedmonJM -manager Liuy -title "Sr. Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity ReedEL -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Reganlm -manager Walterac -title "Project Assistant" -department "810.05 ASH Document Control"
set-aduser -identity Chetan.Rege -manager HodepeTL -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Reinerjm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Josh.Rice -manager Dankoww -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity Luke.Richards -manager Jalpan.Soni -title "Intern" -department "600.28 MAD Electrical"
set-aduser -identity Robertmd -manager Granatpj -title "Specialist" -department "100.03 TOL Structural"
set-aduser -identity Rossjw -manager Brent.Prazer -title "Staff Engineer" -department "350.01 CLE Process"
set-aduser -identity James.Rossi -manager WrightPJ -title "Major Projects Manager" -department "899.02 CHI SMM"
set-aduser -identity Rothrj -manager Bridgecj -title "Sr. Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity John.Rotroff -manager mark.seifried -title "Sr. Project Manager" -department "900.08 NWI SPM"
set-aduser -identity Gary.Row -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity RoweGF -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Shawn.Rudy -manager PiperCR -title "Major Projects Manager" -department "899.27 PIT SMM"
set-aduser -identity RyanCD -manager Shkurtav -title "Project Engineer" -department "100.02 CHI Structural"
set-aduser -identity Joe.Rybicki -manager MakinsAP -title "Designer" -department "100.08 NWI Structural"
set-aduser -identity Salowma -manager Lowrydp -title "Sr. Project Manager" -department "900.05 ASH SPM"
set-aduser -identity Mark.Santillana -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity dan.sarata -manager Adam.Smith -title "Sr. Engineer" -department "100.06 BUF Structural"
set-aduser -identity Michael.Sarver -manager Endersmd -title "Sr. Designer" -department "425.27 PIT Piping"
set-aduser -identity Tim.Saunders -manager Adam.Smith -title "Designer" -department "100.06 BUF Structural"
set-aduser -identity David.Schmidt -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Schmidrc -manager jason.lamb -title "IT Generalist " -department "740.01 CLE Information Technology"
set-aduser -identity Schrinmj -manager Waltonjs -title "Discipline Manager" -department "425.03 TOL Piping"
set-aduser -identity rosario.scibona -manager Ledinje -title "IS Manager " -department "720.01 CLE MIS"
set-aduser -identity john.seaman -manager mark.seifried -title "Sr. Project Manager" -department "900.08 NWI SPM"
set-aduser -identity Sebekjj -manager KruppBE -title "Project Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Sebonimj -manager HayesRJ -title "Sr. Staff Specialist" -department "821.02 CHI Estimating"
set-aduser -identity SefcikKP -manager Brent.Prazer -title "Discipline Manager" -department "200.01 CLE Civil"
set-aduser -identity Seibolgr -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity mark.seifried -manager sam.barnes -title "Senior Vice President & GM" -department "699.01 CLE Management"
set-aduser -identity deb.semego -manager PiperCR -title "Document Controls Coordinator" -department "810.27 PIT Document Control"
set-aduser -identity Denise.SetteurSpurio -manager Ledinje -title "IS Generalist " -department "720.01 CLE MIS"
set-aduser -identity Buzz.Seydel -manager WrightPJ -title "Construction Manager" -department "870.02 CHI Construction Management"
set-aduser -identity adam.shands -manager jamie.jurin -title "Sr. Engineer" -department "670.01 CLE Power"
set-aduser -identity Shkurtav -manager TurneyBK -title "Sr. Discipline Manager" -department "100.02 CHI Structural"
set-aduser -identity Shogresc -manager Liuy -title "Sr. Specialist" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Ray.Shore -manager Endersmd -title "Discipline Manager" -department "400.27 PIT Mechanical"
set-aduser -identity Scott.Siatkowski -manager mark.seifried -title "Director" -department "900.01 CLE SPM"
set-aduser -identity Victor.Sibiga -manager HodepeTL -title "Engineer" -department "350.02 CHI Process"
set-aduser -identity SilajSM -manager WrightPJ -title "Procurement Agent" -department "840.02 CHI Procurement"
set-aduser -identity Sinhask -manager Jalpan.Soni -title "Sr. Engineer" -department "600.02 CHI Electrical"
set-aduser -identity Kory.Siverd -manager Khaterjm -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Slabyja -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity Adam.Smith -manager Sortispd -title "Discipline Manager" -department "100.06 BUF Structural"
set-aduser -identity SmithBM -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity SmithMJ -manager Shkurtav -title "Staff Engineer" -department "100.02 CHI Structural"
set-aduser -identity Jalpan.Soni -manager TurneyBK -title "Discipline Manager" -department "600.02 CHI Electrical"
set-aduser -identity Sortispd -manager mark.seifried -title "Director" -department "400.06 BUF Mechanical"
set-aduser -identity Stagerdj -manager Granatpj -title "Designer" -department "100.03 TOL Structural"
set-aduser -identity Stahlcw -manager Waltonjs -title "Document Controls Coordinator" -department "810.03 TOL Document Control"
set-aduser -identity StalteDE -manager jamie.jurin -title "Sr. Engineer" -department "670.01 CLE Power"
set-aduser -identity StarkCJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Wes.Stewart -manager Ray.Shore -title "Project Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Doug.Stieb -manager Schrinmj -title "Staff Specialist" -department "425.03 TOL Piping"
set-aduser -identity StolleNW -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity StonemPJ -manager sam.barnes -title "Director, Marketing" -department "760.01 CLE Marketing"
set-aduser -identity Streitgj -manager HayesRJ -title "Sr. Major Projects Manager" -department "899.02 CHI SMM"
set-aduser -identity Strosnrl -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Lonnie.Stump -manager GrelewJF -title "Specialist" -department "125.08 NWI Asset Integrity"
set-aduser -identity Caitlyn.Sullivan -manager YoungKE -title "Human Resources Manager " -department "710.02 CHI Human Resources"
set-aduser -identity cathy.sullivan -manager WrightPJ -title "Document Controls Coordinator" -department "810.02 CHI Document Control"
set-aduser -identity Sulzbamd -manager Adamsjk -title "Sr. Specialist" -department "400.06 BUF Mechanical"
set-aduser -identity Sweenejw -manager Waltonjs -title "Sr. Discipline Manager" -department "600.03 TOL Electrical"
set-aduser -identity Szalkomg -manager Blairtg -title "IT Manager " -department "740.01 CLE Information Technology"
set-aduser -identity Caleb.Tackett -manager Darbyjd -title "Intern" -department "425.05 ASH Piping"
set-aduser -identity TaylorTR -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity TerryAM -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Tholete -manager Mckenzrl -title "Sr. Specialist" -department "425.01 CLE Piping"
set-aduser -identity Bryan.Thomas -manager Shawn.dishauzi -title "Sr. Specialist" -department "785.01 TOL Health & Safety"
set-aduser -identity jim.thomas -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity Thompsba -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity ThompsCJ -manager Mckenzrl -title "Designer" -department "425.01 CLE Piping"
set-aduser -identity Rob.Tibbitts -manager sam.barnes -title "Director, Legal" -department "780.01 CLE Legal"
set-aduser -identity Tielldm -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Torosiaa -manager Bridgecj -title "Staff Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Troutbd -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Nick.Trout -manager Walterac -title "Designer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity TurneyBK -manager HayesRJ -title "Sr. Technical Manager" -department "100.02 CHI Structural"
set-aduser -identity jordan.unmuth -manager Jalpan.Soni -title "Sr. Engineer" -department "600.28 MAD Electrical"
set-aduser -identity Urankaaj -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity UttechMJ -manager HayesRJ -title "Director" -department "899.28 MAD SMM"
set-aduser -identity Jennifer.Valek -manager Zdolshtl -title "Accounting Specialist " -department "750.01 CLE Accounting"
set-aduser -identity Gise.VanBaren -manager GrelewJF -title "Intern" -department "125.08 NWI Asset Integrity"
set-aduser -identity Michael.Vargas -manager jason.lamb -title "IT Specialist " -department "740.02 CHI Information Technology"
set-aduser -identity Jonathan.Vernon -manager Liuy -title "Intern" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity trenton.vicker -manager Jalpan.Soni -title "Engineer" -department "600.02 CHI Electrical"
set-aduser -identity Shawn.Vickers -manager sam.barnes -title "Vice President, Business Development" -department "930.01 CLE Business Development"
set-aduser -identity Vidrare -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity Santiago.villegas -manager Shkurtav -title "Designer" -department "100.02 CHI Structural"
set-aduser -identity Justin.Viola -manager Endersmd -title "Drafter" -department "425.27 PIT Piping"
set-aduser -identity Voytkotl -manager Brent.Prazer -title "Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity Stephen.Wagner -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Walterac -manager Lowrydp -title "Tech Manager" -department "100.05 ASH Structural"
set-aduser -identity Walterja -manager HayesRJ -title "Director" -department "900.02 CHI SPM"
set-aduser -identity Justin.Walters -manager Bridgecj -title "Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Waltonjs -manager Lowrydp -title "Director" -department "425.03 TOL Piping"
set-aduser -identity Warnecm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Avionne.Weaver -manager Brent.Prazer -title "Engineer" -department "475.01 CLE Automation"
set-aduser -identity Weiganrk -manager KruppBE -title "Sr. Designer" -department "600.01 CLE Electrical"
set-aduser -identity Weinhejr -manager mark.seifried -title "Director" -department "899.06 BUF SMM"
set-aduser -identity WeinheSG -manager Adamsjk -title "Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Kendall.Welling -manager Shkurtav -title "Engineer" -department "100.28 MAD Structural"
set-aduser -identity Otto.Wenzel -manager John.Rotroff -title "Project Manager" -department "800.08 NWI PM"
set-aduser -identity Wheatmd -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity Eric.Whittaker -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Wickerth -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity Wilkinvp -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Keyana.Williams -manager StonemPJ -title "Marketing Generalist " -department "760.01 CLE Marketing"
set-aduser -identity Winklekm -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity WinterWF -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Matt.Wisniewski -manager Waltonjs -title "Discipline Manager" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Wiszjl -manager jason.lamb -title "IT Generalist " -department "740.02 CHI Information Technology"
set-aduser -identity Jimmy.Wood -manager KuzmaJS -title "Sr. Designer" -department "425.02 CHI Piping"
set-aduser -identity David.Woodnorth -manager HayesRJ -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity WraseJW -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity WrightPJ -manager HayesRJ -title "Sr. Major Projects Manager" -department "899.02 CHI SMM"
set-aduser -identity Li.Yan -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity Yoergerw -manager KruppBE -title "Sr. Designer" -department "600.01 CLE Electrical"
set-aduser -identity brian.young -manager Brent.Prazer -title "Sr. Specialist" -department "100.01 CLE Structural"
set-aduser -identity YoungKE -manager sam.barnes -title "Vice President, Human Resources" -department "710.01 CLE Human Resources"
set-aduser -identity YoungCS -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity Zapataem -manager Mclaugma -title "Project Controls Coordinator" -department "820.03 TOL Project Controls"
set-aduser -identity ZatoWA -manager LantinZL -title "Sr. Specialist" -department "425.08 NWI Piping"
set-aduser -identity Zdolshtl -manager Dankoww -title "Accounting Manager " -department "750.01 CLE Accounting"
set-aduser -identity chad.zimmerman -manager LantinZL -title "Sr. Specialist" -department "425.08 NWI Piping"
set-aduser -identity drew.zimmerman -manager Cussenkg -title "Sr. Engineer" -department "200.02 CHI Civil"
set-aduser -identity Jeff.Zunich -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"

===

6/10/24
New-ADUser -Name “Wendy Sanderfer" -GivenName "Wendy" -Surname "Sanderfer" -displayname "Wendy Sanderfer" -SamAccountName "wendy.sanderfer" -path "OU=710,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -UserPrincipalName "wendy.sanderfer@middough.com" -department "710.01 CLE Human Resources" -office "Cleveland" -state "OH" -initials "WS" -StreetAddress "1901 E 13th St, Ste 400" -City "Cleveland" -PostalCode "44114" -title "HR Generalist " -company "Middough" -manager "Melilllm";set-aduser "wendy.sanderfer" -Replace @{c="US";co="United States";countrycode=840};Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members wendy.sanderfer;; Add-ADGroupMember -identity CLE_710 -members wendy.sanderfer;; Add-ADGroupMember -identity "SSO" -members wendy.sanderfer; Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members wendy.sanderfer;;
set-aduser "wendy.sanderfer" -officephone "216-367-6107"
New-ADGroup -Name ORACLE-WS -SamAccountName ORACLE-WS -GroupCategory Security -GroupScope Global -DisplayName ORACLE-WS -Path "OU=RDP Access,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" -Description "Members of this group have RDP access to  \\ORACLE24";  Add-ADGroupMember -identity ORACLE-WS -Members wendy.sanderfer

===

6/20/24

set-aduser -identity Blackjl -manager HayesRJ -title "Sr. Major Projects Manager" -department "800.02 CHI PM"
set-aduser -identity Jeff.Fesko -manager PiperCR -title "Major Projects Manager" -department "800.27 PIT PM"
set-aduser -identity JaraczJP -manager Weinhejr -title "Major Projects Manager" -department "800.06 BUF PM"
set-aduser -identity Khaterjm -manager mark.seifried -title "Director" -department "800.01 CLE PM"
set-aduser -identity tiffany.malcom -manager PiperCR -title "Major Projects Manager" -department "800.27 PIT PM"
set-aduser -identity Mike.Picardi -manager Khaterjm -title "Major Projects Manager" -department "800.01 CLE PM"
set-aduser -identity PiperCR -manager Bob.Necciai -title "Director" -department "800.27 PIT PM"
set-aduser -identity James.Rossi -manager WrightPJ -title "Major Projects Manager" -department "800.02 CHI PM"
set-aduser -identity Shawn.Rudy -manager PiperCR -title "Major Projects Manager" -department "800.27 PIT PM"
set-aduser -identity Streitgj -manager HayesRJ -title "Sr. Major Projects Manager" -department "800.02 CHI PM"
set-aduser -identity UttechMJ -manager HayesRJ -title "Director" -department "800.28 MAD PM"
set-aduser -identity Weinhejr -manager mark.seifried -title "Director" -department "800.06 BUF PM"
set-aduser -identity WrightPJ -manager HayesRJ -title "Sr. Major Projects Manager" -department "800.02 CHI PM"

add-ADGroupMember -Identity "pit_899" -Members ThompsCJ
remove-adgroupmember -identity pit_899 -members Blackjl

Get-ADPrincipalGroupMembership -Identity thompscj

remove-adgroupmember -identity CHI_899 -members Blackjl	; add-adgroupmember -identity CHI_899 -members Blackjl


Move-ADObject -Identity blackjl -TargetPath "OU=800,OU=CHI,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"
set-aduser -identity blackjl  -path "OU=800,OU=CHI,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" 


set-aduser -identity Blackjl -manager HayesRJ -title "Sr. Major Projects Manager" -department "800.02 CHI PM"	; remove-adgroupmember -identity CHI_899 -members Blackjl	; add-adgroupmember -identity CHI_800 -members Blackjl
set-aduser -identity Jeff.Fesko -manager PiperCR -title "Major Projects Manager" -department "800.27 PIT PM"	; remove-adgroupmember -identity PIT_899 -members Jeff.Fesko	; add-adgroupmember -identity PIT_800 -members Jeff.Fesko
set-aduser -identity JaraczJP -manager Weinhejr -title "Major Projects Manager" -department "800.06 BUF PM"	; remove-adgroupmember -identity BUF_899 -members JaraczJP	; add-adgroupmember -identity BUF_800 -members JaraczJP
set-aduser -identity Khaterjm -manager mark.seifried -title "Director" -department "800.01 CLE PM"	; remove-adgroupmember -identity CLE_899 -members Khaterjm	; add-adgroupmember -identity CLE_800 -members Khaterjm
set-aduser -identity tiffany.malcom -manager PiperCR -title "Major Projects Manager" -department "800.27 PIT PM"	; remove-adgroupmember -identity PIT_899 -members tiffany.malcom	; add-adgroupmember -identity PIT_800 -members tiffany.malcom
set-aduser -identity Mike.Picardi -manager Khaterjm -title "Major Projects Manager" -department "800.01 CLE PM"	; remove-adgroupmember -identity CLE_899 -members Mike.Picardi	; add-adgroupmember -identity CLE_800 -members Mike.Picardi
set-aduser -identity PiperCR -manager Bob.Necciai -title "Director" -department "800.27 PIT PM"	; remove-adgroupmember -identity PIT_899 -members PiperCR	; add-adgroupmember -identity PIT_800 -members PiperCR
set-aduser -identity James.Rossi -manager WrightPJ -title "Major Projects Manager" -department "800.02 CHI PM"	; remove-adgroupmember -identity CHI_899 -members James.Rossi	; add-adgroupmember -identity CHI_800 -members James.Rossi
set-aduser -identity Shawn.Rudy -manager PiperCR -title "Major Projects Manager" -department "800.27 PIT PM"	; remove-adgroupmember -identity PIT_899 -members Shawn.Rudy	; add-adgroupmember -identity PIT_800 -members Shawn.Rudy
set-aduser -identity Streitgj -manager HayesRJ -title "Sr. Major Projects Manager" -department "800.02 CHI PM"	; remove-adgroupmember -identity CHI_899 -members Streitgj	; add-adgroupmember -identity CHI_800 -members Streitgj
set-aduser -identity UttechMJ -manager HayesRJ -title "Director" -department "800.28 MAD PM"	; remove-adgroupmember -identity MAD_899 -members UttechMJ	; add-adgroupmember -identity MAD_800 -members UttechMJ
set-aduser -identity Weinhejr -manager mark.seifried -title "Director" -department "800.06 BUF PM"	; remove-adgroupmember -identity BUF_899 -members Weinhejr	; add-adgroupmember -identity BUF_800 -members Weinhejr
set-aduser -identity WrightPJ -manager HayesRJ -title "Sr. Major Projects Manager" -department "800.02 CHI PM"	; remove-adgroupmember -identity CHI_899 -members WrightPJ	; add-adgroupmember -identity CHI_800 -members WrightPJ


set-ADUser jasono.lambo -StreetAddress "2650 Warrenville Rd, Ste 500" -City "Downers Grove" -PostalCode "60515" 

===

# 09/18/24 - HR UPDATE

set-aduser -identity WeinheSG -manager Adamsjk -title "Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Harold.Kropp -manager Adamsjk -title "Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Failindj -manager Adamsjk -title "Sr. Designer" -department "400.06 BUF Mechanical"
set-aduser -identity jeff.martis2 -manager Adamsjk -title "Sr. Designer" -department "400.06 BUF Mechanical"
set-aduser -identity Sulzbamd -manager Adamsjk -title "Sr. Specialist" -department "400.06 BUF Mechanical"
set-aduser -identity Nashad -manager Adamsjk -title "Staff Engineer" -department "400.06 BUF Mechanical"
set-aduser -identity Walterja -manager sam.barnes -title "Director" -department "900.02 CHI SPM"
set-aduser -identity DavidsRJ -manager sam.barnes -title "Director" -department "050.02 CHI Architectural"
set-aduser -identity Hurstdl -manager sam.barnes -title "Sr. Discipline Manager" -department "400.02 CHI Mechanical"
set-aduser -identity Blackjl -manager sam.barnes -title "Sr. Major Projects Manager" -department "800.02 CHI PM"
set-aduser -identity WrightPJ -manager sam.barnes -title "Sr. Major Projects Manager" -department "800.02 CHI PM"
set-aduser -identity Geresbc -manager sam.barnes -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity David.Woodnorth -manager sam.barnes -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity Charu.Bhat -manager sam.barnes -title "Sr. Project Manager" -department "900.02 CHI SPM"
set-aduser -identity Roger.Hieser -manager sam.barnes -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Bogaersm -manager sam.barnes -title "Vice President" -department "705.08 CHI Quality"
set-aduser -identity Perlaaj -manager sam.barnes -title "Vice President" -department "930.02 CHI Business Development"
set-aduser -identity Blairtg -manager sam.barnes -title "Director" -department "740.01 CLE Information Technology"
set-aduser -identity StonemPJ -manager sam.barnes -title "Director" -department "760.01 CLE Marketing"
set-aduser -identity Rob.Tibbitts -manager sam.barnes -title "Director" -department "780.01 CLE Legal"
set-aduser -identity Shawn.Dishauzi -manager sam.barnes -title "Director" -department "785.01 CLE Health & Safety"
set-aduser -identity Ledinje -manager sam.barnes -title "Senior Vice President" -department "720.01 CLE MIS"
set-aduser -identity OconnoDP -manager sam.barnes -title "Senior Vice President" -department "799.01 CLE Corporate Executives"
set-aduser -identity mark.seifried -manager sam.barnes -title "Senior Vice President" -department "699.01 CLE Management"
set-aduser -identity YoungKE -manager sam.barnes -title "Vice President" -department "710.01 CLE Human Resources"
set-aduser -identity Shawn.Vickers -manager sam.barnes -title "Vice President" -department "930.01 CLE Business Development"
set-aduser -identity Dankoww -manager sam.barnes -title "Vice President" -department "750.01 CLE Accounting"
set-aduser -identity Samantha.Fox -manager sam.barnes -title "Business Development Director" -department "930.27 PIT Business Development"
set-aduser -identity shannon.owen -manager sam.barnes -title "Business Development Director" -department "930.27 PIT Business Development"
set-aduser -identity Bob.Necciai -manager sam.barnes -title "Senior Vice President" -department "699.27 PIT Management"
set-aduser -identity Lowrydp -manager sam.barnes -title "Senior Vice President" -department "699.03 TOL Management"
set-aduser -identity TurneyBK -manager sam.barnes -title "Sr. Technical Manager" -department "100.02 CHI Structural"
set-aduser -identity Kevin.Zhang -manager Bealmk -title "Drafter" -department "425.06 BUF Piping"
set-aduser -identity Greg.Furgala -manager Bealmk -title "Specialist" -department "425.06 BUF Piping"
set-aduser -identity Tyler.Baird -manager Matt.Bedee -title "Designer" -department "050.01 CLE Architectural"
set-aduser -identity Szalkomg -manager Blairtg -title "IT Manager" -department "740.01 CLE Information Technology"
set-aduser -identity Podhorrl -manager Blairtg -title "IT Manager" -department "740.01 CLE Information Technology"
set-aduser -identity jason.lamb -manager Blairtg -title "IT Manager" -department "740.01 CLE Information Technology"
set-aduser -identity Justin.Otero -manager Bridgecj -title "Drafter" -department "350.01 CLE Process"
set-aduser -identity Bordonra -manager Bridgecj -title "Project Engineer" -department "350.01 CLE Process"
set-aduser -identity AtkinsJD -manager Bridgecj -title "Project Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Justin.Walters -manager Bridgecj -title "Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Jeff.Zunich -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity andrew.gallagher -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity rick.dugan -manager Bridgecj -title "Sr. Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Rothrj -manager Bridgecj -title "Sr. Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity Rossjw -manager Bridgecj -title "Staff Engineer" -department "350.01 CLE Process"
set-aduser -identity Torosiaa -manager Bridgecj -title "Staff Engineer" -department "400.01 CLE Mechanical"
set-aduser -identity Lytlemp -manager Bridgecj -title "Staff Specialist" -department "400.01 CLE Mechanical"
set-aduser -identity drew.zimmerman -manager Cussenkg -title "Sr. Engineer" -department "200.02 CHI Civil"
set-aduser -identity Payneke -manager Dankoww -title "Accounting Generalist" -department "750.01 CLE Accounting"
set-aduser -identity Olesicka -manager Dankoww -title "Accounting Generalist" -department "750.01 CLE Accounting"
set-aduser -identity Chris.Puleo -manager Dankoww -title "Accounting Generalist" -department "750.01 CLE Accounting"
set-aduser -identity Zdolshtl -manager Dankoww -title "Accounting Manager" -department "750.01 CLE Accounting"
set-aduser -identity Leonarcm -manager Dankoww -title "Accounting Specialist" -department "750.01 CLE Accounting"
set-aduser -identity Anthony.Gigante -manager Dankoww -title "Accounting Specialist" -department "750.01 CLE Accounting"
set-aduser -identity Clougheg -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity MillerJK -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity Halljl -manager Darbyjd -title "Designer" -department "425.05 ASH Piping"
set-aduser -identity Autumn.Hatcher -manager Darbyjd -title "Drafter" -department "425.05 ASH Piping"
set-aduser -identity Ashama.Babooram -manager Darbyjd -title "Engineer" -department "425.05 ASH Piping"
set-aduser -identity Caleb.Tackett -manager Darbyjd -title "Intern" -department "425.05 ASH Piping"
set-aduser -identity Flaughpl -manager Darbyjd -title "Specialist" -department "425.05 ASH Piping"
set-aduser -identity Bowlinpa -manager Darbyjd -title "Sr. Specialist" -department "425.05 ASH Piping"
set-aduser -identity Grubbkl -manager Darbyjd -title "Sr. Specialist" -department "425.05 ASH Piping"
set-aduser -identity Jon.Beskin -manager DavidsRJ -title "Sr. Designer" -department "050.02 CHI Architectural"
set-aduser -identity MastanEJ -manager DavidsRJ -title "Staff Architect" -department "050.02 CHI Architectural"
set-aduser -identity Bryan.Thomas -manager Shawn.dishauzi -title "Sr. Specialist" -department "890.01 TOL ERROR Health & Safety"
set-aduser -identity josh.palyo -manager Chris.Edwards -title "Sr. Engineer" -department "350.27 PIT Process"
set-aduser -identity Luka.Stratimirovic -manager Endersmd -title "Engineer" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity Nathan.Ingram -manager Endersmd -title "Specialist" -department "600.27 PIT Electrical"
set-aduser -identity Abdallah.Hamad -manager Endersmd -title "Sr. Engineer" -department "600.27 PIT Electrical"
set-aduser -identity patrick.conner -manager FaulknAM -title "Sr. Project Controls Specialist" -department "820.02 CHI Project Controls"
set-aduser -identity PutnamKA -manager FaulknAM -title "Staff Estimator" -department "821.02 CHI Estimating"
set-aduser -identity rich.phillips -manager FaulknAM -title "Staff Estimator" -department "821.02 CHI Estimating"
set-aduser -identity Michael.Deinhammer -manager Geresbc -title "Project Manager" -department "800.10 MIN PM"
set-aduser -identity Stagerdj -manager Granatpj -title "Designer" -department "100.03 TOL Structural"
set-aduser -identity Robertmd -manager Granatpj -title "Specialist" -department "100.03 TOL Structural"
set-aduser -identity Wheatmd -manager Granatpj -title "Specialist" -department "100.03 TOL Structural"
set-aduser -identity Vidrare -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity Wickerth -manager Granatpj -title "Sr. Designer" -department "100.03 TOL Structural"
set-aduser -identity HitesZH -manager Granatpj -title "Sr. Engineer" -department "100.03 TOL Structural"
set-aduser -identity Gasem.Elarbi -manager Granatpj -title "Sr. Engineer" -department "100.03 TOL Structural"
set-aduser -identity Slabyja -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity Pricewf -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity YoungCS -manager GrelewJF -title "Inspector" -department "125.01 CLE Asset Integrity"
set-aduser -identity lela.conley -manager GrelewJF -title "Inspection Coordinator " -department "125.08 NWI Asset Integrity"
set-aduser -identity klimka.grubbe -manager GrelewJF -title "Inspection Coordinator " -department "125.08 NWI Asset Integrity"
set-aduser -identity Dylan.McNamee -manager GrelewJF -title "Inspector" -department "125.08 NWI Asset Integrity"
set-aduser -identity logan.cover -manager GrelewJF -title "Inspector" -department "125.08 NWI Asset Integrity"
set-aduser -identity travis.culver -manager GrelewJF -title "Inspector" -department "125.08 NWI Asset Integrity"
set-aduser -identity Gise.VanBaren -manager GrelewJF -title "Intern" -department "125.08 NWI Asset Integrity"
set-aduser -identity Jayden.Andras -manager GrelewJF -title "Intern" -department "125.08 NWI Asset Integrity"
set-aduser -identity Lonnie.Stump -manager GrelewJF -title "Specialist" -department "125.08 NWI Asset Integrity"
set-aduser -identity Keith.Luttell -manager GrelewJF -title "Sr.nspector" -department "125.08 NWI Asset Integrity"
set-aduser -identity Richard.Genser -manager Chris.Hennessey -title "Designer" -department "100.27 PIT Structural"
set-aduser -identity Molly.Green -manager Chris.Hennessey -title "Engineer" -department "100.27 PIT Structural"
set-aduser -identity jason.clouse -manager Chris.Hennessey -title "Engineer" -department "100.27 PIT Structural"
set-aduser -identity Chris.Muntz -manager Chris.Hennessey -title "Specialist" -department "100.27 PIT Structural"
set-aduser -identity Jackie.Kolling -manager Chris.Hennessey -title "Sr. Designer" -department "100.27 PIT Structural"
set-aduser -identity Lenny.Laird -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity nick.arnold -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity luke.potter -manager Chris.Hennessey -title "Sr. Engineer" -department "100.27 PIT Structural"
set-aduser -identity Curtis.Merow -manager Chris.Hennessey -title "Sr. Specialist" -department "100.27 PIT Structural"
set-aduser -identity Victor.Sibiga -manager HodepeTL -title "Engineer" -department "350.02 CHI Process"
set-aduser -identity Lillian.Bennett -manager HodepeTL -title "Engineer" -department "350.02 CHI Process"
set-aduser -identity Robert.Adamski -manager HodepeTL -title "Project Engineer " -department "350.02 CHI Process"
set-aduser -identity Chihakaa -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity Glen.Hoppe -manager HodepeTL -title "Sr. Engineer" -department "350.02 CHI Process"
set-aduser -identity John.Micheli -manager HodepeTL -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Merrill.Childs -manager HodepeTL -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Chetan.Rege -manager HodepeTL -title "Sr. Staff Engineer" -department "350.02 CHI Process"
set-aduser -identity Connor.Loughlin -manager Hurstdl -title "Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity john.genau -manager Hurstdl -title "Project Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity RoweGF -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity GonzalED -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity Dan.Heberer -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity yafei.liu -manager Hurstdl -title "Sr. Engineer" -department "400.02 CHI Mechanical"
set-aduser -identity StalteDE -manager jamie.jurin -title "Sr. Engineer" -department "670.01 CLE Power"
set-aduser -identity adam.shands -manager jamie.jurin -title "Sr. Engineer" -department "670.01 CLE Power"
set-aduser -identity adam.clark -manager jamie.jurin -title "Sr. Engineer" -department "670.10 MIN Power"
set-aduser -identity Mike.Picardi -manager Khaterjm -title "Major Projects Manager" -department "800.01 CLE PM"
set-aduser -identity CullerTL -manager Khaterjm -title "Procurement Manager" -department "840.01 CLE Procurement"
set-aduser -identity Meyersmj -manager Khaterjm -title "Project Assistant" -department "810.01 CLE Document Control"
set-aduser -identity Keyta -manager Khaterjm -title "Project Assistant" -department "810.01 CLE Document Control"
set-aduser -identity Kory.Siverd -manager Khaterjm -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Chris.Moran -manager Khaterjm -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity Palmerbj -manager KruppBE -title "Designer" -department "600.01 CLE Electrical"
set-aduser -identity Sam.Bennett -manager KruppBE -title "Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Sebekjj -manager KruppBE -title "Project Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Jose.DeJesus -manager KruppBE -title "Specialist" -department "600.01 CLE Electrical"
set-aduser -identity Weiganrk -manager KruppBE -title "Sr. Designer" -department "600.01 CLE Electrical"
set-aduser -identity Yoergerw -manager KruppBE -title "Sr. Designer" -department "600.01 CLE Electrical"
set-aduser -identity Daniel.Devadoss -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity Eric.Whittaker -manager KruppBE -title "Sr. Engineer" -department "600.01 CLE Electrical"
set-aduser -identity PrudenGA -manager KruppBE -title "Sr. Specialist" -department "600.01 CLE Electrical"
set-aduser -identity Steve.Maggiano -manager KruppBE -title "Staff Engineer" -department "600.01 CLE Electrical"
set-aduser -identity victor.guerrero -manager KuzmaJS -title "Designer" -department "425.02 CHI Piping"
set-aduser -identity Jimmy.Wood -manager KuzmaJS -title "Sr. Designer" -department "425.02 CHI Piping"
set-aduser -identity Johnsoje -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Nestor.Hiso -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Mark.Santillana -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity WinterWF -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity MayareD -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Stephen.Wagner -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Justin.Pappas -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Savares.McCarter -manager KuzmaJS -title "Sr. Specialist" -department "425.02 CHI Piping"
set-aduser -identity Wiszjl -manager jason.lamb -title "IT Generalist" -department "740.02 CHI Information Technology"
set-aduser -identity Michael.Vargas -manager jason.lamb -title "IT Specialist" -department "740.02 CHI Information Technology"
set-aduser -identity Schmidrc -manager jason.lamb -title "IT Generalist" -department "740.01 CLE Information Technology"
set-aduser -identity GeorgeM -manager Christian.Lange -title "Project Engineer" -department "400.08 NWI Mechanical"
set-aduser -identity DeakinJR -manager Christian.Lange -title "Sr. Engineer" -department "400.08 NWI Mechanical"
set-aduser -identity ZatoWA -manager Christian.Lange -title "Sr. Specialist" -department "425.08 NWI Piping"
set-aduser -identity Kenneth.Dudzik -manager Christian.Lange -title "Sr. Specialist" -department "425.08 NWI Piping"
set-aduser -identity chad.zimmerman -manager Christian.Lange -title "Sr. Specialist" -department "425.08 NWI Piping"
set-aduser -identity Christian.Lange -manager LantinZL -title "Discipline Manager" -department "400.08 NWI Mechanical"
set-aduser -identity Elena.Graupera -manager LantinZL -title "Document Controls Coordinator" -department "810.08 NWI Document Control"
set-aduser -identity jim.bereda -manager LantinZL -title "Sr. Engineer" -department "600.08 NWI Electrical"
set-aduser -identity MakinsAP -manager LantinZL -title "Discipline Manager" -department "100.08 NWI Structural"
set-aduser -identity Hilbercr -manager Ledinje -title "IS Generalist" -department "720.01 CLE MIS"
set-aduser -identity Denise.SetteurSpurio -manager Ledinje -title "IS Generalist" -department "720.01 CLE MIS"
set-aduser -identity rosario.scibona -manager Ledinje -title "IS Manager" -department "720.01 CLE MIS"
set-aduser -identity Ledinrr -title "Chairman" -department "799.01 CLE Corporate Executives"
set-aduser -identity sam.barnes -manager Ledinrr -title "President & CEO" -department "799.01 CLE Corporate Executives"
set-aduser -identity Newmankj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Rectordj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Gary.Row -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity Carnsjj -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity SmithBM -manager Lenharbd -title "Project Manager" -department "800.03 TOL PM"
set-aduser -identity kayan.kartoum -manager Liuy -title "Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity AldridBC -manager Liuy -title "Specialist" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity RedmonJM -manager Liuy -title "Sr. Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Shogresc -manager Liuy -title "Sr. Specialist" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Thomas.Paprocki -manager Liuy -title "Staff Engineer" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity Hoggeml -manager Lowrydp -title "Director" -department "900.05 ASH SPM"
set-aduser -identity Salowma -manager Lowrydp -title "Sr. Project Manager" -department "900.05 ASH SPM"
set-aduser -identity jeff.caldwell -manager Lowrydp -title "Sr. Project Manager" -department "900.05 ASH SPM"
set-aduser -identity Lenharbd -manager Lowrydp -title "Director" -department "900.03 TOL SPM"
set-aduser -identity Waltonjs -manager Lowrydp -title "Director" -department "425.03 TOL Piping"
set-aduser -identity Winklekm -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Postacj -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Rabquewa -manager Lowrydp -title "Sr. Project Manager" -department "900.03 TOL SPM"
set-aduser -identity Walterac -manager Lowrydp -title "Tech Manager" -department "100.05 ASH Structural"
set-aduser -identity Joe.Rybicki -manager MakinsAP -title "Designer" -department "100.08 NWI Structural"
set-aduser -identity Jason.Thompson -manager MakinsAP -title "Designer" -department "100.08 NWI Structural"
set-aduser -identity brandon.magnusen -manager MakinsAP -title "Engineer" -department "100.08 NWI Structural"
set-aduser -identity ThompsCJ -manager Mckenzrl -title "Designer" -department "425.01 CLE Piping"
set-aduser -identity joseph.kalic -manager Mckenzrl -title "Engineer" -department "425.01 CLE Piping"
set-aduser -identity Austin.Lackritz -manager Mckenzrl -title "Engineer" -department "425.01 CLE Piping"
set-aduser -identity Mike.Paulic -manager Mckenzrl -title "Project Engineer" -department "425.01 CLE Piping"
set-aduser -identity BalchaDM -manager Mckenzrl -title "Specialist" -department "425.01 CLE Piping"
set-aduser -identity JankeyRW -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity Urankaaj -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity kevin.kerline -manager Mckenzrl -title "Sr. Engineer" -department "425.01 CLE Piping"
set-aduser -identity Tholete -manager Mckenzrl -title "Sr. Specialist" -department "425.01 CLE Piping"
set-aduser -identity Althoumj -manager Mckenzrl -title "Staff Engineer" -department "425.01 CLE Piping"
set-aduser -identity Justin.Viola -manager Mckenzrl -title "Drafter" -department "425.27 PIT Piping"
set-aduser -identity Michael.Sarver -manager Mckenzrl -title "Sr. Designer" -department "425.27 PIT Piping"
set-aduser -identity Frankie.Strahl -manager Mckenzrl -title "Sr. Designer" -department "425.27 PIT Piping"
set-aduser -identity Devriejc -manager Mclaugma -title "Cost Scheduler" -department "820.03 TOL Project Controls"
set-aduser -identity Zapataem -manager Mclaugma -title "Project Controls Coordinator" -department "820.03 TOL Project Controls"
set-aduser -identity Gravesrm -manager Mclaugma -title "Project Controls Coordinator" -department "820.03 TOL Project Controls"
set-aduser -identity chris.edwards -manager Jeffrey.Moreland -title "Discipline Manager" -department "350.27 PIT Process"
set-aduser -identity Ray.Shore -manager Jeffrey.Moreland -title "Discipline Manager" -department "400.27 PIT Mechanical"
set-aduser -identity Endersmd -manager Jeffrey.Moreland -title "Sr. Discipline Manager" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity Chris.Hennessey -manager Jeffrey.Moreland -title "Discipline Manager" -department "100.27 PIT Structural"
set-aduser -identity Overhorj -manager Sortispd -title "Specialist" -department "600.06 BUF Electrical"
set-aduser -identity PiperCR -manager Bob.Necciai -title "Director" -department "800.27 PIT PM"
set-aduser -identity Jeffrey.Moreland -manager Bob.Necciai -title "Director" -department "650.27 PIT Instrumental & Controls"
set-aduser -identity deb.semego -manager PiperCR -title "Document Controls Coordinator" -department "810.27 PIT Document Control"
set-aduser -identity Jeff.Fesko -manager PiperCR -title "Major Projects Manager" -department "800.27 PIT PM"
set-aduser -identity tiffany.malcom -manager PiperCR -title "Major Projects Manager" -department "800.27 PIT PM"
set-aduser -identity Sam.Blood -manager PiperCR -title "Project Controls Specialist" -department "820.27 PIT Project Controls"
set-aduser -identity Justin.Pistininzi -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity jim.thomas -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity Matthew.Stanton -manager PiperCR -title "Project Manager" -department "800.27 PIT PM"
set-aduser -identity Olschlre -manager Podhorrl -title "IT Generalist" -department "740.01 CLE Information Technology"
set-aduser -identity brad.daugharthy -manager Podhorrl -title "IT Generalist" -department "740.01 CLE Information Technology"
set-aduser -identity raya.Alhamzeh -manager Brent.Prazer -title "Engineer" -department "100.01 CLE Structural"
set-aduser -identity rana.kalaji -manager Brent.Prazer -title "Engineer" -department "100.01 CLE Structural"
set-aduser -identity Hlavacgm -manager Brent.Prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity Friedmm -manager Brent.Prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity Kordahyk -manager Brent.Prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity Pienostm -manager Brent.Prazer -title "Sr. Engineer" -department "100.01 CLE Structural"
set-aduser -identity brian.young -manager Brent.Prazer -title "Sr. Specialist" -department "100.01 CLE Structural"
set-aduser -identity Hoppelcl -manager Brent.Prazer -title "Sr. Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity Kilbyjw -manager Brent.Prazer -title "Staff Engineer" -department "100.01 CLE Structural"
set-aduser -identity Mckenzrl -manager Brent.Prazer -title "Discipline Manager" -department "425.01 CLE Piping"
set-aduser -identity Bridgecj -manager Brent.Prazer -title "Discipline Manager" -department "400.01 CLE Mechanical"
set-aduser -identity SefcikKP -manager Brent.Prazer -title "Discipline Manager" -department "200.01 CLE Civil"
set-aduser -identity Matt.Bedee -manager Brent.Prazer -title "Discipline Manager" -department "050.01 CLE Architectural"
set-aduser -identity jamie.jurin -manager Brent.Prazer -title "Discipline Manager" -department "670.01 CLE Power"
set-aduser -identity Avionne.Weaver -manager Brent.Prazer -title "Engineer" -department "475.01 CLE Automation"
set-aduser -identity Lawrence.Amerson -manager Brent.Prazer -title "Engineer" -department "475.01 CLE Automation"
set-aduser -identity Patricia.Krupp -manager Brent.Prazer -title "Sr. Designer" -department "475.01 CLE Automation"
set-aduser -identity Kasickjc -manager Brent.Prazer -title "Sr. Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity Jeff.McClurg -manager Brent.Prazer -title "Sr. Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity sumita.pol -manager Brent.Prazer -title "Sr. Engineer" -department "650.01 CLE Instrumental & Controls"
set-aduser -identity Jeff.Hollinshead -manager Brent.Prazer -title "Staff Engineer" -department "475.01 CLE Automation"
set-aduser -identity Mark.Custer -manager Brent.Prazer -title "Sr. Specialist" -department "650.08 NWI Instrumental & Controls"
set-aduser -identity Otto.Wenzel -manager John.Rotroff -title "Project Manager" -department "800.08 NWI PM"
set-aduser -identity shane.gulvas -manager John.Rotroff -title "Project Manager" -department "800.08 NWI PM"
set-aduser -identity joe.andras -manager John.Rotroff -title "Project Manager" -department "800.08 NWI PM"
set-aduser -identity PorterMR -manager Schrinmj -title "Designer" -department "425.03 TOL Piping"
set-aduser -identity Jeremias.Ortiz -manager Schrinmj -title "Designer" -department "425.03 TOL Piping"
set-aduser -identity Donavynn.Hayes -manager Schrinmj -title "Drafter" -department "425.03 TOL Piping"
set-aduser -identity reynoltl -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity TerryAM -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Tanner.Drees -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity joseph.imre -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity jack.middleton -manager Schrinmj -title "Engineer" -department "425.03 TOL Piping"
set-aduser -identity Reamerda -manager Schrinmj -title "Project Engineer" -department "425.03 TOL Piping"
set-aduser -identity Peacerj -manager Schrinmj -title "Specialist" -department "425.03 TOL Piping"
set-aduser -identity John.Hayes -manager Schrinmj -title "Specialist" -department "425.03 TOL Piping"
set-aduser -identity Hoyecl -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Seibolgr -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Thompsba -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity StarkCJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity RadtkeAJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity BettinJ -manager Schrinmj -title "Sr. Designer" -department "425.03 TOL Piping"
set-aduser -identity Browngt -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Feeneysm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Zach.Johnson -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Hammonmr -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Warnecm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Reinerjm -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Troutbd -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Wilkinvp -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity JimeneMJ -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity BrownTJ -manager Schrinmj -title "Sr. Engineer" -department "425.03 TOL Piping"
set-aduser -identity Fonsecmj -manager Schrinmj -title "Sr. Specialist" -department "425.03 TOL Piping"
set-aduser -identity Munjesr -manager Schrinmj -title "Staff Engineer" -department "425.03 TOL Piping"
set-aduser -identity Doug.Stieb -manager Schrinmj -title "Staff Specialist" -department "425.03 TOL Piping"
set-aduser -identity brent.prazer -manager mark.seifried -title "Sr. Technical Manager" -department "100.01 CLE Structural"
set-aduser -identity Weinhejr -manager mark.seifried -title "Director" -department "800.06 BUF PM"
set-aduser -identity Sortispd -manager mark.seifried -title "Director" -department "400.06 BUF Mechanical"
set-aduser -identity Khaterjm -manager mark.seifried -title "Director" -department "800.01 CLE PM"
set-aduser -identity Scott.Siatkowski -manager mark.seifried -title "Director" -department "900.01 CLE SPM"
set-aduser -identity Andy.Minderman -manager mark.seifried -title "Project Manager" -department "800.01 CLE PM"
set-aduser -identity KruppBE -manager mark.seifried -title "Sr. Discipline Director" -department "600.01 CLE Electrical"
set-aduser -identity Frederjw -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity Strosnrl -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity ReedEL -manager mark.seifried -title "Sr. Project Manager" -department "900.01 CLE SPM"
set-aduser -identity GrelewJF -manager mark.seifried -title "Sr. Discipline Manager" -department "125.08 NWI Asset Integrity"
set-aduser -identity John.Rotroff -manager mark.seifried -title "Sr. Project Manager" -department "900.08 NWI SPM"
set-aduser -identity LantinZL -manager mark.seifried -title "Sr. Technical Manager" -department "100.08 NWI Structural"
set-aduser -identity Santiago.villegas -manager Shkurtav -title "Designer" -department "100.02 CHI Structural"
set-aduser -identity Kendall.Welling -manager Shkurtav -title "Engineer" -department "100.02 MAD Structural"
set-aduser -identity RyanCD -manager Shkurtav -title "Project Engineer" -department "100.02 CHI Structural"
set-aduser -identity Bridendj -manager Shkurtav -title "Sr. Designer" -department "100.02 CHI Structural"
set-aduser -identity Braunske -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity WraseJW -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity Ashwin.Patel -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity Li.Yan -manager Shkurtav -title "Sr. Engineer" -department "100.02 CHI Structural"
set-aduser -identity SmithMJ -manager Shkurtav -title "Staff Engineer" -department "100.02 CHI Structural"
set-aduser -identity Wesley.McCurdy -manager Ray.Shore -title "Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Wes.Stewart -manager Ray.Shore -title "Project Engineer" -department "400.27 PIT Mechanical"
set-aduser -identity Tim.Saunders -manager Adam.Smith -title "Designer" -department "100.06 BUF Structural"
set-aduser -identity ben.mccoy -manager Adam.Smith -title "Engineer" -department "100.06 BUF Structural"
set-aduser -identity GoodJP -manager Adam.Smith -title "Specialist" -department "100.06 BUF Structural"
set-aduser -identity dan.sarata -manager Adam.Smith -title "Sr. Engineer" -department "100.06 BUF Structural"
set-aduser -identity Palmertp -manager Adam.Smith -title "Sr. Specialist" -department "100.06 BUF Structural"
set-aduser -identity Myra.Parayno -manager Jalpan.Soni -title "Specialist" -department "600.02 CHI Electrical"
set-aduser -identity Sinhask -manager Jalpan.Soni -title "Sr. Engineer" -department "600.02 CHI Electrical"
set-aduser -identity OlsonGA -manager Jalpan.Soni -title "Sr. Engineer" -department "600.02 CHI Electrical"
set-aduser -identity jordan.unmuth -manager Jalpan.Soni -title "Sr. Engineer" -department "600.02 MAD Electrical"
set-aduser -identity Adam.Smith -manager Sortispd -title "Discipline Manager" -department "100.06 BUF Structural"
set-aduser -identity Bealmk -manager Sortispd -title "Discipline Manager" -department "425.06 BUF Piping"
set-aduser -identity Adamsjk -manager Sortispd -title "Discipline Manager" -department "400.06 BUF Mechanical"
set-aduser -identity renee.morgan -manager Sortispd -title "Discipline Manager" -department "600.06 BUF Electrical"
set-aduser -identity jeren.lemanek -manager StonemPJ -title "Intern" -department "760.01 CLE Marketing"
set-aduser -identity Keyana.Williams -manager StonemPJ -title "Marketing Generalist" -department "760.01 CLE Marketing"
set-aduser -identity Jackie.Morris -manager StonemPJ -title "Marketing Manager" -department "760.01 CLE Marketing"
set-aduser -identity sherkoh.anz -manager Sweenejw -title "Engineer" -department "600.03 TOL Electrical"
set-aduser -identity clint.poca -manager Sweenejw -title "Sr. Specialist" -department "600.03 TOL Electrical"
set-aduser -identity Shkurtav -manager TurneyBK -title "Sr. Discipline Manager" -department "100.02 CHI Structural"
set-aduser -identity Cussenkg -manager TurneyBK -title "Discipline Manager" -department "200.02 CHI Civil"
set-aduser -identity Liuy -manager TurneyBK -title "Discipline Manager" -department "650.02 CHI Instrumental & Controls"
set-aduser -identity HodepeTL -manager TurneyBK -title "Discipline Manager" -department "350.02 CHI Process"
set-aduser -identity KuzmaJS -manager TurneyBK -title "Discipline Manager" -department "425.02 CHI Piping"
set-aduser -identity Jalpan.Soni -manager TurneyBK -title "Discipline Manager" -department "600.02 CHI Electrical"
set-aduser -identity Tristan.Griffith -manager Walterac -title "Drafter" -department "100.05 ASH Structural"
set-aduser -identity Kevin.Bollinger -manager Walterac -title "Engineer" -department "100.05 ASH Structural"
set-aduser -identity Johnsora -manager Walterac -title "Sr. Specialist" -department "100.05 ASH Structural"
set-aduser -identity Millerne -manager Walterac -title "Designer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Nick.Trout -manager Walterac -title "Designer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Darbyjd -manager Walterac -title "Discipline Manager" -department "425.05 ASH Piping"
set-aduser -identity Noah.Blain -manager Walterac -title "Engineer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Reganlm -manager Walterac -title "Project Assistant" -department "810.05 ASH Document Control"
set-aduser -identity PericD -manager Walterac -title "Specialist" -department "600.05 ASH Electrical"
set-aduser -identity BihlJC -manager Walterac -title "Sr. Engineer" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity matt.locher -manager Walterac -title "Sr. Specialist" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Carmen.Carr -manager Walterac -title "Sr. Specialist" -department "650.05 ASH Instrumental & Controls"
set-aduser -identity Bonerich -manager Walterja -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity BellTR -manager Walterja -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity Granatpj -manager Waltonjs -title "Sr. Discipline Manager" -department "100.03 TOL Structural"
set-aduser -identity Bill.Celian -manager Waltonjs -title "Construction Manager" -department "870.03 TOL Construction Management"
set-aduser -identity Schrinmj -manager Waltonjs -title "Discipline Manager" -department "425.03 TOL Piping"
set-aduser -identity Mclaugma -manager Waltonjs -title "Discipline Manager" -department "820.03 TOL Project Controls"
set-aduser -identity Matt.Wisniewski -manager Waltonjs -title "Discipline Manager" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity cookke -manager Waltonjs -title "Document Controls Coordinator" -department "810.03 TOL Document Control"
set-aduser -identity Stahlcw -manager Waltonjs -title "Document Controls Coordinator" -department "810.03 TOL Document Control"
set-aduser -identity Lowryma -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Tielldm -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity FryNL -manager Waltonjs -title "Project Assistant" -department "810.03 TOL Document Control"
set-aduser -identity Matt.Morgan -manager Waltonjs -title "Sr. Construction Manager" -department "870.03 TOL Construction Management"
set-aduser -identity Sweenejw -manager Waltonjs -title "Sr. Discipline Manager" -department "600.03 TOL Electrical"
set-aduser -identity JaraczJP -manager Weinhejr -title "Major Projects Manager" -department "800.06 BUF PM"
set-aduser -identity GawronRT -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity Patrick.Keenan -manager Weinhejr -title "Project Manager" -department "800.06 BUF PM"
set-aduser -identity kauveh.aynafshar -manager Matt.Wisniewski -title "Designer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Polcynam -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Durkindp -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity davisjl -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Christian.Kanfeld -manager Matt.Wisniewski -title "Sr. Engineer" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Koniectl -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Lesleylr -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity TaylorTR -manager Matt.Wisniewski -title "Sr. Specialist" -department "650.03 TOL Instrumental & Controls"
set-aduser -identity Buzz.Seydel -manager WrightPJ -title "Construction Manager" -department "870.02 CHI Construction Management"
set-aduser -identity FaulknAM -manager WrightPJ -title "Discipline Manager" -department "820.02 CHI Project Controls"
set-aduser -identity allison.hassig -manager WrightPJ -title "Discipline Manager" -department "840.02 CHI Procurement"
set-aduser -identity cathy.sullivan -manager WrightPJ -title "Document Controls Coordinator" -department "810.02 CHI Document Control"
set-aduser -identity kim.morphew -manager WrightPJ -title "Document Controls Specialist" -department "810.02 CHI Document Control"
set-aduser -identity James.Rossi -manager WrightPJ -title "Major Projects Manager" -department "800.02 CHI PM"
set-aduser -identity SilajSM -manager WrightPJ -title "Procurement Agent" -department "840.02 CHI Procurement"
set-aduser -identity CarneySP -manager WrightPJ -title "Project Manager" -department "800.02 CHI PM"
set-aduser -identity clint.downey -manager WrightPJ -title "Project Manager" -department "800.02 MAD PM"
set-aduser -identity robert.leugers -manager WrightPJ -title "Sr. Construct Supt" -department "870.02 CHI Construction Management"
set-aduser -identity Caitlyn.Sullivan -manager YoungKE -title "Human Resources Manager" -department "710.02 CHI Human Resources"
set-aduser -identity Amanda.Keller -manager YoungKE -title "HR Generalist" -department "710.01 CLE Human Resources"
set-aduser -identity lindsay.kaminski -manager YoungKE -title "HR Generalist" -department "710.01 CLE Human Resources"
set-aduser -identity Melilllm -manager YoungKE -title "Human Resources Manager" -department "710.01 CLE Human Resources"
set-aduser -identity jeff.peters -manager YoungKE -title "Human Resources Manager" -department "710.27 PIT Human Resources"
set-aduser -identity Jennifer.Valek -manager Zdolshtl -title "Accounting Specialist" -department "750.01 CLE Accounting"

