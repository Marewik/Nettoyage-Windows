# Pulizia di Windows

## Descrizione
Script PowerShell per pulire Windows in modalità silenziosa mostrando un riepilogo.  
Elimina file temporanei, log, cache e controlla il sistema con DISM e SFC.  
Alla fine viene mostrato un riepilogo e si consiglia il riavvio per completare la pulizia.

---

## Contenuto dello script
Lo script esegue le seguenti azioni:

1. **TEMP utente**  
   Elimina tutti i file nella cartella `%TEMP%`.

2. **TEMP di sistema**  
   Elimina tutti i file in `C:\Windows\Temp`.

3. **File di log e cache**  
   Elimina il contenuto delle cartelle:
   - `C:\Windows\SoftwareDistribution\Download`
   - `C:\Windows\Logs`
   - `C:\Windows\System32\LogFiles`

4. **DISM**  
   Pulizia dei componenti di Windows:
   ```powershell
   Dism.exe /Online /Cleanup-Image /StartComponentCleanup /Quiet
