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

source utils && clear

echo
echo "# INSTALLING DE or WM - https://wiki.archlinux.org/index.php/General_recommendations#Desktop_environments"
echo

PACKAGES=(

    xdg-user-dirs-gtk

    #
    gdm
    lightdm

    # QTile
    qtile
    picom         # Compositor (shadows and transparency)
    python-psutil
    rofi
    dunst         # Notification helper
    dmenu
    polkit-gnome

    # GNOME
    baobab # A graphical directory tree analyzer
    evince # Document viewer
    file-roller # Create and modify archives
    gnome-calculator # GNOME Scientific calculator
    gnome-shell # Next generation desktop shell
    gnome-tweaks # Graphical interface for advanced GNOME 3 settings
    mutter # A window manager for GNOME
    nautilus
    sushi

    gnome-usage
    dconf-editor
    gnome-todo
    gnome-nettool

    gnome-initial-setup
    deja-dup
    gedit-plugins
    gnome-power-manager
    nautilus-share
    gnome-defaults-list
    gnome-search-tool
    system-config-printer
    gtk3-print-backends
)

for PKG in "${PACKAGES[@]}"; do
  package_install "${PKG}"
done

system_ctl enable gdm
system_ctl enable lightdm

echo
echo "Done!"
echo

read -er -p "Press enter to continue..."
