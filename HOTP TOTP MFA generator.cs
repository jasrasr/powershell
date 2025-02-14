Install-Package OATH.Net

# Import required namespace
Add-Type -TypeDefinition @"
using System;
using System.Security.Cryptography;
using System.Text;

public class OTPGenerator
{
    private static int DIGITS = 6; // Length of OTP
    private static int TIME_STEP = 30; // TOTP time step (default 30 seconds)

    public static string GenerateHOTP(string base32Secret, long counter)
    {
        byte[] key = Base32Decode(base32Secret);
        byte[] counterBytes = BitConverter.GetBytes(counter);
        if (BitConverter.IsLittleEndian)
        {
            Array.Reverse(counterBytes);
        }

        using (HMACSHA1 hmac = new HMACSHA1(key))
        {
            byte[] hash = hmac.ComputeHash(counterBytes);
            int offset = hash[hash.Length - 1] & 0x0F;
            int binaryCode = ((hash[offset] & 0x7F) << 24) |
                             ((hash[offset + 1] & 0xFF) << 16) |
                             ((hash[offset + 2] & 0xFF) << 8) |
                             (hash[offset + 3] & 0xFF);
            int otp = binaryCode % (int)Math.Pow(10, DIGITS);
            return otp.ToString(new string('0', DIGITS));
        }
    }

    public static string GenerateTOTP(string base32Secret)
    {
        long counter = DateTimeOffset.UtcNow.ToUnixTimeSeconds() / TIME_STEP;
        return GenerateHOTP(base32Secret, counter);
    }

    private static byte[] Base32Decode(string input)
    {
        const string base32Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
        input = input.TrimEnd('=').ToUpper();
        byte[] outputBytes = new byte[input.Length * 5 / 8];
        int bitBuffer = 0, bitCount = 0, index = 0;

        foreach (char c in input)
        {
            int value = base32Chars.IndexOf(c);
            if (value < 0) throw new ArgumentException("Invalid Base32 character.");
            bitBuffer = (bitBuffer << 5) | value;
            bitCount += 5;
            if (bitCount >= 8)
            {
                outputBytes[index++] = (byte)(bitBuffer >> (bitCount - 8));
                bitCount -= 8;
            }
        }
        return outputBytes;
    }
}
"@ -Language CSharp

# Secret key in Base32 format (e.g., from a QR code setup)
$base32Secret = "JBSWY3DPEHPK3PXP"  # Replace with your actual secret

# Generate HOTP (using counter)
$counter = 1  # Replace with your counter value
$hotp : [OTPGenerator]::GenerateHOTP($base32Secret, $counter)
Write-Output "HOTP : $hotp"

# Generate TOTP (time-based)
$totp : [OTPGenerator]::GenerateTOTP($base32Secret)
Write-Output "TOTP : $totp"
