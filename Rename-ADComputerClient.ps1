# CONFIG BLOCK
$config = @{
    TriggerPolicyGUIDs = @(
        '{00000000-0000-0000-0000-000000000001}',
        # Machine Policy Retrieval
        '{00000000-0000-0000-0000-000000000002}',
        # Machine Policy Evaluation
        '{00000000-0000-0000-0000-000000000003}' # Hardware Inventory
    )
    CCMExecPath = "$env:ProgramFiles\CCM\ccmexec.exe" # Default SCCM client executable
    RestartDelaySeconds = 10
}

param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,15)]
    [ValidatePattern('^[A-Za-z0-9-]+$')]
    [string]$NewComputerName
)

function Rename-ComputerClient {
    try {
        Write-Host "Renaming computer to '$NewComputerName'..."
        Rename-Computer -NewName $NewComputerName -Force -ErrorAction Stop
    } catch {
        Write-Error "Failed to rename computer: $_"
        return
    }

    # restart SCCM client
    try {
        & $using:config.CCMExecPath /restart
    } catch {
        Write-Error "Failed to restart SCCM client: $_"
    }

    # Trigger policies
    foreach ($guid in $config.TriggerPolicyGUIDs) {
        try {
            Invoke-WmiMethod -Namespace 'root\ccm' -Class 'SMS_Client' -Name 'TriggerSchedule' -ArgumentList $guid -ErrorAction Stop
        } catch {
            Write-Error "Failed to trigger schedule $guid: $_"
        }
    }

    Start-Sleep -Seconds $config.RestartDelaySeconds

  
# Call the function with the provided new computer name
Rename-ComputerClient
  Restart-Computer -Force
}

# Call the function with the provided new computer name
Rename-ComputerClient
