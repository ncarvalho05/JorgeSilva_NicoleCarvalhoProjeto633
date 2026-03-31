Clear-Host
Write-Host "--- SISTEMA DE BACKUP AUTOMÁTICO ---" -ForegroundColor Yellow
 
$data = Get-Date -Format "dd-MM-yyyy"
$origem = "C:\Dados"
$destino = "C:\Backups\Backup_$data"

if (Test-Path $origem) {
    if (-not (Test-Path $destino)) { 
        New-Item -Path $destino -ItemType Directory | Out-Null 
    }
    Write-Host "A copiar ficheiros de $origem para $destino..." -ForegroundColor Cyan
    Copy-Item -Path $origem -Destination $destino -Recurse -Force
    if ($?) {
        Write-Host "Backup concluído com sucesso!" -ForegroundColor Green
    }
} else {
    Write-Host "Erro: Pasta de origem ($origem) não encontrada." -ForegroundColor Red
}
