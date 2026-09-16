---
name: memoria-decisoes
description: >-
  Registra decisão técnica não óbvia em ADR curto e promove achado recorrente a
  regra permanente. Use ao escolher entre alternativas de arquitetura, quando o
  mesmo problema reaparece pela segunda vez, ao perguntar "por que fizemos
  assim", ou quando o usuário mencionar ADR, registrar decisão, aprendizado,
  padrão recorrente. Não usar para decisão trivial ou já padronizada no repo.
---

# Memória de decisões

Skill do núcleo, **transversal**. Combate dois desperdícios: decisão sem rastro
(“por que está assim?”) e o mesmo achado sendo corrigido de novo a cada mês.

## Quando aplicar

- Escolha entre alternativas com trade-off real (biblioteca, fronteira, formato)
- Decisão que contraria o padrão do repo (precisa justificar)
- Achado de revisão que aparece pela **segunda** vez
- Bug de produção com causa que vale documentar

## Quando NÃO aplicar

- Decisão trivial ou já coberta por padrão existente
- Documentar tudo por reflexo (ADR virando ruído)

## ADR curto (8 linhas, não relatório)

```markdown
# ADR <NNNN> — <decisão em uma linha>
Data: AAAA-MM-DD | Status: aceita | substituída por <NNNN>

Contexto: <o problema e a restrição real>
Decisão: <o que foi escolhido>
Alternativas: <o que foi descartado e por quê>
Consequência: <o que fica mais fácil / mais difícil>
```

Onde gravar, na ordem:

1. `docs/adr/NNNN-<slug>.md` no próprio repo, se existir a pasta
2. Pasta de docs do domínio (ex.: base do produto)
3. Base de conhecimento do time, se estiver configurada

Nunca inventar estrutura nova de documentação sem confirmar.

## Achado recorrente → regra

Gatilho: o mesmo tipo de problema aparece **duas vezes** em revisões.

```
- [ ] 1. Nomear o padrão (ex.: "sentinel '0' em vez de null")
- [ ] 2. Escrever a regra em uma frase verificável
- [ ] 3. Adicionar no lugar certo:
        checklist de `codigo-limpo`      → higiene geral
        matriz de `testes-e-bordas`      → caso de borda
        `arquitetura-solid`              → decisão de design
        `.cursor/rules/*.mdc` do projeto → convenção daquele repo
- [ ] 4. Citar o exemplo real que originou a regra
```

Regra vaga não entra. `"tratar bem os nulos"` não é regra;
`"campo ausente vira null + label explícito, nunca 0 ou string vazia"` é.

Promover a partir de uma conversa longa: contar **tipos** de pergunta, não
só o cluster maior. Cada tipo com 2+ ocorrências vira regra no skill dono.
Parar no topo (layout) e ignorar upload/`undefined`/resize é a promoção
incompleta.

## Regras

1. ADR registra **decisão**, não narrativa de implementação.
2. Decisão revista não é apagada: novo ADR marca o anterior como substituído.
3. Uma regra nova por achado; não reescrever o guia inteiro.
4. Se o repo já documenta a decisão, atualizar em vez de duplicar.

## Relação com outras skills

- `revisao-pos-implementacao` — origem dos achados recorrentes
- `codigo-limpo` / `testes-e-bordas` / `arquitetura-solid` — destino das regras
- `arquitetura-solid` — decisões de fronteira que merecem ADR
