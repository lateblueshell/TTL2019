# Execute the file with the function(s) we want to test.
# Running each time ensures we have the most current copy in memory
$dir = Get-Location
. .\MockUnitTesting.ps1

# Original declaration without the tag
# Describe 'Unit Tests' {

Describe 'Unit Tests' -Tag 'Unit' {

  # Create a file name which doesn't exist
  $aFileThatDoesntExist = 'C:\blah\blah\blah\fooey.txt'

  # Test 1, make sure function returns false if file exists
  
  # Make test-path indicate the file already exists
  Mock Test-Path { return $true }
  
  # Calling with verbose can aid in testing
  $aTestResult = PretendToDoSomething $aFileThatDoesntExist -Verbose
  It 'Returns False if file already exists' {
    $aTestResult | Should Be $False
  }

  # Test 2, make sure function returns true if file doesn't exist

  # Make test-path indicate the file doesn't exist
  Mock Test-Path { return $false }
  Mock Out-File { }

  # Calling with verbose can aid in testing
  $aTestResult = PretendToDoSomething $aFileThatDoesntExist -Verbose
  It 'Returns True if file didnt exist and processed OK' {
    $aTestResult | Should Be $True
  }

}

# Original declaration without the tag
# Describe 'Integration Tests' {

Describe 'Integration Tests' -Tag 'Integration' {

  # Create a file name 
  # $myTestData = "$($TestDrive)\MyTestData.txt"

  # Create a file name (revised)
  $myTestDataFile = 'MyTestData.txt'
  $myTestData = "$($TestDrive)\$($myTestDataFile)"
  
  # Test using a file name that won't exist
  $aTestResult = PretendToDoSomething $myTestData
  It 'Returns True if file didnt exist and processed OK' {
    $aTestResult | Should Be $True
  }

}
# Original declaration without the tag
# Describe 'Acceptance Tests' {

Describe 'Acceptance Tests' -Tag 'Acceptance' {

  # Setup a location and file name for testing
  $dir = Get-Location
  $testFile = 'AcceptanceTestData.txt'
  $testFilePath = "$dir\$testFile"

  # Ensure the file wasn't left over from a previous test
  if ($(Test-Path $testFilePath))
  {
    # Delete it, don't ask for confirmation
    Remove-Item $testFilePath -Force -ErrorAction SilentlyContinue
  }

  # Test using a file name that won't exist
  $aTestResult = PretendToDoSomething $testFilePath
  It 'Returns True if file didnt exist and processed OK' {
    $aTestResult | Should Be $True
  }

  }