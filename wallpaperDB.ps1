# User Input Section
$ErrorActionPreference = "Stop" # This will make errors visible

# How often to change wallpaper (Example: In Minutes) - Get input as string
$changeIntervalInput = Read-Host "Enter wallpaper change interval (in minutes)" 

# Convert input to integer
$changeInterval = [int]::Parse($changeIntervalInput)

# Function to create a scheduled task 
function Create-WallpaperTask {
    $taskName = "Wallpaper Changer"
    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File C:\path\to\wallpaper.ps1" 
    $trigger = New-ScheduledTaskTrigger -Daily -At (Get-Date).ToString("hh:mm tt") # Triggers daily at a set time

    # Check if a task with the same name already exists
    if (-not (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue)) {
        # Task does not exist, so create it
        Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action 
    } else {
        Write-Host "Task with name '$taskName' already exists. Please choose a different name."
    }
}

# Ask user if they want to schedule the task
$scheduleTaskInput = Read-Host "Do you want to schedule the task? (y/n)"

# Set $scheduleTask variable based on user input
if ($scheduleTaskInput -eq "y") {
    $scheduleTask = $true
} else {
    $scheduleTask = $false
}

# If scheduling is requested, create the task
if ($scheduleTask) {
    Create-WallpaperTask # Call the function to create the scheduled task
} else {
    Write-Host "Task scheduling skipped."
    return  # Terminate the script if task scheduling is skipped
}

# Image URLs (Your image list)
$imageUrls = @(
    "https://images.pexels.com/photos/2959611/pexels-photo-2959611.jpeg?auto=compress&cs=tinysrgb&w=600", 
    "https://images.pexels.com/photos/209943/pexels-photo-209943.jpeg?auto=compress&cs=tinysrgb&w=600",
    "https://images.pexels.com/photos/1230688/pexels-photo-1230688.jpeg?auto=compress&cs=tinysrgb&w=600", 
    "https://images.pexels.com/photos/804573/pexels-photo-804573.jpeg?auto=compress&cs=tinysrgb&w=600",
    "https://images.pexels.com/photos/848599/pexels-photo-848599.jpeg?auto=compress&cs=tinysrgb&w=600" 
)

# Functions

# Function to set the desktop wallpaper 
function Set-DesktopWallpaper {
    param (
        [string]$imagePath
    )
    Write-Host "Setting wallpaper to: $imagePath"
    
    # Load the required assembly for SystemParametersInfo
    Add-Type -AssemblyName System.Drawing

    # Constants for SystemParametersInfo call
    $SPI_SETDESKWALLPAPER = 20
    $SPIF_UPDATEINIFILE = 0x01
    $SPIF_SENDWININICHANGE = 0x02

    # Call SystemParametersInfo to set the wallpaper
    Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        public class Wallpaper {
            [DllImport("user32.dll", CharSet = CharSet.Auto)]
            public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
        }
"@

    # Download the image from the web
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($imagePath, "wallpaper.jpg")
    $imagePath = "$pwd\wallpaper.jpg" # Path to the downloaded image

    # Set the downloaded image as wallpaper
    [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $imagePath, $SPIF_UPDATEINIFILE)
}

# Main Logic
$currentIndex = 0
while ($true) {
    # Get the current image URL
    $currentImageUrl = $imageUrls[$currentIndex]

    # Call the Set-DesktopWallpaper function with $currentImageUrl
    Set-DesktopWallpaper -imagePath $currentImageUrl

    # Increment the index (loop back to 0 if it exceeds the array length)
    $currentIndex = ($currentIndex + 1) % $imageUrls.Length

    # Wait for the specified interval before changing the wallpaper again
    Start-Sleep -Seconds ($changeInterval * 60)
}