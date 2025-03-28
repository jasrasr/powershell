# 1. Import the Exchange Online PowerShell module and connect
#Import-Module ExchangeOnlineManagement
#Connect-ExchangeOnline -UserPrincipalName 'jason.lamb@middough.com'

# 2. Define the array of conference/mailbox email addresses
$CalendarMailboxes = @(
    "CLE-ConferenceA1@Middough.com",
    "CLE-ConferenceA2@Middough.com",
    "CLE-Conferenceb1@Middough.com",
    "CLE-Conferenceb2@Middough.com",
    "CLE-Conferencec1@Middough.com",
    "CLE-Conferencec2@Middough.com",
    "CLE-Conferenced1@Middough.com",
    "CLE-Conferenced2@Middough.com",
    "CLE-Conferencedevelopmentcenter@Middough.com",
    "CLE-Conferenceboardroom@Middough.com",
    "CLE-Conferencemain@Middough.com",
    "CLE-insta360-camera@Middough.com"
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
    #Set-Mailbox -Identity $Mailbox -Office "Cleveland Headquarters"
}

# 4. Disconnect (optional)
#Disconnect-ExchangeOnline
