#!/usr/bin/env python3
"""Add and validate Bipolaris PWA metadata in Flutter's build output."""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


def normalized_base_path(value: str) -> str:
    path = "/" + value.strip("/") + "/"
    return path if path != "//" else "/"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--build-dir", type=Path, default=Path("build/web"))
    parser.add_argument("--base-path", default="/bipolaris/")
    args = parser.parse_args()

    build_dir = args.build_dir.resolve()
    source_root = Path(__file__).resolve().parents[1]
    base_path = normalized_base_path(args.base_path)
    index_path = build_dir / "index.html"
    manifest_path = build_dir / "manifest.json"
    if not index_path.is_file() or not manifest_path.is_file():
        raise SystemExit("Flutter output must include index.html and manifest.json")

    index = index_path.read_text(encoding="utf-8")
    if f'<base href="{base_path}">' not in index:
        raise SystemExit(f"index.html base href must be {base_path!r}")

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    icons = manifest.get("icons", [])
    required_icons = {"icons/Icon-192.png", "icons/Icon-512.png"}
    manifest_icons = {icon.get("src") for icon in icons}
    missing_manifest_icons = required_icons - manifest_icons
    missing_icon_files = [name for name in required_icons if not (build_dir / name).is_file()]
    if missing_manifest_icons or missing_icon_files:
        raise SystemExit(
            f"Flutter PWA icons missing: manifest={sorted(missing_manifest_icons)}, files={missing_icon_files}"
        )

    manifest.update({
        "id": base_path,
        "name": "Bipolaris",
        "short_name": "Bipolaris",
        "description": "Protótipo acadêmico demonstrativo com conteúdo fictício.",
        "start_url": base_path,
        "scope": base_path,
        "display": "standalone",
        "background_color": "#f4f6fb",
        "theme_color": "#183153",
    })
    for icon in icons:
        if icon.get("src") in required_icons:
            icon["purpose"] = "any"
        elif "maskable" in str(icon.get("src", "")).lower():
            icon["purpose"] = "maskable"
    manifest_path.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    (build_dir / "sw.js").write_text(
        (source_root / "web-assets/sw.js").read_text(encoding="utf-8"),
        encoding="utf-8",
    )
    (build_dir / "pwa-register.js").write_text(
        (source_root / "web-assets/pwa-register.js").read_text(encoding="utf-8"),
        encoding="utf-8",
    )

    manifest_link = '<link rel="manifest" href="manifest.json">'
    pattern = r'<link[^>]+rel=["\']manifest["\'][^>]*>'
    if re.search(pattern, index, flags=re.IGNORECASE):
        index = re.sub(pattern, manifest_link, index, count=1, flags=re.IGNORECASE)
    else:
        index = re.sub(r"</head>", f"  {manifest_link}\n</head>", index, count=1, flags=re.IGNORECASE)
    if 'name="theme-color"' not in index:
        index = re.sub(
            r"</head>",
            '  <meta name="theme-color" content="#183153">\n</head>',
            index,
            count=1,
            flags=re.IGNORECASE,
        )
    if "pwa-register.js" not in index:
        index = re.sub(
            r"</body>",
            '  <script src="pwa-register.js" defer></script>\n</body>',
            index,
            count=1,
            flags=re.IGNORECASE,
        )
    index_path.write_text(index, encoding="utf-8")

    if manifest["start_url"] != base_path or manifest["scope"] != base_path:
        raise SystemExit("Manifest start_url/scope does not match deployment base path")
    if 'rel="manifest"' not in index or "pwa-register.js" not in index:
        raise SystemExit("index.html is missing PWA manifest/registration wiring")
    if not (build_dir / "sw.js").is_file():
        raise SystemExit("Service worker was not copied to build output")


if __name__ == "__main__":
    main()
