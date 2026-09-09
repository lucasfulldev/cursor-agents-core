---
name: performance-app
description: >-
  Diagnostica e corrige lentidão de aplicação com medição antes e depois: N+1,
  payload grande, loop de I/O, re-render, lista longa, bundle e imagem. Use
  quando a tela ou endpoint estiver lento, travando, com timeout, muitas
  requisições, ou o usuário mencionar performance, otimizar, memo, bundle. Para
  query/índice/plano de execução, usar a skill de banco.
---

# Performance de aplicação

Skill sob demanda. Regra que governa tudo: **sem medição não há otimização**.

## Quando aplicar

- Tela lenta, endpoint lento, timeout, travamento ao digitar/rolar
- Muitas requisições em cascata
- Bundle grande / primeiro carregamento pesado

## Workflow

```
- [ ] 1. Medir e anotar o número atual (tempo, nº de queries, tamanho, FPS)
- [ ] 2. Localizar o gargalo com evidência (log, devtools, timing, contador)
- [ ] 3. Corrigir UMA causa
- [ ] 4. Medir de novo e comparar com o número inicial
- [ ] 5. Sem ganho → reverter e voltar ao passo 2
```

## Suspeitos por camada

| Camada | Suspeito | Correção típica |
|--------|----------|-----------------|
| Back | N+1 (query no loop) | Buscar em lote / include / join |
| Back | Payload gigante | Selecionar campos, paginar |
| Back | I/O sequencial independente | Paralelizar com cuidado de limite |
| Back | Serialização/JSON enorme | Reduzir escopo, stream |
| Back | Falta de cache em dado estável | Cache com invalidação clara |
| Front | Re-render em cascata | Estado no lugar certo antes de `memo` |
| Front | Lista longa | Paginação ou virtualização |
| Front | Waterfall de requests | Paralelizar, prefetch, cache do react-query |
| Front | Bundle | Code splitting, import dinâmico, tirar lib pesada |
| Front | Imagem/asset | Dimensão correta, formato moderno, lazy |

## Regras

1. Não memoizar por superstição: `memo`/`useMemo` sem medição vira ruído e bug
   de dependência.
2. Cache só com regra de invalidação definida — cache errado é bug de dado.
3. Não paralelizar I/O sem limite (estoura conexão/rate limit).
4. Otimização que piora legibilidade precisa de ganho medido para valer.
5. Query lenta, índice e plano de execução → `senior-banco-dados`.

## Formato do resultado

```
Antes:  <métrica>
Causa:  <evidência do gargalo>
Ação:   <mudança aplicada>
Depois: <métrica> (ganho X%)
```

## Relação com outras skills

- `depuracao-evidencia` — mesmo método de hipótese e prova
- `senior-banco-dados` — SQL, índice, plano
- `gates-verificacao` — garantir que a otimização não quebrou comportamento
- `observabilidade` — instrumentar para medir em produção
