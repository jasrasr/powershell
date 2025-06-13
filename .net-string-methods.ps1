# PowerShell String Methods Cheat Sheet (Flat List)
> Common string operations in PowerShell using .NET string methods.
[link text](https://learn.microsoft.com/en-us/dotnet/api/system.string)

```powershell
# Convert to upper/lower case
$string.ToUpper()                  # "abc" → "ABC"
$string.ToLower()                  # "ABC" → "abc"

# Trim whitespace
$string.Trim()                     # Removes leading/trailing spaces
$string.TrimStart()                # Removes leading spaces
$string.TrimEnd()                  # Removes trailing spaces

# Search and comparison
$string.Contains("value")          # True/False
$string.StartsWith("Power")        # True if it starts with "Power"
$string.EndsWith("Shell")          # True if it ends with "Shell"
$string.IndexOf("e")               # Returns index of first match
$string.Equals("text")             # Case-sensitive comparison
$string.Equals("text", 'OrdinalIgnoreCase') # Case-insensitive comparison

# Modify string
$string.Replace("old", "new")      # Replaces text
$string.Remove(4, 3)               # Removes 3 characters starting at index 4
$string.Insert(5, "_here_")        # Inserts "_here_" at index 5

# Substring
$string.Substring(0, 4)            # Returns first 4 characters
$string.Substring(5)              # Returns from index 5 to end

# Get string length
$string.Length                     # Number of characters

# Split and join
"one,two,three".Split(",")         # → array: "one" "two" "three"
@("one", "two") -join "|"          # → "one|two"

# File path helpers
[System.IO.Path]::GetFileName($path)        # "file.txt"
[System.IO.Path]::GetDirectoryName($path)   # "C:\folder"
[System.IO.Path]::GetExtension($path)       # ".txt"
[System.IO.Path]::ChangeExtension($path, ".bak")  # Change file extension

# Practical examples
" jason.lamb ".Trim().ToUpper()             # "JASON.LAMB"
"report-2025.pdf".Replace("2025","2026")    # "report-2026.pdf"
"one,two,three".Split(",")                  # "one","two","three"
@("x", "y", "z") -join ";"                   # "x;y;z"
