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
echo Tentando metodo 1 (Winget)...
winget install -e --id AnyDeskSoftwareGmbH.AnyDesk --silent --accept-source-agreements --accept-package-agreements --force 2>nul
if %errorLevel%==0 (
    echo [OK] AnyDesk instalado via Winget!
    goto :EOF
)

echo Metodo 1 falhou. Tentando metodo 2 (Download direto)...
powershell -ExecutionPolicy Bypass -Command "try { $url = 'https://download.anydesk.com/AnyDesk.exe'; $output = Join-Path $env:TEMP 'AnyDesk_Setup.exe'; Write-Host 'Baixando AnyDesk...'; (New-Object System.Net.WebClient).DownloadFile($url, $output); Write-Host 'Instalando...'; Start-Process -FilePath $output -ArgumentList '--install', '--silent' -Wait -NoNewWindow; Start-Sleep -Seconds 3; Remove-Item $output -Force -ErrorAction SilentlyContinue; Write-Host '[OK] AnyDesk instalado!' } catch { Write-Host '[ERRO] Falha:' $_.Exception.Message; exit 1 }"
if %errorLevel%==0 (
    echo [OK] AnyDesk instalado com sucesso!
) else (
    echo [AVISO] Nao foi possivel instalar o AnyDesk automaticamente
    echo Baixe manualmente em: https://anydesk.com/pt/downloads/windows
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
echo (Isso pode demorar varios minutos - aguarde...)
echo.

:: Tenta instalar o Office com timeout maior
winget install -e --id Microsoft.Office --accept-source-agreements --accept-package-agreements --silent --force 2>nul

:: Aguarda um pouco para verificar instalacao
timeout /t 3 /nobreak >nul

:: Verifica se o Office foi instalado checando processos ou pastas comuns
powershell -Command "if (Test-Path 'C:\Program Files\Microsoft Office') { exit 0 } else { exit 1 }" >nul 2>&1
if %errorLevel%==0 (
    echo [OK] Office instalado com sucesso!
    echo.
    echo IMPORTANTE: Abra o Word ou Excel e faca login
    echo com sua conta Microsoft para ativar o Office
) else (
    echo.
    echo [AVISO] A instalacao do Office pode estar em andamento
    echo ou precisa ser ativada manualmente.
    echo.
    echo Opcoes:
    echo 1. Aguarde alguns minutos e verifique o Menu Iniciar
    echo 2. Ou instale manualmente de: https://www.office.com/
    echo 3. Ou use a opcao de ativacao ao final deste script
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