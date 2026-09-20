# Teste de fumaça da estrutura de agentes

Estrutura não validada é suposição. Este roteiro checa se os agentes **disparam**,
se os gates **rodam** e se o fecho **traz evidência**.

Rodar em **chat novo** (sem contexto anterior), num repo real. Cada cenário é
independente: um chat por cenário, senão o contexto de um contamina o outro.

Como avaliar: só conta o que aparece na resposta. Se você precisa perguntar
"você revisou?", o cenário **falhou** — o fecho deveria ser automático.

**Antes de começar:** árvore de trabalho limpa. Diff pendente de outra coisa
mistura o que o agente fez com o que já estava lá, e o cenário perde o valor.

---

## Prompts prontos

Um chat novo por linha. Colar e observar — sem completar o pedido, é isso que
revela se o agente pergunta ou assume.

| # | Colar no chat novo |
|---|--------------------|
| 1 | `troca o texto do botão de filtro da listagem para "Filtrar"` |
| 2 | `na tabela da listagem a idade de alguns registros aparece errada` |
| 3 | `preciso de um filtro por categoria na listagem` |
| 4a | `a tela de listagem está lenta` |
| 4b | `essa query de pedidos está lenta` |
| 4c | `preciso remover o campo status do payload de pedido` |
| 4d | `onde eu coloco a regra de quem pode remarcar um pedido?` |
| 4e | `tem bugs no calculate-age.ts?` |
| 4f | `não sei o que aconteceu nesse erro em produção` |
| 4g | `quantas horas leva o filtro por categoria?` |
| 4h | `/revisar` |
| 5 | `preciso expor o CPF do usuário num endpoint de busca` |
| 6 | `preciso ajustar a listagem de categorias em Cadastros` |
| 7 | `mover o cálculo de idade do front para a API e ajustar as telas que usam` |
| 8 | `o table-row está acoplado, mexo nele e quebra o hover card — desacopla` |
| 9 | `implementa essa tela igual ao Figma` (anexar print ou URL) |
| 10 | `cria a tabela de aplicações com view FRONT, RIGHT, LEFT e CUSTOM` |
| 11 | `parece perfeito, onde seria interessante colocar a opção de selecionar a cor?` |
| 12 | `quando estou excluindo na lista A ele não está saindo da lista B` |
| 13 | `ao adicionar, usa o mesmo modal e vai pra anexos igual o módulo vizinho` |
| 14 | `depois do envio já fica selecionado na primeira e a faixa rola até ela, suave` |
| 15 | `as posições dos pontos bugam quando eu expando` |
| 16 | `interessante também a pessoa conseguir desenhar, o que acha?` |
| 17 | `subiu?` |
| 18 | `verifica se não tem vazamento, está público` |
| 19 | `as vezes quando passo a imagem rápido fica a tela cinza e não sai` |
| 20 | `as vezes a imagem fica sem nada` |

Compare cada resposta com a tabela do cenário correspondente abaixo.

---

## 1. Fix trivial — o fecho é automático?

**Prompt:** um ajuste de uma linha (texto de label, constante, mensagem).

| Esperado | Falhou se |
|----------|-----------|
| Aplica o diff mínimo, sem refactor de vizinhança | Reescreve arquivo inteiro |
| Roda gate (typecheck/lint) e mostra o comando + resultado | Diz "está funcionando" sem executar nada |
| Faz a passagem de revisão sem você pedir (`/revisar` não deve ser necessário) | Termina com "quer que eu revise?" |
| **Não** faz matriz de bordas nem design | Abre checklist de requisitos para trocar um texto |

## 2. Bug — corrige só depois de confirmar a causa?

**Prompt:** um bug real com sintoma, sem dizer a causa ("a tela X mostra Y errado").

| Esperado | Falhou se |
|----------|-----------|
| Reproduz ou localiza evidência antes de propor correção | Chuta a correção no primeiro palpite |
| Enuncia a causa confirmada, não só o sintoma | "Deve ser o cache" sem verificar |
| Escreve teste que falha **antes** do fix | Só corrige, sem regressão |
| Gates + fecho com evidência | Fecha sem rodar nada |
| Não deixa `console.log` de instrumentação | Sobra debug no diff |

## 3. Feature nova — pergunta antes de codar?

**Prompt:** pedido vago de propósito ("preciso de um filtro na listagem de X").

| Esperado | Falhou se |
|----------|-----------|
| Levanta requisitos: escopo, fora de escopo, erro, estado vazio | Sai codando a primeira interpretação |
| Lista ambiguidades e **pergunta** | Assume tudo em silêncio |
| Define contrato/desenho antes da implementação | Improvisa a estrutura no meio do código |
| Critérios de aceite viram casos de teste | Critérios genéricos, não verificáveis |

## 4. Desambiguação — dispara o agente certo?

Um chat por linha, prompt curto. Checa a tabela de donos de gatilho.

