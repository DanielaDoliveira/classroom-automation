@echo off
setlocal

:: Verifica se já tem privilégios de administrador
net session >nul 2>&1
if %errorLevel% == 0 (
    :: Se já for admin, executa diretamente, garantindo aspas no caminho
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-Location '%~dp0'; & '%~dp0Main.ps1'"
) else (
    :: Se não for, solicita elevação
    echo ===========================================
    echo   SOLICITANDO PERMISSAO DE ADMINISTRADOR
    echo ===========================================
    :: O comando abaixo faz 3 coisas: 
    :: - Pede Admin (RunAs)
    :: - Muda o diretório para a pasta do script (Set-Location)
    :: - Executa o Main.ps1
    powershell -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command ""Set-Location ''%~dp0''; & ''%~dp0Main.ps1''""' -Verb RunAs"
)

if %errorLevel% neq 0 (
    echo.
    echo Ocorreu um erro ao tentar iniciar o script como Administrador.
    pause
)