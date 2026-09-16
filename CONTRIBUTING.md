# Como contribuir

O `main` só recebe mudança por **pull request**. Não há push direto para
quem não é admin.

## Fluxo

1. Faça um **fork** deste repositório
2. Crie uma branch a partir do `main`
3. Abra um Pull Request para `lucasfulldev/cursor-agents-core`

Não peça acesso Write. Triagem usa o PR.

## Escopo

Este repo é o **núcleo genérico**. Cabe: skill/rule do pipeline, transversal
(segurança, contrato, git) e o plugin de dados (`senior-banco-dados`).

Não cabe: pack de produto, nome interno de sistema, runbook de infra, mapa
de serviços, secret, e-mail, path de máquina.

Achado que só existe num produto → skill de domínio **no repo privado do
time**, não aqui.

## Skill nova ou gatilho novo

- `description` com frases que disparam (e o que **não** é desta skill)
- Um gatilho, um dono: tabela em `skills/orquestracao-agentes/SKILL.md`
- Se o gatilho já tem dono, qualificar ou delegar — não disputar a palavra
- Cenário novo em `TESTE-FUMACA.md` quando o comportamento for observável

Depois de sincronizar: chat **novo** no Cursor. Contexto velho não carrega
description nova.

## Antes do PR

```bash
bash scripts/check-core.sh
```
