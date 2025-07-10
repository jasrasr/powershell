# '$onedrivepath\Downloads\GRC_SN_Files\Transcriptions'

function Get-TagsFromText {
    param (
        [string]$text
    )

    $tags = @()

    # Define tag keywords as hashtable (category = keywords)
    $tagKeywords = @{
        "rsa"          = @("rsa", "quantum", "cryptography", "encryption", "public key", "private key")
        "extortion"    = @("extortion", "npd", "breach", "scam", "terror", "blackmail", "bitcoin")
        "fido"         = @("fido", "credential exchange", "cxp", "passkey", "webauthn")
        "microsoft"    = @("microsoft", "azure", "logs", "security logs", "honeypot", "phishing")
        "eu-policy"    = @("eu", "liability", "software", "directive", "product law", "compliance")
        "dji"          = @("dji", "drones", "china", "ban", "dod", "lawsuit")
        "deepfake"     = @("deepfake", "persona", "ai", "military", "sockpuppet", "disinformation")
        "security"     = @("cybersecurity", "infosec", "vulnerabilities", "risk", "exploit")
        "ai"           = @("ai", "chatgpt", "openai", "language model", "machine learning")
        "email-scams"  = @("pdf scam", "phishing", "email threat", "spoofing", "pig butchering")
    }

    foreach ($tag in $tagKeywords.Keys) {
        foreach ($keyword in $tagKeywords[$tag]) {
            if ($text -match [regex]::Escape($keyword)) {
                $tags += $tag
                break
            }
        }
    }

    return ($tags | Sort-Object -Unique)
}
