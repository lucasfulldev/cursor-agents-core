# Horas e esforço do agente — referência

Complemento de `SKILL.md`. Ler sob demanda.

## Caso calibrado — menu e permissão

Task: opção nova num grupo de perfil, item no segundo menu, mesma tela do
primeiro menu, permissão desse primeiro menu intacta.

Estimativa de time, só com a user story: 8–16 h (mais provável: 12 h).
Incluía 2–4 h de guards na API.

O que o código mostrou:

- A tela e o módulo já existiam.
- O primeiro menu já usa a permissão atual.
- Os controllers da tela só exigem autenticação.
- A permissão nova segue o script que copia o grupo de um slug irmão.

Horas do agente depois dessa leitura: **3–6 h (mais provável: 4 h)**.
Confiança alta. O topo (6 h) é ambiente sem usuário para marcar a permissão.

O que entrou nas 4 h: script, enum e item de menu, guarda do módulo e da rota
para as duas permissões, testes da matriz, QA dos quatro cenários, changelog
e roteiro de teste.

Esforço, pelo repertório, sobre os mesmos blocos — não sobre as 4 h:

| Código | Quantidade | UST |
| ------ | ---------- | --- |
| DB.1 script da permissão | 1 | 2 |
| P.5 item de menu na tela que já existe | 1 | 2 |
| P.12 guarda da rota | 1 | 1 |
| T.1 teste da matriz | 1 | 1 |
| **Total** |  | **6** |

4 h e 6 UST convivem. Nenhum dos dois converte no outro.

## Como decompor sem inflar

Contar bloco, não arquivo.

| Bloco | Teto típico quando o padrão já está no repo |
| :--- | :--- |
| Achar o call site e o padrão irmão | 0,5 h |
| Script ou seed no formato já usado | 0,5 h |
| Enum + menu + guarda de rota | 1–1,5 h |
| Spec ao lado de um teste que já cobre o módulo | 0,5–1 h |
| Rodar o gate do que foi tocado | 0,5 h |
| QA de tela com app no ar | 0,5–1 h |
| Changelog + roteiro de teste | 0,5 h |

Passou desses tetos: o padrão não era o que parecia, ou o aceite abre
outro desenho. Aí a faixa sobe e a confiança desce para média. Não
esticar o bloco “por segurança”.
