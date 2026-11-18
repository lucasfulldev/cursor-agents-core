---
name: revisao-pos-implementacao
description: >-
  Dona de toda revisão de código: passa no diff da task procurando só defeito
  que quebra comportamento, contrato, dado ou segurança, corrige na mesma
  resposta e conclui. Use ao fechar mudança de código e quando o usuário pedir
  "revise", "revisar", "revisão de qualidade", "revisar PR/diff", "tem bugs?",
  self-review, ou o comando `/revisar`. Não usar em pergunta conceitual sem
  mudança de código.
---

# Revisão pós-implementação

Fecho automático de qualquer mudança de código. Objetivo: achar **defeito real**,
não opinar sobre estilo. Zero achados é veredito válido.

## 1. Escopo

- Alvo = arquivos alterados **nesta task**: diff contra a base da feature
  (ex.: `origin/release`) mais os não rastreados que a task criou.
- Trabalho anterior na mesma branch, de outra task ou de commit antigo não entra,
  a menos que o usuário diga "branch", "PR" ou "tudo".
- O veredito começa com o escopo: arquivos tocados, em uma linha.

## 2. O que é achado

Entra como achado só se cumprir os dois itens:

1. **Caminho de execução concreto**: entrada ou estado → passo → resultado errado.
   Escrever em uma frase. Sem caminho, não é achado.
2. **Categoria de defeito**: crash ou `null` com entrada válida; resultado visível
   errado num caminho que a UI ou a API oferece; campo enviado e ignorado; opção
   oferecida e não honrada; dado persistido errado; vazamento, IDOR ou PII; regra
   de negócio violada; regra nova sem teste num módulo que já tem suíte.

Não é achado, e não entra no veredito: nome, tamanho de função, SRP, DRY,
"poderia extrair", early return, estilo, comentário, ordem de import, código
vizinho não tocado, comportamento antigo fora do diff.

Antes de reportar, confirme no código: DTO, validador, caller ou guard que já
protege o caminho derruba o achado. Se a proteção existe, não é defeito.

## 3. Passagem única com checklist fixo

Rodar as mesmas dimensões, na mesma ordem, em cada arquivo do escopo. Cada
dimensão termina em "ok" ou em achado com caminho.

| # | Dimensão | Pergunta |
|---|----------|----------|
| 1 | Entradas | Opcional `undefined`, `null` ou vazio tratado? Valor fora da allowlist? |
| 2 | Ponta a ponta | Todo campo enviado é aceito **e usado**? Toda opção que a UI oferece é honrada pelo backend? |
| 3 | Estado derivado | Effect ou memo sincroniza? Valor inválido após troca de contexto é resetado? |
| 4 | Persistência | Update parcial não apaga o que foi omitido? Estado vem do banco, não de flag do cliente? |
| 5 | Autorização | Recurso filtrado pelo contrato ou tenant do usuário? Dado pessoal fora de log e de URL? |
| 6 | Erros | `find*` que retorna `null` é tratado? Catch não engole falha parcial? |
| 7 | Testes | Regra nova tem teste, quando o módulo já tem suíte? |
| 8 | Sobras | `console.log`, debug, código morto, comentário novo, `as any` novo? |

A dimensão 2 pega a maioria dos defeitos de filtro, payload e enum: a UI oferece
a opção e o backend ignora. Não pule.

## 4. Gates

Rodar os gates que o projeto tem (typecheck, lint dos arquivos tocados, teste do
módulo). Citar comando e resultado. Erro pré-existente em arquivo não tocado não
é achado; só entra se a task causou a falha.

## 5. Corrigir e concluir

- Crítico e importante: corrigir nesta resposta, com diff mínimo e teste de
  regressão quando o módulo tem suíte.
- Depois da correção, rechecar só o que mudou. Não refazer o checklist inteiro.
- Veredito:

```
Revisado: <N> arquivos (<lista curta>).
Achados: <nenhum> | <lista de críticos e importantes, já corrigidos>.
Gates: <comando → ok | falha>. Não verificado: <o que não deu para rodar, ou "nada">.
```

## 6. Repetição e parada

- Uma passagem por resposta. Não fazer segunda busca "para garantir".
- Se o usuário pede "revise" de novo e o diff não mudou desde a última revisão
  desta conversa: repetir o veredito anterior. Não procurar de novo.
- Se o diff mudou: revisar só o delta, mais as dimensões 2 e 3 nos arquivos que o
  delta afeta.
- Nunca completar uma cota de achados. Zero achados é o veredito certo quando não
  há defeito.
- Não perguntar "quer que eu revise?" nem pedir ao usuário para revisar.

## 7. Sugestões só sob pedido

Sugestão de refatoração, nome, estilo ou clareza só aparece se o usuário pedir
explicitamente ("sugestões", "nits", "refatora", "deixa mais limpo"). Nesse caso,
listar em bloco separado, depois do veredito, sem misturar com defeito.

Se a mudança só fica correta com refatoração, o problema já é defeito com caminho
de execução e entra como achado.

## Gatilhos que elevam para importante

- Permissão, login, upload, PII, segredo: `seguranca-codigo`. Falha crítica bloqueia o fecho.
- Payload consumido por outro serviço ou pelo front: `contrato-api`. PATCH que transforma campo omitido em `null` é importante.
- Tela com Figma ou print: `fidelidade-ui`. Loading que finge tela pronta, `undefined` na tela, thumb vazia e duas superfícies do mesmo id dessincronizadas são importantes.
- Schema ou migration: `CREATE TYPE ... AS ENUM` ou Prisma `enum` é importante (VARCHAR com validação na API).
- Achado igual ao de uma revisão anterior: `memoria-decisoes`, para virar regra.

## Relação com outras skills

- `codigo-limpo`: critério de escrita. Esta revisão não usa a checklist de estilo dele.
- `gates-verificacao`: execução e evidência do fecho.
- `testes-e-bordas`: regressão quando o achado é bug.
- `fidelidade-ui`: no fecho de tela, comparação com o design.
- Pack de domínio do time: processo do produto. Esta skill cuida da qualidade do diff.
