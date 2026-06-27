@echo off
setlocal

:: ============================================================
:: LAUNCHER.bat — Ponto de entrada do pipeline de provisionamento
:: Função: garantir que o Main.ps1 seja sempre
:: executado com privilégios de Administrador.
:: ============================================================


:: -------------------------------------------------------
:: FASE 1 — Verificação de privilégios
:: "net session" é um comando que falha silenciosamente
:: quando executado sem permissão de Administrador.
:: Isso foi usado aqui como teste indireto de elevação

:: -------------------------------------------------------
net session >nul 2>&1
if %errorLevel% == 0 (

    ::----------------------------------------------------------------------------------------
    :: Se já for Administrador executa o Main.ps1 diretamente.
    :: -NoProfile: ignora perfis de usuário do PowerShell (mais rápido e previsível).
    :: -ExecutionPolicy Bypass: permite rodar scripts sem alterar a política global do sistema.
    :: Set-Location: garante que o caminho relativo do script seja resolvido corretamente.
    ::-----------------------------------------------------------------------------------------
    

    powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-Location '%~dp0'; & '%~dp0Main.ps1'"
) else (

    :: ------------------------------------------------------------
    :: Sem privilégios — solicita elevação via UAC (User Account Control).
    :: Start-Process com -Verb RunAs é o mecanismo oficial do Windows
    :: para relançar um processo com permissões elevadas.
    :: ------------------------------------------------------------
    echo ===========================================
    echo   SOLICITANDO PERMISSAO DE ADMINISTRADOR
    echo ===========================================
    
    powershell -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command ""Set-Location ''%~dp0''; & ''%~dp0Main.ps1''""' -Verb RunAs"
)


:: ------------------------------------------------------------
:: FASE 2 — Tratamento de erro pós-execução
:: Se o errorLevel for diferente de 0 após a tentativa,
:: significa que o usuário negou o UAC ou ocorreu uma falha
:: ao iniciar o processo elevado.
:: ------------------------------------------------------------

if %errorLevel% neq 0 (
    echo.
    echo Ocorreu um erro ao tentar iniciar o script como Administrador.
    pause
)