Return "This is a demo script, please don't just run me"

#region Beginner

#region Getting started
<# Pick an environment. Built into Windows is two options, the Powershell shell prompt and the Powershell ISE. The shell prompt works well for running
single lines or a few lines of code. This runs into limitations when you want to write a script. Technically you can write a Powershell script in whatever
text editor you want from Notepad on up (Notepad++ provides colors to mark between commands and values). I can recommend starting with Powershell ISE.
If you want to follow along with this presentation then ISE will work best for you. I can also recommend VSCode which adds even more features especially 
for complex scripts. This works for all versions of Powershell where as the ISE only works up to Powershell 5.1 and does not include support for 
Powershell Core 6 and higher.
#>

<# Launch your editor as Admin. You can run many Powershell commands as your standard user account for gathering information. As with many other parts of Windows
when you need to make changes then they need to be under an elevated prompt. You will need to run as admin to follow along with this demonstration.
#>

<# To run a full script you can hit F5 or the Play button. I don't recommend that on this script as it will error out. To run an individual line you can
either highlight the line or click the number beside the line then hit F8. F8 also works when you select multiple lines.
#>

#Set Execution Policy 
<#The default execution policy for Powershell is Restricted. This will permit individual commands to be run but not scripts. This includes configuration files, modules, and profiles. 
Windows Servers default to RemoteSigned. This allows scripts to run but requires a digital signature when downloaded from the internet. Scripts can be unblocked using Unblock-File
For testing set the ExecutionPolicy to Unrestricted.
#>
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

<# If you run into an error that says this is overriden by another execution policy we can see what that policy is. Just uncomment this line below
#>

#Get-ExecutionPolicy -List

<# If you see another execution policy that is set more restrictive then you can name that scope and set it individually. For example, the line below
#>
#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted

<#A good first step is to update the help file. Powershell ships with a bare skeleton of help and will refer to downloading the rest of the files. This may take some time
Updating help is a command that requires administrative access. Note, occasionally some modules may error out if the online version of the help files is not 
currently available. Don't worry about this
#>
Update-Help

#endregion

#region Help
#Now that we have updated help files it's a good time to find out what the help files do. This gives an overview on how to use help files
Get-Help

<# Get-Help needs a command to show the information about that command. For example we can look at the information on the Update-Help command we ran earlier.
Note that there is multiple syntax options. Each command can have multiple sets of parameters based on how it is being run. The syntax examples show which 
parameters are required. These also show the parameters that allow for multiple values using []. Switches are shown such as -Force that do not require a value
but by specifying those are used.
#>
Get-Help Update-Help 

<# Update help is a fine beginning command but lets look at a real life command that you can use. Get-Command is a command that you can use to find Powershell commands. 
In this case we will find command associated with Windows Event Logs
#>
Get-Command *eventlog*

<# Note the command names returned. These follow the Verb-Noun structure which make them fairly easy to read and understand. Get-, Clear-, New-, Remove- are all actions that you recognize.
Most commands follow this structure, even third party modules. You can check and see the full list of "approved" verbs by running Get-Verb. Nothing forces people to use those verbs. 
#>

<# Get-EventLog is an easily acccessible command. Look up the help files for Get-EventLog. Note that these give two different sets of Syntax that can be used. This shows the types of input that
can be accepted. Each of these are parameters that can be added to the command which we will cover in a bit. It also gives a description and links to the online version. 
#>
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

<# According to the list we should be able to pull back System logs. Be careful though, if you run this it will bring back all System logs. That is quite a few. 
If you run this and tire of waiting you can use Ctrl+C to cancel the operation
#>
Get-EventLog System

#Instead, we can use parameters to cut down on the amount of information we're receiving. This grabs only the 10 most recent events in the System log
Get-EventLog System -Newest 10

#I find using the -EntryType parameter useful. Often when I'm searching the event logs I only want Errors or Warnings
Get-EventLog System -Newest 10 -EntryType Error

#We can actually search for both of those because the -EntryType parameter accepts multiple parameters
Get-EventLog System -Newest 10 -EntryType Error,Warning

<# While the standard output for Get-EventLog is in table format, it may be easier to read all of the information if it is in list form. If we pipe the command into Format-List this will
present the information differently. Note that the information is now in rows and grouped by entries. Each entry will have its own set of rows.
#>
Get-EventLog System -Newest 1 -EntryType Error | Format-List

<# We can can also use parameters to specify another computer to connect to and read logs from. This will use your current logged in user similar to how
Event Viewer connects to a remote computer. If you need to connect using a different account I will cover that later.
Note this will work for me, not for you
#>
Get-EventLog System -Newest 10 -EntryType Error -ComputerName (Read-Host)

#We can use this output and format it as a list as well.
Get-EventLog System -Newest 10 -EntryType Error -ComputerName (Read-Host) | Format-List

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

