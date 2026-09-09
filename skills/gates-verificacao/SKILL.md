---
name: gates-verificacao
description: >-
  Executa os comandos de verificação que o projeto oferece (typecheck, lint,
  build e a suíte existente) nos arquivos tocados e reporta a evidência antes de
  concluir. Use ao fechar implementação, antes de commit/PR, ou quando o usuário
  perguntar se compila, se roda, se a suíte passou. Executa a suíte; quem
  escreve caso novo é testes-e-bordas. Não usar quando não houve
  alteração de código.
---

# Gates de verificação

Skill do núcleo. “Funciona” só pode ser afirmado com **saída de comando**,
nunca por leitura do diff.

Modo **adaptativo**: roda o que o projeto tem; declara o que não tem.

## Quando aplicar

- Depois de editar código, antes do veredito final
- Antes de commit, push ou PR
- Quando o usuário pergunta “compila?”, “passou?”, “tá funcionando?”

## Workflow

```
- [ ] 1. Descobrir comandos disponíveis (package.json, Makefile, pyproject, CI)
- [ ] 2. Rodar na ordem: typecheck → lint (arquivos tocados) → testes do caminho
- [ ] 3. Build só se for rápido ou se a mudança afetar bundle/tipos globais
- [ ] 4. Falhou? corrigir e rodar de novo (máximo 2 ciclos)
- [ ] 5. Reportar tabela comando → resultado
- [ ] 6. Declarar o que NÃO existe no projeto (sem inventar infra)
```

## Onde procurar os comandos

| Stack | Fonte |
|-------|-------|
| Node/TS | `package.json` → `scripts` (`test`, `lint`, `typecheck`, `build`, `tsc`) |
| Python | `pyproject.toml`, `Makefile`, `tox.ini` (`pytest`, `ruff`, `mypy`) |
| Qualquer | workflow de CI (`.github/workflows`) — replicar localmente o que for barato |

Se o projeto expõe suíte parcial, rodar **só o arquivo/caminho tocado** em vez
da suíte inteira quando ela for longa.

## Formato do relatório

```
| Gate       | Comando                  | Resultado        |
|------------|--------------------------|------------------|
| Typecheck  | npx tsc --noEmit         | ok               |
| Testes     | npm test -- <arquivo>    | 3/3              |
| Lint       | (não configurado)        | não disponível   |
```

Resumo em uma frase: o que rodou, o que passou, o que ficou sem cobertura.

## Regras

1. **Não afirmar sucesso sem execução.** Sem gate disponível → dizer que a
   verificação foi apenas por leitura.
2. Erro pré-existente (não causado pela task) → reportar, não corrigir junto,
   salvo pedido.
3. Não desligar regra de lint nem `@ts-ignore` para “passar” o gate.
4. Comando longo (build/E2E) → rodar em background e reportar quando terminar.
5. Máximo 2 ciclos de correção automática; depois, relatar e pedir direção.

## Relação com outras skills

- `revisao-pos-implementacao` — exige esta evidência no fecho
- `testes-e-bordas` — define o que deve ser executado
- `codigo-limpo` — corrige o que o gate acusar
