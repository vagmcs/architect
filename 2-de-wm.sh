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

    #
    # BSP WM
    #
    bspwm                             # Tiling window manager based on binary space partitioning
    dmenu                             # Generic menu for X
    dunst                             # Notification helper
    i3lock-fancy                      # i3lock-color script
    lxappearance-gtk3                 # GTK+ theme changer
    lxrandr-gtk3                      # Monitor configuration tool
    mictray                           # System tray to control the microphone state and volume
    nm-connection-editor              # NetworkManager GUI connection editor
    network-manager-applet            # Applet for managing network connections
    pavucontrol                       # PulseAudio Volume Control
    picom                             # Compositor (shadows and transparency)
    polkit-gnome                      # Legacy authentication agent for GNOME
    polybar                           # A fast and easy-to-use status bar
    rofi                              # A window switcher and application launcher
    sxhkd                             # Simple X hotkey daemon
    system-config-printer             # A CUPS printer configuration tool and status applet
    volctl                            # Volume control and OSD
    xautolock                         # An automatic X screen-locker/screen-saver
    xdg-user-dirs-gtk                 # Creates user dirs

    #
    # GNOME (MINIMAL)
    #
    dconf-editor                      # Configuration editor
    gdm                               # Display manager and login screen
    gnome-color-manager               # GNOME Color Profile Tools
    gnome-control-center              # GNOME main interface to configure various aspects of the desktop
    gnome-disk-utility 	              # Disk Management for GNOME
    gnome-keyring                     # Stores passwords and encryption keys
    gnome-session 	                  # The GNOME Session Handler
    gnome-settings-daemon 	          # GNOME Settings Daemon
    gnome-shell 	                    # Next generation desktop shell
    gnome-shell-extensions            # Extensions for GNOME shell, including classic mode
    gnome-tweaks                      # Graphical interface for advanced GNOME 3 settings
 	  gnome-user-share 	                # Easy to use user-level file sharing for GNOME
 	  gvfs-goa                          # Virtual filesystem implementation for GIO (Gnome Online Accounts backend)
    gvfs-google                       # Virtual filesystem implementation for GIO (Google Drive backend)
    mutter                            # GNOME window manager
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
