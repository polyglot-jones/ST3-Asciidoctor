:: build_docx.bat -- Sublime Build script (Windows version) that exports AsciiDoc to DOCX.
::
:: To invoke this from inside a *.sublime-build file, use:
::
::     build_docx.bat $file_path $file_base_name

:: %1 = $file_path
:: %2 = $file_base_name

set WORKING_PATH=%1
set WORKING_PATH=%WORKING_PATH:"=%
set BASE_NAME=%2
set BASE_NAME=%BASE_NAME:"=%

set DATA_DIR=.\config\pandoc
set SOURCE_FILE=%BASE_NAME%.adoc
set DEST_FILE=%BASE_NAME%.docx
set DOCBOOK_FILE=%BASE_NAME%.xml

:: echo Parameter 1 = %1
:: echo Parameter 2 = %2
:: echo SOURCE_FILE = %SOURCE_FILE%
:: echo DOCBOOK_FILE = %DOCBOOK_FILE%
:: echo Pandoc reference document = "%DATA_DIR%\reference.docx"

del /Q /F "%TEMP%\%2.*"
del /Q /F "%WORKING_PATH%\%DEST_FILE%"

call asciidoctor -b docbook -o "%TEMP%\%DOCBOOK_FILE%" "%SOURCE_FILE%"

if exist "%DATA_DIR%\reference.docx" (
	pandoc -f docbook --data-dir="%DATA_DIR%" -t docx -o %TEMP%\%2.docx "%TEMP%\%DOCBOOK_FILE%"
) else (
	pandoc -f docbook -t docx -o "%TEMP%\%DEST_FILE%" "%TEMP%\%DOCBOOK_FILE%"
)

if exist "%TEMP%\%2.docx" (
	move /Y "%TEMP%\%DEST_FILE%" "%WORKING_PATH%"
)
if exist "%WORKING_PATH%\%DEST_FILE%" (
	"%WORKING_PATH%\%DEST_FILE%"
)

