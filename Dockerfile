# Use the official PowerShell image as a parent image
FROM mcr.microsoft.com/powershell:latest

# Copy your PowerShell script into the container
COPY SyncFilesWithNAS.ps1 /SyncFilesWithNAS.ps1

# Define the entry point for the container
ENTRYPOINT ["pwsh", "-File", "/SyncFilesWithNAS.ps1"]
