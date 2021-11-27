' If you want to run backup process in background mode
Set WshShell = CreateObject("WScript.Shell" )
WshShell.Run "[Full_Path_To_Bat_File_Folder]\backup.bat", 0 
