"c:\Server\bin\mysql\bin\mysqldump.exe"  --defaults-extra-file="c:\Server\data\htdocs\www\config.cnf" your_db_name > "c:\Server\data\htdocs\www\your_db_name.sql"
"c:\Server\bin\mysql\bin\mysqldump.exe"  --defaults-extra-file="c:\Server\data\htdocs\www\config.cnf" --no-data your_db_name > "c:\Server\data\htdocs\www\your_db_structure_name.sql"

set BackupName="server.zip"
set BackupPath="c:\Backups\Server\"
set TargetPath="c:\Server\data\htdocs\www\"
set /A BackupsCount=5
set /A BackupsCountNext=BackupsCount+1

SET j=1
FOR /L %%A IN (1,1,%BackupsCount%) DO (
  if /i exist %BackupPath%%%A"_"%BackupName% (
    set /a j+=1
  )
)

SetLocal EnableDelayedExpansion

if %j% LSS %BackupsCountNext% (
  "C:\Program Files\7-Zip\7z.exe" a -tzip -ssw -mx1 -r0 %BackupPath%%j%"_"%BackupName% %TargetPath%
) else (
  FOR /L %%A IN (1,1,%BackupsCount%) DO (
    if %%A==1 (
      erase %BackupPath%%%A"_"%BackupName%
    ) else (
      Set /A n=%%A-1
      copy %BackupPath%%%A"_"%BackupName% %BackupPath%"!n!"_"%BackupName%
    )
  )

  erase %BackupPath%%BackupsCount%"_"%BackupName%

  "C:\Program Files\7-Zip\7z.exe" a -tzip -ssw -mx1 -r0 %BackupPath%%BackupsCount%"_"%BackupName% %TargetPath%
)

set FileNumber=%BackupsCount%
if %j% LSS %BackupsCountNext% (
  set FileNumber=%j%
)

SET Final=%BackupPath%%FileNumber%_%BackupName%
SET Final=%Final:"=%

for /f %%i in ("%Final%") do set CurrentVolume=%%~zi

curl "https://api.telegram.org/bot[BOT:TOKEN]/sendMessage?chat_id=-[Chat ID]&parse_mode=html&text=<b>\[LeonidKoshcheev\]</b> Backup %Final% is done. File size: <b>%CurrentVolume%b</b>"
