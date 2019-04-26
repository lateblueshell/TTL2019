using namespace System.Data;
using namespace System.Data.SqlClient;
using namespace System.Collections;
using namespace System.Collections.Generic;

<# There's a few things to unpack about this one. First you'll see the .Net classes used and called at the beginning of the script. The using command
must come at the beginning of the script, hence the comments down below that. You can declare a variable using the fully qualified class if you prefer
such as [System.Data.SqlClient.SqlConnection] but it's nicer to call the class at the beginning when you may use it for multiple types.
You do not have to explicity declare the variables in Powershell but I do prefer it for complex scripts. It's easier to do this than to run into errors
where Powershell tries to convert a different type to an object. Normally not a problem but I do consider this a best practice. 

Next you can see that I've built out my SQL connection. Powershell does contain a command for SQL connections with Invoke-SQLCmd but there are some detailed
limitations that I won't go into here. I prefer this method as it's tried and true and easy to follow. Your choice of which to use. 
I've built the connection into a function so that I can reuse it for retrieving multiple data sets within the same script. 

This returns the data in a dataset which does require additional processing. I've included a loop which displays the information in a row. Below I'll show a 
way to create a PSCustomObject which allows you to work with the data in a Powershell object which is easier to work with.

This does provide an excellent way to show how debugging is helpful. I'll fully admit that when I modified my existing code to drop into this presentation 
I used debugging to sort through a few issues that I ran into. It is extrememely helpful to step into this function and examine the lines to ensure that you are
receiving the information how you expect to.
#>
<#
[dataset] $dataset

function Get-DataSet([string]$SQL, [string]$ConnectionString) {

    "Attempting to execute the following sql query: " + $SQL | Out-File $log -Append
    [SqlConnection] $conn = new-object SqlConnection($ConnectionString)
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
        $LogEntry | Out-File $log -Append          
    }

    Finally {

        $cmd.Dispose()

        If ($conn.State -ne "Closed") {
                $conn.close()
        }
    }

    return $ds
}

$dataset = Get-DataSet -SQL "SELECT * FROM [TTL2019].[dbo].[Presentations]" -ConnectionString "server=IUHQVSQL009\TECH;uid=_ttl;pwd=notmyrealpassword"

foreach($row in $dataset.Tables[0].Rows) {
    $row 

}



<# In the previous example I showed how you can loop through and display each row. In a normal use case you would not be just displaying the information but using
it to build a command. That's fine if you can use the data exactly as you pull it from the database. In most cases I've found that you may need to manipulate 
the data or add additional information before using it. In the example below you can see that I'm creating a PSCustomObject. This object allows me to interact 
with an object similar to how I do other Powershell variables by using it's attributes. I've added attributes to the object using the straight database row information
but I've also created an attribute that has hard coded value like all of my rows would have that's not included in the databse. I've also created another attribute
that transforms the row to add other information that I wanted to present. 

A real world example wouldn't use Write-Host, I'm just using that to display the information from my object. However, an example would be creating a user account.
For that we would use New-ADUser -samaccountname $User.Samaccountname -password $User.password -Path $User.OU
This way we can use the object to build all of our account information based off of both database information and other information that we know of outside
of the database
#>
<#
$dataset = Get-DataSet -SQL "SELECT * FROM [TTL2019].[dbo].[Presentations]" -ConnectionString "server=IUHQVSQL009\TECH;uid=_ttl;pwd=notmyrealpassword"

foreach($row in $dataset.Tables[0].Rows) {

    $objectProperty = [ordered]@{

        ID = $row['ID']
        Presenter = $row['Presenter']
        Room = $row['Room']
        Conference = "Tech Talk Live 2019"
        ConferenceRoom = "Conference Room Number: " + $row['Room']

    }


    [PSCustomObject] $Presentation = New-Object -TypeName psobject -Property $objectProperty

    Write-Host $Presentation.id " | " $Presentation.Presenter " | " $Presentation.Room " | " $Presentation.Conference " | " $presentation.ConferenceRoom

}

#>



Function Save-LogEntry([string] $PreviousValue, [string] $NewValue, [string] $message) {

    $date = Get-Date -format "dd-MMM-yyyy HH:mm:ss"
    [SqlConnection] $conn = new-object SqlConnection("server=IUHQVSQL009\TECH;uid=_ttl;pwd=notmyrealpassword")
    $conn.Open
    [SqlDataAdapter] $da = new-object SqlDataAdapter
    [SqlCommand] $cmd = $conn.CreateCommand()
    $cmd.CommandText =            
    "INSERT INTO [TTL2019].[dbo].[Log] ([Date],[PreviousValue],[NewValue],[Message])
        VALUES (@Date,@PreviousValue,@NewValue,@Message)"
    $cmd.Parameters.AddWithValue("@Date", $date)
    $cmd.Parameters.AddWithValue("@PreviousValue", $PreviousValue)
    $cmd.Parameters.AddWithValue("@NewValue", $NewValue)
    $cmd.Parameters.AddWithValue("@Message", $Message)
    $cmd.Connection.Open()
    $cmd.ExecuteNonQuery()
    $cmd.Dispose()
    $conn.Close()

}



Function Add-LogEntry([string] $PreviousValue, [string] $NewValue, [string] $message) {
   Save-LogEntry($PreviousValue, $NewValue, $message)
}


 Add-LogEntry -PreviousValue "Old" -NewValue "New" -message "Changing values"