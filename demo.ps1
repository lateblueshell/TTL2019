Return "This is a demo script, please don't just run me"

#region Beginner

#region Getting started
#Launch as Admin

#Set Execution Policy 
#The default execution policy for Powershell is Restricted. This will permit individual commands to be run but not scripts. This includes configuration files, modules, and profiles. 
#Windows Servers default to RemoteSigned. This allows scripts to run but requires a digital signature when downloaded from teh internet. Scripts can be unblocked using Unblock-File
#For testing set the ExecutionPolicy to Unrestricted.
Set-ExecutionPolicy -ExecutionPolicy $unrestricted

#A good first step is to update the help file. Powershell ships with a bare skeleton of help and will refer to downloading the rest of the files. This may take some time
#Updating help is a command that requires administrative access. 
Update-Help

#endregion

#region Help
#Now that we have updated help files it's a good time to find out what the help files do. This gives an overview on how to use help files
Get-Help

#Get-Help needs a command to show the information about that command. For example we can look at the information on the Update-Help command we ran earlier
Get-Help Update-Help 

#Update help is a cool command but lets look at a real life command that you can use. Get-Command is a command that you can use to find Powershell commands. In this case we will find command associated with Windows Event Logs
Get-Command *eventlog*

#Note the command names returned. These follow the Verb-Noun structure which make them fairly easy to read and understand. Get-, Clear-, New-, Remove- are all actions that you recognize.
#Most commands follow this structure, even third party modules. 

#Get-EventLog is an easily acccessible command. Look up the help files for Get-EventLog. Note that these give two different sets of Syntax that can be used. This shows the types of input that
#can be accepted. Each of these are parameters that can be added to the command which we will cover in a bit. It also gives a description and links to the online version. 
Get-Help Get-EventLog

#We can add the -Examples parameter to Get-Help to get examples of how to use the Get-EventLog command
Get-Help Get-EventLog -Examples

#The -Full parameter provides additional detail to the parameters and examples section. This is very similar to the help that you see online. 
Get-Help Get-EventLog -Full

#The -Online parameter pulls up the online help for the Get-EventLog command. I'll be honest, while I use the command line help often, I do find the online version easier to read sometimes
Get-Help Get-EventLog -Online
#endregion

#region Understanding commands
#We can see from the help file that -List is a parameter of Get-EventLog. According to the Full help file it "Indicates that this cmdlet gets a list of event logs on the computer." Lets see what event logs are available
Get-EventLog -List

#According to the list we should be able to pull back System logs. Be careful though, if you run this it will bring back all System logs. That is quite a few. 
#If you run this and tire of waiting you can use Ctrl+C to cancel the operation
Get-EventLog System

#Instead, we can use parameters to cut down on the amount of information we're receiving. This grabs only the 10 most recent events in the System log
Get-EventLog System -Newest 10

#I find using the -EntryType parameter useful. Often when I'm searching the event logs I only want Errors or Warnings
Get-EventLog System -Newest 10 -EntryType Error

#We can actually search for both of those because the -EntryType parameter accepts multiple parameters
Get-EventLog System -Newest 10 -EntryType Error,Warning

#While the standard output for Get-EventLog is in table format, it may be easier to read all of the information if it is in list form. If we pipe the command into Format-List this will
#present the information differently. Note that the information is now in rows and grouped by entries. Each entry will have its own set of rows.
Get-EventLog System -Newest 1 -EntryType Error | Format-List

#We can can also use parameters to specify another computer to connect to and read logs from. Note this will work for me, not for you
Get-EventLog System -Newest 10 -EntryType Error -ComputerName "TTL1.hq.iu13.local"

#We can use this output and format it as a list as well.
Get-EventLog System -Newest 10 -EntryType Error -ComputerName "TTL1.hq.iu13.local" | Format-List

#endregion


#endregion

#region Intermediate

#endregion

#region Advanced

#region PSDirect
$domaincred = Get-Credential

Enter-PSSession -ComputerName "IUHQSHPV003.hq.iu13.local" -Credential $domaincred

$servername = "TTL1"
$setip = {
    #Operations performed in the console so that remote computer can connect
    $ipaddress = "10.14.14.251"
    $defaultgateway = "10.14.14.1"
    $DNS = "10.14.14.2,10.14.14.3"
    
    Get-NetIPConfiguration | New-NetIPAddress -IPAddress $ipaddress -PrefixLength 24 -DefaultGateway $defaultgateway
    
    Get-NetIPConfiguration | Set-DnsClientServerAddress -ServerAddresses ($DNS)
    }

$credential = Get-Credential 
Invoke-Command -VMName $servername -ScriptBlock $setip -Credential $credential

$rename = {
    $ServerName = "TTL1"

    Rename-Computer -NewName $ServerName -Restart
}

Invoke-Command -VMName $servername -ScriptBlock $rename -Credential $credential

$bind = {
 
    $domainname = "hq.iu13.local"

    Add-Computer -DomainName $DomainName -Restart
}

Invoke-Command -VMName $servername -ScriptBlock $bind -Credential $credential

Exit-PSSession


#endregion

