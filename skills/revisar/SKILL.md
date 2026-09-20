---
name: revisar
description: >-
  Atalho de revisão avulsa do diff atual. Use só quando o usuário invocar
  /revisar. O fecho automático de implementação é revisao-pos-implementacao —
  não esperar este comando para revisar depois de editar código.
disable-model-invocation: true
---

# /revisar

Atalho explícito. Lê e executa `revisao-pos-implementacao` no **diff atual**
(git diff / arquivos tocados nesta conversa). Não reabrir escopo. Não
implementar feature nova.

Se a revisão já rodou nesta resposta e não restou crítico/importante: parar.

O usuário **não** precisa disto depois de uma implementação: o fecho do
pipeline já é essa passagem. Este comando existe para revisão avulsa
(diff/PR já existente, “tem bugs?”, chat que só pede review).