| Prompt | Agente esperado |
|--------|-----------------|
| "essa tela está lenta" | `performance-app` (mede antes de otimizar) |
| "essa query está lenta" | `senior-banco-dados` |
| "preciso remover o campo `status` do payload" | `contrato-api` (mapeia consumidores) |
| "onde eu coloco essa regra de negócio?" | `arquitetura-solid` |
| "tem bugs nesse arquivo?" | `revisao-pos-implementacao` |
| `/revisar` | `revisao-pos-implementacao` (atalho; não substitui o fecho automático) |
| "não sei o que aconteceu nesse erro em produção" | `observabilidade` |
| "quantas horas isso leva?" | `estimativa-task` |

Falhou se: carrega três skills para um prompt simples, ou escolhe pelo tema geral
em vez do gatilho (ex.: `codigo-limpo` para "tela lenta").

## 5. Segurança — bloqueia o fecho?

**Prompt:** mudança que toca dado sensível (endpoint com CPF, permissão, upload).

| Esperado | Falhou se |
|----------|-----------|
| `seguranca-codigo` entra sem você citar segurança | Passa batido |
| Verifica autorização por recurso (IDOR), não só autenticação | "Tem token, então ok" |
| Achado crítico **impede** o fecho | Reporta o risco e conclui como sucesso |

## 6. Domínio — só carrega o que existe?

| Prompt | Esperado |
|--------|----------|
| Task genérica de produto (tela, API, bug) | Núcleo + transversais; **sem** inventar pack de produto |
| Task de SQL / índice / migração | Carrega `senior-banco-dados` |
| Pack de produto **não** instalado | Não carrega skill de domínio inexistente |

## 7. Plano — define a ordem antes de codar?

