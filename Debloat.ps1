Add-Type -AssemblyName PresentationFramework

# ASCII Art
$asciiArt = @"
  ____            _       _     _     
 | __ )  ___  ___| |_    | |   (_)_ __ 
 |  _ \ / _ \/ __| __|   | |   | | '__|
 | |_) |  __/\__ \ |_    | |___| | |   
 |____/ \___||___/\__|   |_____|_|_|   
 
 Welcome to the De-bloat Script
"@

# Display ASCII Art in PowerShell console
Write-Host $asciiArt -ForegroundColor Green

# Define De-bloat options (includes new apps list)
$appsList = @(
    "Microsoft.3DBuilder",
    "Microsoft.BingNews",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.MSPaint",
    "Microsoft.People",
    "Microsoft.SkypeApp",
    "Microsoft.Wallet",
    "Microsoft.Windows.Photos",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCamera",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.Edge",
    "3D Viewer",
    "Adobe Express",
    "Clipchamp",
    "Facebook",
    "Hidden City: Hidden Object Adventure",
    "Instagram",
    "Netflix",
    "News",
    "Prime Video",
    "Solitaire Collection",
    "Mixed Reality Portal",
    "Roblox",
    "TikTok",
    "Age of Empires: Castle Siege",
    "Asphalt 8: Airborne",
    "Bubble Witch 3 Saga",
    "Candy Crush Friends Saga",
    "Candy Crush Saga",
    "FarmVille 2: Country Escape",
    "Fitbit Coach",
    "Gardenscapes",
    "Phototastic Collage",
    "PicsArt Photo Studio",
    "Print 3D",
    "Spotify",
    "Twitter"
)

# Create GUI using XAML
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Title="Windows De-Bloat Script" Height="600" Width="500">
    <Grid>
        <StackPanel Margin="10">
            <TextBlock Text="Select Apps to Remove:" FontWeight="Bold" FontSize="16"/>

            <ScrollViewer Height="300">
                <StackPanel Name="appCheckBoxPanel" Margin="5"/>
            </ScrollViewer>
            
            <Button Name="btnSelectAll" Content="Select All" Width="100" Margin="10" HorizontalAlignment="Left"/>
            <CheckBox Name="chkDisableServices" Content="Disable Unnecessary Services" IsChecked="True" Margin="5"/>
            <CheckBox Name="chkDisableTelemetry" Content="Disable Telemetry" IsChecked="True" Margin="5"/>
            <CheckBox Name="chkDisableCortana" Content="Disable Cortana" IsChecked="True" Margin="5"/>

            <Button Name="btnRun" Content="Run" Width="80" Margin="10" HorizontalAlignment="Center"/>
            <TextBlock Name="txtStatus" Text="Status: Idle" Margin="10" HorizontalAlignment="Center"/>

            <TextBlock Text="Additional Options:" FontWeight="Bold" FontSize="16"/>
            <CheckBox Name="chkInstallIntelDrivers" Content="Install Intel Drivers" Margin="5"/>
            <CheckBox Name="chkInstallAMDDdrivers" Content="Install AMD Drivers" Margin="5"/>
            <CheckBox Name="chkInstallChromium" Content="Install Chromium" Margin="5"/>

            <TextBlock Text="For more tools visit: " FontWeight="Bold"/>
            <TextBlock>
                <Hyperlink NavigateUri="http://flubhub.top">flubhub.top</Hyperlink>
            </TextBlock>
        </StackPanel>
    </Grid>
</Window>
"@

# Load XAML and create window
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Get form elements
$appCheckBoxPanel = $window.FindName("appCheckBoxPanel")
$btnRun = $window.FindName("btnRun")
$btnSelectAll = $window.FindName("btnSelectAll")
$chkDisableServices = $window.FindName("chkDisableServices")
$chkDisableTelemetry = $window.FindName("chkDisableTelemetry")
$chkDisableCortana = $window.FindName("chkDisableCortana")
$txtStatus = $window.FindName("txtStatus")
$chkInstallIntelDrivers = $window.FindName("chkInstallIntelDrivers")
$chkInstallAMDDdrivers = $window.FindName("chkInstallAMDDdrivers")
$chkInstallChromium = $window.FindName("chkInstallChromium")

