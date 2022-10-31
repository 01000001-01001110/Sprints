<#

Sprint Planning Layout Script

The idea is to template the sprint plan and notes generation so I do not have to manually format/type everything. 
The script requires that you enter -Days for the amount of days the sprint is going to run. 
The script requires that you enter -Name for the specific sprint name when running. 
If Days To Work equal 5 (Saturday) Then Skip To Monday (7) Assuming all sprints will be no longer than two weeks.
I have modified a GUI box to also support this request so it's a bit more friendly. 

Example: Create-Sprint
#> 
function Create-Sprint {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Sprint Notes Creation'
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = 'CenterScreen'
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75,120)
    $okButton.Size = New-Object System.Drawing.Size(75,23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150,120)
    $cancelButton.Size = New-Object System.Drawing.Size(75,23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,10)
    $label.Size = New-Object System.Drawing.Size(280,25)
    $label.Text = 'Provide a unique sprint name to use for this sprint:'
    $form.Controls.Add($label)
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,35)
    $textBox.Size = New-Object System.Drawing.Size(260,20)
    $form.Controls.Add($textBox)
    $label2 = New-Object System.Windows.Forms.Label
    $label2.Location = New-Object System.Drawing.Point(10,73)
    $label2.Size = New-Object System.Drawing.Size(280,20)
    $label2.Text = 'Number of days for sprint 12 is two weeks:'
    $form.Controls.Add($label2)
    $textBox2 = New-Object System.Windows.Forms.TextBox
    $textBox2.Location = New-Object System.Drawing.Point(10,93)
    $textBox2.Size = New-Object System.Drawing.Size(260,20)
    $form.Controls.Add($textBox2)
    $form.Topmost = $true
    $form.Add_Shown({$textBox.Select()})
    $result = $form.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
        {
            Write-Host "Here is the first number $D"
            $Name = $textBox.Text
            $D = [Int]$textBox2.Text
            Write-Host "Second $D"
            $Days = $D
            [String]$Path = "C:\Temp\AlansWork\Automations" 
            [String]$Filename = "SprintPlan_$Name.txt"
            #Thank you https://regex-generator.olafneumann.org/
            $pattern ='s\d\d:\d\d:\d\d\s[a-zA-Z][a-zA-Z]'
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
                    #How do I exclude the weekend dates from the script output? 
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
}
