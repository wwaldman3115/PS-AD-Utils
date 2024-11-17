function Export-UsersInOU {
    param (
        [string]$OU,          # Distinguished Name of the Organizational Unit (OU)
        [string]$ExportPath   # Path to save the CSV file
    )

    # Import Active Directory module (if not already imported)
    Import-Module ActiveDirectory

    # Check if the OU exists and is a valid Distinguished Name
    if (-not (Get-ADOrganizationalUnit -Filter { DistinguishedName -eq $OU })) {
        Write-Host "The specified OU does not exist or is invalid." -ForegroundColor Red
        return
    }

    # Get all user objects in the specified OU
    $users = Get-ADUser -Filter * -SearchBase $OU -Properties *

    # Check if there are users to export
    if ($users.Count -eq 0) {
        Write-Host "No users found in the specified OU." -ForegroundColor Yellow
        return
    }

    # Select properties to export (you can modify this list based on what information you need)
    $userData = $users | Select-Object SamAccountName, Name, GivenName, Surname, DisplayName, EmailAddress, Enabled, LastLogonDate

    # Export the data to CSV
    try {
        $userData | Export-Csv -Path $ExportPath -NoTypeInformation
        Write-Host "Users exported successfully to $ExportPath." -ForegroundColor Green
    }
    catch {
        Write-Host "An error occurred while exporting the users: $_" -ForegroundColor Red
    }
}

# Example of how to call the function:
# Export-UsersInOU -OU "OU=Employees,DC=example,DC=com" -ExportPath "C:\path\to\export\users.csv"
