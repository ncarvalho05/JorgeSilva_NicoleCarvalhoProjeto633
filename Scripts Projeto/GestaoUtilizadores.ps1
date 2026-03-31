Clear-Host
Write-Host "--- GESTÃO DE UTILIZADORES ---" -ForegroundColor Yellow

Write-Host "1. Criar Utilizador`n2. Remover Utilizador`n3. Listar Utilizadores"

$op = Read-Host "Opção"

if ($op -eq "1") {

    $user = Read-Host "Nome do Utilizador"

    $pass = Read-Host "Password" -AsSecureString

    try {

        New-LocalUser -Name $user -Password $pass -FullName $user -Description "Conta criada via Script" -ErrorAction Stop

        Enable-LocalUser -Name $user

        Add-LocalGroupMember -Group "Administrators" -Member $user -ErrorAction SilentlyContinue

        Add-LocalGroupMember -Group "Administrators" -Member $user -ErrorAction SilentlyContinue

        Write-Host "Utilizador $user criado, ativado e adicionado aos Administradores." -ForegroundColor Green

    }

    catch {

        Write-Host "Erro ao criar utilizador. Verifique se a password é forte (Letras, números e símbolos) ou se o nome já existe." -ForegroundColor Red

    }

}

elseif ($op -eq "2") {

    $user = Read-Host "Nome do Utilizador a remover"

    Remove-LocalUser -Name $user -ErrorAction SilentlyContinue

    Write-Host "Utilizador $user removido (se existia)." -ForegroundColor Red

}

elseif ($op -eq "3") {

    Write-Host "`n--- LISTA DE UTILIZADORES NO SISTEMA ---" -ForegroundColor Cyan

    Get-LocalUser | Select-Object Name, Enabled, LastLogon | Format-Table -AutoSize

}

Read-Host "`nPressione ENTER para continuar"
 
Start-Transcript -Path ".\logs_atividade.txt" -Append

function Mostrar-Menu {

    Clear-Host

    Write-Host "============================================================== " -ForegroundColor Cyan

    Write-Host " SISTEMA DE ADMINISTRAÇÃO E MONITORIZAÇÃO - GRUPO Jorge/Nicole " -ForegroundColor Cyan

    Write-Host "============================================================== " -ForegroundColor Cyan

    Write-Host "1. [Processos]    Monitorizar CPU e RAM"

    Write-Host "2. [Disco]        Sistema de Ficheiros e Espaço"

    Write-Host "3. [Utilizadores] Gestão de Users e Domínio (AD)"

    Write-Host "4. [Rede/Serv]    Monitorização e IP Estático"

    Write-Host "5. [Segurança]    Análise de Logs de Acesso"

    Write-Host "6. [Backup]       Executar Backup Automático"

    Write-Host "7. Sair"

    Write-Host "=========================================================="

}

$sair = $false

do {

    Mostrar-Menu

    $opcao = Read-Host "Selecione a operação pretendida (1-7)"

    switch ($opcao) {

        "1" { & ".\GestaoProcessos.ps1" }

        "2" { & ".\MonitorizacaoDisco.ps1" }

        "3" { 

            if (Get-Module -ListAvailable ActiveDirectory) {
& ".\GestaoUtilizadores.ps1" 

            } else {

                Write-Host "AVISO: Módulo Active Directory não detetado. Use apenas Opções Locais." -ForegroundColor Yellow
& ".\GestaoUtilizadores.ps1"

            }

        }

        "4" { & ".\MonitorizacaoRede.ps1" }

        "5" { & ".\SegurancaLogs.ps1" }

        "6" { & ".\BackupSistema.ps1" }

        "7" { 

            Write-Host "A fechar o sistema e a guardar logs..." -ForegroundColor Green

            Stop-Transcript -ErrorAction SilentlyContinue

            $sair = $true

        }

        Default { Write-Host "Opção inválida!" -ForegroundColor Red }

    }

    if (-not $sair) {

        Write-Host "`nOperação concluída. Pressione ENTER para voltar ao Menu..."

        $null = Read-Host

    }

} while (-not $sair)
 
