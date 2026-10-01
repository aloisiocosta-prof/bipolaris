#!/usr/bin/env bash
set -euo pipefail

BASE_HREF="${BASE_HREF:-/bipolaris/}"
flutter build web --wasm --base-href "$BASE_HREF"
python3 tool/prepare_pwa.py --build-dir build/web --base-path "$BASE_HREF"
