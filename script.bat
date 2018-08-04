@echo off
cls

@echo ---------------  WLAN SAVED PASSWORDS EXTRACTOR  ---------------
@echo I                        Created by SOS                        I
@echo I                                                              I
@echo I The author is not responsable of the bad uses of this script I
@echo I                                                              I
@echo I                           Thanks!                            I
@echo ----------------------------------------------------------------
@echo.

rem VARIABLES
set auxname=auxiliar
set filename=%computername%-%username%

@echo Searching content in %filename%, wait...
@echo.

netsh wlan show profile | findstr /I /C:": " > %auxname%.txt

call :addHeader

timeout 2 > NUL

@echo Profiles found:
netsh wlan show profile | findstr /I /C:": "
@echo.
@echo.
@echo Extracting content...
@echo.

rem Looping wlan profiles
FOR /f "delims=" %%p IN (%auxname%.txt) DO (
    call :addProfile "%%p"
)
goto :end


rem FUNCTIONS  -----------------------------------

:addProfile
    rem Save parameter in _profile variable
    SET "_profile=%~1"
    rem Extract name of the profile string
    SET _name=%_profile:~39,150%
    @echo Getting information of %_name% ...
    @echo. Profile: %_name% >> %filename%.txt
    netsh wlan show profile "%_name%" key = clear | findstr /I /C:"contenido de la clave" >> %filename%.txt
    @echo. >> %filename%.txt
    @echo. Done!
    goto :eof

:addHeader
    @echo --------------------------------- > %filename%.txt
    @echo Comupter Name: %computername% >> %filename%.txt
    @echo Domain: %userdomain% >> %filename%.txt
    @echo User: %username% >> %filename%.txt
    @echo --------------------------------- >> %filename%.txt
    @echo. >> %filename%.txt
    @echo WLAN PROFILES AND PASSWORDS: >> %filename%.txt
    @echo --------------------------------- >> %filename%.txt
    goto :eof


:end
@echo.
@echo Wlan passwords extracted succesfully!
@echo.
@echo Deleting auxiliar files..
del %auxname%.txt
timeout 1 > NUL