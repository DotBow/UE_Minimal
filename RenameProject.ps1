# Parameters - change these as needed
$oldSubstring = "UE_Minimal"
$newSubstring = "Luna"
$extensions = @(".sln", ".uproject", ".cs", ".h", ".cpp")  # List your target extensions here

# Get the script's filename to exclude it from processing
$scriptFileName = $MyInvocation.MyCommand.Name

# Get all files in current directory and subdirectories
$files = Get-ChildItem -File -Recurse | Where-Object { $_.Name -ne $scriptFileName }

foreach ($file in $files) {
    # Check if the file extension matches your target list
    if ($extensions -contains $file.Extension.ToLower()) {
        # Replace in content
        $content = Get-Content -Path $file.FullName -Raw
        if ($content -like "*$oldSubstring*") {
            $newContent = $content -replace [regex]::Escape($oldSubstring), $newSubstring
            Set-Content -Path $file.FullName -Value $newContent
            Write-Host "Updated content in file: $($file.FullName)"
        }
    }

    # Check if filename contains the substring
    if ($file.Name -like "*$oldSubstring*") {
        $newFileName = $file.Name -replace [regex]::Escape($oldSubstring), $newSubstring
        $newFilePath = Join-Path -Path $file.DirectoryName -ChildPath $newFileName
        Rename-Item -Path $file.FullName -NewName $newFileName
        Write-Host "Renamed file: $($file.Name) -> $newFileName"
    }
}

# Process directories for renaming
$directories = Get-ChildItem -Directory -Recurse | Where-Object { $_.FullName -ne $scriptFileName }

foreach ($dir in $directories) {
    if ($dir.Name -like "*$oldSubstring*") {
        $newDirName = $dir.Name -replace [regex]::Escape($oldSubstring), $newSubstring
        $newDirPath = Join-Path -Path $dir.Parent.FullName -ChildPath $newDirName
        Rename-Item -Path $dir.FullName -NewName $newDirName
        Write-Host "Renamed folder: $($dir.FullName) -> $newDirPath"
    }
}