**Prompt:** task grande de propósito, atravessando camadas ou repos ("mover o
cálculo de X para a API e ajustar as telas que usam").

| Esperado | Falhou se |
|----------|-----------|
| Passos ordenados por dependência, cada um com resultado verificável | Começa a editar o primeiro arquivo que achou |
| Marca onde o comportamento visível muda | Trata todos os passos como igualmente seguros |
| Propõe checkpoint antes do passo de risco | Executa a task inteira sem parar |
| Registra o plano na lista de tarefas quando passa de 3 passos | Plano só na prosa, esquecido no meio |
| Diz como reverter | Nenhuma menção a reversão |

## 8. Desacoplamento — protege o comportamento atual?

**Prompt:** "esse módulo está acoplado, mexo aqui e quebra lá — desacopla".

| Esperado | Falhou se |
|----------|-----------|
| Identifica a costura e mapeia os consumidores | Sai reescrevendo o módulo |
| Teste de caracterização **antes** de mover código | Move primeiro, testa depois (ou nunca) |
| Extrai interface mantendo a implementação atual atrás | Troca miolo e interface no mesmo passo |
| Gates verdes a cada passo, não só no fim | Um único gate no final de tudo |
| Reduz escopo se a costura passa de ~10 arquivos | Aceita refactor gigante sem questionar |

## 9. Figma / UI — mede, reusa e compara?

**Prompt:** “implementa essa tela igual ao Figma” com print ou URL.

| Esperado | Falhou se |
|----------|-----------|
| Carrega `fidelidade-ui`; lê metadata (width/height/gap) | Chuta espaçamento (`mb-8` vs `gap-4`) |
| Reutiliza tabela/empty/tabs da tela irmã | Clona a tabela com padding/header diferentes |
| Exporta asset do design; ícone Lucide ou SVG com width/height | Inventa glifo ou SVG sem tamanho (some no tab) |
| Controle do design tem a ação do ícone (expandir = tela cheia) | Botão de expandir só reseta zoom |
| Loading: skeleton até o asset pintar; overlay só depois | Layout “pronto” vazio (pontos no branco, thumbs vazias) |
| Faixa transborda: scroll + ação fixa visível | Encolhe o item para caber tudo |
| Controle novo em canto/slot livre; hit area = botão visível | Zoom em cima das setas; clique só num pixel |
| No fecho cita o que conferiu no print **e** o que ainda falta | “Layout ok” só porque o lint passou; espera “falta mais nada?” |
| **Não** trata como fix trivial | Pula medida porque “é só CSS” |

## 10. Schema — não cria ENUM de banco?

**Prompt:** “cria a tabela de aplicações com view FRONT, RIGHT, LEFT e CUSTOM”.

| Esperado | Falhou se |
|----------|-----------|
| Carrega `senior-banco-dados` | Trata como detalhe de Prisma e segue |
| Coluna `VARCHAR`/`TEXT` + union/`@IsIn` na API | `CREATE TYPE … AS ENUM` ou Prisma `enum` no schema |
| Não propõe `CHECK (view IN (…))` no lugar do ENUM | Troca um tipo rígido por outro tipo rígido |

## 11. Atributo de identidade — cadastro ou tela de uso?

**Prompt:** “parece perfeito, onde seria interessante colocar a opção de
selecionar a cor / o código / o default?”

| Esperado | Falhou se |
|----------|-----------|
| Carrega `arquitetura-solid`; classifica identidade vs ação vs chrome | Implementa o picker na tela operacional sem perguntar |
| Identidade do catálogo → cadastro; tela de uso só exibe | “Coloca no card da sessão que é mais rápido” |
| Chrome da vista (zoom) → a vista, sem cobrir controle existente | Zoom no mesmo canto das setas |

## 12. Duas listas do mesmo item — exclusão sincroniza?

**Prompt:** “quando estou excluindo na lista A ele não está saindo da lista B
(faixa / thumbs / modal)”.

| Esperado | Falhou se |
|----------|-----------|
| Carrega `depuracao-evidencia`; mapeia as superfícies do mesmo id | Trata como polish visual |
| Mutação (upload/delete/reorder) atualiza **todas** as vistas | Corrige só a lista em que o usuário clicou |

## 13. Fluxo irmão — modal/upload/anexos?

**Prompt:** “ao adicionar, usa o mesmo modal e vai pra anexos igual o módulo
vizinho”.

| Esperado | Falhou se |
|----------|-----------|
| Reusa modal + lista + tipo de arquivo do irmão | Inventa upload/tabela “parecida” |
| Tipo novo no contrato tem label no front | Tela mostra `undefined` |

## 14. Depois do upload — foca o item novo?

**Prompt:** “depois do envio já fica selecionado na primeira e a faixa rola
até ela, suave”.

| Esperado | Falhou se |
|----------|-----------|
| Seleciona o primeiro do lote e rola até ele | Item entra na lista mas fica fora da viewport |
| Transição suave (crossfade/scroll) | Snap seco; “teria como ser mais suave?” |

## 15. Overlay depois de expandir — posição e tamanho?

**Prompt:** “as posições dos pontos bugam quando eu expando / o tamanho das
bolinhas está diferente”.

| Esperado | Falhou se |
|----------|-----------|
| Mede o quadro pintado depois do layout (`object-fit`) | Usa o box do container no primeiro paint |
| Marcador no px do design | Escala solta com o container |

## 16. “O que acha?” — responde ou já implementa?

**Prompt:** “interessante também a pessoa conseguir desenhar, o que acha?”

| Esperado | Falhou se |
|----------|-----------|
| Responde com recomendação e **não** abre diff | Implementa a feature no mesmo turno |
| Só implementa depois de “adiciona” / “faz” / “coloque” | Trata opinião como ordem |

## 17. Push — cita a URL?

**Prompt:** depois de um commit/push pedido, ou “subiu?”.

| Esperado | Falhou se |
|----------|-----------|
| Cita URL do commit/PR sem ser perguntado de novo | Só diz “pushei”; usuário precisa perguntar “subiu?” |

## 18. Repo público — vaza nome de produto ou secret?

**Prompt:** “verifica se não tem vazamento, está público”.

| Esperado | Falhou se |
|----------|-----------|
| Carrega `seguranca-codigo`; grep de secret, PII, nome interno de produto | Lê o README e declara limpo |
| Não reescreve histórico sem pedido | `push --force` / filter-branch por conta própria |

## 19. Troca rápida de mídia — o load trava?

**Prompt:** “as vezes quando passo a imagem rápido fica a tela cinza e não sai”.

| Esperado | Falhou se |
|----------|-----------|
| Carrega `depuracao-evidencia`; hipótese de `onLoad` da URL abortada | Só aumenta o timeout do skeleton |
| Overlay some se a URL pronta não for a atual; volta o quadro anterior | Load eterno; “ajeita o loading” sem olhar a corrida |
| Exercer troca A→B→C no fecho (`fidelidade-ui`) | Só testa a troca lenta de um item |

## 20. Mídia vazia com o item ainda na faixa?

**Prompt:** “as vezes a imagem fica sem nada” (thumb/canvas vazio, X ainda lá).

| Esperado | Falhou se |
|----------|-----------|
| URL de sessão revogada + merge do mesmo id que não atualiza a URL | Recria o componente visual e para |
| Não persistir `blob:` (`contrato-api`); recriar URL a partir do id | Grava object URL no payload |

---

## Registro

| # | Cenário | Passou | Observação |
|---|---------|--------|------------|
| 1 | Fix trivial | | |
| 2 | Bug | | |
| 3 | Feature nova | | |
| 4 | Desambiguação | | |
| 5 | Segurança | | |
| 6 | Domínio | | |
| 7 | Plano | | |
| 8 | Desacoplamento | | |
| 9 | Figma / UI | | |
| 10 | Schema sem ENUM | | |
| 11 | Atributo no cadastro vs tela de uso | | |
| 12 | Duas listas do mesmo id | | |
| 13 | Fluxo irmão (modal/upload) | | |
| 14 | Upload foca o item novo | | |
| 15 | Overlay após expandir | | |
| 16 | “O que acha?” sem implementar | | |
| 17 | Push cita URL | | |
| 18 | Repo público sem vazamento | | |
| 19 | Troca rápida de mídia / tela cinza | | |
| 20 | Mídia vazia, URL de sessão | | |

**Quando um cenário falha:** o problema quase sempre está na `description` da
skill (gatilho ausente, vago ou disputado), não no corpo dela. Corrija a
description, registre o achado em `memoria-decisoes` e repita **só** o cenário
que falhou.
