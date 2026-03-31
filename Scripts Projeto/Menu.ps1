Clear-Host
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
 
function Mostrar-Menu {
    $meuIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -like "*Ethernet*" -and $_.IPAddress -notlike "169.*" }).IPAddress | Select-Object -First 1
    if ($null -eq $meuIP) { $meuIP = "Sem IP Ativo" }
 
    Clear-Host
    Write-Host "===============================================================" -ForegroundColor Cyan
    Write-Host "   SISTEMA DE ADMINISTRAÇÃO E MONITORIZAÇÃO - GRUPO Jorge/Nicole " -ForegroundColor Cyan
    Write-Host "   SERVIDOR ATIVO NO IP: $meuIP" -ForegroundColor Yellow
    Write-Host "===============================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " 1. [Processos]    Monitorizar CPU e RAM"
    Write-Host " 2. [Disco]        Sistema de Ficheiros e Espaço"
    Write-Host " 3. [Utilizadores] Gestão de Users e Domínio (AD)"
    Write-Host " 4. [Rede/Serv]    Monitorização e Conectividade"
    Write-Host " 5. [Segurança]    Análise de Logs de Acesso"
    Write-Host " 6. [Backup]       Executar Backup Automático"
    Write-Host " 7. Sair"
    Write-Host ""
    $escolha = Read-Host "Selecione a operação (1-7)"
 
    switch ($escolha) {
        "1" { & ".\GestaoProcessos.ps1"; Mostrar-Menu }
        "2" { & ".\MonitorizacaoDisco.ps1"; Mostrar-Menu }
        "3" { & ".\GestaoUtilizadores.ps1"; Mostrar-Menu }
        "4" { & ".\MonitorizacaoRede.ps1"; Mostrar-Menu }
        "5" { & ".\SegurancaLogs.ps1"; Mostrar-Menu }
        "6" { & ".\BackupSistema.ps1"; Mostrar-Menu }
        "7" { exit }
        default { Write-Host "Opção Inválida!"; Start-Sleep -Seconds 1; Mostrar-Menu }
    }
}
 
Mostrar-Menu
