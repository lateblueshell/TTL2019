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
#Most commands follow this structure, even third party modules. You can check and see the full list of "approved" verbs by running Get-Verb. Nothing forces people to use those verbs. 

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

#region Aliases
#Aliases can be used to shorten the name of common commands. You can find if there is an alias using Get-Alias
Get-Alias -Definition "Get-Member"

#You can reverse this if you find an alias in a script online. Use Get-Help and it will show you the actual command behind the alias
Get-Help gm

#There are aliases for other commands that you wouldn't expect. Dir is a cmd command to display items in the directory. The Powershell command is Get-ChildItem
Get-Help dir

#Also unxpected aliases for Get-ChildItem from other operating systems. 
Get-Help ls

#We can see that gci is another alias as well
Get-Alias -Definition "Get-ChildItem"

#You can create aliases yourself using New-Alias but I wouldn't recommend it. The aliases are only available to you and not ported to any other computer unless you use Export-Alias. 
#Aliases are discouraged in scripts. They are easy to type when you're just running a command, but a script you're likely to come back to or someone else will read it.
#In that case aliases make it harder to understand the commands. It's advised to just type out Get-ChildItem. After all, that's what tab completion is for, right?
#endregion

#region Making things easy
#Ok so you see how to find parameters using help and how to use them. That's hard to grasp at first though. Plus for some people working in a command line only can get tiring.
#Sometimes you just want to click something, right? (We are Windows admins after all). Show-Command is helpful and gives you boxes to fill out. Once you fill them out you can click Run
#Your command is then populated with all the parameters filled out. This can be useful for learning 
Show-Command Get-EventLog

#endregion

#region Errors
#Errors will happen. I run into them all the time whether I'm mistyping something or just running the wrong command. The biggest thing is learning how to read them. 
#Powershell for the most part has errors that make sense, it's just taking the time to read and understand them. 

#Bad Command. We can see that this isn't a command. Good time to use Get-Command and see if we just didn't type the right name
#The term 'Get_Service' is not recognized as the name of a cmdlet, function, script file, or operable program
Get_Service

#This can happen with parameters that need to be in certain formats. If you check Get-Date, the -Date parameter needs to be a Date/Time format. We're specifying it using a bad date and time
#You can see that Powershell attempts to convert it to the correct format. We can even feed it dates that aren't in that format ("May 1") and it will convert to date/time. However this is
#bad enough it won't work
#Cannot bind parameter 'Date'. Cannot convert value "May_1" to type "System.DateTime"
Get-Date -Date "May_1"

#Don't be scared of errors. They happen often enough especially as you are learning. Just take the time to read them and learn what they're saying. If you need to, Google them and there's often examples
#Worst case as a presenter once said, you can change the error text color to Green. It makes you feel a lot less like red ink on a test
$host.PrivateData.ErrorForegroundColor = 'Green'

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

