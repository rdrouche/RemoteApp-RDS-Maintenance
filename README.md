# RemoteApp-RDS-Maintenance
Script PowerShell for set in maintenance RemoteApp in RDS FARM Windows

## Description

### French
Ce script permet de mettre en maintenance une application publiée par les RemoteApp sur un déploiement de ferme RDS à l'aide d'une interface graphique.
Le script change le chemin de l'execuration par un fichier fictif, ce qui empeche toute execution du programme.
Au lancement le script créé un sauvegarde de la configuration des RemoteApp dans C:\ProgramData
Avant le changement de configuration, les informations de l'application sont stockées en base de registre, ces informations sont utilisées pour la sortie du mode maintenance.

### English
This script is used to maintain an application published by RemoteApps on an RDS farm deployment using a graphical interface.
The script changes the execution path to a dummy file, which prevents any execution of the program.
At launch the script creates a backup of the RemoteApp configuration in C:\ProgramData
Before the configuration change, the application information is stored in the registry, this information is used for exiting maintenance mode.

## Utilisation / Use

### French
#### Mise en maintenance
1. Depuis le serveur broker, executer le fichier RemoteApp-RDS-Maintenance.ps1 depuis une invite de commande PowerShell ou ISE en Administrateur
2. Choisir l'application à mettre en maintenance et cliquer sur le bouton Mettre en maintenance
#### Sortie de la maintenance
1. Depuis le serveur broker, executer le fichier RemoteApp-RDS-Maintenance.ps1 depuis une invite de commande PowerShell ou ISE en Administrateur
2. Choisir l'application à sortie de la maintenance et cliquer sur le bouton Mettre en service

### English
#### Maintenance
1. From the broker server, execute the RemoteApp-RDS-Maintenance.ps1 file from a PowerShell or ISE command prompt in Administrator
2. Choose the application to be maintained and click on the button Mettre en maintenance
#### Exit Maintenance
1. From the broker server, execute the RemoteApp-RDS-Maintenance.ps1 file from a PowerShell or ISE command prompt in Administrator
2. Choose the application after maintenance and click on the button Mettre en service

## Capture / Screenshot