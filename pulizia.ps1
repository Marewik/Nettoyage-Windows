# =====================================================================
# Script di pulizia di Windows silenzioso con riepilogo
# =====================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Memorizzazione dei risultati per il riepilogo
$summary = @()

# --- TEMP utente ---
Try {
    Get-ChildItem "$env:TEMP" -Recurse -Force -ErrorAction SilentlyContinue |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    $summary += "TEMP utente: pulito"
} Catch {
    $summary += "TEMP utente: errore"
}

# --- TEMP sistema ---
Try {
    Get-ChildItem "C:\Windows\Temp" -Recurse -Force -ErrorAction SilentlyContinue |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    $summary += "TEMP di sistema: pulito"
} Catch {
    $summary += "TEMP di sistema: errore"
}

# --- File di log e cache ---
$paths = @(
    "C:\Windows\SoftwareDistribution\Download",
    "C:\Windows\Logs",
    "C:\Windows\System32\LogFiles"
)
foreach ($path in $paths) {
    if (Test-Path $path) {
        Try {
            Get-ChildItem $path -Recurse -Force -ErrorAction SilentlyContinue |
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            $summary += "$path : pulito"
        } Catch {
            $summary += "$path : errore"
        }
    }
}

# --- DISM ---
Try {
    Dism.exe /Online /Cleanup-Image /StartComponentCleanup /Quiet
    $summary += "DISM: completato"
} Catch {
    $summary += "DISM: errore"
}

# --- SFC ---
Try {
    sfc /scannow
    $summary += "SFC: completato"
} Catch {
    $summary += "SFC: errore"
}

# --- Flush DNS ---
Try {
    ipconfig /flushdns
    $summary += "Cache DNS: svuotata"
} Catch {
    $summary += "Cache DNS: errore"
}

# --- Visualizzazione del riepilogo finale ---
Write-Host ""
Write-Host "=== Riepilogo della pulizia di Windows ==="
foreach ($line in $summary) {
    Write-Host $line
}
Write-Host ""
Write-Host "Si consiglia di riavviare per completare le eliminazioni."
Read-Host "Premere Invio per chiudere"
