# Prompt user for the group name
$groupName = Read-Host "Enter the Active Directory group name"

# Import the Active Directory module (if it's not already imported)
Import-Module ActiveDirectory

# Get all members of the specified group
$groupMembers = Get-ADGroupMember -Identity $groupName

# Check if the group has members
if ($groupMembers.Count -gt 0) {
    # Loop through each member and remove them from the group
    foreach ($member in $groupMembers) {
        try {
            # Attempt to remove the user/member from the group
            Remove-ADGroupMember -Identity $groupName -Members $member -Confirm:$false
            Write-Host "Removed $($member.SamAccountName) from group $groupName."
        }
        catch {
            Write-Host "Failed to remove $($member.SamAccountName): $_"
        }
    }
} else {
    Write-Host "The group '$groupName' has no members."
}