<# You can create aliases yourself using New-Alias but I wouldn't recommend it. The aliases are only available to you and not ported to any other computer unless you use Export-Alias. 
Aliases are discouraged in scripts. They are easy to type when you're just running a command, but a script you're likely to come back to or someone else will read it.
In that case aliases make it harder to understand the commands. It's advised to just type out Get-ChildItem. After all, that's what tab completion is for, right?
#>
#endregion

#region Making things easy
<# Ok so you see how to find parameters using help and how to use them. That's hard to grasp at first though. Plus for some people working in a command line only can get tiring.
Sometimes you just want to click something, right? (We are working with Windows after all). Show-Command is helpful and gives you boxes to fill out. 
Once you fill them out you can click Run. Your command is then populated with all the parameters filled out. This can be useful for learning new commands.
Note that there is tabs to shows you the different parameter sets. Once you get the command built, copy it and then run it. Save what you copied in your 
documentation so that next time you can just run that. 

In many online services such as Exchange you can enable commandlet logging. This will start a transcript of what you are clicking and accomplishing. You can
then take the transcript and use it to understand what commands are being run in the background. Then next time you can quickly run the command rather than 
clicking around everywhere.
#>
Show-Command Get-EventLog

#endregion

#region Errors
<# Errors will happen. I run into them all the time whether I'm mistyping something or just running the wrong command. The biggest thing is learning how to read them. 
Powershell for the most part has errors that make sense, it's just taking the time to read and understand them. 
#>

<# Bad Command. We can see that this isn't a command. Good time to use Get-Command and see if we just didn't type the right name
The term 'Get_Service' is not recognized as the name of a cmdlet, function, script file, or operable program. Powershell tries to aid us by giving suggestoins
such as checking the spelling or path to something. That's a good indicator that either we've typed a command that doesn't exist, or doesn't exist
within the commands we have available currently. 
#>
Get_Service

<# This can happen with parameters that need to be in certain formats. If you check Get-Date, the -Date parameter needs to be a Date/Time format. We're specifying it using a bad date and time
You can see that Powershell attempts to convert it to the correct format. We can even feed it dates that aren't in that format ("May 1") and it will convert to date/time. However this is
bad enough it won't work
Cannot bind parameter 'Date'. Cannot convert value "May_1" to type "System.DateTime". I find this helpful because it tells us what format is expected. 
It's simple enough to Google System.DateTime examples (or Powershell System.DateTime examples) and find more than a few blogs and documentation on what is 
acceptable in that format. 
#>
Get-Date -Date "May_1"

<# Don't be scared of errors. They happen often enough especially as you are learning. Just take the time to read them and learn what they're saying. If you need to, Google them and there's often examples
Worst case as a presenter once said, you can change the error text color to Green. It makes you feel a lot less like red ink on a test
#>
$host.PrivateData.ErrorForegroundColor = 'Green'

<# here is another common mistake. We can see that Powershell tells us that the file doesn't exist. I see that commonly when you are running Powershell
as an admin which uses a separate admin account. Files that were downloaded or saved to your normal provile are not in the profile folders under your admin account
#>
Get-ChildItem C:\TTL3

<# The fun thing is we can test that file path and return a boolean value of whether it exists or not. You'll see that in use in a later script in this presentation
#>
Test-Path c:\ttl3

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
Get-Process | Select-Object -First 1 | Format-List *

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

<# Alternately we can look at our CSV file which has all of the properties of the processes
#>
Invoke-Item C:\ttl\processes.csv

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

<# We see that the file contains the same info as the object
#>

Invoke-item C:\ttl\processnames.txt

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

<# Without the filtering we would have pulled back much more information that we didn't need
#>
Get-CimInstance -class Win32_NetworkAdapterConfiguration

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

<# We can look at this credential object. The username is in clear text but the password is stored as a secure string. This is how Powershell expects credentials
although VMware and some others will accept plain text passwords. That's not good practice though.
#>

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
#We can create a short script which prompts the user for a service and then returns the status of that service. This provides the user a method to find status without having to know anything more
#We could save this code snippet as a .ps1 and have another user run it

$name = Read-Host "Enter a service name"
$service = Get-Service $name 

     If ($service.status -eq "Running") {

         Write-Output "The service is running"} 

    Else {

        Write-Output "The service is not running"}

#Prompting a user for a value is necessary for some scripts. However, many scripts require automation. It would be difficult to require a user to type in values if the script runs on a schedule
#Alternately, we can provide a value for the service name which then can automatically run.

$name = "BITS"
$service = Get-Service $name 
        
    If ($service.status -eq "Running") {
        
        Write-Output "The service $name is running"}
        
    Else {
        
        Write-Output "The service $name is not running"}


#If we want to be a bit more dynamic, we could maintain a csv file of services that we want to check. The first command simply exports some services for us to create that csv
#Then we can run the rest of the script on a regular basis. We've also added logging to the script. Since we won't be sitting at the console everytime this runs we need a way to check the results
#Here we can drop the results to a log and check at our leisure

#run once
$log = "c:\ttl\log.txt"
Get-Service "BITS" | Export-Csv c:\ttl\services.csv -NoTypeInformation

