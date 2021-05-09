#!/usr/bin/env bash
#     _             _     _ _            _
#    / \   _ __ ___| |__ (_) |_ ___  ___| |_
#   / _ \ | '__/ __| '_ \| | __/ _ \/ __| __|
#  / ___ \| | | (__| | | | | ||  __/ (__| |_
# /_/   \_\_|  \___|_| |_|_|\__\___|\___|\__|
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

source globals && clear

echo
echo "# INSTALLING FONTS - https://wiki.archlinux.org/index.php/Fonts"
echo

PACKAGES=(
    adobe-source-code-pro-fonts  # Monospaced font for user interface and coding environments
    nerd-fonts-fira-code         # Patched font FirA Code from the nerd-fonts library
    nerd-fonts-hack              # Patched font Hack from nerd-fonts library
    nerd-fonts-inconsolata       # Patched font In-consolata from the nerd-fonts library
    nerd-fonts-jetbrains-mono    # Patched font JetBrains Mono from nerd-fonts library
    nerd-fonts-source-code-pro   # Patched font SourceCodePro from nerd-fonts library
    nerd-fonts-ubuntu-mono       # Patched font UbuntuMono from the nerd-fonts library
    noto-fonts-emoji             # Google 'NO more TOfu' emoji fonts
    noto-color-emoji-fontconfig  # Fontconfig to enable 'NO more TOfu' Color Emoji fonts
    terminus-font                # Monospace bitmap font for the console
    ttf-fira-code                # Monospaced font that includes programming ligatures
    ttf-hack                     # A hand groomed and optically balanced typeface
    ttf-inconsolata              # Monospace font for pretty code listings
    ttf-jetbrains-mono           # Typeface for developers by JetBrains
    ttf-ubuntu-font-family       # Ubuntu font family
)

for PKG in "${PACKAGES[@]}"; do
    package_install "${PKG}"
done

echo
echo "Done!"
echo

read -er -p "Press enter to continue..."