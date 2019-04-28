using namespace System.Data

<# Now that we've covered connecting to Microsoft SQL, lets take a look at connecting to an Oracle database, like for Powerschool. This presents a few new challenges. 
First, the Microsoft SQL types are included in .Net so they can be used by simply calling the class that they are contained in. Oracle datatypes are not contained 
unless you have the (Oracle management software) installed. Ideally we'd like this script to be as portable as possible and not have to install a several hundred
MB piece of software on the server that you're running this script from. 

Thankfully Oracle has recently packaged up the ManagedDataAccess dll and published it on NuGet. That's great news, but how do we make sure that it's been installed?
We aren't doing an import-module otherwise we could use a try\catch block around the import-module statement. That would allow us to catch if there was an error 
and attempt to install the module if the import failed. However, we can't just import the module, we need to actually add the class types from the dll. 

Earlier in the demo I showed you Test-Path and here is where I use it in production. I've included a variable so that if we update the version of ManagedDataAccess 
then we only need to update it in a single spot. As you can see, I've included a path within the directory that the script runs. It checks to see if the dll is present.
If the dll is not present then it installs the package and places the dll in that spot. I use $ManagedDataAccess = Install-Package because that command outputs
data to the console when it runs. This way instead of outputting to the console the data is saved to a variable that we don't do anything with. This keeps the script 
run cleaner. 

So now we've used an if statment to check if the dll is not present and install it if the dll is not there. Then outside that if there is an Add-Type. Recall that we 
called the .Net types by using statements. That's because Powershell already knows about their existance. We can't count on that with the Oracle types as we must 
add the types and then we could theoretically use a using stameent for those types We can't make use of those here because those need to be at the beginning of the script.

So we've added the types but we haven't called them using the namespace. Alternately we can use New-Object to create an object of that type. This declares the variable
and sets the type so that resolves our problem.

As you can see there are several challenges to getting data from an Oracle databse but they aren't insurmountable. I wrote a blog post on this topic on the 
Tech Talk Live blog if your'e interested in reading a bit more. However now that we've gotten our types squared away, the actual dataset retrieval from the database
is quite similar to working with Microsoft SQL. You can see that we used the appropriate types but the commands themselves are pretty similar. I won't go over how
to deal with the datasets but you can refer to the Get-Dataset.ps1 file for that since handling the datasets is the same as Microsoft SQL.
#>

[dataset] $students

Function Load-DatabaseAccess(){

	# Load Oracle.ManagedDataAccess. Download the package and install if it does not already exist
	$version = '18.3.0'

	try	{
			
		if (! $(Test-Path ".\NugetPackages\Oracle.ManagedDataAccess.$version\lib\net40\Oracle.ManagedDataAccess.dll"))
		{
		$ManagedDataAccess = Install-Package Oracle.ManagedDataAccess -Destination ".\NugetPackages" -Force -Source 'https://www.nuget.org/api/v2' -ProviderName NuGet -RequiredVersion $version -ErrorAction SilentlyContinue
		}
		
		Add-Type -Path ".\NugetPackages\Oracle.ManagedDataAccess.$version\lib\net40\Oracle.ManagedDataAccess.dll"


	}
	catch 
	{
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.GetType().FullName  
		InsertLogEntry("","","","", "Error Loading Managed Data Access: " + $FailedItem + " " +  $ErrorMessage,"Error")            
	}
}

Function Get-DataSet([string]$SQL) {

	InsertLogEntry("","","","", "Checking Oracle Type","Information")            

	If ([bool]("Oracle.ManagedDataAccess.Client.OracleConnection" -as [type]) -eq $false){

		InsertLogEntry("","","","", "Loading Oracle Type","Information")            

		Load-DatabaseAccess

	}


    #$this.InsertLogEntry("Attempting to execute the following sql query: " + $SQL)
    $conn = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($ConnectionString)
	$da = new-object Oracle.ManagedDataAccess.Client.OracleDataAdapter
	$cmd = new-object Oracle.ManagedDataAccess.Client.OracleCommand
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $SQL
	$da.SelectCommand = $cmd
    [DataSet] $ds = new-object DataSet

	Try {

		$conn.Open
		$da.Fill($ds)

	}
	Catch {
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.GetType().FullName  
		InsertLogEntry("","","","", "Unable to retrieve dataset: " + $FailedItem + " " +  $ErrorMessage,"Error")            
	}

	Finally {

		$cmd.Dispose()

		If ($conn.State -ne "Closed") {
				$conn.close()
		}
	}


    return $ds
}

$students = Get-DataSet -SQL "SELECT * FROM STUDENTS"