#Script to be scheduled
$service = Import-Csv C:\ttl\services.csv
$name = $service.name

    If ($service.status -eq "Running") {
        
        Write-Output "The service $name is running" | Out-File $log -Append }
        
    Else {
        
        Write-Output "The service $name is not running" | Out-File $log -Append }

Invoke-item $log


#Naturally we want to extend this so that we could check multiple services. To do this we can add a simple loop into the script
#This works easily since the $services variable is just a collection of multiple values. Foreach tells the loop to go through each value of $services one value at a time
#This starts with the first value which is $services[0] then to $services[1] and $services[2]. You can run that in your shell to see the values. 
#The foreach loop does this automatically. It allows us to specify $service as the variable to put a single value and work with that within our loop. So now we are looping through
#each value and checking that service.

$log = "c:\ttl\log.txt"
Get-Service "BITS","BranchCache","ibtsiva" | Export-Csv c:\ttl\services.csv -NoTypeInformation

$services = Import-Csv C:\ttl\services.csv
    
    Foreach ($service in $services){

        $name = $service.name

        If ($service.status -eq "Running") {
            
            Write-Output "The service $name is running" | Out-File $log -Append }
            
        Else {
            
            Write-Output "The service $name is not running" | Out-File $log -Append }

    }

Invoke-item $log

#As we evolve our script we realize that just knowing that a service is started or stopped isn't everything we need. We want our automatic services to be running. If they aren't running
#then we want to remediate that. If it is a manual service and it's stopped it has likely run it's course so we'll ignore that. To accomplish this we'll add another If statement
#This way if the service is stopped then we evaluate if the service is Automatic or not and then if it is Automatic we log that and start the service.

$log = "c:\ttl\log.txt"
Get-Service "BITS","BranchCache","ibtsiva" | Export-Csv c:\ttl\services.csv -NoTypeInformation

$services = Import-Csv C:\ttl\services.csv
    
    Foreach ($service in $services){

        $name = $service.name

        If ($service.status -eq "Running") {
            
            Write-Output "The service $name is running" | Out-File $log -Append 
        }
            
        Else {
            
            If ($service.StartType -eq "Automatic"){

                Write-Output "The service $name is not running and should be. Starting service" | Out-File $log -Append 

                Start-Service -Name $service.Name

            }

            Else{
            
                Write-Output "The service $name is not running" | Out-File $log -Append 
            }
        }    
    }

Invoke-item $log

#endregion

#region Error Handling

<#When we're running a script automatically we have to plan that someone will not be watching the console to see if the script is running. In our example we are trying to start a service
What happens if we're unable to start the service? How do you know? Currently we're writing to the log that we're trying to start the service, but if that fails we don't know, just that 
the service didn't start. We can use try/catch blocks to catch errors. These blocks will catch the error as it happens. When an error occurs in the Try block the error is passed down
to the Catch block. We grab the error properties and pass them to the Catch block and then drop the errors to the log file. This gives us visibility into an error that is thrown 
and then can be addressed.
#>

Set-Service -Name BITS -StartupType Disabled
Stop-Service -Name BITS

$log = "c:\ttl\log.txt"
Get-Service "BITS","BranchCache","ibtsiva" | Export-Csv c:\ttl\services.csv -NoTypeInformation

$services = Import-Csv C:\ttl\services.csv
    
    Foreach ($service in $services){

        $name = $service.name

        If ($service.status -eq "Running") {
            
            Write-Output "The service $name is running" | Out-File $log -Append 
        }
            
        Else {
            
            If ($service.StartType -eq "Disabled"){

                Write-Output "The service $name is not running and should be. Starting service" | Out-File $log -Append 

                Try {
                 
                    Start-Service -Name $service.Name -ErrorAction Stop
                
                }

                Catch{

                    $ErrorMessage = $_.Exception.Message
                    $FailedItem = $_.Exception.GetType().FullName  
                    $LogEntry = "Unable to start service: " + $FailedItem + " " + $ErrorMessage
                    $LogEntry | Out-File $log -Append 

                }

            }

            Else{
            
                Write-Output "The service $name is not running" | Out-File $log -Append 
            }
        }    
    }

Invoke-item $log

Set-Service -Name BITS -StartupType Manual

<#Another way to use the Try/Catch block is Try/Catch/Finally blocks. I've used those in situations where you want a command to run at the end no matter what the earlier result was.
This shows an example of a function in a class where a finally block is used to dispose or close the connection when it's done. Don't try to run this example was it won't work
#>
[DataSet] GetDataSet([string]$SQL) {

    $this.InsertLogEntry("Attempting to execute the following sql query: " + $SQL)
    [SqlConnection] $conn = new-object SqlConnection($this.ConnectionString)
    [SqlDataAdapter] $da = new-object SqlDataAdapter
    [SqlCommand] $cmd = $conn.CreateCommand()
    $cmd.CommandText = $SQL
    $cmd.CommandTimeout = 120
    $da.SelectCommand = $cmd
    [DataSet] $ds = new-object DataSet

    Try {

        $conn.Open
        $da.Fill($ds)

    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.GetType().FullName  
        $LogEntry = "Unable to retrieve dataset: {0}, {1}" -f $FailedItem, $ErrorMessage
        $this.InsertLogEntry($LogEntry)            
    }

    Finally {

        $cmd.Dispose()

        If ($conn.State -ne "Closed") {
                $conn.close()
        }
    }

    return $ds
}



