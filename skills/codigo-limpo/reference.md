# Código Limpo — referência

Ler quando a task pedir revisão profunda, exemplificação ou formato de feedback.

## Nomes

- Evitar: `data`, `info`, `temp`, `handler2`, abreviações obscuras
- Preferir: `findUserById`, `hasUser`, `isActive`, `canEdit`
- Em legado com typo histórico: só renomear se a task incluir

## Funções

- Early return / guard clauses em vez de nesting profundo
- Flag booleana que muda o comportamento inteiro → duas funções explícitas
- **Não adicionar comentários** (`//`, `/* */`, JSDoc). Nome e estrutura bastam;
  bloco que “precisa de seção comentada” → extrair função
- Separar comando (mutação) de consulta quando misturar atrapalhar leitura

## Erros e bordas (APIs)

- Validar entrada no controller/use-case
- `undefined` em campo opcional ≠ `false` (ex.: `active` em update)
- Preferir mensagem útil em PT-BR em painéis operacionais
- Não usar exceção para fluxo normal previsível quando status/Result basta
- Após `findFirst`/`findUnique`, tratar `null` antes de usar propriedades

## Camadas

```
HTTP / Controller  → parse, validate, orquestra
Service / Use-case → regra de negócio
Repository / DB    → persistência
Integrações        → GraphQL, filas, HTTP externos
```

## Exemplos rápidos

### Ruim — confiar no client

```ts
if (permission.previousExists) { /* update */ }
else if (permission.active) { /* create */ }
```

O form pode omitir `previousExists` → cria duplicata.

### Bom — consultar o estado real

```ts
const existing = await findUserPermissions(...)
if (existing.length) { /* update se mudou */ }
else if (active) { /* create */ }
```

### Ruim — destructuring inseguro

```ts
const { id: userId } = await users.findFirst(...)
```

### Bom

```ts
const user = await users.findFirst(...)
if (!user) { /* hasUser: false ou 404 */ }
```

### Ruim — update com default perigoso

```ts
await update({ data: { active: !!body.active } }) // undefined → false
```

### Bom

```ts
const nextActive =
  body.active === undefined || body.active === null
    ? current.active
    : !!body.active
```

## Formato de revisão (quando o usuário pedir revisão / bugs)

Ordenar achados do mais grave ao menos:

1. **Crítico** — crash, perda/corrupção de dados, segurança, regressão de fluxo
2. **Importante** — bug de borda, contrato API quebrado, duplicação perigosa
3. **Sugestão** — clareza, SRP, nome, early return
4. **Opcional** — nit de estilo alinhado ao repo

Para cada item: **onde** (arquivo/trecho) → **por quê** → **como corrigir** (curto).
Se corrigir na mesma task: aplicar diff mínimo e revalidar checklist do `SKILL.md`.

## Testes

- Ao corrigir bug: adicionar/ajustar teste de regressão se o módulo já tiver suíte no caminho
- Não inventar infraestrutura de teste nova só por clean code
- Preferir testes legíveis que documentam a regra de negócio quebrada

## Relação com outras skills

- Pack de domínio do time: manda no processo; esta skill manda na qualidade do código tocado
- Banco: `senior-banco-dados` para SQL/schema
