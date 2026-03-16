# Revision # 1
# Description : Retrieves a list of interactive user sessions (quser output) from the specified remote server.
# Author      : Jason Lamb (help from ChatGPT 4o)
# Date        : 2025-06-02

$server = 'RemoteServerName'
Invoke-Command -ComputerName $server -ScriptBlock {
    quser
}