#endregion

#region Functions

<#The next logical step of our script is enclosing what we've done in a function. Functions allow us to name our function (Get-ServiceStatus) and execute the function. Once that code
is run then we can run it again by calling Get-ServiceStatus. If we intend on running this multiple times in a single script we can save some writing and confusion by enclosing it in 
a function. One thing to note is variable scope. Any variables declared outside of the function are considered global variables and available. Variables within the scope are local 
to the scope of the function. When the function is completed those variable go away and cannot be called. 
#>
Function Get-ServiceStatus {
$log = "c:\ttl\log.txt"
Get-Service "BITS","BranchCache","ibtsiva" | Export-Csv c:\ttl\services.csv -NoTypeInformation

$services = Import-Csv C:\ttl\services.csv
    
    Foreach ($service in $services){

        $name = $service.name

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
                    $LogEntry = "Unable to start service: " + $FailedItem + " " + $ErrorMessage
                    $LogEntry | Out-File $log -Append 


                }

            }

            Else{
            
                Write-Output "The service $name is not running" | Out-File $log -Append 
            }
        }    
    }

Invoke-item $log
}

Get-ServiceStatus

<# While the previous example showed you how to change a block of code into a function, it certainly isn't optimized for a function. The function is hardcoded to pull certain services
out of a file. We would like to keep our functions as simple as can be. In this case we will refactor the function to focus only on one service at a time. We will remove the loop
from the function. Instead we add our own parameters to the function. These function just like the parameters we used in the built in Powershell commands. It is a best practice to tell 
the function what type of data we expect from these parameters which we are saving into variables. In this case both of them are strings so that makes it easy. We can then use those
variable within the function with values that came from outside the function. In this case we're passing one service at a time into the function but with a single command so it's cleaner
and easier to understand. Alternately we could create a loop outside of the function to pass all 3 values in one at a time, similar to what we had in the code before. This shows how
functions are reusable and easy to understand what is happening
#>

$log = "c:\ttl\log.txt"
Function Get-ServiceStatus {

    Param(
        [string] $servicename,
        [string] $log
    )

    $service = Get-Service $servicename
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
                $LogEntry = "Unable to start service: " + $FailedItem + " " + $ErrorMessage
                $LogEntry | Out-File $log -Append 

        
            }
        
        }
    
        Else{
                    
            Write-Output "The service $name is not running" | Out-File $log -Append 
        }

    
    }

}





Get-ServiceStatus -servicename "BITS" -log $log
Get-ServiceStatus -servicename "BranchCache" -log $log
Get-ServiceStatus -servicename "ibtsiva" -log $log
Invoke-item $log

<# We will refactor our function one more time. Powershell gives us the ability to require that parameters be filled out. You may notice this with some of the built in commands.
Here you see that we added the [Parameter(Mandatory=$true)] designation for the $servicename parameter. We have to do this because if we call Get-Service with no value it will error out.
By requiring the parameter we can avoid user input errors causing function errors. We've also added a $computername parameter which has a default value. That is an enviornmental variable
so that if no -computername parameter is specified the function will run against the local computer. If a name is specified then Get-Service will run against the remote computer specified.
#>

$log = "c:\ttl\log.txt"
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
                $LogEntry = "Unable to start service: " + $FailedItem + " " + $ErrorMessage
                $LogEntry | Out-File $log -Append 

        
            }
        
        }
    
        Else{
                    
            Write-Output "The service $name is not running" | Out-File $log -Append 
        }

    
    }

}





Get-ServiceStatus -servicename "BITS" -log $log
Get-ServiceStatus -servicename "BranchCache" -log $log
Get-ServiceStatus -servicename "ibtsiva" -log $log
Invoke-item $log

<#Now we can test our mandatory parameters. Run the following command without and parameters. Note how it asks for both the service name and log as we've made those mandatory. This 
can help enforce data integrity
#>

Get-ServiceStatus

#endregion

#region Modules
<# Scripts with functions and parameters are great. That works very well if you have a script that you'll run often. However, what if you want to use that function across multiple scripts?
The issue you would run into is if you make a change to that function. Then this function needs to be changed across all scripts that it is used in. To simplify this we can use modules.
We talked about importing public modules previously such as the ActiveDirectory one or online ones such as WinSCP. You can write your own modules and store them on your network if you prefer.
The simplest way to do this is to take your function and save it as a psm1. This signifies that it is a module. That's the simplest way to make a module. There are additional steps you
can take and if you're interested in building modules I'd suggest you read the following blog post (http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/). 
I've used both Plaster (https://github.com/PowerShell/Plaster) and PlatyPS (https://github.com/PowerShell/platyPS) to help automate setting up a module correctly.
For the purpose of this demonstration we'll keep it simple.
The additional power of a module is that it can include multiple functions. This is ideal if you have a group of functions that are related, you can combine them in a function and
just import that function when needed. When a change is applied to the function you will see that reflected across all the scripts that it is used in. 
#>

