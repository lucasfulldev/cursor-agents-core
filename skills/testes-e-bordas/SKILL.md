---
name: testes-e-bordas
description: >-
  Enumera casos de borda (classes de equivalência e valores-limite) e escreve o
  teste de regressão que falha antes da correção. Use quando o usuário mencionar
  teste, cobertura, casos de borda, TDD, regressão, "e se vier vazio/nulo", e na
  etapa de testes do pipeline ao implementar regra de negócio ou validação de
  entrada. Escreve o teste; quem executa a suíte é gates-verificacao. Não usar
  para criar infraestrutura de teste nova em projeto que não testa.
---

# Testes e bordas

Skill do núcleo. Transforma “acho que funciona” em caso verificável.
Roda **antes ou junto** da implementação; nunca só no final.

## Quando aplicar

- Bug: reproduzir com teste antes de corrigir
- Regra de negócio, cálculo, parsing, formatação, permissão
- Entrada externa (form, payload, query, arquivo)
- Refatoração: rede de segurança no comportamento atual

## Quando NÃO aplicar

- Projeto sem suíte e task pequena → apenas **declarar** os casos verificados à mão
- Mudança puramente visual sem lógica
- Não inventar framework de teste novo por conta própria

## Workflow

```
- [ ] 1. Listar as entradas do trecho (parâmetros, estado, payload, config)
- [ ] 2. Para cada entrada: classes de equivalência + valores-limite
- [ ] 3. Marcar quais bordas o código atual NÃO trata
- [ ] 4. Bug? escrever teste que falha agora (vermelho) e só então corrigir
- [ ] 5. Escolher o nível mais barato que pega o erro (ver tabela)
- [ ] 6. Rodar via `gates-verificacao` e reportar resultado
```

## Matriz de bordas por tipo de dado

| Tipo | Bordas obrigatórias |
|------|---------------------|
| String | `''`, espaços, acentos, muito longa, numérica (`"0"`), `null`/`undefined` |
| Número | `0`, negativo, fração, limite, `NaN`, string numérica, overflow |
| Data | ausente, inválida, timezone/UTC, futuro, ano < 1000, fim de mês, bissexto |
| Lista | vazia, 1 item, N itens, duplicados, ordem, paginação, limite, remoção que também aparece em outra lista |
| Booleano/opcional | `true`/`false`/`undefined` — e `undefined` ≠ `false` |
| ID/relação | inexistente, sem permissão, deletado, FK órfã |
| Externo (API/DB) | timeout, 4xx, 5xx, resposta parcial, retry, idempotência |
| UI | loading, vazio, erro, sem permissão, texto longo, mobile, overlay só depois do asset, duas listas do mesmo id, `undefined` visível, overlay depois de expandir, upload foca o item novo, troca rápida A→B→C, URL de sessão revogada, merge atualiza URL do mesmo id |

## Nível de teste (o mais barato que pega o bug)

| Alvo | Nível |
|------|-------|
| Lógica pura (cálculo, formatação, regra) | Unitário |
| Fronteira (controller, hook, serviço com mock de I/O) | Integração fina |
| Fluxo crítico ponta a ponta | E2E — só se o projeto já tiver |

## Regras

1. **Bug sem teste de regressão** só se o projeto não testa aquele caminho —
   e então declarar explicitamente o que foi verificado manualmente.
2. Teste deve **falhar antes** da correção; se passa antes, ele não prova nada.
3. Um comportamento por teste; nome descreve a regra, não a implementação.
4. Não testar detalhe interno que muda sem quebrar contrato.
5. Seguir o runner e o estilo já usados no repo.

## Relação com outras skills

- `arquitetura-solid` — fornece contrato e lista inicial de bordas
- `gates-verificacao` — executa a suíte e coleta evidência
- `depuracao-evidencia` — usa o teste vermelho como prova da causa
- `codigo-limpo` — higiene do código de produção e do teste
