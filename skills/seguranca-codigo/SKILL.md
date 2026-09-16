---
name: seguranca-codigo
description: >-
  Escreve e audita código com foco em segurança de aplicação: autorização por
  recurso (IDOR), injeção, XSS, upload, segredos, multi-tenant e PII/LGPD em log,
  URL e export. Use ao mexer em login, permissão, token, endpoint, upload, dado
  pessoal/CPF, .env, ou quando o usuário mencionar segurança, LGPD, vazamento,
  repo público, acesso indevido. Não usar para segurança de infraestrutura de
  rede.
---

# Segurança de código (AppSec)

Skill do núcleo, **transversal**: ativa quando a mudança toca autenticação,
autorização, entrada externa ou dado sensível.

Contexto sensível: dado pessoal identificável é **PII** (LGPD). Dado de saúde
é categoria especial.

## Quando aplicar

- Endpoint, rota, handler, query que recebe id do cliente
- Login, sessão, token, permissão, perfil, multi-tenant (organização/unidade)
- Upload, download, export, relatório, integração externa
- Qualquer log/mensagem que possa carregar CPF, nome, documento pessoal
- Repo ou skill pack **público**: “tem vazamento?”, auditoria de diff/docs

## Workflow

```
- [ ] 1. Identificar o ator (quem chama) e o recurso (o que acessa)
- [ ] 2. Conferir autorização por recurso, não só "está logado"
- [ ] 3. Validar/normalizar toda entrada externa na borda
- [ ] 4. Conferir se PII não vaza em log, URL, mensagem de erro ou export
- [ ] 5. Conferir segredo fora do código e do diff
- [ ] 6. Reportar achado com severidade e correção curta
```

## Checklist por risco

| Risco | O que verificar |
|-------|-----------------|
| **IDOR / authz** | `GET /x/:id` checa se o recurso pertence ao usuário/tenant? |
| **Multi-tenant** | Filtro de organização/unidade aplicado **no servidor**, nunca só no front |
| **Injeção** | SQL/ORM com parâmetro (nunca concatenação); comando de shell |
| **XSS** | HTML dinâmico, `dangerouslySetInnerHTML`, markdown de usuário |
| **Mass assignment** | Body inteiro indo para `update()` (permite trocar `role`, `id`) |
| **Upload** | Tipo, tamanho, nome sanitizado, destino fora do webroot |
| **Segredos** | Chave/token no código, no `.env` commitado, em log de build |
| **PII** | CPF/nome/documento em log, query string, analytics, mensagem de erro |
| **Repo público** | Diff/docs/skills sem nome interno de produto, secret, PII, e-mail, path local |
| **Erro** | Stacktrace ou SQL cru devolvido ao cliente |
| **Rate limit** | Endpoint de login, busca e export protegidos |

## Regras duras

1. **Nunca confiar em id vindo do cliente** para decidir acesso — checar dono no
   servidor.
2. Autenticado ≠ autorizado. Perfil no token não substitui checagem do recurso.
3. Segredo nunca entra em commit; se entrou, avisar que precisa ser **rotacionado**
   (remover do diff não basta).
4. PII em log só como id/hash; export e relatório recebem minimização.
5. Não desligar validação/CSP/CORS para “funcionar”; ajustar corretamente.

## LGPD no código

- Minimização: buscar só as colunas necessárias, não `SELECT *` para a tela
- Base legal e finalidade: dado pessoal não trafega para serviço novo sem motivo
- Retenção e exclusão: caminho de anonimização previsto em export/backup de dev
- Ambiente de dev/homolog com dado real → anonimizar antes

## Formato do achado

```
[Crítico|Importante|Sugestão] <risco> — <arquivo:trecho>
Por quê: <impacto concreto>
Correção: <1–2 linhas>
```

## Relação com outras skills

- `arquitetura-solid` — validação na borda faz parte do contrato
- `contrato-api` — campo sensível novo entrando no payload
- `testes-e-bordas` — caso de "sem permissão" é borda obrigatória
- `revisao-pos-implementacao` — achado crítico de segurança bloqueia o fecho
- `senior-banco-dados` — LGPD e acesso no lado do banco
