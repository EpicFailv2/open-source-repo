@echo off
:start
cls

net stop wuauserv
sc config wuauserv start=disabled

net stop WaaSMedicSvc
sc config WaaSMedicSvc start=disabled

net stop UsoSvc
sc config UsoSvc start=disabled

schtasks /delete /tn "Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /f
schtasks /delete /tn "Microsoft\Windows\UpdateOrchestrator\Schedule Retry Scan" /f
schtasks /delete /tn "Microsoft\Windows\UpdateOrchestrator\Reboot" /f
schtasks /delete /tn "Microsoft\Windows\UpdateOrchestrator\USO_Broker_Display" /f
schtasks /delete /tn "Microsoft\Windows\WaaSMedic\PerformRemediation" /f
schtasks /delete /tn "Microsoft\Windows\WindowsUpdate\Scheduled Start" /f

timeout 5
goto start