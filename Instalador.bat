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
goto FIM

:MENU
echo.
set /p CHROME="Instalar Google Chrome? (S/N): "
if /i "%CHROME%"=="S" call :CHROME

set /p ANYDESK="Instalar AnyDesk? (S/N): "
if /i "%ANYDESK%"=="S" call :ANYDESK

set /p REVO="Instalar Revo Uninstaller? (S/N): "
if /i "%REVO%"=="S" call :REVO
goto FIM

:CHROME
echo.
echo [1/3] Instalando Google Chrome...
winget install -e --id Google.Chrome --silent --accept-source-agreements --accept-package-agreements
if %errorLevel%==0 (
    echo [OK] Chrome instalado!
) else (
    echo [AVISO] Erro ao instalar Chrome
)
goto :EOF

:ANYDESK
echo.
echo [2/3] Instalando AnyDesk...
echo Baixando instalador do AnyDesk...

:: Usa pasta Windows Temp em vez de user temp para evitar problemas com caracteres especiais
set "ANYDESK_TEMP=%SystemRoot%\Temp\AnyDesk_Setup.exe"

:: Baixa o AnyDesk direto do site oficial
powershell -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; try { Invoke-WebRequest -Uri 'https://download.anydesk.com/AnyDesk.exe' -OutFile '%ANYDESK_TEMP%' -UseBasicParsing; exit 0 } catch { exit 1 }"

if exist "%ANYDESK_TEMP%" (
    echo Instalando AnyDesk...
    start /wait "" "%ANYDESK_TEMP%" --install --silent --create-shortcuts --start-with-win
    timeout /t 3 /nobreak >nul
    echo [OK] AnyDesk instalado!
    del "%ANYDESK_TEMP%" /f /q 2>nul
) else (
    echo [ERRO] Falha ao baixar AnyDesk
    echo Baixe manualmente: https://anydesk.com/pt/downloads/windows
)
goto :EOF

:REVO
echo.
echo [3/3] Instalando Revo Uninstaller...
winget install -e --id RevoUninstaller.RevoUninstaller --silent --accept-source-agreements --accept-package-agreements
if %errorLevel%==0 (
    echo [OK] Revo Uninstaller instalado!
) else (
    echo [AVISO] Erro ao instalar Revo Uninstaller
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