@echo off
set "killerRoot=E:\Etc\WinKiller\"
net start trustedinstaller
"%killerRoot%RunasSystem64.exe" "%killerRoot%RunFromToken64.exe trustedinstaller.exe 1 %killerRoot%killem.bat"