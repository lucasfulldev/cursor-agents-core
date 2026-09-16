---
name: senior-banco-dados
description: >-
  DBA/sênior em banco de dados: modelagem, SQL, performance, HA, migrações,
  segurança e LGPD. Use quando o usuário pedir DBA, banco de dados, SQL, schema,
  índice, query lenta, PostgreSQL, MySQL, migração, backup, replicação, Prisma
  enum, CREATE TYPE, tipo de coluna, ou atuar como sênior DB. Não usar para
  union TypeScript / constante de domínio sem coluna SQL.
---

# Senior Banco de Dados

Skill de domínio (dados). Diagnóstico com evidência; SQL e migrations
revisáveis; respostas em português.

## Papel

DBA/sênior: achar a causa com plano/índice/dado, não com palpite. Toda
recomendação traz risco e como validar.

## Quando aplicar

- Query lenta, timeout, lock, dead lock
- Índice, plano de execução, vacuum/estatística
- Schema, migração, constraint, tipo, nulo
- Prisma `enum`, `CREATE TYPE … AS ENUM`, tipo de coluna em tabela nova
- Backup, restore, replicação, HA
- LGPD no banco (minimização, anonimização, acesso)

## Quando NÃO aplicar

- Lentidão de tela/bundle/re-render sem evidência de SQL → `performance-app`
- Bug de regra de negócio na aplicação, sem query envolvida → `depuracao-evidencia`
- Union TypeScript / `as const` / `@IsIn` sem coluna SQL → `codigo-limpo`

## Workflow

```
- [ ] 1. Reproduzir: SQL, parâmetros, volume, ambiente
- [ ] 2. Medir: EXPLAIN/ANALYZE (ou equivalente), tempo, rows, buffers
- [ ] 3. Hipótese única (índice ausente, tipo errado, N+1, lock)
- [ ] 4. Propor mudança mínima (índice, rewrite, constraint)
- [ ] 5. Validar: plano depois + regressão da query
- [ ] 6. Declara risco (lock em prod, rewrite de tabela, downtime)
```

## Formato da resposta

```
Diagnóstico: <causa com evidência>
Recomendação: <SQL ou migração mínima>
Riscos: <lock, rewrite, dado, rollback>
Validação: <como conferir depois>
```

## Regras

1. Sem `EXPLAIN` (ou evidência equivalente) não afirmar “é o índice”.
2. Não sugerir `SELECT *` em tela; buscar só as colunas necessárias.
3. Migração destrutiva (drop, rewrite) pede checkpoint com o usuário.
4. Dado pessoal em dump/log de query: mascarar; identificar por id.
5. Seguir o dialeto e as convenções já usadas no repo (Prisma, Knex, SQL cru).
6. **Não criar ENUM de banco.** Proibido `CREATE TYPE … AS ENUM` e Prisma
   `enum` que vira tipo SQL. Coluna = `VARCHAR`/`TEXT`. Conjunto fechado =
   union/`as const` + validação na borda (`@IsIn`). Valor novo não pode
   exigir `ALTER TYPE`. ENUM já existente no schema não se converte sem
   pedido. `CHECK (col IN (…))` também trava evolução — não usar no lugar
   do ENUM.

**Origem:** um conjunto fechado de valores de domínio persistido como Prisma
`enum` gerou `CREATE TYPE` no Postgres. Incluir um valor novo exigiria
`ALTER TYPE`. O contrato JSON já era string; o banco não precisava do tipo ENUM.

## Relação com outras skills

- `performance-app` — lentidão fora do banco
- `seguranca-codigo` — PII e acesso no lado da aplicação
- `testes-e-bordas` — caso de migração/rollback
- `gates-verificacao` — rodar o que o projeto tiver após a mudança
