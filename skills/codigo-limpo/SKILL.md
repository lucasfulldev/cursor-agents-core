---
name: codigo-limpo
description: >-
  Catálogo de critérios de Código Limpo (Clean Code / Robert C. Martin) aplicado
  enquanto se escreve: nomes claros, funções pequenas (SRP), erros explícitos,
  camadas finas, DRY com critério e diff mínimo em legado. Use quando o usuário
  pedir código limpo, clean code, boy scout, cheiro de código, refatorar,
  "função grande demais", "nome ruim", ou ao implementar com foco em
  legibilidade. Quem faz a passagem de revisão do diff é
  revisao-pos-implementacao, usando estes critérios.
---

# Código Limpo

Skill pessoal. Guia operacional baseado em *Clean Code* (Robert C. Martin).

**Primeira ação:** ler este `SKILL.md` por completo. Para exemplos e tom de
revisão, ler [reference.md](reference.md). Opcional: consultar
um guia de Clean Code do time, se existir.

## Quando usar

- Escrever ou alterar código com qualidade
- Revisar PR, diff ou “verifique se tem bugs”
- Refatorar / “deixar limpo” / clean code / boy scout
- Antes de concluir implementação não trivial

## Quando NÃO usar

- Pergunta só conceitual, sem mudança de código
- Formatação cosmética sem ganho de clareza
- Reescrita ampla de módulo fora do escopo da task
- Domínio de outra skill no comando (ex.: só SQL → `senior-banco-dados`)

## Workflow obrigatório

```
- [ ] 1. Entender o objetivo da task (não “limpar o mundo”)
- [ ] 2. Ler o código tocado + padrões do arquivo/módulo vizinho. UI: buscar
        o componente irmão **antes** de criar outro (`fidelidade-ui`)
- [ ] 3. Aplicar princípios na área alterada (tabela abaixo)
- [ ] 4. Tratar bordas (null, validação, 404/409, FK, undefined ≠ false)
- [ ] 5. Rodar checklist antes de concluir
- [ ] 6. Typecheck/lint nos arquivos alterados quando o projeto tiver
- [ ] 7. Se for revisão: reportar no formato de reference.md
```

## Regras ao aplicar

1. **Diff mínimo** — só o necessário à task; sem refactor oportunista.
2. **Boy Scout** — deixar o trecho tocado mais limpo; não reescrever o sistema.
3. **Estilo do repo** — seguir naming, imports e padrões já usados no módulo.
4. **Confiar no servidor** — estado de persistência vem do banco/serviço, não de
   flags frágeis do client (`previousExists`, etc.).
5. Responder em **português**.

## Design (SOLID)

Desenho de módulo novo, contrato ou fronteira → aplicar `arquitetura-solid`
**antes** de codar. Aqui vale o mínimo: regra de negócio não importa framework,
dependência de I/O é injetada, sem `any` em código novo, sem sentinel mágico.

## Princípios (resumo)

| Princípio | Prática |
|-----------|---------|
| Nomes | Revelam intenção; `is`/`has`/`can`; verbo+objeto |
| Funções | Uma responsabilidade; curtas; poucos args (0–3); early return |
| Comentários | **Não adicionar.** Nome revela intenção; se precisa explicar, extrair/renomear |
| Erros | Explícitos na borda; não engolir; mensagem útil |
| Camadas | Controller fino → serviço/use-case → repo/DB |
| DRY | Extrair regra igual; não abstrair cedo demais |
| Testes | Preferir regressão mínima ao corrigir bug, se o projeto testar o caminho |
| Coesão | Módulo/classe com um motivo para mudar; evitar god-class |

## Checklist antes de concluir

- [ ] Nomes de funções/arquivos contam a história?
- [ ] Cada função faz uma coisa?
- [ ] Sem destructuring inseguro de `null`/`undefined`?
- [ ] Bordas (null, 404/409, FK, validação, `undefined` em updates) tratadas?
- [ ] Side effects óbvios (I/O, DB) não escondidos em getters “inocentes”?
- [ ] Diff mínimo para o objetivo?
- [ ] Sem comentário novo (`//`, `/* */`, JSDoc)? Nome/estrutura devem bastar
- [ ] Sem `console.log`/comentários de debug?
- [ ] Contrato API ↔ front ainda coerente?
- [ ] Gates executados (`gates-verificacao`) e evidência reportada?

## Anti-padrões

- Função “faz tudo” (validar + persistir + notificar + métrica)
- Flag do cliente decidindo persistência sem checar o banco
- Default implícito que desativa/apaga quando o campo vem `undefined`
- Comentário no lugar de nome claro ou de extrair função
- Renomear/mover/formatar em massa fora do escopo
- Catch vazio ou “sucesso” silencioso após falha parcial
- Magia numérica sem nome (`if (status === 3)` sem constante/enum do domínio)

## Relação com outras skills

- `orquestracao-agentes` — mapa núcleo + domínios
- `arquitetura-solid` — desenho e SOLID antes de codar
- `testes-e-bordas` — casos de borda e regressão
- `gates-verificacao` — typecheck/lint/test com evidência
- `depuracao-evidencia` — quando a task é um bug
- `revisao-pos-implementacao` — após implementar, revisar o diff sozinho (sem
  o usuário pedir "revise"); usa estes critérios
- `fidelidade-ui` — tela/Figma/espaçamento; daqui só a higiene do código
- Pack de domínio do time — processo do produto; esta skill = qualidade
  do código tocado em qualquer projeto
- `senior-banco-dados` — SQL/schema; aqui só higiene do código em volta

## Recursos

- [reference.md](reference.md) — exemplos, tom de revisão, bordas de API
- Guia de Clean Code do time, se houver
