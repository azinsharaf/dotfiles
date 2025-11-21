
param([string]$file)

# Handle directories
if (Test-Path $file -PathType Container) {
    Write-Output " Directory:`n"
    Get-ChildItem $file | Select-Object Name, Length, Mode
    exit
}

# Detect file extension
$ext = [System.IO.Path]::GetExtension($file).ToLower()

switch ($ext) {
    # Images (jpg, png, gif...)
    ".jpg"  { chafa $file; exit }
    ".jpeg" { chafa $file; exit }
    ".png"  { chafa $file; exit }
    ".gif"  { chafa $file; exit }
    ".bmp"  { chafa $file; exit }
    ".webp" { chafa $file; exit }

    # PDF
    ".pdf" {
        Write-Output " PDF File`n"
        pdftotext $file - | bat --color always --language=markdown
        exit
    }

    # Markdown
    ".md" {
        Write-Output " Markdown Preview:`n"
        bat --style=plain --color=always $file
        exit
    }

    # JSON
    ".json" {
        Write-Output " JSON:`n"
        Get-Content $file | python -m json.tool | bat --color=always --language=json
        exit
    }

    # Code files
    ".py"  { bat --color=always $file; exit }
    ".js"  { bat --color=always $file; exit }
    ".ts"  { bat --color=always $file; exit }
    ".rs"  { bat --color=always $file; exit }
    ".go"  { bat --color=always $file; exit }
    ".cpp" { bat --color=always $file; exit }
    ".c"   { bat --color=always $file; exit }
    ".cs"  { bat --color=always $file; exit }
    ".html"{ bat --color=always $file; exit }
    ".css" { bat --color=always $file; exit }

    default {
        bat --color=always $file
    }
}
