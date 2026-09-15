---
name: fidelidade-ui
description: >-
  Implementa tela a partir do design (Figma ou print): mede nós, reutiliza o
  componente já existente no produto e não inventa asset nem espaçamento. Use
  quando houver Figma, print, layout, alinhamento, espaçamento, tela nova, card,
  tabela visual, empty state, ícone de aba, SVG custom, expandir, “ícone sumiu”,
  ou o usuário disser que não está igual ao Figma. Não usar para API/SQL sem UI,
  nem para “tela lenta” (isso é performance-app).
---

# Fidelidade de UI

Skill do núcleo. Combate o padrão de “quase igual”: implementar de memória,
inventar ilustração, clonar tabela com visual diferente e declarar pronto
sem comparar com o design.

**Origem:** tela com design + módulo irmão no mesmo produto — título desalinhado
do card, sem divisor, canvas grande demais, busca mais estreita que o card,
gaps mistos no mesmo bloco, expandir só resetava zoom, tabela reescrita em
vez da aba vizinha, ícone do Figma virando SVG sem `width`/`height` (some
no tab).

## Quando usar

- Task com Figma, print ou referência visual
- Tela, card, tabela, empty state, espaçamento, alinhamento
- Controle visível no design (expandir, mover, switch, tabs)
- Usuário diz que “não está igual”, “falta o divisor”, “distâncias diferentes”

## Quando NÃO usar

- API, SQL, contrato, backend sem superfície visual
- Troca de um texto/label **sem** Figma nem print
- “Tela lenta” → `performance-app`

Layout a partir de Figma **não** é fix trivial. Não pular esta skill.

## Workflow obrigatório

```
- [ ] 1. Achar a tela irmã no mesmo produto (aba/módulo vizinho) e listar o
        que já existe: tabela, empty state, tabs, sheet, botão, header
- [ ] 2. Ler o design: metadata (x, y, width, height, gap) + screenshot.
        Anotar as medidas que viram CSS — não chutar
- [ ] 3. Exportar asset do design. Proibido inventar SVG/ilustração que o
        arquivo já tem. Ícone: Lucide se o glifo for o mesmo; senão SVG do
        Figma com `currentColor`
- [ ] 4. Mapear cada controle do design → ação real (nome da camada + ícone)
- [ ] 5. Implementar com as medidas. Um grupo visual = um gap
- [ ] 6. Comparar implementação vs print: colunas alinhadas, divisor, tamanho,
        campo vs card, controles presentes
- [ ] 7. Sem essa comparação, a tela não está pronta — lint verde não conta
```

## Regras (verificáveis)

1. **O design ganha.** “Quase igual” é erro. Usar width/height/gap do nó, não
   palpite (`mb-8` num bloco em que o resto é `24px`).
2. **Reutilizar antes de clonar.** Tabela, empty state, chrome de tabs e
   ações da tela irmã entram como estão. Cópia com `padding`/`bg` diferentes
   é componente novo sem pedido.
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

## Anti-padrões

- Ilustração/SVG inventados com o Figma aberto (smile no lugar da estrela)
- SVG custom só com `className="size-[18px]"` em pasta fora do `content` do Tailwind
- Tabela nova quando a aba vizinha já tem `Table` + `TableEmptyState` + ações
- `fitView()` no botão de expandir
- Declarar layout ok depois de ler o CSS, sem bater no print
- Tratar pedido de Figma como “ajuste trivial” e pular medida

## Evidência no fecho

Citar: nós/medidas usados, componente irmão reutilizado, o que conferiu no
print (alinhamento, divisor, tamanho, controles). Sem isso, a UI não passou.

## Relação com outras skills

- `orquestracao-agentes` — dispara esta skill quando a task tem UI/Figma
- `codigo-limpo` — higiene do código; fidelidade visual é aqui
- `revisao-pos-implementacao` — no fecho de diff de UI, aplica estas regras
- `performance-app` — dono de “tela lenta”
- Pack de domínio — Figma MCP, path de assets e módulo irmão do produto
