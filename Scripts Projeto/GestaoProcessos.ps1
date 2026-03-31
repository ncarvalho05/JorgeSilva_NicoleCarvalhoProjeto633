Clear-Host
Write-Host "--- MONITORIZAÇÃO DE PROCESSOS (TOP 10 RAM) ---" -ForegroundColor Yellow
 
Get-Process | Sort-Object WS -Descending | Select-Object -First 10 Name, ID, 
    @{Name="Memoria(MB)"; Expression={ "{0:N2}" -f ($_.WS / 1MB) }} | Format-Table
 
$idProc = Read-Host "Introduza o ID do processo para encerrar (ou Enter para sair)"
 
if ($idProc -ne "") {
    Stop-Process -Id $idProc -Force
    Write-Host "Processo $idProc encerrado com sucesso!" -ForegroundColor Green
}
