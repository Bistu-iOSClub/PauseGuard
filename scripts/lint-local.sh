#!/usr/bin/env bash

set -euo pipefail

repository_root="$(git rev-parse --show-toplevel)"
cd "$repository_root"

if ! command -v swiftlint >/dev/null 2>&1; then
  echo "SwiftLint is not installed. Install it with: brew install swiftlint" >&2
  exit 1
fi

swiftlint lint --strict --config .swiftlint.yml
