# Nettoyage Windows

## Description
Script PowerShell pour nettoyer Windows silencieusement tout en générant un résumé final.  
Il supprime les fichiers temporaires, journaux, caches, et effectue les vérifications système avec DISM et SFC.  
Un résumé final est affiché et un redémarrage est conseillé pour finaliser le nettoyage.

---

## Contenu du script
Le script réalise les actions suivantes :

1. **TEMP utilisateur**  
   Supprime tout le contenu du dossier `%TEMP%`.

2. **TEMP système**  
   Supprime tout le contenu de `C:\Windows\Temp`.

3. **Fichiers journaux et caches**  
   Supprime le contenu des dossiers :
   - `C:\Windows\SoftwareDistribution\Download`
   - `C:\Windows\Logs`
   - `C:\Windows\System32\LogFiles`

4. **DISM, SFC et Flush DNS**  
   - Nettoyage des composants Windows via :
     ```powershell
     Dism.exe /Online /Cleanup-Image /StartComponentCleanup /Quiet
     ```  
   - Vérification et réparation des fichiers système :
     ```powershell
     sfc /scannow
     ```  
   - Vidage du cache DNS :
     ```powershell
     ipconfig /flushdns
     ```

---

À la fin du script, un résumé des opérations effectuées est affiché.  
Un redémarrage est conseillé pour appliquer complètement les changements.
