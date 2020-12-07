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

#
#
#
config_x_init_rc() {
  cp -fv /etc/X11/xinit/xinitrc /home/vagmcs/.xinitrc
  echo -e "exec ${1}" >>/home/vagmcs/.xinitrc
  chown -R vagmcs:users /home/vagmcs/.xinitrc
}

echo
echo "INSTALLING DE or WM - https://wiki.archlinux.org/index.php/General_recommendations#Desktop_environments"
echo

PACKAGES=(

    picom   # Compositor (shadows and transparency)
    xdg-user-dirs-gtk

    #
    gdm
    lightdm

    # QTile
    qtile
    rofi

    # BSPWM
    bspwm

    # Xmonad
    xmonad
    xmonad-contrib
    xmobar
    xterm

    # i3
    i3-gaps
    i3status
    i3lock
    dmenu

    # DWM
    dwm

    # Awesome
    awesome
    polybar

    # GNOME
    gnome
    gnome-extra
    gnome-tweaks
    gnome-usage
    gnome-initial-setup
    deja-dup
    gedit-plugins
    gnome-power-manager
    nautilus-share
    gnome-defaults-list
)

for PKG in "${PACKAGES[@]}"; do
  package_install "${PKG}"
done

if [[ ! -d /home/${username}/.config/qtile/ ]]; then
  mkdir -p /home/"${username}"/.config/qtile/
  cp /usr/share/doc/qtile/default_config.py /home/"${username}"/.config/qtile/config.py
  chown -R "${username}":users /home/"${username}"/.config
fi
if [[ ! -d /home/${username}/.config/bspwm/ ]]; then
  mkdir -p /home/"${username}"/.config/bspwm/
  cp /usr/share/doc/bspwm/examples/{bspwmrc,sxhkdrc} /home/"${username}"/.config/bspwm/
  chown -R "${username}":users /home/"${username}"/.config
fi
if [[ ! -d /home/${username}/.config/awesome/ ]]; then
  mkdir -p /home/"${username}"/.config/awesome/
  cp /etc/xdg/awesome/rc.lua /home/"${username}"/.config/awesome/
  chown -R "${username}":users /home/"${username}"/.config
fi

system_ctl enable gdm
system_ctl enable lightdm

echo
echo "Done!"
echo

read -er -p "Press enter to continue..."
