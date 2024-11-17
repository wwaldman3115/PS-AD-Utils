# Function to convert an Organizational Unit (OU) to a Common Name (CN)
function Convert-OUToCN {
    param (
        [string]$OU               # Distinguished Name (DN) of the Organizational Unit (OU)
    )

    # Ensure that the OU is in Distinguished Name format
    if ($OU -match '^OU=.*') {
        try {
            # Extract CN (common name) from the OU Distinguished Name
            $CN = $OU.Split(',')[0] -replace '^OU=', ''
            return $CN
        }
        catch {
            Write-Host "Error while converting OU to CN: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "The input does not appear to be a valid OU Distinguished Name." -ForegroundColor Red
    }
}

# Function to convert a Common Name (CN) to an Organizational Unit (OU)
function Convert-CNToOU {
    param (
        [string]$CN               # Common Name (CN) to be converted
        [string]$DomainDN         # The domain's Distinguished Name (DN)
    )

    # Check if CN and DomainDN are provided
    if (-not $CN -or -not $DomainDN) {
        Write-Host "Both CN and DomainDN must be provided." -ForegroundColor Red
        return
    }

    try {
        # Construct the OU Distinguished Name (DN) from CN and domain DN
        $OU = "OU=$CN," + $DomainDN
        return $OU
    }
    catch {
        Write-Host "Error while converting CN to OU: $_" -ForegroundColor Red
    }
}

# Example usage:
# Convert-OUToCN -OU "OU=Sales,DC=example,DC=com"
# Convert-CNToOU -CN "Sales" -DomainDN "DC=example,DC=com"
