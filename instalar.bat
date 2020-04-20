REM uso: probar.bat [carpetaProyecto] [server] [usuario] [password] [baseDeDatos] 
if "%5"=="" goto error
sqlcmd -S %2\sqlexpress -U %3 -P %4 -Q "create database %5;"
for /f "delims=*" %%i in ('dir /A-D /S /b /on /x %1\DDL\*.sql') do (sqlcmd -S %2\sqlexpress -U %3 -P %4 -d %5 -i "%%i")
for /f "delims=*" %%i in ('dir /A-D /S /b /on /x %1\desarrollo\*.sql') do (sqlcmd -S %2\sqlexpress -U %3 -P %4 -d %5 -i "%%i")

goto eof
:error
echo uso: %0 [carpetaProyecto] [server] [usuario] [password] [baseDeDatos]

:eof
