# =====================================================================
# Script de nettoyage Windows silencieux avec résumé
# =====================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Stockage des résultats pour le résumé
$summary = @()

# --- TEMP utilisateur ---
Try {
    Get-ChildItem "$env:TEMP" -Recurse -Force -ErrorAction SilentlyContinue |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    $summary += "TEMP utilisateur : nettoyé"
} Catch {
    $summary += "TEMP utilisateur : échec"
}

# --- TEMP système ---
Try {
    Get-ChildItem "C:\Windows\Temp" -Recurse -Force -ErrorAction SilentlyContinue |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    $summary += "TEMP système : nettoyé"
} Catch {
    $summary += "TEMP système : échec"
}

# --- Fichiers journaux et caches ---
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
            $summary += "$path : nettoyé"
        } Catch {
            $summary += "$path : échec"
        }
    }
}

# --- DISM ---
Try {
    Dism.exe /Online /Cleanup-Image /StartComponentCleanup /Quiet
    $summary += "DISM : terminé"
} Catch {
    $summary += "DISM : échec"
}

# --- SFC ---
Try {
    sfc /scannow
    $summary += "SFC : terminé"
} Catch {
    $summary += "SFC : échec"
}

# --- Flush DNS ---
Try {
    ipconfig /flushdns
    $summary += "Cache DNS : vidé"
} Catch {
    $summary += "Cache DNS : échec"
}

# --- Affichage du résumé final ---
Write-Host ""
Write-Host "=== Résumé du nettoyage Windows ==="
foreach ($line in $summary) {
    Write-Host $line
}
Write-Host ""
Write-Host "Redémarrage conseillé pour finaliser les suppressions."
Read-Host "Appuyez sur Entrée pour fermer"
