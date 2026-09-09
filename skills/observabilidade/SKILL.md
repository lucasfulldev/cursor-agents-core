---
name: observabilidade
description: >-
  Define o que registrar para diagnosticar incidente sem adivinhação: log
  estruturado, id de correlação, nível adequado, erro com contexto e sem PII. Use
  ao tratar erro, adicionar log, ou quando o usuário mencionar log, monitoramento,
  alerta, rastrear requisição, "não sei o que aconteceu", "faltou informação para
  investigar". Decide o que registrar daqui pra frente; achar a causa de um bug
  atual é depuracao-evidencia. Não usar para log temporário de debug local.
---

# Observabilidade

Skill sob demanda. Objetivo: quando o problema acontecer em produção, o log
responder **o que**, **para quem** e **por quê** — sem precisar reproduzir.

## Quando aplicar

- Tratamento de erro em borda (API, job, integração, webhook)
- Fluxo crítico de negócio (pagamento, pedido, envio)
- Depois de um incidente em que faltou informação
- Integração externa (timeout, 4xx/5xx, retry)

## Quando NÃO aplicar

- `console.log` temporário de investigação local → `depuracao-evidencia`
  (e remover no fecho)

## Workflow

```
- [ ] 1. Perguntar: em um incidente, qual pergunta preciso responder?
- [ ] 2. Escolher os pontos mínimos que respondem isso
- [ ] 3. Log estruturado (campos, não frase interpolada)
- [ ] 4. Propagar id de correlação entre serviços
- [ ] 5. Conferir que não há PII nem segredo no que é registrado
- [ ] 6. Erro: registrar contexto + causa, e não engolir
```

## O que registrar

| Sempre | Nunca |
|--------|-------|
| Entrada de use-case crítico (ação, ator, recurso) | CPF, nome, e-mail, documento pessoal |
| Falha de integração externa (serviço, status, tentativa) | Token, senha, chave |
| Decisão de negócio relevante (por que negou/aprovou) | Payload inteiro sem filtro |
| Erro com stack + id de correlação | Log em loop quente (ruído/custo) |

Identificar por **id**, não por dado pessoal (`clientId`, não `cpf`).

## Níveis

| Nível | Uso |
|-------|-----|
| `error` | Falhou e alguém precisa agir |
| `warn` | Degradou, seguiu com fallback |
| `info` | Evento de negócio relevante |
| `debug` | Detalhe de investigação, desligado por padrão |

## Erro bem tratado

```
- [ ] Contexto: o que se tentava fazer, com qual recurso
- [ ] Causa: preservar erro original (não perder o `cause`)
- [ ] Correlação: id que liga front → API → serviço
- [ ] Mensagem ao usuário: útil e sem detalhe interno
```

Anti-padrão: `catch {}`, `catch { return null }` e mensagem genérica
(“Erro ao processar”) sem registrar nada — o incidente nasce cego.

## Regras

1. `catch` sem log nem repasse = erro perdido; sempre um dos dois.
2. Log não substitui teste: serve para o que não se consegue prever.
3. Seguir o logger já usado no projeto; não introduzir stack novo sem pedido.
4. Alerta só para o que exige ação humana — o resto é métrica.

## Relação com outras skills

- `depuracao-evidencia` — usa o log para confirmar hipótese
- `seguranca-codigo` — PII e segredo fora do log
- `performance-app` — instrumentação para medir
- `codigo-limpo` — erro explícito, mensagem útil
