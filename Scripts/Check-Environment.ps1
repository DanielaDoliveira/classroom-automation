function Invoke-CheckEnvironment {
    Write-Host "[1/3] Verificando ambiente..." -ForegroundColor Cyan

    # Validacao de Internet
    # Usando google.com para testar conectividade e DNS simultaneamente
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

    # Ajuste de Permissoes (Bypass de Seguranca)
    try {
        # Define a politica para o usuario atual e para o processo em execucao
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
    } catch {
        # Se falhar aqui, a verificacao abaixo confirmara o estado real
    }

    # Verificacao do bypass
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