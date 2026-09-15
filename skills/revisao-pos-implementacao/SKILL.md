---
name: revisao-pos-implementacao
description: >-
  Dona de toda revisão de código: passa no diff aplicando os critérios de
  codigo-limpo e seguranca-codigo, corrige achados críticos/importantes na mesma
  resposta e só então conclui. Use sempre ao fechar uma mudança de código, após
  editar arquivos, e quando o usuário pedir "revise", "revisar", "revisão de
  qualidade", "revisar PR/diff", "tem bugs?", self-review — inclusive sem esse
  pedido. Não usar em pergunta só conceitual sem mudança de código.
---

# Revisão pós-implementação (automática)

Skill pessoal. O usuário **não** precisa mandar "revise": a revisão faz parte
do fecho de qualquer implementação.

**Antes de concluir** uma task que alterou código: ler a skill `codigo-limpo`
(`SKILL.md`; `reference.md` se for reportar achados).

## Quando aplicar

- Depois de editar/criar código nesta conversa
- Ao fechar bug, fix, feature ou refatoração
- Se o usuário disser só "revise" / "revisar" → tratar como pedido de revisão
  do diff atual (não reabrir escopo)

## Quando NÃO aplicar

- Resposta só conceitual / explicação, sem diff
- Commit, PR, deploy ou pergunta operacional sem mudança de código
- Loop: já rodou a revisão nesta resposta e não restou crítico/importante

## Workflow obrigatório (uma passagem)

```
- [ ] 1. Listar arquivos tocados nesta task (git diff / edits da conversa)
- [ ] 2. Revisar só o diff + vizinhança imediata (diff mínimo)
- [ ] 3. Classificar: crítico → importante → sugestão → opcional
- [ ] 4. Corrigir crítico e importante agora (mesma resposta)
- [ ] 5. Sugestão/opcional: só se for boy scout barato no trecho tocado
- [ ] 6. Revalidar checklist do codigo-limpo nos arquivos alterados
- [ ] 7. Rodar `gates-verificacao` e anexar a evidência ao veredito
- [ ] 8. Concluir com veredito curto em português
```

## Evidência obrigatória

O veredito cita o que **foi executado** (typecheck, testes, lint) e o que não
existia no projeto. Sem gate disponível, dizer que a verificação foi só por
leitura — nunca afirmar "funciona" sem execução.

## Regras anti-loop

1. **No máximo uma** passagem revisão → correção → rechecagem por resposta.
2. Se após a correção ainda houver crítico: corrigir de novo **só** o crítico;
   não reescrever o que já está ok.
3. Não pedir ao usuário “revise de novo”. Se aprovado, diga que está pronto.
4. Não expandir escopo (“já que estamos aqui…”) fora do trecho da task.

## Formato do fecho

Curto. Exemplos:

- `Pronto. Revisado: sem críticos; X corrigido (borda null). Typecheck e 3 testes ok.`
- `Pronto. Revisado: aprovado no diff tocado. Testes 12/12; lint não configurado.`

Se a task for só revisão pedida pelo usuário, usar o formato de
`codigo-limpo` / `reference.md` (crítico → importante → sugestão → opcional).

## Critérios (resumo)

Delegar detalhe ao `codigo-limpo`. Focar em:

- Comportamento correto no caso pedido + bordas null/vazio/inválido
- Sentinel ruim (`"0"`, `""` mágico) vs `null`/label explícito
- Duplicação introduzida agora; nomes; SRP no trecho novo
- Comentário novo no diff → remover (nome/estrutura no lugar)
- Diff mínimo; sem debug; testes de regressão se o caminho já tiver suíte
- Tocou permissão, dado pessoal ou segredo? → `seguranca-codigo`
  (achado crítico de segurança **bloqueia** o fecho)
- Diff de UI (Figma, layout, tabela, espaçamento, empty state)? →
  `fidelidade-ui`. Asset inventado, componente irmão ignorado ou controle
  do design ausente = **importante** (corrigir na mesma resposta)
- Mudou payload que outro serviço/front consome? → `contrato-api`
- Achado igual ao de uma revisão anterior? → `memoria-decisoes` (virar regra)

## Relação com outras skills

- `orquestracao-agentes` — mapa núcleo + domínios
- `codigo-limpo` — critérios e checklist (ler ao aplicar esta skill)
- `gates-verificacao` — evidência executável exigida no fecho
- `fidelidade-ui` — no fecho de tela, exige comparação com o design
- `testes-e-bordas` — regressão quando o achado é bug
- Pack de domínio do time — processo do produto; esta skill fecha a
  qualidade do diff em qualquer projeto
