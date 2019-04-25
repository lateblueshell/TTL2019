Function Get-ServiceStatus {

    Param(
        [Parameter(Mandatory=$true)]
        [string] $servicename,
        [string] $computername = $env:COMPUTERNAME,
        [Parameter(Mandatory=$true)]
        [string] $log
    )

    $service = Get-Service $servicename -ComputerName $computername
    $name = $service.Name

    If ($service.status -eq "Running") {
                
        Write-Output "The service $name is running" | Out-File $log -Append 
    }
                
    Else {
                
        If ($service.StartType -eq "Automatic"){
        
            Write-Output "The service $name is not running and should be. Starting service" | Out-File $log -Append 
        
            Try {
                        
                Start-Service -Name $service.Name -ErrorAction Stop
                        
            }
        
            Catch{
        
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.GetType().FullName  
                $LogEntry = "Unable to start service: " -f $FailedItem, $ErrorMessage
                Out-File $LogEntry -Append 
        
            }
        
        }
    
        Else{
                    
            Write-Output "The service $name is not running" | Out-File $log -Append 
        }

    
    }

}