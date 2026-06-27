[ENG-US](README.md) | PT-BR

---

## Pipeline de Provisionamento de Ambiente de Sala de Aula
> Solução de Infraestrutura como Código (IaC) para Ambientes Educacionais baseados em Windows.

---

### O Problema (Restrições de Produção)

Em laboratórios com reformatação frequente de máquinas, a configuração manual de ambientes de desenvolvimento era um grande gargalo. Verificar e instalar o VS Code, Node.js e Nodemon, além de configurar manualmente as Políticas de Execução do PowerShell, consumia entre 30 e 60 minutos por sessão.

Quando escalado para uma sala de aula inteira, essa "dívida de setup" frequentemente comprometia o plano de aula e reduzia o tempo efetivo de ensino em quase 50%.

---

### A Solução

Desenvolvi um pipeline de automação leve e de "um clique" usando PowerShell e Batch para gerenciar todo o ciclo de vida do ambiente. Esta solução transforma um processo manual de 30 minutos em um deploy automatizado de 2 minutos.

---

### Arquitetura do Pipeline

- **Fase 1 — Validação de Ambiente:** Verificação automatizada de conectividade com a internet e resolução de DNS.

- **Fase 2 — Bypass de Segurança:** Elevação programática da ExecutionPolicy (escopo de Processo/Usuário) para permitir a execução de scripts sem comprometer a segurança permanente do sistema.

- **Fase 3 — Provisionamento Inteligente:** Instalação resiliente do VS Code e Node.js via Winget.
  - Instalação global do Nodemon via NPM.
  - Lógica de Retry: Sistema de failover com 3 tentativas para condições de rede instável.

- **Fase 4 — Orquestração do Workspace:** Criação automatizada de pastas de projeto com data e inicialização sincronizada dos recursos educacionais (Notion e Google Drive).

---

## Impacto

- **Eficiência de Setup:** Tempo de provisionamento de ambiente reduzido em mais de 90%.

- **Confiabilidade:** Elimina o "configuration drift" garantindo que todos os alunos tenham um ambiente idêntico.

- **Resiliência:** O script lida graciosamente com estados de "já instalado", evitando downloads redundantes e erros.

---

### Documentação e Acessibilidade

-  Comentários no código em português para manutenibilidade do projeto*.

-  Isso garante que instrutores locais, técnicos de laboratório e alunos possam entender, auditar e modificar a lógica com facilidade, independentemente do nível de inglês.

---

## Changelog
### v1.1.0
- **Documentação do Código:** Todos os scripts (`Launcher.bat`, `Main.ps1`, `Check-Environment.ps1`, `Install-Tools.ps1`, `Setup-Workspace.ps1`) passaram por uma revisão completa de comentários.
- Comentários reescritos com foco em clareza técnica, cobrindo decisões arquiteturais, comportamentos não-óbvios do PowerShell e justificativas de manutenibilidade.
- Comentários dos scripts escritos em português para facilitar o acesso de instrutores e técnicos de laboratório.
- **README:** Adicionada tradução em português (`README.pt.md`) e seção de changelog.

### v1.0.0
- Lançamento inicial: pipeline de provisionamento automatizado para ambientes de sala de aula.