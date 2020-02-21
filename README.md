# RemoteApp-RDS-Maintenance
Script PowerShell for set in maintenance RemoteApp in RDS FARM Windows

## Description

### French
Ce script permet de mettre en maintenance une application publiée par les RemoteApp sur un déploiement de ferme RDS.
Le script change le chemin de l'execuration par un fichier fictif, ce qui empeche toute execution du programme.
Au lancement le script créé un sauvegarde de la configuration des RemoteApp dans C:\ProgramData
Avant le changement de configuration, les informations de l'application sont stockées en base de registre, ces informations sont utilisées pour la sortie du mode maintenance.

### English
This script is used to maintain an application published by RemoteApps on an RDS farm deployment.
The script changes the execution path to a dummy file, which prevents any execution of the program.
At launch the script creates a backup of the RemoteApp configuration in C:\ProgramData
Before the configuration change, the application information is stored in the registry, this information is used for exiting maintenance mode.