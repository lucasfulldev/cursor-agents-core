# Cursor Agents (núcleo)

Estrutura de agentes Cursor em **três camadas**:

1. **Núcleo** — pipeline que serve qualquer projeto
2. **Transversais** — entram pelo tipo de risco da mudança
3. **Domínios (plugins)** — só quando o time instalar um pack de produto

Este repositório publica **só o núcleo genérico**. Packs de produto, runbooks
de infra e mapa de serviços internos ficam fora de propósito — cada time
mantém isso em repositório privado.

```
skills/     → ~/.cursor/skills/
rules/      → ~/.cursor/rules/
```

## Núcleo — pipeline

| Estágio | Skill | Entrega |
|---------|-------|---------|
| Orquestração | `orquestracao-agentes` | Escolhe time e pipeline |
| Requisitos | seção em `orquestracao-agentes` | Escopo, regras, critérios de aceite |
| Plano | estágio 0.6 em `orquestracao-agentes` | Ordem dos passos, checkpoint, reversão |
| Design | `arquitetura-solid` | Contrato, fronteira, SOLID, tipos |
| Bordas e testes | `testes-e-bordas` | Matriz de casos + regressão |
| Implementação | `codigo-limpo` | Clean Code, diff mínimo |
| UI / Figma | `fidelidade-ui` | Medida do design, reuso, loading, overflow, sem inventar asset |
| Verificação | `gates-verificacao` | Typecheck/lint/test com evidência |
| Fecho | `revisao-pos-implementacao` | Revisão automática do diff |

## Transversais (por gatilho)

| Agente | Skill | Gatilho |
|--------|-------|---------|
| Segurança | `seguranca-codigo` | Authz, PII/LGPD, segredo, upload |
| Contrato de API | `contrato-api` | Payload/DTO cruzando serviço ou front↔API |
| Memória | `memoria-decisoes` | Decisão com trade-off; achado recorrente |
| Git/PR | `git-pr` | Commit, PR, split |

## Sob demanda

`depuracao-evidencia` (bug) · `performance-app` (lentidão) · `observabilidade` (log/incidente) · `estimativa-task` (horas)

## Domínios instalados neste repo

| Domínio | Skills |
|---------|--------|
| Dados | `senior-banco-dados` |

Produto do time: crie a skill do domínio e registre em `orquestracao-agentes` —
**não** altere o núcleo.

## Pipelines

Feature nova:

```
Estimador? → Domínio? → Requisitos → Plano → Design → Bordas/Testes
           → Código limpo (+ fidelidade-ui se houver tela) → Gates → Fecho
+ transversais (segurança / contrato) conforme o risco
```

Bug:

```
Depuração (causa confirmada) → Teste vermelho → Correção → Gates → Fecho
```

Fix trivial:

```
Código limpo → Gates → Fecho
```

Desacoplamento / refactor estrutural:

```
Plano → Costura + teste de caracterização → Extrair interface
      → Trocar miolo (gates a cada passo) → Remover órfão
```

Sem mudança de código → sem gates e sem fecho.

## Princípios que sustentam a estrutura

- Critério de aceite verificável antes do desenho; pedido com duas entregas é fatiado
- Ordem decidida antes de codar: preparação → comportamento → limpeza
- Desenho antes do código (SOLID, DIP, tipos que impedem estado inválido)
- Legado se desacopla por costura + teste de caracterização, nunca por reescrita
- Borda enumerada antes de implementar; bug nasce com teste vermelho
- “Funciona” só com saída de comando — nunca por leitura de diff
- Tela com Figma: medida do nó + componente irmão; lint verde não prova layout
- Sem ENUM de banco: VARCHAR + validação na API (`senior-banco-dados`)
- Segurança crítica bloqueia a entrega
- Achado recorrente vira regra, não correção repetida
- Diff mínimo em legado; revisão de fecho automática
- Um gatilho, um dono: description que disputa palavra com outra skill vira sorteio

## O que o núcleo já antecipa

Pergunta repetida em task longa vira regra. Inventário (não é dica):

| O usuário ainda precisa pedir? | Skill |
|--------------------------------|-------|
| Medir Figma, não inventar asset, expandir = tela cheia | `fidelidade-ui` |
| Usar a ferramenta de design quando há URL | `fidelidade-ui` |
| Loading que não finge tela pronta | `fidelidade-ui` |
| Faixa rola; item não encolhe; sombra só no eixo certo | `fidelidade-ui` |
| Controle novo não cobre outro; hit area = botão | `fidelidade-ui` |
| Fluxo irmão (modal, upload, anexos), não só a tabela | `fidelidade-ui` |
| Não pintar `undefined`; chrome acima da mídia | `fidelidade-ui` |
| Depois do upload: selecionar, rolar, transição suave | `fidelidade-ui` |
| Overlay depois de expandir: quadro pintado, px do design | `fidelidade-ui` |
| Variantes do clique (tipo A / tipo B) no aceite | `fidelidade-ui` |
| Gesto novo exercido (drag/upload/**troca rápida**), print não basta | `fidelidade-ui` |
| Troca rápida de mídia não trava skeleton; ignora load abortado | `fidelidade-ui` |
| URL de sessão (`blob:`) não persiste; merge atualiza URL do mesmo id | `fidelidade-ui` + `contrato-api` |
| Identidade (cor, código) no cadastro; tela de uso exibe | `arquitetura-solid` |
| Duas listas do mesmo id após delete/upload | `depuracao-evidencia` |
| PATCH omitido ≠ `null`; valor novo tem label no front | `contrato-api` |
| Sem ENUM SQL | `senior-banco-dados` |
| `o que acha?` sem “adiciona” = resposta, não diff | `orquestracao-agentes` |
| Erro da skill → patch da skill na mesma conversa | `orquestracao-agentes` |
| Push cita URL; repo público sem nome de produto/secret | `git-pr` + `seguranca-codigo` |

## O que **não** entra no núcleo

- Nome, iframe, paleta, tipo de arquivo ou hash de um produto
- Pack de domínio, runbook de infra, mapa de serviços internos
- Rewrite de git history (só com pedido explícito)

## Validar

Cada skill tem **um** dono por gatilho (tabela em `orquestracao-agentes`). Depois
de sincronizar ou criar skill nova, rode [`TESTE-FUMACA.md`](./TESTE-FUMACA.md):
cenários em chat novo que checam se o agente certo dispara, se os gates
rodam e se o fecho traz evidência.

## Instalar / sincronizar

```bash
rsync -a ./skills/ ~/.cursor/skills/
mkdir -p ~/.cursor/rules
cp ./rules/*.mdc ~/.cursor/rules/
```

Source of truth com symlink (opcional):

```bash
mv ~/.cursor/skills ~/.cursor/skills.bak 2>/dev/null || true
ln -s "$(pwd)/skills" ~/.cursor/skills
mkdir -p ~/.cursor/rules
ln -sf "$(pwd)/rules/roteamento-agentes.mdc" ~/.cursor/rules/roteamento-agentes.mdc
```

Abra um **chat novo** no Cursor após sincronizar.

## Contribuir

Fork → branch → Pull request. Sem push direto no `main`. Detalhe em
[CONTRIBUTING.md](./CONTRIBUTING.md).

## Licença

MIT. Veja [LICENSE](./LICENSE).
