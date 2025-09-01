c:\app\lis\CONFIG.exe /S Output %1 
c:\app\lis\config.exe /S ConfirmOverwrite no 
c:\app\lis\config.exe /S ShowSaveAS never 
c:\app\lis\config.exe /S ShowSettings never 
c:\app\lis\config.exe /S ShowPDF no 
c:\app\lis\config.exe /S StatusFile c:\app\lis\bullzip.log
c:\app\lis\config.exe /S DisableOptionDialog yes
c:\app\lis\config.exe /S SuppressErrors yes
c:\app\lis\config.exe /S AppendIfExists no > %1.txt