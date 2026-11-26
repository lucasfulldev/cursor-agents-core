---
name: teste-ui-playwright
description: >-
  Testa UI no navegador com Playwright MCP no Mac: percorre o fluxo, tira
  print de cada tela e procura bug de layout causado pela alteração (botão
  vazando do card, texto cortado, diálogo estreito, overflow). Use em teste
  de UI, Playwright MCP, print da tela, “botão vazando”, diálogo que não
  cabe, ou quando o clique passou e falta checar o visual. Não usar CDP.
  Quem escreve caso de regressão é testes-e-bordas; quem roda a suíte do
  repo é gates-verificacao; quem implementa layout a partir do Figma é
  fidelidade-ui.
---

# Teste de UI com Playwright

Skill sob demanda. O clique que funciona não prova que a tela cabe no card.

**Origem:** um diálogo passou no teste funcional — os botões respondiam ao
clique — e as ações vazavam para fora do card. O print mostrava o defeito;
o fluxo, não.

## Quando usar

- Teste de UI no navegador, no Mac, com Playwright MCP
- Print da tela, diálogo, “botão vazando”, texto cortado, overflow
- A alteração tem superfície visual e o caminho de clique não basta

## Quando NÃO usar

- Escrever caso de regressão ou matriz de borda → `testes-e-bordas`
- Rodar typecheck, lint ou a suíte do repo → `gates-verificacao`
- Implementar tela a partir de Figma ou print de design → `fidelidade-ui`
- Causa de bug ainda não reproduzida → `depuracao-evidencia` primeiro
- API ou SQL, sem tela no navegador

A palavra “teste” sozinha não dispara esta skill.

## Workflow

```
- [ ] 1. Abrir o navegador pelo Playwright MCP. Não usar CDP
- [ ] 2. Entrar só com o login que veio neste pedido
- [ ] 3. Percorrer o fluxo. Em cada tela e cada diálogo, tirar print
- [ ] 4. Olhar o print: layout das telas que a alteração toca
- [ ] 5. Reportar fluxo, layout e o caminho de cada print
```

## Playwright MCP, não CDP

Usar as ferramentas do Playwright MCP já configuradas no Cursor.

No Mac o servidor sobe pelo wrapper `~/.cursor/bin/playwright-mcp.sh`. Ele
remove `--stdio` (o Cursor injeta essa flag; `@playwright/mcp` rejeita e o
processo morre) e abre o Chrome no perfil já configurado.

Proibido como substituto: CDP, `connectOverCDP`, porta de debug,
`chrome://inspect`, outro binário de browser.

Se o MCP não responder, parar e dizer que o Playwright MCP não está no ar.
Não improvisar CDP.

## Print

Uma imagem por tela e por diálogo aberto, inclusive estado vazio e erro.
Não só o caminho feliz.

O print mostra o diálogo inteiro, com a borda do card. Recorte que esconde
a borda não serve: o botão pode estar vazando fora do quadro.

Salvar no `media/` do store do Project, no caminho que o pedido indicar.
Nome curto em kebab-case, com a tela e o estado. Não commitar a imagem no
repositório. Não colocar senha no nome do arquivo. Não fotografar o campo
de senha preenchido.

Snapshot de acessibilidade e clique bem-sucedido não substituem o print.

## Checagem de layout

Olhar a imagem das telas que a alteração toca. O que procurar:

| Defeito | O que se vê |
|---------|-------------|
| Botão vazando | Ação fora do card ou do diálogo, cortada na borda, ou por cima de outro bloco |
| Texto cortado | Título, corpo ou rótulo ilegível, cortado no meio, ou reticências que escondem a ação |
| Diálogo estreito | Largura menor que o conteúdo; botões empurrados para fora; ação primária inacessível |
| Overflow | Scroll horizontal involuntário; conteúdo por baixo de outro; faixa estourando o container |

Fora das telas alteradas, defeito já existente vai à parte e não reprova
esta alteração. Na tela alterada, dúvida conta como achado.

## O que reportar

```
## Fluxo
- <passo>: ok | falhou — <o que apareceu na tela>

## Layout
- Tela: <nome visível>
- Print: <caminho absoluto no store>
- Achado: nenhum | botão vazando | texto cortado | diálogo estreito | overflow
- Veio da alteração: sim | não | incerto

## Credencial
não registrada
```

Falha de layout na tela alterada reprova o teste. Corrigir o produto só se
o pedido incluir a correção.

## Credencial

Esta skill não tem usuário, senha, URL nem ambiente. Quem pede o teste
informa o login na hora. Não repetir a senha no relatório, no print, no log
nem no commit.

## Regras

1. Sem print, a tela não foi testada.
2. Layout se julga na imagem, não no fato de o botão ter recebido o clique.
3. CDP não é fallback do Playwright MCP.
4. Senha nunca é conteúdo da skill nem do relatório.

## Relação com outras skills

- `fidelidade-ui` — implementa o layout; aqui se confere a tela rodando
- `testes-e-bordas` — escreve o caso; aqui se executa o teste visual
- `gates-verificacao` — suíte do repo; print não substitui o gate
- `seguranca-codigo` — senha e dado pessoal fora do relatório
- `depuracao-evidencia` — bug a corrigir: a causa vem antes do patch
