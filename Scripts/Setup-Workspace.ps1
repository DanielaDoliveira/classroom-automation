function Invoke-SetupWorkspace {
    Write-Host "[3/3] Organizando area de trabalho e materiais..." -ForegroundColor Cyan

    # Definicao do Caminho (Usando USERPROFILE)
    $caminhoBase = Join-Path $env:USERPROFILE "Documents"
    $data = Get-Date -Format "dd-MM-yyyy"
    $pastaAula = Join-Path $caminhoBase "Curso_Programacao\Aula-$data"

    # Tenta criar a pasta com tratamento de erro
    try {
        if (!(Test-Path $pastaAula)) {
            New-Item -Path $pastaAula -ItemType Directory -Force | Out-Null
            Write-Host "  > Pasta da aula criada: $pastaAula" -ForegroundColor Gray
        }
    } catch {
        Write-Host "  ! ERRO de PERMISSAO: Nao foi possivel criar a pasta em Documentos." -ForegroundColor Red
        Write-Host "  Tentando criar na raiz C:\Curso_Programacao..." -ForegroundColor Yellow
        $pastaAula = "C:\Curso_Programacao\Aula-$data"
        
        if (!(Test-Path $pastaAula)) {
            New-Item -Path $pastaAula -ItemType Directory -Force | Out-Null
        }
    }

    # Abre Materiais e Exercicios (Notion e Drive)
    Write-Host "  > Abrindo apostila e Google Drive..." -ForegroundColor Gray
    
    # URL do Notion (Apostila)
    $urlNotion = "https://lydian-pint-174.notion.site/Aulas-de-Javascript-2e0782cae23b80db8341f760c32e519c?pvs=74"
    Start-Process $urlNotion
    
    Start-Sleep -Seconds 1 # Pausa para estabilidade do sistema
    
    # URL do Drive
    Start-Process "https://drive.google.com"

    # Abre o VS Code na pasta correta
    if (Get-Command code -ErrorAction SilentlyContinue) {
        if (Test-Path $pastaAula) {
            Set-Location $pastaAula
            code .
            Write-Host "  > VS Code iniciado na pasta do dia." -ForegroundColor Green
        }
    } else {
        Write-Warning "  ! VS Code nao encontrado no comando 'code'. Abra-o manualmente."
    }
}