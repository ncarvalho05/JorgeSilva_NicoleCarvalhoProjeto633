Clear-Host
Write-Host "--- AUDITORIA DE SEGURANÇA ---" -ForegroundColor Red
 
$dataLimite = (Get-Date).AddDays(-1)
 
$eventos = Get-EventLog -LogName Security -InstanceId 4625 -After $dataLimite -ErrorAction SilentlyContinue
 
if ($eventos) {
    $total = $eventos.Count
    Write-Host "ALERTA: Detetadas $total tentativas de login falhadas nas últimas 24h!" -ForegroundColor Yellow
    $eventos | Select-Object TimeGenerated, Message -First 5 | Format-Table
} else {
    Write-Host "Atividade Normal: Sem falhas de login registadas." -ForegroundColor Green
}
