# 
# ============================================================
# Main.ps1 — Orquestrador principal do pipeline
# Função: carregar os módulos e coordenar a execução
# das três fases do provisionamento na ordem correta.
# Contém apenas composição e sequência.Não tem lógica de negócio.
# ============================================================


#----------------------------------------------------------
# CARREGAMENTO DOS MÓDULOS (Dot-Sourcing)
# O operador "." (dot-source) carrega cada script no escopo
# atual, tornando suas funções disponíveis neste contexto.

# $PSScriptRoot garante que o caminho seja sempre relativo
# à localização do Main.ps1, independente de onde o script
# for chamado — evitando erros de "arquivo não encontrado"
# quando executado a partir do Launcher.bat.
#---------------------------------------------------------

. "$PSScriptRoot\Scripts\Check-Environment.ps1"
. "$PSScriptRoot\Scripts\Install-Tools.ps1"
. "$PSScriptRoot\Scripts\Setup-Workspace.ps1"

# Limpa o terminal antes de exibir o banner,



Clear-Host
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "   AUTOMACAO - CURSO DE FRONT END WEB" -ForegroundColor Magenta
Write-Host "   Criado por: Prof Daniela DOliveira" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta

#-----------------------------------------------------------------
# PIPELINE DE EXECUÇÃO — 3 fases em sequência obrigatória:
#
#   1. Check-Environment  - valida conectividade e pré-requisitos
#   2. Install-Tools      - provisiona VS Code, Node.js e Nodemon
#   3. Setup-Workspace    - cria pastas e abre recursos da aula
#
#  Install-Tools depende da validação prévia,
# e Setup-Workspace assume que as ferramentas já estão prontas.
#-----------------------------------------------------------------


Invoke-CheckEnvironment
Invoke-InstallTools
Invoke-SetupWorkspace

Write-Host "`nAmbiente configurado! Bons estudos!" -ForegroundColor Green
Pause