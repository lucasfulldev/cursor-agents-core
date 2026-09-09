---
name: arquitetura-solid
description: >-
  Define o desenho antes de codar: SOLID (SRP, OCP, LSP, ISP, DIP), fronteiras
  entre camadas, contratos de entrada/saída/erro e tipos que impedem estado
  inválido. Use ao criar módulo/feature nova, desenhar contrato novo, quebrar
  acoplamento, ou quando o usuário mencionar arquitetura, SOLID, interface,
  injeção de dependência, desacoplar, "onde colocar essa regra". Desenha contrato
  novo; alterar contrato já consumido é contrato-api. Não usar em fix pontual de
  uma linha nem em legado que só recebe patch mínimo.
---

# Arquitetura SOLID (design antes do código)

Skill do núcleo. Roda **antes** de escrever código não trivial. A saída é um
desenho curto (contrato + fronteira + tipos), não um documento.

Depois desta skill: implementar com `codigo-limpo`.

## Quando aplicar

- Módulo, serviço, use-case, hook ou componente **novo**
- Mudança que atravessa camadas (UI ↔ API ↔ domínio ↔ persistência)
- Acoplamento doendo: “mexo aqui e quebra lá” → seção **Desacoplar código que já
  existe** (workflow diferente do de código novo)
- Regra de negócio nova que precisa de lugar certo

## Quando NÃO aplicar

- Correção pontual, ajuste de label, uma linha
- Legado onde a task pede diff mínimo — desacoplar só quando **é** a task
- Já existe padrão canônico no módulo → seguir o padrão, não redesenhar

## Workflow (antes do primeiro edit)

```
- [ ] 1. Enunciar o caso de uso em 1 frase (quem pede, o que recebe, o que sai)
- [ ] 2. Definir contrato: entrada, saída, erros possíveis
- [ ] 3. Escolher a fronteira: onde mora a regra, o que é adaptador
- [ ] 4. Modelar tipos que impeçam estado inválido
- [ ] 5. Listar dependências e o que precisa ser invertido (I/O, tempo, random)
- [ ] 6. Passar a lista de bordas para `testes-e-bordas`
- [ ] 7. Só então codar (`codigo-limpo`)
```

## Desacoplar código que já existe

O workflow acima é para código novo. Quando o acoplamento já está lá e já tem
consumidores, o risco muda de lugar: o inimigo não é o desenho ruim, é **mudar
comportamento sem perceber**.

```
- [ ] 1. Achar a costura: menor ponto onde dá para interceptar sem reescrever
- [ ] 2. Mapear consumidores (grep do símbolo em todos os repos envolvidos)
- [ ] 3. Travar o comportamento atual com teste de caracterização
- [ ] 4. Extrair a interface na costura, com a implementação atual atrás dela
- [ ] 5. Embrulhar e delegar: caminho novo chama o antigo; nada muda ainda
- [ ] 6. Trocar o miolo, testes verdes a cada passo
- [ ] 7. Remover o caminho antigo só quando ninguém mais o importa
```

**Teste de caracterização ≠ teste de regra.** Ele registra o que o código faz
hoje, sem julgar se está certo — inclusive o comportamento errado, que é o
baseline. Se ele quebra durante a extração, você mudou algo sem querer.

Quando a troca não cabe num passo: caminho paralelo atrás de flag, com o antigo
ainda ativo, e remoção depois — nunca os dois meio-prontos ao mesmo tempo.

**Pare e reduza escopo se:** a costura exige tocar mais de ~10 arquivos, ou não
existe forma de observar o comportamento atual. Aí desacoplar não é o próximo
passo.

Se a costura cruza fronteira de serviço ou front↔API, `contrato-api` entra junto.

## SOLID na prática

| Princípio | Prática | Cheiro que denuncia |
|-----------|---------|---------------------|
| **SRP** | Um motivo para mudar por módulo/função | Função que valida + persiste + notifica |
| **OCP** | Estender por novo caso, não editando `switch` gigante | Cada feature nova mexe no mesmo `if/else` |
| **LSP** | Implementação respeita o contrato do tipo | Subtipo que lança onde o pai retorna vazio |
| **ISP** | Interface pequena, focada no consumidor | Interface com 12 métodos e ninguém usa 10 |
| **DIP** | Regra depende de abstração; I/O é injetado | Use-case importando `axios`/ORM direto |

## Fronteiras

```
Entrada (HTTP, UI, fila)  → parse + validação + orquestração
Domínio / use-case        → regra de negócio (puro, testável)
Adaptadores               → HTTP, DB, cache, storage, clock, e-mail
```

Regra: **regra de negócio não importa framework**. Se precisa do `Date.now()`,
do banco ou de rede, isso entra como dependência (parâmetro, port, provider).

## Tipos que evitam bug

- União discriminada em vez de vários booleanos soltos
  (`{status:'loading'} | {status:'ok', data} | {status:'error', error}`)
- Nunca `any` em código novo; `unknown` + validação na borda
- Sem sentinel mágico (`"0"`, `-1`, `""`) — usar `null` + label explícito
- Campo opcional: `undefined` ≠ `false` ≠ “apagar”
- Validar payload externo com schema (zod/similar) na entrada, não espalhado

## Regras de bom senso

1. **Abstração só com segundo caso real** — não criar interface para um único
   implementador (YAGNI vence DIP especulativo).
2. **Composição antes de herança.**
3. **Padrão do repo vence preferência pessoal** — desenho novo só onde não há
   padrão; caso contrário, seguir o vizinho.
4. Desenho cabe em ~10 linhas de resumo. Se não cabe, está grande demais.

## Saída esperada (formato curto)

```
Caso de uso: <1 frase>
Contrato:    entrada / saída / erros
Fronteira:   onde fica a regra | quem é adaptador
Tipos:       decisões que impedem estado inválido
Bordas:      lista para testes-e-bordas
```

## Relação com outras skills

- `codigo-limpo` — implementa o desenho com higiene
- `testes-e-bordas` — recebe a lista de bordas deste desenho
- `contrato-api` — quando a costura cruza serviço ou front↔API
- `git-pr` — um commit por etapa (preparação → comportamento → limpeza)
- `orquestracao-agentes` — pipeline do núcleo e plano de execução
