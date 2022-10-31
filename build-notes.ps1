<#

Sprint Planning Layout Script

The idea is to template the sprint plan and notes generation so I do not have to manually format/type everything. 
The script requires that you enter -Days for the amount of days the sprint is going to run. 
The script requires that you enter -Name for the specific sprint name when running. 
If Days To Work equal 5 (Saturday) Then Skip To Monday (7) Assuming all sprints will be no longer than two weeks.
For a two Week Generation: Example: add-Days -Days 12 -Name "PL8"
#> 

function add-Days {
    
    param (
        [Int]$Days,
        [String]$Name
    )

    [String]$Path = "C:\Temp\AlansWork\Automations" 
    [String]$Filename = "SprintPlan_$Name.txt"

    #Thank you https://regex-generator.olafneumann.org/
    $pattern = '\s\d\d:\d\d:\d\d\s[a-zA-Z][a-zA-Z]'
    #Variable Work Here
    $Time = (Get-Date -DisplayHint Date)
    $sprintLength = ($Time).AddDays($Days)
    [Int]$DaysToWork = 0
    #Variable Formatting Here
    $TimeR = $Time-replace $pattern
    $sprintR = $sprintLength -replace $pattern
    
    Write-Host "Sprint Start Date is :" $TimeR
    #Create my file
    New-Item -Force -Path $Path -Name $Filename -ItemType "file" -Value "This is the automatic sprint plan layout generator 0.0.1 - Alan Newingham`n`n`n"
    
    #Pathing out the place I want to temp hold the file.
    $Path = $Path + "\" + $Filename
    Add-Content $Path "Sprint Planning Automation for $Name"
    Add-Content $Path "This sprint is from $TimeR to $sprintR `n"
    #Output during testing is important
    Write-Host "You specified there were $Days days to work this sprint."
   
    #How do I iterate through the days and apply formatted text to the file? 
    
    while($Days -ne $DaysToWork)
    {
        $Length = ($Time).AddDays($DaysToWork)
        $DaysToWork++
        $Length = $Length -replace $pattern
            if ($DaysToWork -eq 5) {
                $DaysToWork = 7
            } 

    
        Write-Host "Building Day # " $DaysToWork
        
        
        Add-Content $Path "
--------------------------------------------------------------------------------------------
============================================================================================`n`n
============================================================================================
$Length
============================================================================================
--------------------------------------------------------------------------------------------`n`n`n
Note:
--------------------------------------------------------------------------------------------`n"
    }



}
