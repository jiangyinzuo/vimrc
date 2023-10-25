# Copied from vimrc
# Convert PowerPoint to PDF

param(
    [string]$inputFile
)

Add-Type -AssemblyName "Microsoft.Office.Interop.PowerPoint"
$PowerPoint = New-Object -ComObject "PowerPoint.Application"

# Load presentation
if (Test-Path $inputFile) {
    $Presentation = $PowerPoint.Presentations.Open($inputFile, $true, $true, $false)
} else {
    Write-Host "File not found: $inputFile"
    exit 1
}

# Check the total number of slides
$totalSlides = $Presentation.Slides.Count

# Enumerate through each slide and export
$slideIndex = 1
foreach ($Slide in $Presentation.Slides) {
    if ($totalSlides -eq 1) {
        $outputFile = [System.IO.Path]::GetFileNameWithoutExtension($inputFile)
    } else {
        $outputFile = [System.IO.Path]::GetFileNameWithoutExtension($inputFile) + "_slide" + $slideIndex
    }

    $Slide.Export([System.IO.Path]::Combine($pwd, "$outputFile.pdf"), "PDF")
    $slideIndex++
}

# Close presentation
$Presentation.Close()
$PowerPoint.Quit()

