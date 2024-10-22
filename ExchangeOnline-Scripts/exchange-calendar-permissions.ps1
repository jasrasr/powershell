set-calendarprocessing -Identity "chi-conf-room-cr1-west@middough.com" -RemovePrivateProperty $true -AddOrganizerToSubject $true -DeleteSubject $false -DeleteComments $false
set-calendarprocessing -Identity "chi-conf-room-cr2-east@middough.com" -RemovePrivateProperty $true -AddOrganizerToSubject $true -DeleteSubject $false -DeleteComments $false
set-calendarprocessing -Identity "chi-conf-room-cr3-north@middough.com" -RemovePrivateProperty $true -AddOrganizerToSubject $true -DeleteSubject $false -DeleteComments $false
set-calendarprocessing -Identity "chi-board-room-central@middough.com" -RemovePrivateProperty $true -AddOrganizerToSubject $true -DeleteSubject $false -DeleteComments $false
 
#RemovePrivateProperty $true: This 'removed' the private flag on meetings.
#AddOrganizerToSubject $true: Adds the organizer’s name to the subject of the meeting.
#DeleteSubject $false: Keeps the subject visible.
#DeleteComments $false: 'keep' the comments from the calendar.

Set-CalendarProcessing -Identity Meetingroom -AddOrganizerToSubject $true -DeleteComments $false -DeleteSubject $false

set-calendarprocessing -Identity "chi-conf-room-cr1-west@middough.com" -RemovePrivateProperty $true -AddOrganizerToSubject $true -DeleteSubject $false -DeleteComments $false
set-calendarprocessing -Identity "chi-conf-room-cr2-east@middough.com" -RemovePrivateProperty $true -AddOrganizerToSubject $true -DeleteSubject $false -DeleteComments $false
set-calendarprocessing -Identity "chi-conf-room-cr3-north@middough.com" -RemovePrivateProperty $true -AddOrganizerToSubject $true -DeleteSubject $false -DeleteComments $false
set-calendarprocessing -Identity "chi-board-room-central@middough.com" -RemovePrivateProperty $true -AddOrganizerToSubject $true -DeleteSubject $false -DeleteComments $false

get-calendarprocessing -Identity "chi-conf-room-cr1-west@middough.com"
