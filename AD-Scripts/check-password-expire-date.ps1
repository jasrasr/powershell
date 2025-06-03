# Import Active Directory module
Import-Module ActiveDirectory

# Define the username you want to check
$username = "[username]"

# Get the user's account details
$user = Get-ADUser -Identity $username -Properties "msDS-UserPasswordExpiryTimeComputed"

# Convert the expiration time from Windows FileTime to a readable format
$passwordExpiry = [datetime]::FromFileTime($user."msDS-UserPasswordExpiryTimeComputed")

# Output the result
Write-Host "Password Expiry Date for $username : $passwordExpiry"


###
#powershell experts

# Import Active Directory module if not already imported
Import-Module ActiveDirectory

# Replace 'username' with the actual domain username you want to check
$user = "jason.lamb"

# Get the user account and select the necessary properties
Get-ADUser -Identity $user -Properties "msDS-UserPasswordExpiryTimeComputed" | 
    Select-Object Name,@{Name="PasswordExpires";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}


    ###

    # Import Active Directory module
Import-Module ActiveDirectory

# Define the username you want to check
$username = "[username]"

# Get the user's account details
$user = Get-ADUser -Identity $username -Properties "msDS-UserPasswordExpiryTimeComputed"

# Convert the expiration time from Windows FileTime to a readable format
$passwordExpiry = [datetime]::FromFileTime($user."msDS-UserPasswordExpiryTimeComputed")

# Calculate 24 hours prior to the expiration date
$reminderDate = $passwordExpiry.AddDays(-1)

# Create an Outlook Application object
$outlook = New-Object -ComObject Outlook.Application

# Create a new appointment
$appointment = $outlook.CreateItem(1)  # 1 = olAppointmentItem

# Set appointment properties
$appointment.Subject = "Password Expiry Reminder"
$appointment.Body = "Your password will expire on $passwordExpiry. Please change it before that."
$appointment.Start = $reminderDate
$appointment.Duration = 60  # Duration in minutes
$appointment.ReminderSet = $true
$appointment.ReminderMinutesBeforeStart = 15  # Reminder 15 minutes before
$appointment.Save()

Write-Host "Calendar event created for 24 hours before the password expiry date."


###
#powershell experts

# Import Active Directory module
Import-Module ActiveDirectory

# Replace 'username' with the actual domain username you want to check
$user = "[username]"

# Get the user's password expiration date
$expirationDate = Get-ADUser -Identity $user -Properties "msDS-UserPasswordExpiryTimeComputed" | 
    Select-Object -ExpandProperty "msDS-UserPasswordExpiryTimeComputed" | 
    ForEach-Object { [datetime]::FromFileTime($_) }

# Check if expiration date exists
if ($expirationDate) {
    # Subtract 24 hours from the expiration date
    $eventDate = $expirationDate.AddDays(-1)

    # Load Outlook COM object
    $outlook = New-Object -ComObject Outlook.Application
    $namespace = $outlook.GetNamespace("MAPI")
    $calendarFolder = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderCalendar)

    # Create a new appointment
    $appointment = $outlook.CreateItem([Microsoft.Office.Interop.Outlook.OlItemType]::olAppointmentItem)

    # Set the appointment properties
    $appointment.Subject = "Password Expiration Reminder for $user"
    $appointment.Start = $eventDate
    $appointment.Duration = 60  # 1 hour duration
    $appointment.Body = "Reminder: The password for the user '$user' will expire on $expirationDate. Please change your password before the expiration."
    $appointment.ReminderMinutesBeforeStart = 60  # Reminder 60 minutes before the event
    $appointment.BusyStatus = [Microsoft.Office.Interop.Outlook.OlBusyStatus]::olFree
    $appointment.Save()

    Write-Output "Calendar event created for 24 hours before the password expiration date: $eventDate"
} else {
    Write-Output "Password expiration date not found for user $user."
}
