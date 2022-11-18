function Build-Sprint {
#Created variables to modify the WPF form without hardcoding any of the design
$MainFG = "Azure"
$MainBG = "Transparent"
$ButtonBG = "Navy"
$ButtonFG = "Azure"
$BackBG = "CornflowerBlue"
$BorderBG = "Navy"
$BarBG = "Navy"
$FontFamily = "Century Gothic"
$TextBoxBG = "Transparent"
$MainFontSZ = "14"
$ToolBG = "Transparent"
$MainWindowHeight = "265"
$MainWindowWidth = "254"

#Start the WPF Form
    Add-Type -AssemblyName PresentationCore, PresentationFramework
    $Xaml = @"
    <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
            xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
            xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
            xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
            Title="Just Answer The Questions..."
            Height="$MainWindowHeight"
            Width="$MainWindowWidth "
            WindowStyle="None"
            ResizeMode="CanResize"
            AllowsTransparency="True"
            WindowStartupLocation="CenterScreen"
            Background="$MainBG"
            Foreground="$MainFG"
            FontFamily="$FontFamily"
            FontSize="$MainFontSZ"
            Opacity="1" >
    <Window.Resources>
        <Style TargetType="Button" x:Key="RoundButton">
            <Style.Resources>
                <Style TargetType="Border">
                    <Setter Property="CornerRadius" Value="5" />
                </Style>
            </Style.Resources>
        </Style>
        <Style TargetType="{x:Type TextBox}">
            <Style.Resources>
                <Style TargetType="{x:Type Border}">
                    <Setter Property="CornerRadius" Value="3" />
                </Style>
            </Style.Resources>
        </Style>
    </Window.Resources>
    <Border CornerRadius="5" BorderBrush="$BackBG" BorderThickness="5" Background="$BackBG">
        <Grid>
            <Grid Height="30" HorizontalAlignment="Stretch" VerticalAlignment="Top" Background="$MainBG">
                <Border CornerRadius="5" BorderBrush="$BorderBG" BorderThickness="5" Background="$BarBG">
                    <StackPanel Orientation="Horizontal">
                        <Button Name="close_btn" Foreground="$MainFG" Height="20" Width="20" Background="$ToolBG" Content="X" FontSize="14" Margin="10,0,0,0" FontWeight="Bold" Style="{DynamicResource RoundButton}"/>
                        <Button Name="minimize_btn" Foreground="$MainFG" Height="20" Width="20" Background="$ToolBG" Content="-" FontSize="14" Margin="2 0 0 0" FontWeight="Bold" Style="{DynamicResource RoundButton}"/>
                        <TextBlock Text="Let's Build A New Sprint!" Foreground="$MainFG" Margin="20 0 0 0"/>
                    </StackPanel>
                </Border>
            </Grid>
            <Button Style="{DynamicResource RoundButton}" Name="create_btn" Background="$ButtonBG" Foreground="$ButtonFG" Content="Create" HorizontalAlignment="Left" Margin="187,221,0,0" VerticalAlignment="Top" Height="28" Width="57"/>
            <TextBox Name="Sprint_Name" Background="$TextBoxBG" HorizontalAlignment="Center" Margin="0,87,0,0" TextWrapping="Wrap" Text="Dq12" VerticalAlignment="Top" Width="228"/>
            <Label Foreground="$MainFG" Content="What is the name of the sprint?" HorizontalAlignment="Center" Margin="0,61,0,0" VerticalAlignment="Top" Height="26" Width="224"/>
            <Label Foreground="$MainFG" Content="How many days is your sprint?" HorizontalAlignment="Left" Margin="18,106,0,0" VerticalAlignment="Top" Height="34" Width="237"/>
            <TextBox Name="Sprint_Days" Background="$TextBoxBG" HorizontalAlignment="Center" Margin="0,130,0,0" TextWrapping="Wrap" Text="14" VerticalAlignment="Top" Width="228"/>
            <Label Foreground="$MainFG" Content="What is the URL to the sprint?" HorizontalAlignment="Center" Margin="0,150,0,0" VerticalAlignment="Top" Height="26" Width="208"/>
            <TextBox Name="Sprint_URL" Background="$TextBoxBG" HorizontalAlignment="Center" Margin="0,176,0,0" TextWrapping="Wrap" Text="URL" VerticalAlignment="Top" Width="228"/>
        </Grid>
    </Border>
</Window>
    
    
"@
    
    
    #-------------------------------------------------------------#
    #                      Window Function                        #
    #-------------------------------------------------------------#
    $Window = [Windows.Markup.XamlReader]::Parse($Xaml)
    
    [xml]$xml = $Xaml
    
    $xml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name $_.Name -Value $Window.FindName($_.Name) }
    
    #-------------------------------------------------------------#
    #                  Define Window Move                         #
    #-------------------------------------------------------------#
    
    #Click and Drag WPF window without title bar (ChromeTab or whatever it is called)
    $Window.Add_MouseLeftButtonDown({
        $Window.DragMove()
    })
    
    
    #-------------------------------------------------------------#
    #                      Define Buttons                         #
    #-------------------------------------------------------------#
    
    #Custom Close Button
    $close_btn.add_Click({
        $Window.Close();
    })
    #Custom Minimize Button
    $minimize_btn.Add_Click({
        $Window.WindowState = 'Minimized'
    })
    
    
    #Custom Minimize Button
    $create_btn.Add_Click({
        [String]$Name = $Sprint_Name.Text
        [Int]$Days = $Sprint_Days.Text
        [String]$URL = $Sprint_URL.Text
        [String]$Path = "C:\Temp\Automations" 
        [String]$Filename = "SprintPlan_$Name.txt"
        #Thank you https://regex-generator.olafneumann.org/
        $pattern = '\s(0?[0-9]|1[0-9]|2[0-3]):[0-9]+:[0-9]+\s[a-zA-Z]+'
        #Variable Work Here
        $Time = (Get-Date -DisplayHint Date)
        $sprintLength = ($Time).AddDays($Days)
        #Variable Formatting Here
        $TimeR = $Time -replace $pattern
        $sprintR = $sprintLength -replace $pattern
        #Create my file, with all directories and subdirectories required to get file where we want it to.
        New-Item -Force -Path $Path -Name $Filename -ItemType "file" -Value "`n`t`tThis is the automatic sprint plan layout generator 0.1.1 - Alan Newingham`n`n`n"
        #Pathing out the place I want to temp hold the file.
        $Path = $Path + "\" + $Filename
        Add-Content $Path "`t`t`tSprint Planning Automation for $Name"
        Add-Content $Path "`t`tThis sprint is from $TimeR to $sprintR `n"
        Add-Content $Path "`t`tThis sprint URL Location is:`n"
        Add-Content $Path "`t`t $URL `n`n"
        #How do I iterate through the days and apply formatted text to the file?
        #This took a while to get right...
        $start=Get-Date
        $end=$start.Adddays($Days)
        #define a counter
        $i=0
        #I want to test every day and verify that it is not a Saturday or Sunday
        for ($d=$start;$d -le $end;$d=$d.AddDays(1)){
            if ($d.DayOfWeek -notmatch "Saturday|Sunday") 
            {
                $q = $d -replace $pattern
                Add-Content $Path "
    --------------------------------------------------------------------------------------------
    ============================================================================================
    ============================================================================================
    $q
    ============================================================================================
    --------------------------------------------------------------------------------------------
    Stand-Up`n`n
    Lunch`n
    Notes:
    --------------------------------------------------------------------------------------------`n"
                #if the day of the week is not a Saturday or Sunday
                #increment the counter
                $i++
            }
        }

    Code $Path
    })
    
    #-------------------------------------------------------------#
    #                   Define Conditionals                       #
    #-------------------------------------------------------------#
    
    #Show Window, without this, the script will never initialize the OSD of the WPF elements.
    $Window.ShowDialog()
    }

    Build-Sprint
