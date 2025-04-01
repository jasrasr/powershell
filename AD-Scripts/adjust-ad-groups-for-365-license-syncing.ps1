import-module activedirectory
get-aduser -identity 'GonzalED'
remove-adgroupmember -Identity 'O365 Microsoft Teams Phone Standard' -member 'GonzalED' -Confirm:$false

