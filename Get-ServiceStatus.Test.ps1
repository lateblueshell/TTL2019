<# Describe blocks provide logical containers for the tests that we are going to run. We can group together tests that belong together to view their results
in context with the other tests
#>

Describe 'Basic Pester Tests' {

    <# It blocks name the test. These names appear and are in color based on whether the tests have passed or failed
    #>

    It 'A test that should be true' {

        <# Within the it statement is where the test occurs. You can see that even though the rest of the test has been written in Pester's
        Domain Specific Language, the tests themselves are run using Powershell commands. After all, that is what we are testing. This test ensures that
        $true is evaluated as $true. We use the Should Be language to tell the test that the value of $true should be true. Note, that in Pester version
        4 and bove we can describe the Be action as -Be. This test will return green without further detail.
        #>

        $true | Should Be $true

    }

    It 'A test that should be false' {

        $false | Should Be $false

    }

    It 'Test that should fail' {

        <# Here is a test that we know will fail. You'll note that the result shows up in Red and there is further detail. Pester tells us that the test
        described the value should be False but the actual value was True. This can help track down why a value is being returned differently than expected.
        #>
        
        $True | Should Be $false

    }

}

Describe 'File check' {

    It 'Log file should exist' {

        <# Be is not the only comparison that we can use. This test checks to see if our Log file that we've been using exists in our current directory
        #>
        
        '.\log.log' | Should Exist 
    }

    <# Since we're running Powershell commands we can use variables in our tests. Here we use the $module variable to give the name of our module
    which should exist in our current directory. By naming it in the variable this allows us to use that in the It name of the test, and also as the
    value that we say should exist.
    #>
    
    $module = 'Get-ServiceStatus.psm1'

    It "$Module should be in current location"{
        
        $module | Should Exist

    }

}

Describe 'Grouping multiple tests' {

    <# Descibe is not the only logical grouping that we can use. Context allows us to create a sub grouping of tests together which is useful for organization
    #>

    Context 'Mathmatical' {

        It 'Should equal 40' {

            <# Similar to checking boolean values and files existing, we can check mathmatical operations. This is used to ensure that the variables in our 
            code are returning the values that we expect. In a normal sceario our code block would likely be more complex, but this allow us to see
            other value operators.
            #>
            
            $x = 8 * 5

            $x | Should be 40

        }

        It 'Should be less than 10' {

            $x = 11 - 2

            $x | Should belessthan 10

        }

        It 'Should be greater than 100' {

            $x = 11 * 11

            $x | Should begreaterthan 100

        }
    }

}