#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

fail=0

if grep -RInE 'SaudeHD|saudehd|pep_v2|4Filas|4senhas|healthdevio' \
  --include='*.md' --include='*.mdc' \
  skills rules README.md TESTE-FUMACA.md CONTRIBUTING.md; then
  echo "check-core: nome de produto no núcleo genérico" >&2
  fail=1
fi

while IFS= read -r -d '' skill; do
  head="$(head -n 40 "$skill")"
  if ! grep -q '^name:' <<<"$head" || ! grep -q '^description:' <<<"$head"; then
    echo "check-core: $skill sem name/description no frontmatter" >&2
    fail=1
  fi
done < <(find skills -name SKILL.md -print0)

if [[ ! -f rules/roteamento-agentes.mdc ]]; then
  echo "check-core: falta rules/roteamento-agentes.mdc" >&2
  fail=1
fi

if [[ "$fail" -ne 0 ]]; then
  exit 1
fi

echo "check-core: ok"
