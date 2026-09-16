---
name: orquestracao-agentes
description: >-
  Orquestra agentes Cursor em três camadas: núcleo generalista (design, testes,
  código limpo, gates, revisão), transversais (segurança, contrato de API,
  memória) e packs de domínio opcionais. Use ao iniciar feature/bug, escolher
  agente, montar o time, orquestração, ou estrutura de agentes. Não substitui
  as skills especializadas — só escolhe e encadeia.
---

# Orquestração de agentes

Skill pessoal. **Núcleo** serve qualquer projeto; **transversais** entram pelo
tipo de risco; **domínios** só quando o contexto pedir.

**Primeira ação:** aplicar o pipeline do núcleo, ativar transversais conforme os
gatilhos e, se o tema casar com um pack de domínio, ler essa skill.

## Arquitetura

```
┌──────────────────────────────────────────────────────────────┐
│  NÚCLEO — pipeline (quando houver código)                    │
│  Requisitos → Plano → Design → Bordas/Testes → Código limpo  │
│              → Gates → Revisão                               │
├──────────────────────────────────────────────────────────────┤
│  TRANSVERSAIS — por tipo de risco                            │
│  Segurança · Contrato de API · Memória de decisões · Git/PR  │
├──────────────────────────────────────────────────────────────┤
│  SOB DEMANDA — Depuração · Performance · Observabilidade      │
│               Estimativa                                      │
├──────────────────────────────────────────────────────────────┤
│  DOMÍNIOS (plugins) — só o que o time instalar                │
└──────────────────────────────────────────────────────────────┘
```

## Núcleo — pipeline

| Estágio | Skill | Quando |
|---------|-------|--------|
| **0. Orquestração** | `orquestracao-agentes` | Início da task |
| **0.5 Requisitos** | (seção abaixo) | Feature nova, escopo vago, pedido com “e” |
| **0.6 Plano** | (seção abaixo) | Mais de ~3 passos, mais de um repo, entrega em fases |
| **1. Design** | `arquitetura-solid` | Módulo/feature nova, contrato, acoplamento |
| **2. Bordas e testes** | `testes-e-bordas` | Bug, regra de negócio, entrada externa |
| **3. Implementação** | `codigo-limpo` | Sempre ao alterar código |
| **3b. UI / Figma** | `fidelidade-ui` | Tela, layout, Figma, print, espaçamento |
| **4. Verificação** | `gates-verificacao` | Antes de concluir |
| **5. Fecho** | `revisao-pos-implementacao` | Ao terminar |

## Estágio 0.5 — Requisitos e critérios de aceite

Antes do design. Escopo mal definido é a origem mais barata de bug — e a mais
cara de corrigir depois.

**Aplicar quando:** feature nova, US genérica, pedido com “e”/“também”,
regra de negócio não escrita.
**Pular quando:** bug com causa conhecida, fix trivial (label, texto, uma linha), spec já fechada.
**Não pular** só porque a spec existe: se a entrega é tela, Figma ainda manda na implementação (`fidelidade-ui`).

```
- [ ] 1. Ator e valor: quem usa e para quê
- [ ] 2. Escopo: o que entra e, explicitamente, o que fica fora
- [ ] 3. Regras de negócio: limites, permissões, formatos, status
- [ ] 4. Caminho de erro, estado vazio **e loading** (não só o caminho feliz)
- [ ] 5. Dependências: repos, serviços, terceiros
- [ ] 6. Critérios de aceite verificáveis (cada um vira caso em `testes-e-bordas`)
- [ ] 7. Ambiguidades listadas → perguntar antes de codar
- [ ] 8. Identidade vs tela de uso: atributo de cadastro (cor, código) não se
        desenha primeiro na tela operacional — “onde mora?” antes de codar
```

Regras: mais de uma entrega de valor no pedido → propor **fatiar**; não escrever
o “como” técnico no enunciado; critério que não dá para verificar não é critério.

Fontes, na ordem:

1. Spec da task (tracker, doc do produto, aceite escrito) quando houver
2. Código e contratos já existentes nos repos envolvidos
3. Base de conhecimento do time, se estiver configurada

