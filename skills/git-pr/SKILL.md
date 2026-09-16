---
name: git-pr
description: >-
  Organiza a entrega em git: commits coesos com mensagem que explica o porquê,
  PR com contexto e risco, e divisão de mudança grande em partes menores. Use
  ao commitar, abrir PR, escrever mensagem de commit, dividir mudança, "subiu?",
  ou quando o usuário mencionar branch, push, split de PR. Regras de
  branch/changelog do produto ficam na skill de domínio.
---

# Git e Pull Request

Skill do núcleo. Cuida da **forma da entrega**; a política de branch de cada
produto pertence à skill de domínio (ex.: branch base e changelog do time).

## Quando aplicar

- Commit, push, PR, rebase de mudança pronta
- Mudança grande que ficou difícil de revisar
- Mensagem de commit ou descrição de PR

## Antes de commitar

```
- [ ] 1. Gates verdes (`gates-verificacao`)
- [ ] 2. Revisar `git diff` inteiro — nada de arquivo entrando por acidente
- [ ] 3. Sem segredo, `.env`, credencial, dump ou log de debug
- [ ] 3b. Repo **público**: grep no diff de nome interno de produto, PII,
        e-mail, path de máquina. Sem `push --force` / rewrite de histórico
        sem pedido explícito
- [ ] 4. Agrupar por preocupação: 1 commit = 1 mudança coesa
```

## Mensagem de commit

```
<verbo imperativo> <o que muda>

<por que muda / que problema resolve>
```

- Assunto curto, sem ponto final, imperativo (“corrige”, não “corrigido”)
- Corpo explica o **porquê**, não repete o diff
- Refactor, feature e fix não se misturam no mesmo commit
- Seguir o padrão já usado no histórico do repo (conventional ou não)

## Descrição de PR

```markdown
## O que muda
<1–3 bullets>

## Por que
<problema / task>

## Risco e impacto
<o que pode quebrar, quais repos/telas>

## Como validar
<passos + gates executados>
```

## Split de mudança grande

Sinais de que precisa dividir: mais de uma preocupação, refactor junto com
feature, dezenas de arquivos, revisor precisando de contexto que não está no PR.

Ordem preferida: preparação (renomear/extrair sem mudar comportamento) → mudança
de comportamento → limpeza do que ficou órfão.

## Regras duras

1. Nunca commitar segredo. Se já foi commitado: rotacionar a credencial.
2. `--amend` só em commit local e não publicado.
3. `push --force` em `main`/`release` só com pedido explícito.
4. Não commitar sem os gates; commit vermelho suja o histórico.
5. Não criar commit “WIP” na entrega final.
6. Depois do push: citar a URL (commit/PR). Não esperar o usuário perguntar
   “subiu?”.

## Relação com outras skills

- `gates-verificacao` — pré-requisito do commit
- `revisao-pos-implementacao` — revisão acontece antes do PR
- Pack de domínio do time — base de branch, nome com ID, changelog