<# To demonstrate this I'll kill my current powershell session so that it forgets all commands imported. We can see that this command does not exist#>
Get-Command Get-ServiceStatus

<# Here is the default locations that powershell looks for modules. We could copy our module to one of these locations. If we did that, we would not have to specify the location of the
module, Powershell would just check the default locations and load it if found in one of those. Install-Module will download the module to $env:ProgramFiles\PowerShell\Modules by default
so that the module is available to all users  
#>
$Env:PSModulePath

<# Now we import the module. I'll specify that the module is in our current directory since we didn't copy it to one of the default paths #>
Import-Module .\Get-ServiceStatus.psm1

<# After importing the function's command is now available. #>
Get-Command Get-ServiceStatus

<# We can now use this command as we were before #>
$log = "c:\ttl\log.txt"
Get-ServiceStatus -servicename "BITS" -log $log
Invoke-item $log

#endregion

#region Debugging

#See Debugging.ps1

#endregion


#endregion 

#region Advanced

#region PSDirect
<# PSDirect is a Hyper-V specific feature that allows you to connect to a VM and run powershell commands without it being accessible across the network. This differs from PSRemoting
as that requires PSRemoting to be enabled and accessible. PSDirect does need to be run on a Hyper-V server and the guest machine needs to be Server 2016 or newer.
PSDIrect uses Invoke-Command which runs a script block against the VM. This is very useful for scripting a brand new VM and configuring the networking on it. 
Note: You will not be able to run these commands
#>

<#Save the credentials to connect to our Hyper-V host. Then enter into a PSSession from our local computer. This allows us to use the Hyper-V commandlets without needing the role
installed on our desktop 
#>
$domaincred = Get-Credential
Enter-PSSession -ComputerName "IUHQSHPV003.hq.iu13.local" -Credential $domaincred

<# First we set the VM name that we want to connect to on that server. Then we set the IP configuration on that server. Once this is done it will be accessible on the network.
The credentials that we are getting are the local admin credentials for the base Windows installation since it's not bound to a domain. You can see that it quickly connects
and configures the network
#>
$VMname = "TTL2"
$setip = {
    #Operations performed in the console so that remote computer can connect
    $ipaddress = "10.14.14.251"
    $defaultgateway = "10.14.14.1"
    $DNS = "10.14.14.2,10.14.14.3"
    
    Get-NetIPConfiguration | New-NetIPAddress -IPAddress $ipaddress -PrefixLength 24 -DefaultGateway $defaultgateway
    
    Get-NetIPConfiguration | Set-DnsClientServerAddress -ServerAddresses ($DNS)
    }

$credential = Get-Credential 
Invoke-Command -VMName $VMname -ScriptBlock $setip -Credential $credential

<# Test-NetConnection is one of my most used commands. It is ping and telnet rolled up in one command without having to enable to Telnet Client feature. We can see that the server is online
#>
Test-NetConnection "10.14.14.251"


<# Next we can set the computer name and restart the VM afterwards. We could technically include this in our $setip block but it is nice to split script blocks out into logical groupings
#>
$rename = {
    $ServerName = "TTL1"

    Rename-Computer -NewName $ServerName -Restart
}

Invoke-Command -VMName $VMname -ScriptBlock $rename -Credential $credential


<# Now we can bind this to the domain. This does need to be in a separate script block since there is a reboot at the end of the previous block. 
#>
$bind = {
 
    $domainname = "hq.iu13.local"

    Add-Computer -DomainName $DomainName -Restart
}

Invoke-Command -VMName $VMname -ScriptBlock $bind -Credential $credential

<# Enable PSRemoting
#>
Invoke-Command -VMName $VMname -ScriptBlock {Enable-PSRemoting} -Credential $credential


<# Exit the PSSession from our Hyper-V host
#>
Exit-PSSession

<# Now we can connect to the VM since it's on the network and bound to our domain. We can run any remaining tasks in this session
#>
Enter-PSSession $servername

<# Exit the PSSession when we are finished
#>
Exit-PSSession


#endregion

#region VMware Invoke-VMScript
<# VMware has a similar method to PSDirect available. This does require that VMware Tools are installed on the VM before you can run the command.
This means that you will need to have already installed the tools so you can't do this from a bare Windows installation, however you could use it on a deployed
template. Other than that it functions very simliar to PSDirect and relies on passing script blocks to the vm using Invoke-VMScript
Note: you will not be able to run these commands
#>

$VMname = "TTL1"
$cred = Get-Credential

<# This is the local administrator credentials
#>
$VMcred = Get-Credential

<# First you need to install/import the PowerCLI module into your session
#>
Import-Module VMware.PowerCLI

<# Connect to your Vsphere instance
#>
Connect-VIServer vsphere -Protocol https -Credential $cred