Saída alimenta `arquitetura-solid` (contrato) e `testes-e-bordas` (casos).

## Estágio 0.6 — Plano de execução

Requisitos dizem **o quê**. O plano diz **em que ordem** e **onde parar**.

**Aplicar quando:** mais de ~3 passos, mais de um repo, mudança que atravessa
camadas, entrega que não cabe de uma vez.
**Pular quando:** fix trivial, bug com causa confirmada e correção local.

```
- [ ] 1. Quebrar em passos com resultado verificável cada um
- [ ] 2. Ordenar por dependência: o que precisa existir antes do quê
- [ ] 3. Marcar o primeiro passo que muda comportamento visível (o risco começa ali)
- [ ] 4. Definir checkpoint: onde confirmar com o usuário antes de seguir
- [ ] 5. Definir como reverter cada passo (revert, flag, caminho paralelo)
```

Passando de 3 passos, registrar na **lista de tarefas** — plano que só existe na
resposta se perde no meio da execução.

Regras:

1. Ordem que reduz risco: **preparação** (renomear, extrair, mover sem mudar
   comportamento) → **comportamento** → **limpeza**. É o mesmo split do `git-pr`,
   só decidido **antes** de codar em vez de na hora do commit.
2. Checkpoint obrigatório antes de: migração de dados, mudança de contrato já
   consumido, remoção de código, fluxo de pagamento ou dado sensível.
3. Passo sem resultado verificável não é passo — é intenção.
4. Plano é hipótese. Se um passo mostrar que a ordem estava errada, replanejar
   explicitamente; não seguir plano morto até o fim.

## Transversais — ativam por gatilho

| Agente | Skill | Gatilho |
|--------|-------|---------|
| **Segurança** | `seguranca-codigo` | Authz, login, upload, PII/LGPD, segredo, entrada externa |
| **Contrato de API** | `contrato-api` | Payload/DTO/enum/erro cruzando serviço ou front↔API |
| **Memória** | `memoria-decisoes` | Decisão com trade-off; achado repetido 2ª vez |
| **Git/PR** | `git-pr` | Commit, PR, split de mudança grande |

## Sob demanda

| Agente | Skill | Quando |
|--------|-------|--------|
| **Depurador** | `depuracao-evidencia` | Bug, erro, stacktrace, regressão |
| **Performance** | `performance-app` | Lento, timeout, N+1, bundle, re-render |
| **Observabilidade** | `observabilidade` | Log, erro em produção, correlação, alerta |
| **Estimador** | `estimativa-task` | Sizing, horas, esforço |

## Domínios (plugins)

Só carregar se o projeto/tema casar. Um domínio por núcleo de task.

Este repositório **não inclui** packs de produto. Cada time instala o próprio
domínio (skill + linha na tabela abaixo). Enquanto não houver pack, o núcleo
roda sozinho.

| Agente | Skill | Quando |
|--------|-------|--------|
| DBA | `senior-banco-dados` | SQL, schema, índice, plano, migração, LGPD no banco |

### Como adicionar um domínio novo

1. Criar skill em `~/.cursor/skills/<nome>/SKILL.md` (description com triggers).
2. Registrar uma linha na tabela de domínios desta skill.
3. Manter o **núcleo** intacto (nenhum estágio depende de domínio).

## Pipelines

### Feature nova

```
Estimador? → Domínio? → Requisitos → Plano → Design → Bordas/Testes
           → Implementação (`codigo-limpo` + `fidelidade-ui` se houver tela)
           → Gates → Fecho
Transversais: Segurança (se toca dado/permissão) · Contrato (se cruza serviço)
Entrega: Git/PR · Memória (se houve decisão)
```

### Desacoplamento / refactor estrutural

```
Plano (preparação → comportamento → limpeza) → Costura + teste de caracterização
     → Extrair interface → Trocar miolo (gates a cada passo) → Remover órfão
Skill: arquitetura-solid (seção "Desacoplar código que já existe")
Contrato: se a costura cruza serviço ou front↔API
```

### Bug

```
Depuração (causa confirmada) → Teste vermelho → Correção → Gates → Fecho
Memória: se o achado é o mesmo de antes, promover a regra
```

