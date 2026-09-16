---
name: depuracao-evidencia
description: >-
  Investiga bug por evidência: reproduzir, formular hipótese, instrumentar,
  confirmar a causa e só então corrigir. É a porta de entrada de bug, erro,
  stacktrace, tela em branco, dado errado, comportamento inesperado, "não
  funciona", "parou de funcionar", "não tá saindo da lista", duas listas do
  mesmo item. O teste que trava a regressão vem de testes-e-bordas. Não usar
  para implementar feature nova.
---

# Depuração por evidência

Skill opcional do núcleo. Impede correção por chute: nada é corrigido antes de
a causa estar **confirmada**.

## Quando aplicar

- Erro, exceção, stacktrace, log suspeito
- Resultado errado na tela ou no dado
- Regressão (“funcionava antes”)
- Item some de uma lista e permanece em outra (tabela vs faixa vs modal)

## Quando NÃO aplicar

- Feature nova sem defeito relatado
- Ajuste de texto/estilo pedido pelo usuário

## Workflow

```
- [ ] 1. Reproduzir: entrada exata, passos, ambiente, resultado vs esperado
- [ ] 2. Delimitar: qual camada falha (UI, rede, regra, dado, build)
- [ ] 3. Hipótese única e falsificável ("X vem null quando Y")
- [ ] 4. Instrumentar: log temporário, teste vermelho, git log/blame, query
- [ ] 5. Confirmar ou descartar a hipótese com a evidência coletada
- [ ] 6. Corrigir a causa (não o sintoma) com diff mínimo
- [ ] 7. Travar com teste de regressão (`testes-e-bordas`)
- [ ] 8. Remover instrumentação temporária e rodar `gates-verificacao`
```

## Técnicas por sintoma

| Sintoma | Primeiro movimento |
|---------|--------------------|
| Valor errado na tela | Seguir o dado da origem ao render; achar quem transforma |
| Erro só em produção | Comparar config/env, dado real, timezone, permissão |
| Regressão | `git log -S<termo>` / blame no trecho; comparar com versão boa |
| Intermitente | Buscar assincronia, cache, corrida, ordenação, retry |
| “Nada acontece” | Verificar se o handler roda; log na entrada antes de suspeitar da regra |
| Erro engolido | Procurar `catch` vazio, `?.` mascarando, fallback silencioso |
| Saiu de uma lista e ficou na outra | Mapear as superfícies que leem o mesmo id; a mutação atualiza **todas** |
| Overlay/ponto no lugar errado depois de load | Medir o quadro **depois** do `onLoad`/`ResizeObserver`, não no primeiro paint |

## Regras

1. **Uma hipótese por vez**; registrar o que foi descartado.
2. Não alterar várias coisas de uma vez — perde-se a relação causa/efeito.
3. Sintoma corrigido sem causa entendida = bug adiado; dizer isso ao usuário.
4. Sem reproduzir: reduzir escopo e pedir o dado que falta (id, payload, print).
5. Nada de `console.log` sobrando no fecho.

## Relação com outras skills

- `testes-e-bordas` — teste vermelho como prova e depois como regressão
- `gates-verificacao` — confirma que a correção não quebrou o resto
- `codigo-limpo` — higiene da correção
- `fidelidade-ui` — overflow/loading da faixa; a sincronia das duas listas é aqui
