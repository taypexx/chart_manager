set buildraw=build/raw
set buildpath=build/compiled
set innosetup="C:/Program Files/Inno Setup 5/Compil32.exe"

rd /q /s "%buildraw%"
rd /q /s "%buildpath%"

mkdir "%buildraw%"
mkdir "%buildpath%"

copy "main.lua" "%buildraw%"
copy "icon.ico" "%buildraw%"
mkdir "%buildraw%/libs"
robocopy /s "libs" "%buildraw%/libs"
mkdir "%buildraw%/modes"
robocopy /s "modes" "%buildraw%/modes"
mkdir "%buildraw%/lang"
robocopy /s "lang" "%buildraw%/lang"

rtc -w -i "icon.ico" -o "%buildpath%/chart_manager.exe" -lnet "%buildraw%" main.lua

copy "CHANGELOG.md" "%buildpath%"
copy "icon.ico" "%buildpath%"
copy "LICENSE" "%buildpath%"
copy "lua54.dll" "%buildpath%"
copy "README.md" "%buildpath%"
copy "settings.json" "%buildpath%"
copy "version" "%buildpath%"
mkdir "%buildpath%/py"
robocopy /s "py" "%buildpath%/py" *.exe
mkdir "%buildpath%/template"
robocopy /s "template" "%buildpath%/template"
mkdir "%buildpath%/assets"
robocopy /s "assets" "%buildpath%/assets"

%innosetup% /cc "setup.iss"

echo Build success
pause