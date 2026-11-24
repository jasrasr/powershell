$newKey = (Read-Host 'Paste your newly generated OpenAI API key' -MaskInput).Trim()
if (-not $newKey) { throw 'No API key was entered.' }

[pscustomobject]@{
    CurrentSessionMatches = $env:GIT_UPDATE_OPENAI_API_KEY -ceq $newKey
    SavedUserKeyMatches   = [Environment]::GetEnvironmentVariable('GIT_UPDATE_OPENAI_API_KEY', 'User') -ceq $newKey
}

[Environment]::SetEnvironmentVariable('GIT_UPDATE_OPENAI_API_KEY', $newKey, 'User')
$env:GIT_UPDATE_OPENAI_API_KEY = $newKey
Remove-Variable newKey