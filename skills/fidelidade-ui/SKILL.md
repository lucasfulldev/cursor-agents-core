---
name: fidelidade-ui
description: >-
  Implementa tela a partir do design (Figma ou print): mede nós, reutiliza o
  componente já existente no produto e não inventa asset nem espaçamento. Use
  quando houver Figma, print, layout, alinhamento, espaçamento, tela nova, card,
  tabela visual, empty state, ícone de aba, SVG custom, expandir, “ícone sumiu”,
  load, skeleton, “ajeite o load”, scroll da faixa, sombra, “ficou em cima”,
  hit area, cursor, undefined, mesmo modal, “ficou por baixo”, suave,
  “não tá scrollando”, pontos ao expandir, ou o usuário disser que não está
  igual ao Figma. Não usar para API/SQL sem UI, nem para “tela lenta”
  (isso é performance-app).
---

# Fidelidade de UI

Skill do núcleo. Combate o padrão de “quase igual”: implementar de memória,
inventar ilustração, clonar tabela com visual diferente e declarar pronto
sem comparar com o design.

**Origem:** tela com design + módulo irmão no mesmo produto — título desalinhado
do card, sem divisor, canvas grande demais, busca mais estreita que o card,
gaps mistos no mesmo bloco, expandir só resetava zoom, tabela reescrita em
vez da aba vizinha, ícone do Figma virando SVG sem `width`/`height` (some
no tab). Depois: layout “pronto” vazio; faixa que encolhe; controle novo em
cima de outro; hit area de um pixel; tabela irmã reusada mas modal/upload
não; `undefined` na tela; X por baixo da mídia; upload sem focar o item;
overlay que sai do lugar no expandir.

## Quando usar

- Task com Figma, print ou referência visual
- Tela, card, tabela, empty state, espaçamento, alinhamento
- Controle visível no design (expandir, mover, switch, tabs)
- Usuário diz que “não está igual”, “falta o divisor”, “distâncias diferentes”
- Load/skeleton, overflow de faixa, controle “ficou em cima” de outro

## Quando NÃO usar

- API, SQL, contrato, backend sem superfície visual
- Troca de um texto/label **sem** Figma nem print
- “Tela lenta” → `performance-app`
- “Onde mora o atributo no cadastro vs nesta tela?” → `arquitetura-solid`

Layout a partir de Figma **não** é fix trivial. Não pular esta skill.

## Workflow obrigatório

```
- [ ] 1. Achar a tela irmã no mesmo produto (aba/módulo vizinho) e listar o
        que já existe: tabela, empty state, tabs, sheet, botão, header,
        Loading/Skeleton, faixa/strip, modal de anexo
- [ ] 2. Se houver URL de design: **usar a ferramenta** (metadata +
        screenshot + export). Proibido lembrar o layout ou gerar
        ilustração. Anotar width/height/gap que viram CSS
- [ ] 3. Exportar asset do design. Proibido inventar SVG/ilustração que o
        arquivo já tem. Ícone: Lucide se o glifo for o mesmo; senão SVG do
        Figma com `currentColor`
- [ ] 4. Mapear cada controle do design → ação real (nome da camada + ícone)
- [ ] 5. Implementar com as medidas. Um grupo visual = um gap
- [ ] 6. Comparar implementação vs print: colunas alinhadas, divisor, tamanho,
        campo vs card, controles presentes, loading, overflow, hit area
- [ ] 7. **Exercer o gesto novo** (arrastar, upload, expandir, zoom) — print
        estático não prova interação
- [ ] 8. Antes do fecho: listar o que ainda falta vs o design **e** vs o
        vídeo de fluxo. Não esperar “falta mais nada?”
- [ ] 9. Sem essa comparação, a tela não está pronta — lint verde não conta
```

## Regras (verificáveis)

1. **O design ganha.** “Quase igual” é erro. Usar width/height/gap do nó, não
   palpite (`mb-8` num bloco em que o resto é `24px`).
2. **Reutilizar o fluxo irmão, não só o visual.** Tabela, empty state, tabs,
   **e** modal de upload, lista de anexos, tipo de arquivo, ações da linha.
   “Igual ao módulo vizinho” inclui o que acontece no clique. Cópia com
   `padding`/`bg` diferentes é componente novo sem pedido.
3. **Grupo visual, um ritmo.** Título → tabs → texto de ajuda no mesmo stack
   e no mesmo gap. Não misturar `mb-8` com `gap-4` no mesmo bloco.
4. **Campo acima da coluna tem a largura da coluna.** Busca sobre um card
   usa o mesmo grid da primeira coluna — não `max-w` solto.
5. **Controle faz o que o ícone promete.** Expandir/tela cheia abre tela
   cheia. Não reaproveitar o clique para “enquadrar”/resetar zoom.
6. **Controle desenhado e ausente no código é bug**, não polish da próxima
   task (divisor vertical, tela cheia, switch).
