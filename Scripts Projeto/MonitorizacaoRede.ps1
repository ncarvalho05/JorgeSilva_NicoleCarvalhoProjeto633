Clear-Host
Import-Module ActiveDirectory

$meuIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -like "*Ethernet*" -and $_.IPAddress -notlike "169.*" }).IPAddress | Select-Object -First 1if ($null -eq $meuIP) { $meuIP = "Sem IP" }
 
Clear-Host
Write-Host "--- GESTÃO DE REDE E CONECTIVIDADE ---" -ForegroundColor Yellow
Write-Host "Servidor ativo no IP: $meuIP" -ForegroundColor Cyan
Write-Host "--------------------------------------"
 
Write-Host "1. Testar Ligação (Ping)"
Write-Host "2. Verificar Portas Críticas"
Write-Host "3. Configurar IP (Dinâmico/Manual)"
Write-Host "4. Voltar"
 
$op = Read-Host "Opção"
 
switch ($op) {
    "1" {
        $target = Read-Host "Digite o IP ou Nome do Cliente a testar"
        Write-Host "A enviar pacotes para $target..." -ForegroundColor Gray
        if (Test-Connection -ComputerName $target -Count 2 -Quiet) {
            Write-Host "LIGAÇÃO COM SUCESSO!" -ForegroundColor Green
        } else {
            Write-Host "FALHA: Cliente inacessível ou Firewall ativa." -ForegroundColor Red
        }
    }
    "2" {
    Clear-Host
    Write-Host "--- VERIFICAÇÃO DE SERVIÇOS E PORTAS CRÍTICAS ---" -ForegroundColor Yellow
    Write-Host "A verificar a saúde do Servidor...`n" -ForegroundColor Gray
 
    $portas = @{
        "53 (DNS)"       = "Serviço de Nomes (Essencial para o Domínio)"
        "389 (LDAP)"     = "Active Directory (Autenticação)"
        "445 (SMB)"      = "Partilha de Ficheiros e Políticas de Grupo"
        "80 (HTTP)"      = "Serviço Web (Se instalado)"
    }
 
    foreach ($p in $portas.Keys) {
        $portNumber = $p.Split(" ")[0]
        $check = Test-NetConnection -ComputerName localhost -Port $portNumber -WarningAction SilentlyContinue
 
        if ($check.TcpTestSucceeded) {
            Write-Host "[ ATIVA ] Porta $p : $($portas[$p])" -ForegroundColor Green
        } else {
            Write-Host "[ FECHADA ] Porta $p : $($portas[$p])" -ForegroundColor Red
        }
    }
    Write-Host "`nVerificação concluída." -ForegroundColor Cyan
}
    "3" {
& ".\ConfigurarRede.ps1"
    }
    "4" { return }
}
 
Read-Host "`nPressione ENTER para continuar"
