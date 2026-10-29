---
name: pr-conflito-main
description: >-
  Quando um pull request para a main dá conflito, atualiza a main, cria uma
  branch nova com sufixo -resolve a partir da branch da feature, faz merge da
  main nela, resolve os conflitos, commita e abre outro PR para a main. Use
  quando o usuário disser que o PR deu conflito, "deu conflito ao abrir o PR",
  "conflito com a main", ou pedir a branch -resolve. Merge que já está em
  andamento com marcadores continua em git-pr. Não usar rebase.
---

# PR com conflito na main

Vale quando o PR já aberto aponta para a `main` e o GitHub marca conflito.
Não rebase. Não reescreva a branch que já subiu. A branch nova carrega a
feature e recebe a `main` por cima.

Base do produto que não seja `main` (release, develop) fica no pack de
domínio. Esta skill não troca a base do PR.

## Passo a passo

Siga nesta ordem. A branch da feature é a que o PR conflitante usa
(ex.: `feat/ajuste-de-cadastro`).

1. Vá na branch `main` e dê `git pull`.
2. Depois vá na branch da feature e crie `<branch-da-feature>-resolve`
   (ex.: `feat/ajuste-de-cadastro-resolve`).
3. Depois faça merge da `main` na branch `-resolve`.
4. Depois resolva os conflitos, faça commit e abra o PR para a `main`.

Árvore suja antes do passo 1: pare e diga o que está modificado. Não misture
arquivo alheio no commit.

Se a branch já termina em `-resolve`, use essa branch. Não crie
`-resolve-resolve`.

## Conflitos

Una as duas intenções: o que a feature fez e o que chegou na `main`. Sem
reformatar o arquivo e sem aproveitar para limpar.

Não abortar o merge. Sem marcador `<<<<<<<` no commit.

Mensagem do commit de merge:

```
Merge branch 'main' into <branch-resolve>

<o que das duas pontas ficou de pé>
```

Gates nos arquivos do conflito (`gates-verificacao`) antes do commit.

## PR

`gh pr create --base main` a partir da branch `-resolve`.

O PR antigo que conflitava permanece. Diga a URL dos dois e qual revisar.
Não feche o antigo sem pedido.

Não usar `push --force`.
