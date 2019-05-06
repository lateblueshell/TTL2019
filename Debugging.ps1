<# Debugging has become a critical skill for me as I diagnose more complex scripts. Yes we can read through a script and assume what the value of a variable is, but that's not always the case.
This becomes especially important when working with passing values in and out of functions. 
#>

Function Test-Loop{

    $i = 1

    While ($i -lt 20){ 
        
        Write-Output "i is $i"

        $i = $i + 1

    }

}

#Test-Loop


# Raises a positive whole number to a power.
Function Math-Exponent([Int]$number, [Int]$power){
    if ($power -eq 0) {
      1
    }
    else {
      $result = $number
      for ($i = 1; $i -le $power; $i++) {
        $result *= $number
      }
      $result
    }
  }
  
  Math-Exponent -number 2 -power 2  # Should output 4.