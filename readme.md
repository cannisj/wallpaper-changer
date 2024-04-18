Project Description

This PowerShell project provides a simple solution to automatically change your desktop wallpaper at a specified interval. It fetches images from provided URLs and updates your wallpaper accordingly.

Dependencies

PowerShell (Version 5.1 or newer is recommended for compatibility)
Internet connection to download images
Setup

Save Files: Save the code as a PowerShell script (.ps1 file), for example, wallpaper-changer.ps1.
Edit Image URLs: Within the script, modify the $imageUrls array to include the URLs of the images you'd like to use for your wallpapers.
Usage

Run the Script: Execute the PowerShell script from a PowerShell terminal (e.g., ./wallpaper-changer.ps1).
Specify Interval: The script will ask you to enter how frequently you want the wallpaper to change (in minutes).
Schedule (Optional):
The script will ask if you'd like to create a scheduled task. Choose "y" to automatically run the script daily at a set time.
If you choose not to schedule the task, the script will continue to run and change the wallpaper until you stop it.
Stopping the Task

Press Ctrl + C in the PowerShell terminal where the script is running to terminate the process.

Customization

Image Sources: Replace the image URLs within the $imageUrls array with your preferred image links. You can use links to online image sources.
Timing: Modify the $changeInterval variable to adjust how often the wallpaper changes.
Notes

Scheduled Task: If you choose to create a scheduled task, you can manage it from the Windows Task Scheduler.
System Requirements: The script should work on Windows systems with PowerShell installed.