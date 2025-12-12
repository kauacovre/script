@echo off
title Instalador Star - Configuracao Automatica
color 0A

echo ========================================
echo    INSTALADOR STAR
echo    Configuracao Automatica de Notebooks
echo ========================================
echo.
echo Verificando permissoes...

:: Verifica se esta como administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0C
    echo.
    echo ERRO: Precisa executar como Administrador!
    echo.
    echo Clique com botao direito neste arquivo
    echo e escolha "Executar como administrador"
    echo.
    pause
    exit
)

echo [OK] Executando como Administrador
echo.

:: Pergunta se quer instalar tudo
echo Programas que serao instalados:
echo  - Google Chrome
echo  - AnyDesk
echo  - Revo Uninstaller
echo  - Microsoft Office
echo.
set /p OPCAO="Instalar todos os programas? (S/N): "

if /i "%OPCAO%"=="S" (
    goto INSTALAR_TUDO
) else (
    goto MENU
)

:INSTALAR_TUDO
echo.
echo ========================================
echo Instalando todos os programas...
echo ========================================
call :CHROME
call :ANYDESK
call :REVO
call :OFFICE
goto FIM

:MENU
echo.
set /p CHROME="Instalar Google Chrome? (S/N): "
if /i "%CHROME%"=="S" call :CHROME

set /p ANYDESK="Instalar AnyDesk? (S/N): "
if /i "%ANYDESK%"=="S" call :ANYDESK

set /p REVO="Instalar Revo Uninstaller? (S/N): "
if /i "%REVO%"=="S" call :REVO

set /p OFFICE="Instalar Microsoft Office? (S/N): "
if /i "%OFFICE%"=="S" call :OFFICE
goto FIM

:CHROME
echo.
echo [1/4] Instalando Google Chrome...
winget install -e --id Google.Chrome --silent --accept-source-agreements --accept-package-agreements
if %errorLevel%==0 (
    echo [OK] Chrome instalado!
) else (
    echo [AVISO] Erro ao instalar Chrome
)
goto :EOF

:ANYDESK
echo.
echo [2/4] Instalando AnyDesk...
winget install -e --id AnyDeskSoftwareGmbH.AnyDesk --silent --accept-source-agreements --accept-package-agreements
if %errorLevel%==0 (
    echo [OK] AnyDesk instalado!
) else (
    echo [AVISO] Tentando metodo alternativo...
    powershell -Command "& {Invoke-WebRequest -Uri 'https://download.anydesk.com/AnyDesk.exe' -OutFile '$env:TEMP\AnyDesk.exe'; Start-Process -FilePath '$env:TEMP\AnyDesk.exe' -ArgumentList '--install','--silent' -Wait; Remove-Item '$env:TEMP\AnyDesk.exe' -Force}"
    echo [OK] AnyDesk instalado!
)
goto :EOF

:REVO
echo.
echo [3/4] Instalando Revo Uninstaller...
winget install -e --id RevoUninstaller.RevoUninstaller --silent --accept-source-agreements --accept-package-agreements
if %errorLevel%==0 (
    echo [OK] Revo Uninstaller instalado!
) else (
    echo [AVISO] Erro ao instalar Revo Uninstaller
)
goto :EOF

:OFFICE
echo.
echo [4/4] Instalando Microsoft Office...
echo (Isso pode demorar varios minutos)
winget install -e --id Microsoft.Office --silent --accept-source-agreements --accept-package-agreements
if %errorLevel%==0 (
    echo [OK] Office instalado!
    echo.
    echo IMPORTANTE: Abra o Word ou Excel e faca login
    echo com sua conta Microsoft para ativar o Office
) else (
    echo [AVISO] Erro ao instalar Office
)
goto :EOF

:FIM
echo.
echo ========================================
echo     INSTALACAO CONCLUIDA!
echo ========================================
echo.
echo Todos os programas foram instalados.
echo.

:: Pergunta se deseja ativar
set /p ATIVAR="Deseja ativar o Windows/Office? (S/N): "

if /i "%ATIVAR%"=="S" (
    echo.
    echo ========================================
    echo     ATIVANDO WINDOWS/OFFICE
    echo ========================================
    echo.
    echo Iniciando ferramenta de ativacao...
    echo.
    
    :: Executa diretamente o comando de ativacao
    powershell -ExecutionPolicy Bypass -Command "irm https://get.activated.win | iex"
    
    echo.
    echo Ativacao concluida!
    echo.
) else (
    echo.
    echo Ativacao ignorada.
    echo.
)

echo Voce pode fechar esta janela.
echo.
pause
exit