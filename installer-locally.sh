#!/bin/bash

set -e

ASCII="
▀▀█▀▀ █▀▀ █▀▀█ █▀▄▀█ ▒█▀▀█ ▒█▀▀▄ ▒█▀▀▀
░▒█░░ █▀▀ █▄▄▀ █░▀░█ ▒█▄▄█ ▒█░▒█ ▒█▀▀▀
░▒█░░ ▀▀▀ ▀░▀▀ ▀░░░▀ ▒█░░░ ▒█▄▄▀ ▒█░░░

TermPDF Viewer - Install Script (pipx edition)
Developed by: Felipe Alfonso González 
--------------------------------------------------
"

echo "$ASCII"
echo "→ Installing TermPDF Viewer using pipx…"
echo

#----------------------------------------------------------
# 1. Ensure pipx is available
#----------------------------------------------------------

if ! command -v pipx &>/dev/null; then
    echo "→ pipx not found — installing pipx locally..."
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "→ pipx already installed."
fi

#----------------------------------------------------------
# 2. Create temporary build directory
#----------------------------------------------------------

BUILD_DIR="$(mktemp -d)"
echo "→ Using temporary directory: $BUILD_DIR"
cd "$BUILD_DIR"

#----------------------------------------------------------
# 3. Download TermPDF Viewer sources
#   (Modify these URLs if your repo changes)
#----------------------------------------------------------

echo "→ Downloading TermPDF sources..."

curl -L \
  -o termpdf.py \
  "https://raw.githubusercontent.com/felipealfonsog/TermPDFViewer/main/src/termpdf.py"

curl -L \
  -o wrapper.c \
  "https://raw.githubusercontent.com/felipealfonsog/TermPDFViewer/main/src/term-pdf-wrp.c"

curl -L \
  -o README.md \
  "https://raw.githubusercontent.com/felipealfonsog/TermPDFViewer/main/README.md"

#----------------------------------------------------------
# 4. Create package structure
#----------------------------------------------------------

echo "→ Creating Python package structure..."

mkdir -p termpdf
mv termpdf.py termpdf/
mv wrapper.c termpdf/
echo "" > termpdf/__init__.py

#----------------------------------------------------------
# 5. Create pyproject.toml (pipx needs this)
#----------------------------------------------------------

cat << 'EOF' > pyproject.toml
[project]
name = "termpdfviewer"
version = "1.0.0"
description = "Terminal PDF viewer using PyMuPDF, built by Felipe Alfonso González."
readme = "README.md"
requires-python = ">=3.8"
dependencies = ["PyMuPDF", "termcolor"]

[build-system]
requires = ["setuptools"]
build-backend = "setuptools.build_meta"

[project.scripts]
term-pdf = "termpdf.termpdf:main"
EOF

#----------------------------------------------------------
# 6. Install using pipx
#----------------------------------------------------------

echo "→ Installing TermPDF Viewer with pipx..."

pipx install .

echo
echo "--------------------------------------------------"
echo "✔ INSTALLATION COMPLETE"
echo "You can now run TermPDF Viewer with:"
echo
echo "    term-pdf archivo.pdf"
echo
echo "Executables installed in: $HOME/.local/bin/"
echo "Make sure this directory is in your PATH."
echo "--------------------------------------------------"
