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
    nm-connection-editor              # NetworkManager GUI connection editor
    network-manager-applet            # Applet for managing network connections
    picom                             # Compositor (shadows and transparency)
    polkit-gnome                      # Legacy authentication agent for GNOME
    polybar                           # A fast and easy-to-use status bar
    rofi                              # A window switcher and application launcher
    sxhkd                             # Simple X hotkey daemon
    system-config-printer             # A CUPS printer configuration tool and status applet
    xautolock                         # An automatic X screen-locker/screen-saver
    xdg-user-dirs-gtk                 # Creates user dirs

    #
    # GNOME (MINIMAL)
    #
    baobab                            # A graphical directory tree analyzer
    dconf-editor                      # Configuration editor
    eog 	                            # Eye of Gnome: An image viewer
    evince                            # Document viewer (PDF, PostScript, XPS, djvu, dvi, tiff, cbr, cbz, cb7, cbt)
    file-roller                       # Create and modify archives
    gdm                               # Display manager and login screen
    gnome-calculator                  # GNOME calculator
    gnome-characters                  # A character map application
    gnome-color-manager               # GNOME Color Profile Tools
    gnome-control-center              # GNOME main interface to configure various aspects of the desktop
    gnome-disk-utility 	              # Disk Management for GNOME
    gnome-keyring                     # Stores passwords and encryption keys
    gnome-screenshot                  # Take pictures of your screen
    gnome-session 	                  # The GNOME Session Handler
    gnome-settings-daemon 	          # GNOME Settings Daemon
    gnome-shell 	                    # Next generation desktop shell
    gnome-shell-extensions            # Extensions for GNOME shell, including classic mode
    gnome-terminal 	                  # GNOME terminal
    gnome-tweaks                      # Graphical interface for advanced GNOME 3 settings
 	  gnome-user-share 	                # Easy to use user-level file sharing for GNOME
    gvfs                              #	Virtual filesystem implementation for GIO
    gvfs-afc                          # Virtual filesystem implementation for GIO (AFC backend; Apple mobile devices)
    gvfs-goa                          # Virtual filesystem implementation for GIO (Gnome Online Accounts backend)
    gvfs-google                       # Virtual filesystem implementation for GIO (Google Drive backend)
    gvfs-gphoto2                      # Virtual filesystem implementation for GIO (PTP camera, MTP media player)
    gvfs-mtp 	                        # Virtual filesystem implementation for GIO (MTP backend; Android media player)
    gvfs-nfs                          # Virtual filesystem implementation for GIO (NFS backend)
    gvfs-smb                          # Virtual filesystem implementation for GIO (SMB/CIFS backend)
    insync-nautilus                   # Nautilus extension and icons for integrating inSync
    mutter                            # GNOME window manager
    nautilus                          # GNOME file manager
    nautilus-sendto                   # Easily send files via mail
    nautilus-share                    # Nautilus extension to share folder using Samba
    nautilus-image-converter          # Nautilus extension to rotate/resize image files
    okular                            # KDE document viewer
    sushi                             # A quick previewer for Nautilus
    tracker3                          # Desktop-neutral user information store, search tool and indexer
    tracker3-miners 	                # Collection of data extractors for Tracker/Nepomuk
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
