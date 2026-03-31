Clear-Host
Write-Host "--- ANÁLISE DE ESPAÇO EM DISCO ---" -ForegroundColor Yellow
 
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    $totalGB = ($_.Used + $_.Free) / 1GB
    $livreGB = $_.Free / 1GB
    $percentagemUso = ($_.Used / ($_.Used + $_.Free)) * 100
 
    Write-Host "Unidade: $($_.Name)" -ForegroundColor Cyan
    Write-Host "Total:   $("{0:N2}" -f $totalGB) GB"
    Write-Host "Livre:   $("{0:N2}" -f $livreGB) GB"
    Write-Host "Uso:     $("{0:N0}" -f $percentagemUso) %"
 
    if ($percentagemUso -gt 90) {
        Write-Host "AVISO: Pouco espaço disponível em $($_.Name)!" -ForegroundColor Red
    }
    Write-Host "----------------------------------"
}
