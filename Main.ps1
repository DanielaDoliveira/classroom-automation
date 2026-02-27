# Importação dos módulos (usando $PSScriptRoot para não errar o caminho)
. "$PSScriptRoot\Scripts\Check-Environment.ps1"
. "$PSScriptRoot\Scripts\Install-Tools.ps1"
. "$PSScriptRoot\Scripts\Setup-Workspace.ps1"

Clear-Host
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "   AUTOMACAO - CURSO DE FRONT END WEB" -ForegroundColor Magenta
Write-Host "   Criado por: Prof Daniela DOliveira" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta



# Execução das funções
Invoke-CheckEnvironment
Invoke-InstallTools
Invoke-SetupWorkspace

Write-Host "`nAmbiente configurado! Bons estudos!" -ForegroundColor Green
Pause