# Handle hyperlink navigation
$window.FindName("Hyperlink").RequestNavigate += {
    param($sender, $e)
    [System.Diagnostics.Process]::Start($e.Uri.AbsoluteUri)
    $e.Handled = $true
}

# Dynamically create checkboxes for each app
$appCheckboxes = @{}
foreach ($app in $appsList) {
    $checkBox = New-Object Windows.Controls.CheckBox
    $checkBox.Content = $app
    $checkBox.IsChecked = $false
    $appCheckBoxPanel.Children.Add($checkBox)
    $appCheckboxes[$app] = $checkBox
}

# Define event for button click
$btnRun.Add_Click({
    $txtStatus.Text = "Status: Running..."
    $removedApps = @()

    # Remove selected apps
    foreach ($app in $appCheckboxes.Keys) {
        if ($appCheckboxes[$app].IsChecked -eq $true) {
            $txtStatus.Text = "Status: Removing $app..."
            try {
                Get-AppxPackage -Name $app | Remove-AppxPackage -ErrorAction Stop
                Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ $app | Remove-AppxProvisionedPackage -Online -ErrorAction Stop
                $removedApps += $app
            } catch {
                $txtStatus.Text = "Status: $app could not be removed. Already removed or not found."
            }
        }
    }

    # Remove successfully deleted apps from the list
    foreach ($app in $removedApps) {
        $appCheckboxes[$app].IsChecked = $false
        $appCheckBoxPanel.Children.Remove($appCheckboxes[$app])
        $appCheckboxes.Remove($app)
    }

    if ($chkDisableServices.IsChecked -eq $true) {
        # Disable unnecessary services
        $txtStatus.Text = "Status: Disabling unnecessary services..."
        $services = @('DiagTrack', 'dmwappushservice', 'SysMain', 'RemoteRegistry', 'RetailDemo', 'XboxNetApiSvc')
        foreach ($service in $services) {
            Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
            Stop-Service -Name $service -ErrorAction SilentlyContinue
        }
    }

    if ($chkDisableTelemetry.IsChecked -eq $true) {
        # Disable telemetry
        $txtStatus.Text = "Status: Disabling telemetry..."
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name AllowTelemetry -Value 0
    }

    if ($chkDisableCortana.IsChecked -eq $true) {
        # Disable Cortana
        $txtStatus.Text = "Status: Disabling Cortana..."
        Stop-Process -Name Cortana -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name AllowCortana -Value 0
    }

    if ($chkInstallIntelDrivers.IsChecked -eq $true) {
        # Install Intel drivers
        $txtStatus.Text = "Status: Installing Intel drivers..."
        Start-Process "https://downloadcenter.intel.com/download/29945" -Wait
    }

    if ($chkInstallAMDDdrivers.IsChecked -eq $true) {
        # Install AMD drivers
        $txtStatus.Text = "Status: Installing AMD drivers..."
        Start-Process "https://www.amd.com/en/support" -Wait
    }

    if ($chkInstallChromium.IsChecked -eq $true) {
        # Install Chromium
        $txtStatus.Text = "Status: Installing Chromium..."
        Start-Process "https://www.google.com/chrome/?platform=win64" -Wait
    }

    $txtStatus.Text = "Status: Completed"
})

# Event for
# Event for Select All button
$btnSelectAll.Add_Click({
    foreach ($checkBox in $appCheckBoxPanel.Children) {
        if ($checkBox -is [Windows.Controls.CheckBox]) {
            $checkBox.IsChecked = $true
        }
    }
})

# Show the window
$window.ShowDialog() | Out-Null
