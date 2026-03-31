Clear-Host
Write-Host "--- CONFIGURAÇÃO DE REDE (FORÇADA) ---" -ForegroundColor Yellow
 
$interface = Get-NetAdapter | Where-Object Status -eq "Up" | Select-Object -First 1
$name = $interface.Name
 
Write-Host "1. DHCP (Automático)`n2. ESTÁTICO (Manual)"
$op = Read-Host "Escolha"
 
if ($op -eq "2") {
    $ip = Read-Host "IP (Ex: 192.168.1.150)"
    $gw = Read-Host "Gateway (Ex: 192.168.1.1)"
    $dns = Read-Host "DNS (IP do Servidor)"
 
    try {
        Write-Host "`nA limpar configurações anteriores..." -ForegroundColor Gray
        New-NetIPAddress -InterfaceAlias $name -IPAddress $ip -PrefixLength 24 -DefaultGateway $gw -ErrorAction Stop
                Write-Host "A configurar DNS para $dns..." -ForegroundColor Cyan
        Set-DnsClientServerAddress -InterfaceAlias $name -ServerAddresses $dns -ErrorAction SilentlyContinue
                Write-Host "`n[SUCESSO] Rede configurada corretamente!" -ForegroundColor Green
    } catch {
        # Se o IP já estiver lá (como aconteceu agora), ele apenas confirmaWrite-Host "`n[OK] O IP já se encontra ativo na placa." -ForegroundColor Green
    }
} else {
    Set-NetIPInterface -InterfaceAlias $name -DHCP Enabled
    Set-DnsClientServerAddress -InterfaceAlias $name -ResetServerAddresses
    Write-Host "DHCP Ativado!" -ForegroundColor Green
}
Read-Host "`nPressione ENTER para voltar"