### Fix trivial (label, texto, uma linha)

```
Implementação → Gates → Fecho
(pular design e matriz de bordas)
```

**Não é trivial:** Figma, layout, espaçamento, tela nova, controle visível
(expandir, tabela, divisor). Aí entra `fidelidade-ui`.

### Pergunta / arquitetura (sem diff)

```
Domínio? → responder
Sem gates, sem fecho
```

## Regras

1. Núcleo **não depende** de domínio algum.
2. Um domínio (ou nenhum) por task; transversais podem somar.
3. Calibrar ao tamanho: design e bordas são dispensáveis em ajuste trivial
   (label/texto); Figma/layout não é trivial. Gates e fecho, nunca.
4. Não pedir “revise” ao usuário: o fecho é do agente.
5. Não afirmar que funciona sem evidência de execução.
6. Achado crítico de segurança **bloqueia** o fecho.
7. Regras duras do produto (branch, ID de task, changelog) ficam na skill do domínio.

## Frases que disparam

- Núcleo: feature, bug, implementa, arquitetura, SOLID, teste, “compila?”, revise,
  Figma, layout, espaçamento, “não está igual”, “ajeite o load”, “onde colocar”
- Transversal: permissão, LGPD, CPF, segredo, payload, DTO, contrato, commit, PR
- Sob demanda: lento, N+1, log, monitoramento, stacktrace, horas, sizing
- Domínio: nomes do produto/repo do pack instalado, SQL, deploy

## Donos de gatilho (desambiguação)

Cada palavra tem **um** dono. As demais skills apenas delegam — se duas
reivindicarem o mesmo gatilho, a escolha vira sorteio.

| Gatilho | Dono | Confusão comum |
|---------|------|----------------|
| bug, erro, stacktrace, “não funciona” | `depuracao-evidencia` | Não é `observabilidade` (essa decide o que logar daqui pra frente) |
| teste, borda, cobertura, TDD | `testes-e-bordas` | **Escreve** o caso; `gates-verificacao` **executa** a suíte |
| compila?, roda?, suíte passou? | `gates-verificacao` | — |
| revise, tem bugs?, self-review | `revisao-pos-implementacao` | `codigo-limpo` é o catálogo de critérios, não a passagem |
| clean code, cheiro, nome ruim, função grande | `codigo-limpo` | — |
| contrato **novo**, módulo novo, SOLID | `arquitetura-solid` | Alterar contrato **já consumido** é `contrato-api` |
| desacoplar, “mexo aqui e quebra lá”, refactor estrutural | `arquitetura-solid` (seção de legado) | `codigo-limpo` é higiene do diff, não mudança de estrutura |
| ordem dos passos, “por onde começo”, entrega em fases | `orquestracao-agentes` (estágio 0.6) | Split no commit é `git-pr`, e chega tarde |
| log, correlação, alerta | `observabilidade` | PII em log é `seguranca-codigo` |
| lento, N+1, timeout | `performance-app` | Query lenta em banco é `senior-banco-dados` |
| Figma, layout, espaçamento, alinhamento, “não está igual ao Figma”, tela **nova**/card/tabela visual, ícone de aba, “ícone sumiu”, “ajeite o load”, skeleton, “ficou em cima”, faixa/scroll | `fidelidade-ui` | “Tela lenta” é `performance-app`; label isolado sem print não entra; “onde mora no cadastro?” é `arquitetura-solid` |
| “onde seria interessante colocar”, “não seria no cadastro?”, identidade vs tela de uso | `arquitetura-solid` | Overlay/canto de controle visível é `fidelidade-ui` |
| “não tá saindo da lista”, sumiu numa superfície e ficou na outra | `depuracao-evidencia` | Não é polish de `fidelidade-ui` — é mutação que não atualiza todas as vistas |
| CREATE TYPE, Prisma `enum` no schema, tipo SQL novo | `senior-banco-dados` | Union TS / `@IsIn` não é enum de banco |

Ao criar skill nova: se a description repetir gatilho de outra, qualificar
(“contrato **já consumido**”) ou delegar explicitamente (“quem faz X é Y”).
