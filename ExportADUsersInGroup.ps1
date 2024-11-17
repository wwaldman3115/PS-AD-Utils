# File Path: Export-GroupUsersToCSV.ps1

# Import Active Directory module
Import-Module ActiveDirectory

# Function to export group members to a CSV
function Export-GroupMembers {
    param (
        [Parameter(Mandatory = $true)]
        [string]$GroupName,

        [Parameter(Mandatory = $true)]
        [string]$OutputFilePath
    )

    try {
        # Get the group members
        $members = Get-ADGroupMember -Identity $GroupName -Recursive | Where-Object { $_.objectClass -eq 'user' }

        # Create an array of user details
        $userDetails = foreach ($member in $members) {
            Get-ADUser -Identity $member.DistinguishedName -Properties DisplayName, EmailAddress, SamAccountName | Select-Object DisplayName, EmailAddress, SamAccountName
        }

        # Export to CSV
        $userDetails | Export-Csv -Path $OutputFilePath -NoTypeInformation -Encoding UTF8

        Write-Host "Export completed successfully. File saved to $OutputFilePath" -ForegroundColor Green
    } catch {
        Write-Error "An error occurred: $_"
    }
}

# Example usage
# Change the group name and output file path as needed
$GroupName = "GroupNameHere"  # Replace with your group name
$OutputFilePath = "GroupUsers.csv"  # Replace with your desired file path

Export-GroupMembers -GroupName $GroupName -OutputFilePath $OutputFilePath