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

#region File manipulation
#Create a new empty directory
New-Item -Path C:\ -Name "TTL" -ItemType "directory"

#Check directory properties
Get-Item -Path "C:\TTL"

#Create a couple files for example
New-Item -Path "C:\TTL\" -Name "TTL.csv"

New-Item -Path "C:\TTL\" -Name "TTL2.csv"

New-Item -Path "C:\TTL\" -Name "TTL3.csv"

New-Item -Path "C:\TTL\" -Name "TTL.txt"

New-Item -Path "C:\TTL\" -Name "TTL.docx"

New-Item -Path "C:\TTL\" -Name "TTL.xlsx"

#Check items in our directory
Get-ChildItem -Path "C:\TTL"

#Get only csv files in our directory
Get-ChildItem -Path "C:\TTL" -Filter "*.csv"

#Create second directory
New-Item -Path "C:\" -Name "TTL2" -ItemType "directory"

#Get all csv files in first directory and move them to the second directory
Get-ChildItem -Path "C:\TTL" -Filter "*.csv" | Move-Item -Destination "C:\TTL2\"

#Check first directory
Get-ChildItem -Path "C:\TTL"

#Check second directory
Get-ChildItem -Path "C:\TTL2"

#Cleanup our second directory including all files and do not prompt about removal
Remove-Item -Path "C:\TTL2" -Recurse -Confirm:$false
#endregion

#region Import/Export
#So far we've covered simple one line commands. An example of one of these commands is Get-Process
Get-Process

#Often times just viewing things in the shell output isn't the most useful way to look at the output. Another method we can use is Out-GridView
#Out-GridView pops up another window and allows for a more visual representation of the output. This also allow for filtering and sorting via clicking on the grid. 
Get-Process | Out-GridView

#Grid view is nice but often you need to store information for historical documentation or to pass information to another service
#CSV's are still a standard for getting data from one service to another. We can take the process information and export it out to a CSV
Get-Process | Export-Csv C:\TTL\processes.csv

#What is the difference between what we saw on the screen and what it output to the CSV? This CSV shows all of the information gathered by Get-Process, not just the default view
Invoke-Item C:\ttl\processes.csv

#We can actually specify that we want all of the information for each process. This is much easier to see in a list format than table
Get-Process | Format-List *

#We can also import information from CSV files. As you see, since we exported all of the properties to the CSV file, now we see all the properties when importing. 
Import-Csv C:\TTL\Processes.csv

#While viewing information in the shell is helpful we can store it in variables in which we can further manipulate. I'll come back to this in a bit
$Processes = Import-Csv C:\ttl\processes.csv

#It's not just tables that we can work with. Here's outputting text which can be very useful for logging
"Test Text" | Out-File C:\TTL\text.txt

#Check out the output
Invoke-Item C:\TTL\text.txt

#There are other conversions that can be useful such as to html
"Test Text" | ConvertTo-Html

#Conversion to json is useful for passing information to other services via API
$Processes | ConvertTo-Json
#endregion

#region More commands
#You've seen what the built in commands can do and how to search them. There are many other available Powershell commands that are not loaded by default. 
#You can extend the Powershell commands by importing other modules. Start by viewing what modules are loaded by default
Get-Module

#RSAT tools must be installed to run this (https://www.microsoft.com/en-us/download/details.aspx?id=45520)
#If you have the RSAT tools on your laptop already you can run the following Import-Module. This loads AD related commands into your shell
#In fact, this is what happens when you launch the AD Powershell on a Domain Controller. It loads a standard shell and then imports the AD commands
#This is very similar to how Exchange, Lync, DPM, etc shells function
Import-Module ActiveDirectory

#You can then run this again to see the additional modules
Get-Module

#You can get what commands are added after importing the module and search them as we saw earlier
Get-Command -Module activedirectory

#Modules are not limited to programs that you installed already. The Powershell Gallery has a large amount of modules available to install with over 4000 packages available
#You can search and find documentation on them on the website
Start-Process -FilePath "https://www.powershellgallery.com/"

#For example, Vmware PowerCLI
Start-Process -FilePath "https://www.powershellgallery.com/packages/VMware.PowerCLI/11.2.0.12780525"

#Installation can all be accomplished in Powershell with the modules being downloaded. This one takes a little time as there are a lot of commands included
Install-Module VMware.PowerCLI

#Once the module is downloaded it can be called in any script. To do so, just use Import-Module 
Import-Module VMware.PowerCLI

#Check out all the commands added. Vmware breaks theirs out into a bunch of modules so we'll search across all
Get-Command -Module *vmware*

#WinSCP is another common module. This allows for easy and scheduled uploads
Install-Module WinSCP

#Modules can be constantly updated. Use this to download and install the latest version of the module
Update-Module WinSCP

#endregion

#region Objects
#Powershell is an object-oriented language. This means that when we get the output of a command it is nicely structured and can be worked with.
#Contrast this to bash where the output is text that can be manipulated. We don't have to look for patterns or worked but can simply use properties of the object
#Out-GridView provides a nice way to visualize what the properties look like. Run this and look at the column names. These are all attributes of the object
Get-Process | Out-GridView

