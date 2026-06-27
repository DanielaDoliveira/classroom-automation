# ============================================================
# Install-Tools.ps1(Fase 2): Provisionamento de Ferramentas
# Responsabilidade: garantir que VS Code, Node.js e Nodemon
# estejam instalados e acessíveis no PATH antes da aula.
#
# Estratégia: cada ferramenta passa pela função Install-WithRetry,
# que tenta até 3 vezes antes de desistir — tolerando instabilidades
# de rede comuns em ambientes de laboratório.
# ============================================================



function Invoke-InstallTools {
    Write-Host "[2/3] Validando ferramentas de desenvolvimento..." -ForegroundColor Cyan

  # ------------------------------------------------------------
    # FUNÇÃO AUXILIAR — Install-WithRetry
    # Encapsula a lógica de instalação usada por
    # todas as ferramentas. Recebe:
    #   $Name          - nome legível para exibição no log
    #   $Command       - comando usado para verificar se já existe no PATH
    #   $InstallAction - scriptblock com o comando de instalação real
    #
    # Fluxo: verifica -> instala se necessário-> aguarda registro
    #        -> atualiza PATH -> verifica novamente (até 3x)
    # ------------------------------------------------------------

    function Install-WithRetry {
        param ($Name, $Command, [scriptblock]$InstallAction)
        $tentativas = 0
        $sucesso = $false
        
        while ($tentativas -lt 3 -and $sucesso -eq $false) {
            if (Get-Command $Command -ErrorAction SilentlyContinue) {
                $sucesso = $true
            } 
            else 
            {
                $tentativas++
               # ----------------------------------------------------------
               # Feedback visual progressivo inspirado no estilo NPM/React:
                # Write-Progress exibe uma barra na sessão PowerShell,
                # enquanto Write-Host mantém o log textual no terminal.
                  # ----------------------------------------------------------

                Write-Progress -Activity "Instalando $Name" -Status "Tentativa $tentativas de 3..." -PercentComplete (($tentativas / 3) * 100)
                Write-Host "  > $Name nao detectado. Tentando instalacao..." -ForegroundColor Yellow
                
                # Executa o bloco de instalação dentro de try/catch para
                # isolar falhas pontuais sem interromper o pipeline inteiro.
                try {
                    & $InstallAction
                } catch {
                    Write-Warning "    Erro na execucao do comando de instalacao."
                }
                #---------------------------------------------------------------
                 # Aguarda o Windows concluir o registro do software no sistema.
                # Sem esta pausa, o PATH pode não refletir a instalação
                # e a verificação seguinte falharia mesmo com sucesso real.
                #--------------------------------------------------------------
                Start-Sleep -Seconds 5 
                
                # ----------------------------------------------------
                # REFRESH FORÇADO DO PATH — crítico para Node.js/NPM
                # O Winget atualiza o PATH do sistema, mas a sessão
                # PowerShell atual mantém a cópia antiga em memória.
                # Esta linha força a releitura dos valores do registro
                # (Machine + User) sem precisar abrir um novo terminal.
                # ----------------------------------------------------
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                
                if (Get-Command $Command -ErrorAction SilentlyContinue) { 
                    $sucesso = $true 
                    Write-Progress -Activity "Instalando $Name" -Completed
                }
            }
        }
        return $sucesso
    }


    # ------------------------------------------------------------
    # PASSO 1 — VS Code
    # Flag --force garante reinstalação mesmo se o Winget
    # detectar uma versão anterior corrompida ou incompleta.
    # --silent removido intencionalmente: permite acompanhar
    # o progresso do download, útil em VMs de laboratório.
    # ------------------------------------------------------------


    $vsCodeOk = Install-WithRetry "VS Code" "code" { 
        # Removi o --silent para você ver o progresso do download do Winget na VM
        winget install Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements --disable-interactivity --force 
    }

    # ------------------------------------------------------------
    # PASSO 2 — Node.js (inclui NPM automaticamente)
    # OpenJS.NodeJS é o ID oficial do pacote LTS no Winget.
    # O NPM vem bundled — após esta etapa, `npm` já deve estar
    # disponível no PATH (após o refresh acima).
    # ------------------------------------------------------------
    $nodeOk = Install-WithRetry "Node.js" "node" { 
        winget install OpenJS.NodeJS --accept-source-agreements --accept-package-agreements --disable-interactivity --force 
    }

    # ------------------------------------------------------------
    # PASSO 3 — Nodemon (dependente do NPM)
    # Nodemon é instalado via NPM global (-g), então só faz
    # sentido tentar se o NPM estiver acessível no PATH.
    # Verificamos explicitamente antes de chamar Install-WithRetry
    # para evitar uma mensagem de erro genérica e confusa.
    # ------------------------------------------------------------
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        $nodemonOk = Install-WithRetry "Nodemon" "nodemon" { 
            npm install -g nodemon --force
        }
    } else {
        Write-Warning "  ! NPM nao detectado. Nao foi possivel instalar o Nodemon nesta sessao."
    }
}