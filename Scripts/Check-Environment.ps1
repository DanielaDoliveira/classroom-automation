# ============================================================
# Check-Environment.ps1 — Fase 1: Validação de Pré-requisitos
# Função: garantir que as condições mínimas para o
# provisionamento existam ANTES de tentar instalar qualquer coisa.
#
# Validações executadas em sequência:
#   1. Conectividade com a internet (rede + resolução de DNS)
#   2. ExecutionPolicy do PowerShell (ajuste + confirmação)
#
# Princípio: falha rápida e explícita — se qualquer verificação
# falhar, o pipeline para imediatamente com uma mensagem
# acionável (melhor falhar aqui do que no meio de uma instalação).
# ============================================================

function Invoke-CheckEnvironment {
    Write-Host "[1/3] Verificando ambiente..." -ForegroundColor Cyan

    
    # ------------------------------------------------------------
    # VALIDAÇÃO 1 — Conectividade com a Internet
    # Test-Connection envia um ping para "google.com", testando
    # simultaneamente duas coisas:
    #   - Conectividade de rede (o pacote chega até a internet)
    #   - Resolução de DNS (o nome "google.com" é traduzido para IP)
    #
    # -Count 1    → uma única tentativa é suficiente para o diagnóstico
    # -Quiet      → retorna apenas $true/$false, sem output no terminal
    # -ErrorAction SilentlyContinue → suprime erros de timeout,
    #   evitando mensagens vermelhas confusas antes do nosso aviso.
    # ------------------------------------------------------------
    $internet = Test-Connection -ComputerName "google.com" -Count 1 -Quiet -ErrorAction SilentlyContinue

    if (!$internet) {
        Write-Host "------------------------------------------------" -ForegroundColor Red
        Write-Host "ERRO: Computador sem internet ou conexao instavel." -ForegroundColor Red
        Write-Host "Verifique o cabo/Wi-Fi antes de tentar novamente." -ForegroundColor Red
        Write-Host "------------------------------------------------" -ForegroundColor Red
        Pause
        exit 
    }
    Write-Host "  > Conexao com internet: OK" -ForegroundColor Gray

    # ------------------------------------------------------------
    # VALIDAÇÃO 2 — ExecutionPolicy do PowerShell
    #
    # Por padrão, o Windows bloqueia a execução de scripts .ps1
    # (política "Restricted"). Precisamos de pelo menos "RemoteSigned"
    # para rodar scripts locais sem assinatura digital.
    #
    # Aplicamos dois escopos de forma intencional e complementar:
    #
    #   CurrentUser → persiste para sessões futuras deste usuário,
    #                 evitando que o bloqueio volte na próxima aula.
    #
    #   Process     → Bypass apenas para este processo em execução,
    #                 sem alterar a política global da máquina —
    #                 princípio de menor privilégio.
    #
    # O try/catch silencioso é intencional: em máquinas com GPO
    # (Group Policy) corporativa, o Set-ExecutionPolicy pode ser
    # bloqueado pelo domínio. A verificação logo abaixo confirma
    # o estado real independente do sucesso aqui.
    # ------------------------------------------------------------
    try {
       
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
    } catch {
         # Falha silenciosa intencional — o resultado real é lido
        # por Get-ExecutionPolicy logo abaixo, não por esta atribuição.
    }

      # ------------------------------------------------------------
    # CONFIRMAÇÃO DO ESTADO REAL DA POLÍTICA
    # Get-ExecutionPolicy sem -Scope retorna a política efetiva
    # para o processo atual — o valor que o PowerShell realmente
    # vai usar para decidir se executa ou não os próximos scripts.
    #
    # Políticas aceitas pelo pipeline:
    #   Bypass       - sem restrições (definido no escopo Process acima)
    #   Unrestricted - permite tudo com aviso para scripts remotos
    #   RemoteSigned - permite scripts locais sem assinatura (mínimo seguro)
    # ------------------------------------------------------------
    $currentPolicy = Get-ExecutionPolicy
    
    # Lista de politicas permitidas para prosseguir
    $allowedPolicies = @("Bypass", "Unrestricted", "RemoteSigned")

    if ($allowedPolicies -contains $currentPolicy) {
        Write-Host "  > Politicas de seguranca: OK ($currentPolicy)" -ForegroundColor Gray
    } else {
        Write-Host "------------------------------------------------" -ForegroundColor Red
        Write-Host "ERRO: O Windows bloqueou a execucao de scripts." -ForegroundColor Red
        Write-Host "Politica atual: $currentPolicy" -ForegroundColor Red
        Write-Host "Chame o suporte tecnico para liberar o PowerShell." -ForegroundColor Red
        Write-Host "------------------------------------------------" -ForegroundColor Red
        Pause
        exit
    }
}