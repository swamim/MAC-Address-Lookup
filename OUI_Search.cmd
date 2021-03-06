@echo off

rem =====
rem For more information on ScriptTiger and more ScriptTiger scripts visit the following URL:
rem https://scripttiger.github.io/
rem Or visit the following URL for the latest information on this ScriptTiger script:
rem https://github.com/ScriptTiger/MAC-Address-Lookup
rem =====

rem Set SIMPLE to 0 to use master.txt and 1 to use simplified.txt
set SIMPLE=0

rem Set OUI lookup table file path and adjust the search format 
if %SIMPLE%==0 (
	set MASTER=%~dp0master.txt
	if not "%~1"=="" set SEARCH=%~1&set FORMAT="tokens=3 delims={}"&goto MAC_Search
) else (
	set MASTER=%~dp0simplified.txt
	if not "%~1"=="" set SEARCH=%~1&set FORMAT="tokens=2 delims={}"&goto MAC_Search
)

rem Interactive mode prompt
:Choice

rem Exit if not in interactive mode
if not "%~1"=="" exit /b

set FORMAT="tokens=*"
choice /m "Reverse search by company keywords?"
if %ERRORLEVEL%==1 goto Company_Search

:MAC_Input
set /p SEARCH=MAC address: || exit /b

rem Get rid of extra characters before searching
:MAC_Search
set SEARCH=%SEARCH::=%
set SEARCH=%SEARCH:-=%

rem Search the MA-S block entries

for /f %FORMAT% %%0 in ('findstr /r /i "[{]%SEARCH:~,9%[}][{]" %MASTER%') do echo %%0&goto Choice

rem Search the MA-M block entries

for /f %FORMAT% %%0 in ('findstr /r /i "[{]%SEARCH:~,7%[}][{]" %MASTER%') do echo %%0&goto Choice

rem Search the MA-L block entries

for /f %FORMAT% %%0 in ('findstr /r /i "[{]%SEARCH:~,6%[}][{]" %MASTER%') do echo %%0&goto Choice

rem Return a response if no results found

echo Unregistered OUI
goto Choice

rem Search by company information and not strictly by mac address
:Company_Search
set /p SEARCH=Company keywords: || exit /b
findstr /r /i "%SEARCH%" %MASTER% | more
goto Choice