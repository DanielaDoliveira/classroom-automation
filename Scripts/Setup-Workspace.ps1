# ============================================================
# Setup-Workspace.ps1 - Fase 3: Orquestração do Workspace
# Responsabilidade: preparar o ambiente de trabalho do aluno
# para o início imediato da aula, sem intervenção manual.
#
# Ações executadas em sequência:
#   1. Criar pasta da aula com data no nome
#   2. Abrir apostila (Notion) e repositório (Google Drive)
#   3. Iniciar VS Code já apontando para a pasta do dia
# ============================================================

function Invoke-SetupWorkspace {
    Write-Host "[3/3] Organizando area de trabalho e materiais..." -ForegroundColor Cyan

     # ------------------------------------------------------------
    # DEFINIÇÃO DO CAMINHO BASE
    # $env:USERPROFILE aponta para C:\Users\<nome-do-aluno>,
    # garantindo que a pasta seja criada no perfil correto
    # independente do usuário logado na máquina do laboratório.
    #
    # A pasta recebe a data no nome (dd-MM-yyyy) para que cada
    # aula tenha seu próprio diretório isolado - evitando
    # conflitos de arquivos entre sessões diferentes.
    # ------------------------------------------------------------
    # Definicao do Caminho (Usando USERPROFILE)
    $caminhoBase = Join-Path $env:USERPROFILE "Documents"
    $data = Get-Date -Format "dd-MM-yyyy"
    $pastaAula = Join-Path $caminhoBase "Curso_Programacao\Aula-$data"

     # ------------------------------------------------------------
    # CRIAÇÃO DA PASTA - com fallback para C:\
    # Primeiro tentamos em Documentos (caminho preferencial).
    # Em máquinas com perfil redirecionado para rede ou com
    # permissões restritas, essa operação pode falhar -
    # nesse caso, o fallback cria a pasta direto em C:\ onde
    # privilégios de Administrador (já garantidos pelo Launcher)
    # asseguram o acesso de escrita.
    # ------------------------------------------------------------
    try {
        if (!(Test-Path $pastaAula)) {
            New-Item -Path $pastaAula -ItemType Directory -Force | Out-Null
            Write-Host "  > Pasta da aula criada: $pastaAula" -ForegroundColor Gray
        }
        
    }  # ------------------------------------------------------------
      # Caminho alternativo - garante que a aula não seja bloqueada
        # por um problema de permissão no perfil do usuário.
         # ------------------------------------------------------------
    catch {
        Write-Host "  ! ERRO de PERMISSAO: Nao foi possivel criar a pasta em Documentos." -ForegroundColor Red
        Write-Host "  Tentando criar na raiz C:\Curso_Programacao..." -ForegroundColor Yellow
        $pastaAula = "C:\Curso_Programacao\Aula-$data"
        
        if (!(Test-Path $pastaAula)) {
            New-Item -Path $pastaAula -ItemType Directory -Force | Out-Null
        }
    }

     # ------------------------------------------------------------
    # ABERTURA DOS MATERIAIS DA AULA
    # Start-Process delega ao Windows a abertura da URL no
    # navegador padrão, sem depender do Chrome ou Edge.
    #
    # A pausa de 1 segundo entre as chamadas evita condições de
    # corrida onde o sistema tenta abrir dois processos pesados
    # simultaneamente, o que pode causar lentidão perceptível
    # em máquinas com hardware mais limitado de laboratório.
    # ------------------------------------------------------------

    Write-Host "  > Abrindo apostila e Google Drive..." -ForegroundColor Gray
    
    # URL do Notion (Apostila)
    $urlNotion = "https://lydian-pint-174.notion.site/Aulas-de-Javascript-2e0782cae23b80db8341f760c32e519c?pvs=74"
    Start-Process $urlNotion
    
    Start-Sleep -Seconds 1 # Pausa para estabilidade do sistema
    
    # URL do Drive
    Start-Process "https://drive.google.com"

    
    # ------------------------------------------------------------
    # INICIALIZAÇÃO DO VS CODE
    # "code ." abre o VS Code com a pasta do dia como workspace,
    # poupando o aluno de navegar manualmente pelo Explorer.
    #
    # Set-Location muda o diretório de trabalho da sessão atual
    # antes de chamar "code ." .Sem isso, o VS Code abriria
    # no diretório onde o script foi invocado.
    #
    # Verificamos a existência do comando "code" no PATH antes
    # de tentar abrir: se a Fase 2 falhou silenciosamente,
    # este bloco emite um aviso acionável ao invés de travar.
    # ------------------------------------------------------------

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