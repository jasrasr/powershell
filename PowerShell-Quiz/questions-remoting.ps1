<#
  File     : questions-remoting.ps1
  Revision : 1.0
  Purpose  : PowerShell Remoting specialty set for Quiz-Engine.ps1
  Usage    : . "$PSScriptRoot\questions-remoting.ps1"
#>

$Questions = @(
    @{ Q = "What does Enable-PSRemoting -Force primarily do on the local machine?"
       A = @("Configures WinRM service/listeners and opens firewall rules for WSMan remoting",
             "Installs OpenSSH server and sets an sshd_config",
             "Creates a persistent PSSession to localhost",
             "Enables Remote Desktop (RDP) on TCP 3389") },

    @{ Q = "By default, classic WSMan remoting (Enter-PSSession -ComputerName) uses which port?"
       A = @("5985 (HTTP)", "5986 (HTTPS)", "22 (SSH)", "3389 (RDP)") },

    @{ Q = "When is TrustedHosts typically required?"
       A = @("To allow Kerberos constrained delegation",
             "To allow WSMan connections to non-domain/untrusted hosts when Kerberos isn’t available",
             "To allow WinRM over HTTPS in a domain",
             "To allow CredSSP double-hop in a domain") },

    @{ Q = "Invoke-Command -FilePath .\\DoThing.ps1 -ComputerName S1,S2 does what?"
       A = @("Uploads the file to S1,S2 but executes it locally",
             "Copies local variables to remote session and pauses",
             "Sends the local script file’s contents to the remote machines and executes there",
             "Requires the script to already exist on the remote path") },

    @{ Q = "Copy-Item -ToSession $s -Path .\\data.txt -Destination C:\\Temp requires what first?"
       A = @("An established PSSession object from New-PSSession",
             "Enable-PSRemoting run on the client only",
             "A shared folder mapping to C:\\Temp",
             "Enter-PSSession to the target with -UseSSL") },

    @{ Q = "What problem is CredSSP designed to solve in remoting scenarios?"
       A = @("Firewall traversal for WSMan",
             "The 'second hop' (delegating credentials from the remote to a third resource)",
             "FIPS-compliant TLS cipher enforcement",
             "Copying files over RDP") },

    @{ Q = "In PowerShell 7+, which command uses SSH-based remoting?"
       A = @("Enter-PSSession -ComputerName server01 -UseSSH",
             "Enter-PSSession -HostName server01 -User admin",
             "New-PSSession -ComputerName server01 -Transport SSH -User admin",
             "Invoke-Command -ComputerName server01 -Port 22") },

    @{ Q = "Which cmdlet lists current persistent remoting sessions?"
       A = @("Get-PSSession", "Get-PSRemoting", "Get-WSManInstance", "Get-ComputerInfo") },

    @{ Q = "What does Invoke-Command’s -ThrottleLimit actually control?"
       A = @("The maximum number of pipelines per remote computer",
             "The maximum number of open PSSessions you can create on one host",
             "The maximum number of concurrent remote commands across the target list",
             "The maximum number of retries on transient failure") },

    @{ Q = "On a domain-joined client using -ComputerName with WSMan, what’s the default authentication?"
       A = @("Kerberos", "NTLM", "Basic", "Digest") }
)

# XOR key and obfuscated correct answers (no plaintext comments)
$AnswerKeyXor = 0x5A
# Answer string (10): A A B C A B B B C A
# Mapping with XOR 0x5A -> A=27, B=24, C=25, D=30
[byte[]] $ObfuscatedAnswers = [byte[]]@( 27, 27, 24, 25, 27, 24, 24, 24, 25, 27 )