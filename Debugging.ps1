<# Debugging has become a critical skill for me as I diagnose more complex scripts. Yes we can read through a script and assume what the value of a variable is, but that's not always the case.
This becomes especially important when working with passing values in and out of functions. 
#>

$i = 1

While ($i -lt 20){ 
    
    Write-Output "i is $i"

    $i = $i + 1

}