#To make things easier we'll save the output of Get-Process to a variable. It's less typing and will demonstrate how you can work with objects in different ways
$Processes = Get-Process

#Here we can see what calling a property does. We're using Get-Process like we did before, but specifying to only return the Name property. Run this and see how only the name are returned
Get-Process | Select-Object Name

#Alternately, we can use our variable to demonstrate this as well. We've captured all the output of Get-Process into the variable so that the variable is the exact
#output we would have gotten. We can see that $Processes is the object and we're calling a property of that object and only returning that property.
$Processes.Name

#The nice thing about being able to work with the properties of an object is that we can quickly get what we want without any strange statements.
#Here we want to only pull back information on any instances of notepad that are running. We can use the -Name parameter and supply the name we are looking for
Get-Process -Name notepad

#The power to this is that when we receive the output it remains an object. We can use that object and also pass it to other commands. 
#Here we pass it to Stop-Process. We've used Get-Process to narrow down only the processes that we're looking for. This can work also if we have multiple instances
#of notepad running
Get-Process -Name notepad | Stop-Process

#So how do you know what you can do with an object? We can use Get-Member to examine the object and see what is available
#There are a few important things to notice. First, aliases function just like command aliases do. We can see that using the name property is really an alias for ProcessName
#Methods are actions that we can perform. For example, if we had a single process in the object we could use the .kill() method. I wouldn't recommend trying that on 
#an object with all your process though!
#Properties are what we have mostly been talking about. We can see that there are many properties to each process. We can call those by name to select like we did earlier
#Or we can sort or filter based on those properties
$Processes | Get-Member

#If we're being correct, we would use the ProcessName property rather than the Name alias. Does this matter? Not really. But in the interest of teaching and 
#especially in scripts it is better to use the full name or property for something. These are often more clear when you are reading what you wrote later,
#or if someone else is reading it.
$processes.ProcessName

#Knowing that we can sort on properties we can go ahead and test that using ProcessName
$processes | Sort-Object -Property ProcessName

#We can choose which way it sorts. This sorts from lowest to highest
$processes | Sort-Object -Property CPU

#Reversing that we get highest to lowest
$processes | Sort-Object -Property CPU -Descending

#As objects go down the pipeline we refine down to what we want. Each command that we pass into does its action and leaves a different output than what we passed to it
#Lets examine $processes again and see how many attributes there are
$processes | Get-Member

#Perhaps we only want to get the Name, ID and CPU from the process because the rest of the information is not important. We can run that and only obtain the 
#results that we're looking for. 
$Processes | Select-Object Name, ID, CPU

#When we look at the Get-Member results we can see that attributes are narrowed down compared to the original attribute list
$Processes | Select-Object Name, ID, CPU | Get-Member

#A logical next ste would be to pass those values out to a file to store or send to someone requesting that information
$Processes | Select-Object Name, ID, CPU | Out-File C:\TTL\processnames.txt

#When we look at what is left in the pipeline after Out-File we see that there is no object passed on. The object has been fully used and nothing is passed along
#This is common for when files are exported. It gives a good look at what happens to the object as it passes along the pipeline
$Processes | Select-Object Name, ID, CPU | Out-File C:\TTL\processnames.txt | Get-Member
#endregion

#region Filter

#Look at the command before running it
Get-Help Get-CimInstance

#Filtering helps narrow down the information that you are looking for. Rarely would you want to pull back every single AD account whne you're only looking for a single one
#Filtering in the original command  is faster as it only pulls back what matches your filter. Here is an example of filtering on the "left" side
Get-CimInstance -class Win32_NetworkAdapterConfiguration -Filter "IpEnabled = 'True' " 

#Here is an example of filtering on the "right" side. This brings back all of the network adapters and then checks through them to find which meets our criteria. 
#Note that we get the same exact results 
Get-CimInstance -class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq 'True'}

#How can we find the differences in speed between the two. Measure-Command executes the commands and tells us how long each takes.
#In this example it's only about 20% difference. Active Directory is especially sensitive to filtering and when checking over thousands of users you can see a large difference
Write-Output "Filter Left:"
Measure-Command {Get-CimInstance -class Win32_NetworkAdapterConfiguration -Filter "IpEnabled = 'True' "}
Write-Output "Filter Right"
Measure-Command {Get-CimInstance -class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq 'True'}}

#You can filter on both sides if you want or find a scenario where this makes sense. Here we retrieved all enabled adapters then found the Intel one
Get-CimInstance -class Win32_NetworkAdapterConfiguration -Filter "IpEnabled = 'True' " | Where-Object {$_.Description -like "*Intel*" }

#Page on comparison operators https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-5.1

#endregion

#region Intermediate

#region PSRemoting
#PSRemoting is an interesting feature to Powershell where you can run commands on other computers. You saw we previously queried the event viewer on a computer using the -ComputerName parameter
#However PSRemoting actually connects to the remote computer itself and runs the commands there. This exposes other way to run commands that we can't on our local computer
#For example, we talked about having to install the RSAT tools on your computer and then importing the ActiveDirectory module. This allows us to connect to a computer
#which already has those tools installed (such as a domain controller) and run commands there. 
#Note, you will not have the ability to run these exact commands against my demo VM, but can edit them for your own.

