# Estimativa de task — referência

Complemento de `SKILL.md`. Ler sob demanda.

## Horas por natureza do pacote

Use a faixa **depois** de decompor o trabalho (não chute um número único):

| Natureza do pacote | Heurística de horas |
| :--- | :--- |
| Bug pontual / 1–2 arquivos / causa conhecida | 1–4 h (mais provável no meio) |
| Bug multi-camada (front + API) com regressão | 4–12 h |
| Feature pequena (1 aba/endpoint, catálogo pronto) | 8–20 h |
| Feature média (API + UI + status + histórico) | 20–40 h |
| Feature grande (schema + 2–3 repos + relatório + cruzamento) | 40–80 h |
| Só análise/specs (sem código) | 2–8 h |
| Deploy/CI pontual (stack já conhecida) | 1–4 h |

Se o time também fatura por repertório de contrato: reportar as unidades
comerciais **sem** “corrigir” o repertório. Para o sprint, usar a faixa de horas.

## Calibragem (analogia, não tabela de preço)

| Tipo | Exemplo genérico | Ordem de horas | Notas |
| :--- | :--- | :--- | :--- |
| Hotfix UI 1 repo | Ajuste visual de um select | 2–6 h | Pouca API; QA visual |
| Bug multi-repo | Dado some na listagem após inativar | 6–14 h | Causa sutil; listagem + update |
| Feature US média | Novo fluxo com API + tela + status | 40–60 h | Schema + aba nova + cruzamento |
| Feature com arquivo externo | Importar retorno de parceiro | 30–50 h+ | Parser + matching; formato é risco |
| Só planejamento/spec | Specs + ambiguidades, sem código | 4–10 h | Sem implementação |

**O que encarece com frequência:** multi-repo, branch/processo rígido, schema
compartilhado, UI nova **e** legado no mesmo pedido.

## Exemplo de saída (bug)

```markdown
## Estimativa — Item some ao inativar usuário
**Horas (time):** 6–12 h (mais provável: 8 h)
**Confiança:** média

### Breakdown
| Item | Horas (aprox.) |
| ---- | -------------- |
| Diagnóstico listagem | 1–2 |
| Ajuste front da seleção | 1–2 |
| Ajuste API inativar/reativar | 3–5 |
| Teste/regressão | 1–2 |

### Buffers aplicados
- Multi-repo front+API: +15%

### Premissas
- Dado no banco não “troca”; bug de exibição/seleção
- Sem mudança de modelo de dados ampla

### Fora de escopo
- Migração de dados legados
- Refactor geral de permissões

### Riscos / perguntas que mudam a conta
- Se criar vínculo ao trocar perfil entrar no escopo, +2–4 h
```

## Checklist rápido antes de publicar a estimativa

- [ ] Escopo e fora de escopo explícitos
- [ ] Faixa de horas + mais provável
- [ ] Buffer justificado (não lista infinita)
- [ ] Riscos que mudam a conta
- [ ] Pronto para colar no time
