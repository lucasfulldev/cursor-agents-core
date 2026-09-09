---
name: contrato-api
description: >-
  Garante compatibilidade de contrato entre serviços e front: mapeia produtor e
  consumidores, classifica mudança como aditiva ou breaking, define rollout e
  valida as duas pontas. Use ao alterar payload, DTO, endpoint, query param já em
  uso, mudar ou remover campo,
  enum, resposta de erro, ou quando o front não recebe/envia o campo esperado,
  integração entre repos, versionamento. Não usar para mudança interna que não
  cruza fronteira de serviço.
---

# Contrato de API

Skill do núcleo, **transversal**: ativa quando a mudança atravessa a fronteira
entre serviços ou entre front e API.

Contexto: ambiente multi-repo — um campo renomeado num serviço quebra
consumidores que ninguém lembrou de olhar.

## Quando aplicar

- Alterar DTO, response, request, query param, header, enum, status de erro
- Campo novo que o front precisa consumir
- “O front não está recebendo X” / “a API reclama do payload”
- Integração nova entre dois repos

## Workflow

```
- [ ] 1. Localizar o produtor (quem define o contrato)
- [ ] 2. Localizar TODOS os consumidores (grep do nome do campo/rota nos repos)
- [ ] 3. Diff do contrato: antes → depois
- [ ] 4. Classificar cada mudança (tabela abaixo)
- [ ] 5. Breaking? planejar rollout em duas fases
- [ ] 6. Ajustar produtor e consumidores na mesma task (ou versionar)
- [ ] 7. Validar as duas pontas com `gates-verificacao`
```

## Classificação da mudança

| Mudança | Tipo |
|---------|------|
| Adicionar campo **opcional** na resposta | Aditiva (segura) |
| Adicionar campo opcional aceito no request | Aditiva |
| Renomear campo | **Breaking** |
| Remover campo | **Breaking** |
| Tornar campo obrigatório | **Breaking** |
| Mudar tipo (`string` → `number`, escalar → objeto) | **Breaking** |
| Mudar semântica com o mesmo nome (`age` em anos → meses) | **Breaking silencioso** (pior) |
| Novo valor em enum consumido por `switch` | Breaking se o consumidor não tem default |
| Mudar status/shape de erro | Breaking se o front trata por shape |

## Rollout de mudança breaking

```
Fase 1: produzir o campo novo mantendo o antigo (aditivo)
Fase 2: migrar consumidores
Fase 3: remover o antigo quando ninguém mais lê
```

Se não é possível faseiar: alterar produtor e consumidores **na mesma entrega**,
listando os repos tocados.

## Itens que sempre valem conferir

- Contrato de **erro**: código, mensagem, shape estável para o front
- **Paginação**: nome dos params, base 0/1, total vs hasNext
- **Idempotência** em POST que pode ser reenviado
- **Nulabilidade**: campo opcional no back precisa de default no front
- **Data/hora**: fuso e formato (ISO com offset) combinados nas duas pontas
- Tipos do consumidor gerados/duplicados manualmente → atualizar junto

## Regras

1. Não renomear campo ajustando só um lado do contrato.
2. Semântica muda → **nome muda**. Reaproveitar nome esconde bug.
3. Consumidor nunca confia em campo obrigatório sem tratar ausência.
4. Antes de remover algo, provar que ninguém lê (busca nos repos, não memória).

## Relação com outras skills

- `arquitetura-solid` — define o contrato antes de codar
- `testes-e-bordas` — payload ausente/nulo/enum novo como casos
- `gates-verificacao` — typecheck nas duas pontas
- `seguranca-codigo` — campo sensível novo no payload
- Pack de domínio do time — quais repos varrer
