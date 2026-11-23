---
name: estimativa-agente
description: >-
  Estima as horas de sessão do agente e o esforço em UST da task, depois
  de abrir o código que ela mexe. Use quando o usuário disser que o agente
  vai fazer a task, perguntar quantas horas o agente consegue, quanto tempo
  você leva, ou pedir o esforço do agente. Não usar para sizing do time
  humano — isso é estimativa-task.
---

# Horas e esforço do agente

Skill pessoal. Fecha duas contas, separadas:

- **Horas** — sessão do agente até o fecho. Não é hora de pessoa.
- **Esforço** — UST do repertório do contrato, só com código que existe lá.

**Primeira ação:** ler este `SKILL.md`. Faixas e o caso calibrado estão em
[reference.md](reference.md).

## Quando usar

- “Você que vai fazer” / “quanto você leva” / “quantas horas você consegue”
- Gravar esforço na task sabendo que o executor é o agente
- Revisar uma estimativa de time porque o agente é quem implementa

## Quando NÃO usar

- Sizing do time, planning, hora humana → `estimativa-task`
- Cronômetro de tempo já gasto
- Prometer data de entrega

## Regra que fecha o número

O número sai **depois** de abrir os arquivos que a task mexe (menu, guarda,
controller, script, teste). User story sem esses arquivos é faixa provisória,
confiança baixa, e a saída diz o que ainda falta abrir.

Não copiar a tabela de `estimativa-task`. Ela inclui descoberta humana.
Não cobrar hora por arquivo que uma busca acha, nem por guarda que a
história sugere e o código não tem.

## O que entra na conta

- Ler os call sites reais (não o da história)
- Editar
- Teste do comportamento novo, ao lado do spec que já existe
- Gate do repo (typecheck, lint, suíte do que foi tocado)
- Revisão do diff
- QA no browser quando a mudança é de tela, menu ou dado renderizado
- Changelog e roteiro de teste quando a skill do produto exige: somar 0,5 h

## O que fica de fora

- Reunião, fila de review humano, espera de deploy
- Marcar perfil, migrar dado ou mudar contrato já consumido, se o pedido não inclui — listar como risco, não embutir nas horas nem no esforço

## Faixa

Usar a faixa **depois** de decompor. Mais provável é um número da faixa, não a média cega.

| Situação, já olhada no código | Horas do agente |
| :--- | :--- |
| Padrão já existente, 1 repo, poucos arquivos, aceite fechado | 0,5–2 h (mais provável: 1 h) |
| Mesma tela ou endpoint; muda menu, permissão ou cópia de catálogo | 2–5 h (mais provável: 4 h) |
| Bug com área e teste de caracterização já no repo | 1–3 h (mais provável: 2 h) |
| Bug cuja causa ainda não foi lida | 2–6 h — a leitura é o custo |
| Feature pequena, 1 repo, UI reusando componente do produto | 3–8 h (mais provável: 5 h) |
| Dois repos com contrato real (campo novo que o outro lado consome) | 6–12 h (mais provável: 8 h) |
| Schema + tela nova + 2–3 repos | 10–20 h (mais provável: 14 h) |
| Arquivo externo cujo formato ainda não foi aberto | não fechar; ler uma amostra e reestimar |

Acréscimo fixo, não percentual:

| Situação | Somar |
| :--- | :--- |
| QA manual depende de login, perfil ou massa que ainda não está de pé | +1–2 h |
| Suíte do repo é longa e o gate entra no pedido | +0,5–1 h |
| Aceite com dois desenhos possíveis | duas faixas, uma pergunta; sem buffer inventado |

Não somar os acréscimos todos. No máximo um dominante, citado na saída.

## Confiança

| Nível | Quando |
| :--- | :--- |
| Alta | Arquivos da mudança lidos e o repo já tem o mesmo padrão |
| Média | Escopo ok; falta o ambiente ou uma ambiguidade |
| Baixa | Só a user story, ou formato/contrato ainda não aberto |

## Esforço (UST)

O esforço não sai das horas. 4 h pode ser 6 UST. Proibido multiplicar hora por fator ou tratar 1 UST como 1 h.

1. Descrever só os blocos que o código confirmou (o que muda, o que já existe e não entra).
2. Se a ferramenta `commit-to-ust-json` estiver disponível, chamá-la com essa descrição. Sem ela, classificar só com o repertório que o usuário tiver colado.
3. Conferir cada item: o código tem de existir no repertório e a justificativa tem de bater com o arquivo lido. Tirar item de guarda, endpoint ou tela que o código não pede.
4. **Esforço** = soma dos subtotais que passaram. Citar código, quantidade e subtotal.

Códigos com faixa (“6 a 30”) não viram número único sem o time fechar a faixa.

## Gravar no tracker

Só quando o usuário pedir para colocar o esforço.

- Estimativa de tempo = horas mais prováveis, em minutos (`horas × 60`)
- Comentário = o template, com horas e esforço
- Se a task já tem hora de **time** e o executor é o agente, gravar a hora do agente e dizer no comentário o número anterior

## Template de saída

```markdown
## Horas e esforço — [título]
**Horas (agente):** X–Y h (mais provável: Z h)
**Esforço:** N UST
**Confiança:** baixa | média | alta

### O que foi aberto no código
- …

### Horas
| Item | Horas (aprox.) |
| ---- | -------------- |
| ...  | …              |

### Esforço
| Código | Quantidade | UST |
| ------ | ---------- | --- |
| ...    | …          | …   |
| **Total** |  | **N** |

### Premissas
- …

### Fora de escopo
- …

### O que muda a conta
- …
```

Se existir estimativa de time na mesma task, uma linha: hora do time e por que a do agente difere.
