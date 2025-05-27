# 1. Import the Exchange Online PowerShell module and connect
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName '[email]'

# 2. Define the array of conference/mailbox email addresses
$CalendarMailboxes = @(
   "calendar-email1@domain.com",
    "calendar-email1@domain.com"
   )

# 3. Loop through each mailbox and set the desired properties
foreach ($Mailbox in $CalendarMailboxes) {

    # Set the mailbox’s regional configuration (language & time zone)
    Set-MailboxRegionalConfiguration -Identity $Mailbox `
        -Language en-US `
        -TimeZone "Eastern Standard Time"

    # Configure the working hours
    Set-MailboxCalendarConfiguration -Identity $Mailbox `
        -WorkingHoursStartTime 08:00:00 `
        -WorkingHoursEndTime   17:00:00 `
        -WorkingHoursTimeZone  "Eastern Standard Time" `
        #-WorkingDays Monday,Tuesday,Wednesday,Thursday,Friday

    # (Optional) Update the Office/Location property
    #Set-Mailbox -Identity $Mailbox -Office "Office Headquarters"
}

# 4. Disconnect (optional)
#Disconnect-ExchangeOnline