#It's a good practice to specify credentials you are connecting to with. PSRemoting does not require you to run Powershell as admin. Likely your standard account doesn't have 
#administrative permissions to your domain so you can specify your admin account here
$credential = Get-Credential

#Here we specify what we're connecting to. Note that the Powershell prompt changes. You can no see that you're no longer running commands against your local machine but against the remote computer
#The computer name will be surrounded by brackets such as [TTL1.hq.iu13.local]:
Enter-PSSession -ComputerName TTL1.hq.iu13.local -Credential $credential

#Earlier we saw that you could run Get-EventLog System -ComputerName TTL1.hq.iu13.local. Now we can see that connecting to the remote computer does the same thing
Get-EventLog System -Newest 10

#Connecting remotely gives you access to all modules on the remote computer
Get-Module

#We can query the features and roles of the remote computer. This is also a quick way to reference the role name if you need to install or uninstall it.
Get-WindowsFeature

#Since my demo vm doesn't have the DNS role installed we will look at installing it. Check out the Name as that is what will be used to install the role, not the Display Name
#Also important is installing the RSAT tool associated with the role. Otherwise the role will exist on the server but not the management tools
Get-WindowsFeature *DNS*

#Now that you know the name of the DNS role it can be installed. We will use -IncludeManagement tools so that installs the RSAT tools along with the role
#Another switch that we could use is -IncludeAllSubFeature. That will include the RSAT tools since they are a sub feature. However, this isn't recommended for all roles
#Consider IIS which has a large list of sub features and which you would not want to install all.
#This also shows one of my favorite switches: Verbose. If you run the command without the -Verbose switch it will let you know when the installation is complete
#With -Verbose specified you will see additional information prepended with VERBOSE: about the status of the command
Install-WindowsFeature -Name DNS -IncludeManagementTools -Verbose 

#Check to see whether the feature completed
Get-WindowsFeature *DNS*

#Now you can see the commands that are available for DNS management. You can manage DNS now without installing RSAT tools on your local computer
Get-Command *DNS*

#Important, exit your PSRemoting session when you are done!
Exit-PSSession

#endregion


#region Simple scripting
#Powershell doesn't have to be about just single line commands. You can create a quick command to start something or string a long single line command together 
#to accomplish something. Other situations will require more complex code. This is where variables come in handy.
#For this example we'll see how you can have multiple values stored in a single variable. 
#First, let's export some information on services and we can see how importing information into a variable works for a script
Get-Service "BITS","BranchCache","ibtsiva" | Export-Csv c:\ttl\services.csv -NoTypeInformation

#Similar to how we queried running processes earlier, we can check Windows services as well.
$services = Import-Csv C:\ttl\services.csv

#We can see that the services show what the status is, service name, and a description of the service. 
$services

#So what happens if we need to run a command against individual services? As an example here we can see that we can go through a service at a time and list the names
#This is very inefficient, as we saw earlier we could run $services.Name but this is an example
#What you see here is a loop. We're looping through all the values in $services. This will start with $services[0] which is the first value and assign that value to $service
#Then it will move to $services[1] and assign that value to $service. When it runs out of values in $services it will stop.
#This allows us to use the variable $service within the loop and it only affects the single service at a time
Foreach ($Service in $services){

    Write-Output $Service.Name

}

#Here we can refine our loop a little bit more. We print out that this will be a list of manual services. Then we loop through every service and see if it is a manual startup
#If it is set for manual startup then we print the service name
Write-Output "Manual services:"

Foreach ($Service in $services){


    If ($Service.StartType -eq "Manual")
        {
   
         $Service.Name

        }

}

#Lets refine this a bit more. Not only do we want the automatic services listed, but we also want to find out which ones are not running. This could be a realistic scenario
#since usually you want automatic services to be running. 
Write-Output "Automatic services not started:"

Foreach ($Service in $services){


    If (($Service.StartType -eq "Automatic") -and ($service.Status -eq "Stopped"))
        {
   
         $Service.Name

        }

}


#We can use this to fix services which are not running. We loop through all of our automatic services which are not running and attempt to start them
#This is not always successful, but that's more of a function of that service having an issue than the powershell command not working as expected.
Foreach ($Service in $services){


    If (($Service.StartType -eq "Automatic") -and ($service.Status -eq "Stopped"))
        {
   
         Start-Service -Name $Service.Name

        }

}

#You can't run this, but here's a realistic example of a simple loop. This pulls back all students in a single OU and changes their User Principal name to a new value
$students = get-aduser -SearchBase "OU=Students,OU=Example,DC=Contoso,DC=com" -filter * 

Foreach ($student in $students){

    $newupn = $student.samaccountname + "@newcontoso.com"

    Set-ADUser -Identity $student.SamAccountName -UserPrincipalName $newupn
}

#endregion

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

