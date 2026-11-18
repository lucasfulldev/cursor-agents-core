---
description: Revisa o diff da task (defeitos com caminho de execução, checklist fixo, gates) e corrige crítico/importante na hora.
---

Ler e executar a skill `revisao-pos-implementacao` no diff atual.

- Só o diff da task (arquivos alterados nesta conversa). Branch inteira só se o usuário pedir.
- Reportar só crítico e importante, cada um com caminho de execução. Sugestões só se o usuário pedir.
- Corrigir crítico e importante nesta resposta.
- Rodar `gates-verificacao` e citar comando + resultado.
- Zero achados é um veredito válido. Não completar cota.
- Não reabrir escopo. Não pedir ao usuário para revisar de novo.

Se esta conversa acabou de implementar código, o fecho já deveria ter feito
essa passagem; não esperar `/revisar`.
