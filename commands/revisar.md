---
description: Revisa o diff atual (código limpo, segurança, gates) e corrige crítico/importante na hora.
---

Ler e executar a skill `revisao-pos-implementacao` no diff atual.

- Só o git diff / arquivos tocados nesta conversa.
- Classificar: crítico → importante → sugestão → opcional.
- Corrigir crítico e importante nesta resposta.
- Rodar `gates-verificacao` e citar comando + resultado.
- Não reabrir escopo. Não pedir ao usuário para revisar de novo.

Se esta conversa acabou de implementar código, o fecho já deveria ter feito
essa passagem — não esperar `/revisar`.