<# If deploying straight from a template you can just power on the VM and wait for it to boot. 
NOTE: be careful here. If you have the Hyper-V commands loaded and the VMware commands loaded both use Get-VM as a command. This conflicts between the two.
To avoid a conflict you will likely want to import the PowerCLI module using Import-Module VMware.PowerCLI -Prefix VMware. This adds VMware to the beginning
of all of the PowerCLI commands and ensures that there is no conflict. This same technique can be used to avoid conflicting Exchange Online and Exchange 
On Premise commands
#>
Get-VM  $VMname | Start-VM

<# We can reuse the script block since the block itself will not change between Hyper-V and VMware
#>
$setip = {
    #Operations performed in the console so that remote computer can connect
    $ipaddress = "10.14.14.251"
    $defaultgateway = "10.14.14.1"
    $DNS = "10.14.14.2,10.14.14.3"
    
    Get-NetIPConfiguration | New-NetIPAddress -IPAddress $ipaddress -PrefixLength 24 -DefaultGateway $defaultgateway
    
    Get-NetIPConfiguration | Set-DnsClientServerAddress -ServerAddresses ($DNS)
    }

<# The rest of the commands are extremely similar to the PSDirect commands just using Invoke-VMScript rather than Invoke-Command
#>

Invoke-VMScript -VM $VMname -ScriptText $setip -GuestCredential $VMcred

$rename = {
    $ServerName = "TTL1"

    Rename-Computer -NewName $ServerName -Restart
}

Invoke-VMScript -VM $VMname -ScriptText $rename -GuestCredential $VMcred

$bind = {
 
    $domainname = "hq.iu13.local"

    Add-Computer -DomainName $DomainName -Restart
}

Invoke-VMScript -VM $sVMname -ScriptText $bind -GuestCredential $VMcred

#endregion

#region SQL

<# See Get-DataSet.ps1
#>

#endregion

#region Other Logging
<# So far we've covered logging to a text file and to a SQL database. Text files are simple and easy but are not centralized and can only contain information in 
a very simple structure. SQL databases are centralized but require setting up a database and training techs who should be monitoring the database. Documentation is 
fine for that, but it does make it intimidating for techs to check and I've found that means they will do it less. I've found that CSV files are a middle ground.
They allow for multiple columns and sorting similar to SQL but are more accessible for techs to check. They are not centralized, but could be emailed to a distribution
group if that was needed. 

One of the main issues I ran into with exporting to a csv file is performance. For a script that would output about 2500 lines of logging I was seeing it take about 
15 minutes to actually run due to the logging. This was important data I wanted to monitor but that's far too long to run (in my opinion, plus I'm always curious
on how to do things better). What I found was that the export-csv -append was quite costly because every time it had to load the csv file and then skip to the bottom
to add the new line. My example code for that is below.

Great, so what are other options? Next I tried an array figuring that adding the data to an array which is in memory rather than a file on disk would be much less
costly. In testing that minorly improved performance by a minute or so but not nearly the performance impact I expected. In doing some more research I found
that the array suffered from the same issue as exporting to csv. Every time you called the array it had to load it again and skip to the end of the array and add the
new values. So my original issue wasn't really disk performance but loading the object over and over again, 2500 or so times.
#>
Function Insert-LogEntry {
        param [string]$StudentID
        param [string]$StudentName
        param [string]$PreviousValue
        param [string]$NewValue
        param [string]$Message
        param [string]Severity

        [PSCustomObject]@{
        StudentID = $StudentID
		StudentName = $StudentName
		PreviousValue = $PreviousValue
		NewValue = $NewValue
		Message = $Message
		Severity = $Severity
        } | Export-Csv $log -Append
}

<# In my research I came across array lists. Array lists are treated differently and were suited for what I was trying to do. So instead of doing a += to my array,
I can use an .add method to the array. I'm going through and adding the values to the array list during the script run then at the end of the script I take the whole
array list object and export that to csv. This dramatically reduced script run time with it finishing in 4 minutes instead of 14/15. 

Lesson learned, just because there are methods and ways of doing things doesn't mean they are the best suited for the job. Be curious and research. I'd rather spend
the time to fix the issue on this script when that time will pay off for the next 15 scripts that I'll write. 
#>

[System.Collections.ArrayList] $Log = @{}
Function Insert-LogEntry {
    param [string]$StudentID
    param [string]$StudentName
    param [string]$PreviousValue
    param [string]$NewValue
    param [string]$Message
    param [string]Severity

	$Log.add([pscustomobject]@{
		StudentID = $StudentID
		StudentName = $StudentName
		PreviousValue = $PreviousValue
		NewValue = $NewValue
		Message = $Message
		Severity = $Severity
    } )
    
    

}

Function ExportLogEntries{

   $Log |  Export-Csv -Path $Logpath -NoTypeInformation
}

<# Another way we can log is to Microsoft Teams using a WebHook. WebHooks are really easy to enable for a Teams channel and they will provide you a URL to connec to.
I've found this useful for logging info that multiple people may be interested in, but not interested enough to need immediate notification. They can check the 
Teams channel at their leisure and view the history as well. A good example of this is when a user is automatically created or expired. 

