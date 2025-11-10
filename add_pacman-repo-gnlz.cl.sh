#!/bin/bash
set -e

PACMAN_CONF="/etc/pacman.conf"
REPO_NAME="gnlz"
REPO_URL="https://gnlz.cl/repo/\$arch"

if grep -q "^\[$REPO_NAME\]" "$PACMAN_CONF"; then
    echo ">> Repository [$REPO_NAME] already exists in $PACMAN_CONF"
else
    echo ">> Adding repository [$REPO_NAME] to $PACMAN_CONF"
    sudo bash -c "cat >> $PACMAN_CONF" <<EOF
[$REPO_NAME]
SigLevel = Optional TrustAll
Server = $REPO_URL
EOF
fi

echo ">> Synchronizing pacman..."
sudo pacman -Sy

echo "✅ Repository [$REPO_NAME] added and pacman synchronized."

echo ">> You can now install packages from the [$REPO_NAME] repository."
echo ">> Example: sudo pacman -S package_name"
echo ">> For more information, visit: https://gnlz.cl/repo/"
echo ">> To remove the repository, edit $PACMAN_CONF and delete the [$REPO_NAME] section."
echo ">> To refresh the package list, run: sudo pacman -Sy"
echo ">> To uninstall packages from this repository, use: sudo pacman -R package_name"

