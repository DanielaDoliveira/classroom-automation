function Invoke-InstallTools {
    Write-Host "[2/3] Validando ferramentas de desenvolvimento..." -ForegroundColor Cyan

    function Install-WithRetry {
        param ($Name, $Command, [scriptblock]$InstallAction)
        $tentativas = 0
        $sucesso = $false
        
        while ($tentativas -lt 3 -and $sucesso -eq $false) {
            if (Get-Command $Command -ErrorAction SilentlyContinue) {
                $sucesso = $true
            } else {
                $tentativas++
                
                # FEEDBACK VISUAL (Estilo React/NPM)
                Write-Progress -Activity "Instalando $Name" -Status "Tentativa $tentativas de 3..." -PercentComplete (($tentativas / 3) * 100)
                Write-Host "  > $Name nao detectado. Tentando instalacao..." -ForegroundColor Yellow
                
                # Executa o bloco de instalacao
                try {
                    & $InstallAction
                } catch {
                    Write-Warning "    Erro na execucao do comando de instalacao."
                }
                
                # Pausa para o Windows processar o registro do software
                Start-Sleep -Seconds 5 
                
                # REFRESH TOTAL DO AMBIENTE (Crucial para o Node/NPM)
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
                
                if (Get-Command $Command -ErrorAction SilentlyContinue) { 
                    $sucesso = $true 
                    Write-Progress -Activity "Instalando $Name" -Completed
                }
            }
        }
        return $sucesso
    }

    # 1. Validar VS Code
    $vsCodeOk = Install-WithRetry "VS Code" "code" { 
        # Removi o --silent para você ver o progresso do download do Winget na VM
        winget install Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements --disable-interactivity --force 
    }

    # 2. Validar Node.js
    $nodeOk = Install-WithRetry "Node.js" "node" { 
        winget install OpenJS.NodeJS --accept-source-agreements --accept-package-agreements --disable-interactivity --force 
    }

    # 3. Validar Nodemon (Verifica se o NPM ja esta disponivel no Path atualizado)
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        $nodemonOk = Install-WithRetry "Nodemon" "nodemon" { 
            npm install -g nodemon --force
        }
    } else {
        Write-Warning "  ! NPM nao detectado. Nao foi possivel instalar o Nodemon nesta sessao."
    }
}