You can find different json examples across the internet to format the notification how you want. I've passed the notification parameters so that I can generate
different messages for different actions in the script. The function then uses a REST method to pass the notification to the WebHook and it's immediately posted
to Teams. 
#>

Function Send-TeamsNotification {
    param [string]$displayname, 
    param [string]$action

    $uri = 'https://MyWebHookURL.com'

    If ($action -eq "Remove"){



        $body = ConvertTo-Json -Depth 4 @{
            title = 'User disabled'
            sections = @(
                @{
                    activityTitle = 'ADUpdate'
                    activitySubtitle = $displayname + ' account was disabled'
                    activityText = 'A user has been remove'
                    activityImage = 'http://URL'
                }
            )

        }
    
    Invoke-restMethod -uri $uri -Method Post -body $body -ContentType 'application/json'
    }
}

#endregion

#region Oracle

<# See Get-OrcaleData.ps1
#>

#endregion

#region Pester
<# To this point we've written a lot of code. Once we moved into scripts we created some scripts that will likely be scheduled to run automatically.
Often these types of scripts will need updated to change how they operate or add more functionality later on. First, that highlights the importance of
both writing code that is readable and including comments where needed. This also means that you may not be the only one updating the code, it may be a 
coworker or another person in your position.

Updating code always brings the risk of breaking what it already accomplishes. By adding other functions you may disrupt the existing functions without
realizing that. Pester is a way to run tests against your code for unit, integration and acceptance testing. This allows you to write a set of tests and 
include them along side the code itself. Then, when the code is updated the same tests (and new tests for your new code) will be run and ensure that
the previous functions and new functions work. If the tests are written well then you can be confident that everything works and the code can be updated
in production. Taken a step farther, tests can be automatically run when code is committed as part of a CI/CD pipeline. Once the tests pass then the code
can be automatically updated in production.
#>

<# Pester 3.4 is included with Windows 10. For the basis of this talk I'm writing it around Pester 3.4 even though there are later versions available 
in the Powershell Gallery. To install a later version you can use Install-Module to install it from the Gallery. We'll just use what is already installed
so we are loading it using Import-Module
#> 

Import-Module Pester

<# We can see that Pester is loaded and see any additional versions if you've already installed a newer version along side. 
#>
Get-Module -List Pester

<# Looking at the commands in Pester you may notice that most are not written in Verb-Noun form like the other Powershell commands we have been using. 
Pester is written using it's own Domain Specific Language which is why it does not use commands like we are used to. However, you can run Powershell
commands in a Pester test which we will use to test our code.
#>

Get-Command -Module Pester

<# As usual, it's good to start and look at the commands. This command runs the Pester test which is written in a separate file that would be included
with your other scripts and modules. 
#>

Get-Help Invoke-Pester -Full

<# Here we invoke the Pester test against our separate test file. The results are returned to our existing session and we can see the success and 
failures of the individual tests
#>

Invoke-Pester .\Get-ServiceStatus.Test.ps1

<# Now we can address some unit testing. Unit testing is done in isolation and attempts to ensure that our code works without worrying if there is an 
underlying issue with other functions that we call. In our example the function tests a path to ensure that the file is there. We don't want to worry if the
file doesn't exist during our test, just make sure that if the file is there that the rest of our code works. To do this we'll mock the function so that the 
code thinks that the file exists. This allows us to test the rest of our code without worrying about an issue with Test-Path. 

This unit test was adapted from this series on Pester testing
https://www.red-gate.com/simple-talk/sysadmin/powershell/advanced-testing-of-your-powershell-code-with-pester/
#>

Invoke-Pester .\MockUnitTesting.test.ps1

#endregion

#region Bot/Chatops
<# We've seen some useful ways to build and run scripts. However for the most part scripts are run from a shell or task scheduler. This doesn't give much visibility
or flexibility for people to run them. We could build a gui for the script but that doesn't really provide visibility into who ran a script and what it did. 
They also require connectivity to the network to be able to run the script itself. Another way around some of these limitations is a practice called ChatOps.
ChatOps uses a bot that integrates into your existing chat infrastructure (Slack, Teams, Skype For Business Online) and runs powershell modules. I'll focus on 
PoshBot which is a Powershell project created by Brandon Olin who has advocated for this practice. PoshBot ties into the existing bot infrastructure of Slack or 
Teams uses them to pass commands to a back end script. This script can execute modules based on what has been imported, a schedule, and the permissions of the user
issuing the command. 

There are several positive things about this approach. First, the visibility of the command is very useful. By tying the bot into an existing chat channel where
users are already looking then other users will see scripts being run. For example, if a server is experiencing performance issues and a user gets the performance
graphs in chat that allows others to use that copy and not have to request multiple graphs from a server that is already suffering. It also brings visibility 
that someone is looking at the server and others can correlate issues that they have seen as well. This also fits naturally with having the data and having 
discussion around the issue in the same area. 

