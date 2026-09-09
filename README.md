# Cursor Agents (núcleo)

Estrutura de agentes Cursor em **três camadas**:

1. **Núcleo** — pipeline que serve qualquer projeto
2. **Transversais** — entram pelo tipo de risco da mudança
3. **Domínios (plugins)** — só quando o time instalar um pack de produto

Este repositório publica **só o núcleo genérico**. Packs de produto, runbooks
de infra e mapa de serviços internos ficam fora de propósito — cada time
mantém isso em repositório privado.

```
skills/     → ~/.cursor/skills/
rules/      → ~/.cursor/rules/
```

## Núcleo — pipeline

| Estágio | Skill | Entrega |
|---------|-------|---------|
| Orquestração | `orquestracao-agentes` | Escolhe time e pipeline |
| Requisitos | seção em `orquestracao-agentes` | Escopo, regras, critérios de aceite |
| Plano | estágio 0.6 em `orquestracao-agentes` | Ordem dos passos, checkpoint, reversão |
| Design | `arquitetura-solid` | Contrato, fronteira, SOLID, tipos |
| Bordas e testes | `testes-e-bordas` | Matriz de casos + regressão |
| Implementação | `codigo-limpo` | Clean Code, diff mínimo |
| Verificação | `gates-verificacao` | Typecheck/lint/test com evidência |
| Fecho | `revisao-pos-implementacao` | Revisão automática do diff |

## Transversais (por gatilho)

| Agente | Skill | Gatilho |
|--------|-------|---------|
| Segurança | `seguranca-codigo` | Authz, PII/LGPD, segredo, upload |
| Contrato de API | `contrato-api` | Payload/DTO cruzando serviço ou front↔API |
| Memória | `memoria-decisoes` | Decisão com trade-off; achado recorrente |
| Git/PR | `git-pr` | Commit, PR, split |

## Sob demanda

`depuracao-evidencia` (bug) · `performance-app` (lentidão) · `observabilidade` (log/incidente) · `estimativa-task` (horas)

## Domínios instalados neste repo

| Domínio | Skills |
|---------|--------|
| Dados | `senior-banco-dados` |

Produto do time: crie a skill do domínio e registre em `orquestracao-agentes` —
**não** altere o núcleo.

## Pipelines

Feature nova:

```
Estimador? → Domínio? → Requisitos → Plano → Design → Bordas/Testes
           → Código limpo → Gates → Fecho
+ transversais (segurança / contrato) conforme o risco
```

Bug:

```
Depuração (causa confirmada) → Teste vermelho → Correção → Gates → Fecho
```

Fix trivial:

```
Código limpo → Gates → Fecho
```

Desacoplamento / refactor estrutural:

```
Plano → Costura + teste de caracterização → Extrair interface
      → Trocar miolo (gates a cada passo) → Remover órfão
```

Sem mudança de código → sem gates e sem fecho.

## Princípios que sustentam a estrutura

- Critério de aceite verificável antes do desenho; pedido com duas entregas é fatiado
- Ordem decidida antes de codar: preparação → comportamento → limpeza
- Desenho antes do código (SOLID, DIP, tipos que impedem estado inválido)
- Legado se desacopla por costura + teste de caracterização, nunca por reescrita
- Borda enumerada antes de implementar; bug nasce com teste vermelho
- “Funciona” só com saída de comando — nunca por leitura de diff
- Segurança crítica bloqueia a entrega
- Achado recorrente vira regra, não correção repetida
- Diff mínimo em legado; revisão de fecho automática
- Um gatilho, um dono: description que disputa palavra com outra skill vira sorteio

## Validar

Cada skill tem **um** dono por gatilho (tabela em `orquestracao-agentes`). Depois
de sincronizar ou criar skill nova, rode [`TESTE-FUMACA.md`](./TESTE-FUMACA.md):
cenários em chat novo que checam se o agente certo dispara, se os gates
rodam e se o fecho traz evidência.

## Instalar / sincronizar

```bash
rsync -a ./skills/ ~/.cursor/skills/
mkdir -p ~/.cursor/rules
cp ./rules/*.mdc ~/.cursor/rules/
```

Source of truth com symlink (opcional):

```bash
mv ~/.cursor/skills ~/.cursor/skills.bak 2>/dev/null || true
ln -s "$(pwd)/skills" ~/.cursor/skills
mkdir -p ~/.cursor/rules
ln -sf "$(pwd)/rules/roteamento-agentes.mdc" ~/.cursor/rules/roteamento-agentes.mdc
```

Abra um **chat novo** no Cursor após sincronizar.

## Licença

MIT. Veja [LICENSE](./LICENSE).
