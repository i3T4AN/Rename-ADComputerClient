# Rename-ADComputerClient.ps1

PowerShell script for renaming a Windows computer and refreshing its SCCM (Configuration Manager) client policies before performing an automatic restart. The script uses a configurable environment block for timing and executable paths, making it adaptable to enterprise deployments.

## Features

* Renames the local machine with the specified hostname.
* Restarts the SCCM client service to refresh its console record.
* Triggers policy retrieval, evaluation, and hardware inventory updates.
* Configurable restart delay and SCCM client executable path.

## Configuration

Edit the `$config` block to match your environment:

```powershell
$config = @{
    TriggerPolicyGUIDs = @(
        "{00000000-0000-0000-0000-000000000001}", # Machine Policy Retrieval
        "{00000000-0000-0000-0000-000000000002}", # Machine Policy Evaluation
        "{00000000-0000-0000-0000-000000000003}"  # Hardware Inventory
    )
    CCMExecPath = "$env:ProgramFiles\CCM\ccmexec.exe" # SCCM client executable
    RestartDelaySeconds = 10
}
```

## Usage

```powershell
.\Rename-ADComputerClient.ps1 -NewComputerName "NewPC-123"
```

The script renames the computer, restarts the SCCM client, triggers relevant policy updates, and performs a system reboot.

## Requirements

* Windows PowerShell 5.1 or newer
* SCCM client installed and functional on the system
* Administrator privileges

## License

MIT License
