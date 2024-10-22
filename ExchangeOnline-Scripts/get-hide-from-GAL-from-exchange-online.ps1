Connect-ExchangeOnline
get-recipient pvelite@middough.com | fl 
set-recipient 740@middough.com | fl *hidden*
get-recipient 740@middough.com | fl *hiddenfromaddresslistsenabled*