7. **Alinhamento de colunas.** Título da esquerda e card da direita na
   mesma linha de topo, se o design mostrar isso.
8. **Ícone customizado tem tamanho intrínseco.** SVG em tab/flex leva
   `width` e `height` no elemento (padrão Lucide). Classe `size-*` só
   no arquivo que o Tailwind **varre** (`app/`, `components/`). Em
   pasta fora do `content` a classe não entra no CSS e o ícone some —
   tamanho 0. `shrink-0`. `currentColor` no `stroke`/`fill`.
9. **Loading não finge tela pronta.** Marcador, rótulo ou thumb no vazio
   enquanto o asset base ainda não pintou é bug. Skeleton (o da tela irmã)
   até o `onLoad`/frame medido; overlay só depois disso.
10. **Faixa que transborda rola, não encolhe.** Item mantém o tamanho do
    design — a mídia enviada **não** estoura altura/largura do thumb.
    Ação fixa (adicionar) permanece visível e **alinhada** com a
    faixa. Affordance de “tem mais” (sombra/fade) só no eixo que
    transborda — e tem que ser visível com os itens reais (N thumbs).
    Sem scroll no eixo que não transborda. Desktop: chevron se o irmão
    tiver; mobile: o gesto do irmão (ex. long-press), não inventar.
11. **Controle novo não cobre controle existente.** Cada overlay tem
    canto/slot próprio. Se o usuário aponta um canto, usar esse canto.
    Área clicável = o botão visível, não um pixel do ícone. Pedido de
    usabilidade fora do Figma (zoom, setas) não pula esta regra.
12. **Duas superfícies, o mesmo id.** Upload, exclusão e reorder têm que
    atualizar **todas** as listas que mostram o item (tabela, faixa,
    modal). Sumir de uma e ficar na outra é bug, não “estado derivado”.
13. **Nunca pintar `undefined`/`null` como texto.** Falta de label de
    tipo/status é buraco de contrato ou de mapa — empty state do irmão,
    não a palavra `undefined`.
14. **Gesto = cursor e ghost.** Arrastar mostra mão fechada (ou o cursor
    do irmão). O preview identifica o item; preview genérico não conta.
15. **Chrome acima da mídia.** Fechar, expandir, zoom: `z-index` acima do
    conteúdo. Controle “por baixo” da imagem é bug.
16. **Depois do upload, focar o que entrou.** Selecionar o primeiro do
    lote, rolar a faixa até ele, transição suave (crossfade/scroll) —
    não snap e não deixar o item fora da viewport.
17. **Overlay sobrevive a resize.** Expandir, tela cheia, zoom: posição
    relativa ao quadro **pintado** (`object-fit`/letterbox), medida
    depois do layout. Tamanho do marcador é o px do design, não escala
    solta com o container.
18. **Variante do design é escopo.** Se o Figma tem estados (tipo A /
    tipo B no clique), os dois entram na entrega. Default sozinho = falta.

## Anti-padrões

- Ilustração/SVG inventados com o Figma aberto (smile no lugar da estrela)
- SVG custom só com `className="size-[18px]"` em pasta fora do `content` do Tailwind
- Tabela nova quando a aba vizinha já tem `Table` + `TableEmptyState` + ações
- `fitView()` no botão de expandir
- Declarar layout ok depois de ler o CSS, sem bater no print
- Tratar pedido de Figma como “ajuste trivial” e pular medida
- Canvas/card “pronto” com pontos ou labels no branco, thumbs vazias
- Encolher item da faixa para caber tudo na viewport
- Zoom/ação nova no mesmo canto das setas já existentes
- Esperar o usuário perguntar “falta mais nada?” para conferir o Figma
- Reusar a tabela irmã e inventar outro modal/upload
- `undefined` visível; X/expandir por baixo da imagem
- Upload que não seleciona nem rola até o item novo
- Pontos/marcadores que saltam ao expandir porque mediram o box, não a mídia
- Gerar ilustração com a URL do Figma aberta, sem puxar o asset
- Declarar drag/upload/expandir ok só com print, sem exercer o gesto

## Evidência no fecho

Citar: nós/medidas usados, **ferramenta de design** (não memória), componente
irmão reutilizado, gesto exercido (drag/upload/expandir), o que conferiu no
print (alinhamento, divisor, tamanho, controles, loading, overflow, hit
area) e o que ainda falta vs o design. Sem isso, a UI não passou.

## Relação com outras skills

- `orquestracao-agentes` — dispara esta skill quando a task tem UI/Figma
- `arquitetura-solid` — “onde mora” o atributo (cadastro vs tela); overlay é aqui
- `codigo-limpo` — higiene do código; fidelidade visual é aqui
- `revisao-pos-implementacao` — no fecho de diff de UI, aplica estas regras
- `performance-app` — dono de “tela lenta”
- Pack de domínio — Figma MCP, path de assets e módulo irmão do produto
