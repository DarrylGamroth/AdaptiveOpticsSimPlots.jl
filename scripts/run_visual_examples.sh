#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export GKSwstype="${GKSwstype:-100}"

cd "${ROOT_DIR}"

while IFS= read -r example; do
    echo "==> ${example}"
    julia --project=. --startup-file=no "${example}"
done < <(find examples -maxdepth 1 -type f -name '*.jl' ! -name 'common.jl' | sort)

echo "==> Visual examples completed"