ChatOps also extends out the management capabilities outside of the network. Since chat clients have mobile apps this allows management via a mobile app.
The user is already authenticated to the app so the bot understands their roles and permissions. For example, that Tomcat server that always freaks out and
needs rebooted when you are away from home can be restarted using a command from your mobile chat client. 

ChatOps talk by Brandon Olin
https://www.youtube.com/watch?v=Mrs49IdnSHc

Github project and documentation for PoshBot
https://github.com/poshbotio/PoshBot
https://poshbot.readthedocs.io/ 
#>

<# Demo PoshBot in Slack
#>

#endregion

#region DSC
<# Desired State Configuration is a configuration management platform that is integrated into Windows. This means that DSC is used to set the configuration 
of a server from a text file and then ensure that the server remains in that configuration. The value in this is that we can declare the configuration of a server
and then reuse that configuration when redeploying the server or deploying another server just like it. This configuration is also self documenting and can be 
stored in your version control software and tested and deployed as part of a CI/CD pipeline. 

Ok that's all well and good and sounds like awesome marketing speak. In real terms what does that mean? It means that we can deploy a server and do minimal 
configuration to it (mostly networking) and then apply a configuration to it. In that configuration we tell it what we want the services and files to look like
and then the local configuration manager (LCM) looks over that configuration and makes it so. The LCM will check over the configuration every 30 minutes and 
ensure that it still looks the same and if there is a drift then it will correct the drift. 

We'll keep this example simple, this will just check to make sure a file exists. To do so, I've already created the HelloWorld.ps1 script which defines
how the server should look like. Then, the script is compiled into a mof file which is then applied by the LCM. This example will show configuring a bare install
of Windows through to final configuration without needing to remote into it.

For more info the Microsoft Docs are a good place to start https://docs.microsoft.com/en-us/powershell/dsc/overview/overview. That is where this example came from.
#>

<# Starting with a bare installation I'll use PSDirect to configure the networking and join the server to the domain as we saw earlier
#>
$domaincred = Get-Credential

Enter-PSSession -ComputerName "IUHQSHPV003.hq.iu13.local" -Credential $domaincred

$servername = "TTL3"
$setip = {
    #Operations performed in the console so that remote computer can connect
    $ipaddress = "10.14.14.250"
    $defaultgateway = "10.14.14.1"
    $DNS = "10.14.14.2,10.14.14.3"
    
    Get-NetIPConfiguration | New-NetIPAddress -IPAddress $ipaddress -PrefixLength 24 -DefaultGateway $defaultgateway
    
    Get-NetIPConfiguration | Set-DnsClientServerAddress -ServerAddresses ($DNS)
    }

$credential = Get-Credential 
Invoke-Command -VMName $servername -ScriptBlock $setip -Credential $credential

$rename = {
    $ServerName = "TTL3"

    Rename-Computer -NewName $ServerName -Restart
}

Invoke-Command -VMName $servername -ScriptBlock $rename -Credential $credential

$bind = {
 
    $domainname = "hq.iu13.local"

    Add-Computer -DomainName $DomainName -Restart
}

Invoke-Command -VMName $servername -ScriptBlock $bind -Credential $credential

<# This time I'm adding a bit more configuration. I am enabling PSRemoting so that once we can get connected we'll switch over to that. I'm also enabling 
File and Printer sharing so that we can copy files over. I'm installing the module needed for the DSC resources and setting up a folder to host the local files 
for DSC.
#>
$finalconfig = {

    Enable-PSRemoting

    Get-NetFirewallRule -DisplayGroup 'File and Printer Sharing'|  Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true

    Install-Module DSCresources

    New-Item -Path 'c:\dsc' -ItemType directory

}


Invoke-Command -VMName $servername -ScriptBlock $finalconfig -Credential $credential

<# Now we can see that we can connect to the server now that it is networked and configured to allow connections.
#>
Test-NetConnection TTL3.hq.iu13.local

<# We no longer need PSDirect, now we can do the rest of our configuration via PSRemoting as we would other servers
#>
Exit-PSSession

<# Copy over the script that we will compile
#>
Copy-Item -Path .\HelloWorld.ps1 '\\ttl3.hq.iu13.local\c$\dsc\'

<# Connect to our server via PSRemoting
#>
Enter-PSSession -ComputerName ttl3.hq.iu13.local -Credential $domaincred

<# Change directories and run our script. This creates a new HelloWorld subfolder and puts the compiled mof in that folder
#>
Set-Location c:\dsc

. C:\dsc\HelloWorld.ps1
HelloWorld

<# We provide the path to the mof file and then kick off the LCM
#>
    
Start-DscConfiguration -Path C:\dsc\HelloWorld\ -Verbose -Wait -force

<# We can check and ensure that it succeeded
#>
Get-DscConfiguration

<# Here's the file that we specified to create. note that we didn't need to tell the server to create the Temp folder, just that it should have the 
Hello World text file at that location. The LCM configured the server so that would be correct.
#>
Get-Content -Path C:\Temp\HelloWorld.txt


#endregion

#endregion