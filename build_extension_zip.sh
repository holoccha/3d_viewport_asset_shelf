#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$ROOT_DIR/dist"
EXT_ID="$(awk -F '"' '/^id = /{print $2}' "$ROOT_DIR/blender_manifest.toml")"
EXT_VERSION="$(awk -F '"' '/^version = /{print $2}' "$ROOT_DIR/blender_manifest.toml")"
DIST_ZIP="$DIST_DIR/${EXT_ID}-${EXT_VERSION}.zip"
TMP_DIR="$(mktemp -d)"
PACKAGE_DIR="View3D_AssetShelf_Enabler"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

mkdir -p "$DIST_DIR"
rm -f "$DIST_ZIP"

cp "$ROOT_DIR/$PACKAGE_DIR/__init__.py" "$TMP_DIR/__init__.py"
cp "$ROOT_DIR/blender_manifest.toml" "$ROOT_DIR/README.md" "$ROOT_DIR/README.ja.md" "$ROOT_DIR/LICENSE" "$TMP_DIR/"
ZIP_ITEMS=(__init__.py blender_manifest.toml README.md README.ja.md LICENSE)
if [[ -d "$ROOT_DIR/images" ]]; then
  cp -R "$ROOT_DIR/images" "$TMP_DIR/"
  ZIP_ITEMS+=(images)
fi

(
  cd "$TMP_DIR"
  zip -r "$DIST_ZIP" "${ZIP_ITEMS[@]}" > /dev/null
)

echo "Built: $DIST_ZIP"
