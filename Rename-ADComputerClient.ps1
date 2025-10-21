# CONFIG BLOCK
$config = @{
    TriggerPolicyGUIDs = @(
        "{00000000-0000-0000-0000-000000000001}", # Machine Policy Retrieval
        "{00000000-0000-0000-0000-000000000002}", # Machine Policy Evaluation
        "{00000000-0000-0000-0000-000000000003}"  # Hardware Inventory
    )
    CCMExecPath = "$env:ProgramFiles\CCM\ccmexec.exe" # Default SCCM client executable
    RestartDelaySeconds = 10
}

param (
    [string]$NewComputerName
)

function Rename-ComputerClient {
    Rename-Computer -NewName $NewComputerName -Force

    Invoke-Command -ScriptBlock {
        & $using:config.CCMExecPath /restart
        Start-Sleep -Seconds $using:config.RestartDelaySeconds

        foreach ($guid in $using:config.TriggerPolicyGUIDs) {
            Invoke-WmiMethod -Namespace "root\ccm" -Class SMS_Client -Name TriggerSchedule -ArgumentList $guid
        }
    }

    Restart-Computer -Force
}

Rename-ComputerClient
