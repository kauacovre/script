# Instalador de Programas - Star
# Execute este script como Administrador

# Função para limpar a tela
function Limpar-Tela {
    Clear-Host
}

# Função para perguntar Sim/Não
function Perguntar {
    param([string]$mensagem)
    
    while ($true) {
        $resposta = Read-Host "$mensagem (s/n)"
        $resposta = $resposta.ToLower().Trim()
        
        if ($resposta -in @('s', 'sim', 'y', 'yes')) {
            return $true
        }
        elseif ($resposta -in @('n', 'nao', 'não', 'no')) {
            return $false
        }
        else {
            Write-Host "Resposta inválida. Use 's' para sim ou 'n' para não." -ForegroundColor Yellow
        }
    }
}

# Função para instalar Google Chrome
function Instalar-GoogleChrome {
    Write-Host "`n=== Instalando Google Chrome ===" -ForegroundColor Cyan
    try {
        winget install --id=Google.Chrome -e --accept-source-agreements --accept-package-agreements --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Google Chrome instalado com sucesso!" -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "✗ Erro ao instalar Google Chrome" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "✗ Erro: $_" -ForegroundColor Red
        return $false
    }
}

# Função para instalar AnyDesk
function Instalar-AnyDesk {
    Write-Host "`n=== Instalando AnyDesk ===" -ForegroundColor Cyan
    
    # Método 1: Tentar com o ID principal
    Write-Host "Tentando instalação (Método 1)..." -ForegroundColor Yellow
    try {
        winget install --id=AnyDeskSoftwareGmbH.AnyDesk -e --accept-source-agreements --accept-package-agreements --force --silent 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ AnyDesk instalado com sucesso!" -ForegroundColor Green
            return $true
        }
    }
    catch { }
    
    # Método 2: Tentar com ID alternativo
    Write-Host "Tentando instalação (Método 2)..." -ForegroundColor Yellow
    try {
        winget install AnyDesk.AnyDesk --accept-source-agreements --accept-package-agreements --force --silent 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ AnyDesk instalado com sucesso!" -ForegroundColor Green
            return $true
        }
    }
    catch { }
    
    # Método 3: Download direto
    Write-Host "Tentando instalação (Método 3 - Download direto)..." -ForegroundColor Yellow
    try {
        $url = "https://download.anydesk.com/AnyDesk.exe"
        $instalador = "$env:TEMP\AnyDesk.exe"
        
        Write-Host "   Baixando AnyDesk..." -ForegroundColor Gray
        Invoke-WebRequest -Uri $url -OutFile $instalador -UseBasicParsing
        
        Write-Host "   Executando instalador..." -ForegroundColor Gray
        Start-Process -FilePath $instalador -ArgumentList "--install", "--silent" -Wait -NoNewWindow
        
        # Remove instalador temporário
        Remove-Item $instalador -Force -ErrorAction SilentlyContinue
        
        Write-Host "✓ AnyDesk instalado com sucesso!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "✗ Erro no método 3: $_" -ForegroundColor Red
    }
    
    Write-Host "✗ Não foi possível instalar o AnyDesk automaticamente" -ForegroundColor Red
    Write-Host "   Baixe manualmente em: https://anydesk.com/pt/downloads/windows" -ForegroundColor Yellow
    return $false
}

# Função para instalar Revo Uninstaller
function Instalar-RevoUninstaller {
    Write-Host "`n=== Instalando Revo Uninstaller ===" -ForegroundColor Cyan
    try {
        winget install --id=RevoUninstaller.RevoUninstaller -e --accept-source-agreements --accept-package-agreements --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Revo Uninstaller instalado com sucesso!" -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "✗ Erro ao instalar Revo Uninstaller" -ForegroundColor Red
            Write-Host "   Tente instalar manualmente de: https://www.revouninstaller.com/" -ForegroundColor Yellow
            return $false
        }
    }
    catch {
        Write-Host "✗ Erro: $_" -ForegroundColor Red
        return $false
    }
}

# Função para instalar Microsoft Office
function Instalar-Office {
    Write-Host "`n=== Instalando Microsoft Office ===" -ForegroundColor Cyan
    Write-Host "Nota: É necessária uma licença válida do Microsoft 365 ou Office" -ForegroundColor Yellow
    try {
        winget install --id=Microsoft.Office -e --accept-source-agreements --accept-package-agreements --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Microsoft Office instalado com sucesso!" -ForegroundColor Green
            Write-Host "   Faça login com sua conta Microsoft para ativar" -ForegroundColor Cyan
            return $true
        }
        else {
            Write-Host "✗ Erro ao instalar Microsoft Office" -ForegroundColor Red
            Write-Host "   Certifique-se de ter uma licença válida" -ForegroundColor Yellow
            return $false
        }
    }
    catch {
        Write-Host "✗ Erro: $_" -ForegroundColor Red
        return $false
    }
}

# Função principal
function Main {
    Limpar-Tela
    
    # Verifica se está rodando como administrador
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-Host "================================================" -ForegroundColor Red
        Write-Host "AVISO: Execute como Administrador!" -ForegroundColor Red
        Write-Host "================================================" -ForegroundColor Red
        Write-Host "Clique com botão direito no PowerShell e escolha 'Executar como administrador'" -ForegroundColor Yellow
        Write-Host ""
        Read-Host "Pressione ENTER para continuar mesmo assim"
        Limpar-Tela
    }
    
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "       INSTALADOR DE PROGRAMAS - STAR" -ForegroundColor White
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Programas disponíveis:" -ForegroundColor White
    Write-Host "1. Google Chrome" -ForegroundColor Gray
    Write-Host "2. AnyDesk" -ForegroundColor Gray
    Write-Host "3. Revo Uninstaller" -ForegroundColor Gray
    Write-Host "4. Microsoft Office" -ForegroundColor Gray
    Write-Host ""
    
    # Pergunta se quer instalar todos
    $instalarTodos = Perguntar "Deseja instalar TODOS os programas?"
    
    $programas = @{
        'Google Chrome' = ${function:Instalar-GoogleChrome}
        'AnyDesk' = ${function:Instalar-AnyDesk}
        'Revo Uninstaller' = ${function:Instalar-RevoUninstaller}
        'Microsoft Office' = ${function:Instalar-Office}
    }
    
    if ($instalarTodos) {
        Write-Host "`n>>> Instalando todos os programas...`n" -ForegroundColor Green
        foreach ($programa in $programas.Keys) {
            & $programas[$programa]
        }
    }
    else {
        # Pergunta individualmente
        foreach ($programa in $programas.Keys) {
            if (Perguntar "`nDeseja instalar $programa?") {
                & $programas[$programa]
            }
            else {
                Write-Host "⊘ $programa - Instalação pulada" -ForegroundColor Yellow
            }
        }
    }
    
    Write-Host "`n==================================================" -ForegroundColor Cyan
    Write-Host "           INSTALAÇÃO CONCLUÍDA!" -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
}

# Executa o script
Main