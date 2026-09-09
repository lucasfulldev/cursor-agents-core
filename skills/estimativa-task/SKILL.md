---
name: estimativa-task
description: >-
  Estima esforço de tasks em horas, com breakdown, buffers e premissas para
  passar ao time. Use quando o usuário pedir quantas horas, estimar task,
  esforço, sizing de sprint, ou passar descrição/ID de task para estimativa.
---

# Estimativa de horas de task

Skill pessoal. Devolve estimativa **pronta para colar** no chat ou no tracker.

**Primeira ação:** ler este `SKILL.md`. Para faixas e exemplos, ler
[reference.md](reference.md).

## Quando usar

- “Quantas horas essa task?” / “estimar esforço” / “passar pro time”
- Sizing de sprint / planning
- Descrição ou ID de task + escopo de feature ou bug

## Quando NÃO usar

- Cronometragem de tempo já gasto (time tracking)
- Compromisso comercial sem revisão humana
- Estimativa de terceiros sem dados de escopo

## Premissas fixas

1. **Saída padrão: faixa de horas + mais provável.** Se o time também usa
   unidades de repertório de contrato, estimar isso à parte — sem inventar
   códigos que não estejam no repertório do time.
2. **Não usar fórmula 1 unidade = 1 h.** Converter por natureza do pacote
   (ver [reference.md](reference.md)).
3. Não prometer data; entregar faixa + confiança.

## Fontes (nessa ordem)

1. Escopo do usuário (texto, aceites, ambiguidades).
2. Tracker da equipe (descrição da task) se houver ID.
3. Calibragem genérica em [reference.md](reference.md) (multi-repo, legado, QA).
4. Estimativa já registrada na task: **referência**, não verdade absoluta —
   confrontar com o breakdown.

## Workflow

```
- [ ] 1. Entender escopo (o que entra / o que fica fora)
- [ ] 2. Listar repos/camadas tocadas (front, API, DB, deploy, docs)
- [ ] 3. Decompor em atividades
- [ ] 4. Classificar o pacote na faixa de horas (reference)
- [ ] 5. Aplicar buffers (abaixo)
- [ ] 6. Emitir template de saída + confiança
```

### Buffers (aplicar sobre a faixa de horas)

| Situação | Buffer |
| :--- | :--- |
| 2+ repos / contratos de API cruzados | +15–25% |
| Legado pouco documentado / schema órfão | +20–40% |
| Regras de negócio ambíguas | +15–30% |
| Inclui QA manual + deploy/homolog no pedido | +10–20% |
| Hotfix cirúrgico, causa já conhecida, 1 repo | 0% (às vezes −10%) |

Não somar todos os máximos cegamente: escolher 1–2 buffers dominantes e
explicar na saída.

### Confiança

| Nível | Quando |
| :--- | :--- |
| Alta | Escopo fechado, analogia clara, poucos repos |
| Média | Escopo ok, 1–2 ambiguidades ou multi-repo |
| Baixa | US genérica, dependências externas, descoberta pesada |

## Template de saída (obrigatório)

```markdown
## Estimativa — [título]
**Horas (time):** X–Y h (mais provável: Z h)
**Confiança:** baixa | média | alta

### Breakdown
| Item | Horas (aprox.) |
| ---- | -------------- |
| ...  | …              |

### Buffers aplicados
- …

### Premissas
- …

### Fora de escopo
- …

### Riscos / perguntas que mudam a conta
- …
```

## Tom para o time

- Direto, em português, números primeiro.
- Não prometer data; entregar faixa + mais provável.
- Se a task já tiver estimativa, dizer se o breakdown **confirma**, **baixa**
  ou **sobe** e por quê.
