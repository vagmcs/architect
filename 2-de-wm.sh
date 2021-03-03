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
    # General
    #
    xdg-user-dirs-gtk                 # Creates user dirs

    #
    # QTile
    #
    lightdm
    qtile
    picom         # Compositor (shadows and transparency)
    python-psutil
    rofi
    dunst         # Notification helper
    dmenu
    polkit-gnome

    #
    # GNOME
    #
    baobab                            # A graphical directory tree analyzer
    dconf-editor                      # Configuration editor
    eog 	                            # Eye of Gnome: An image viewer
    evince                            # Document viewer (PDF, PostScript, XPS, djvu, dvi, tiff, cbr, cbz, cb7, cbt)
    file-roller                       # Create and modify archives
    gdm                               # Display manager and login screen
    gedit                             # GNOME text editor
    gedit-plugins                     # GNOME text editor plugins
    deja-dup                          # Simple backup tool
    gnome-calculator                  # GNOME calculator
    gnome-characters                  # A character map application
    gnome-color-manager               # GNOME Color Profile Tools
    gnome-control-center              # GNOME main interface to configure various aspects of the desktop
    gnome-disk-utility 	              # Disk Management for GNOME
    gnome-screenshot                  # Take pictures of your screen
    gnome-session 	                  # The GNOME Session Handler
    gnome-settings-daemon 	          # GNOME Settings Daemon
    gnome-shell 	                    # Next generation desktop shell
    gnome-shell-extensions            # Extensions for GNOME shell, including classic mode
    gnome-software 	                  # GNOME Software Tools
 	  gnome-software-packagekit-plugin  # PackageKit support plugin for GNOME Software
 	  gnome-sound-recorder              # Simple audio recordings
 	  gnome-system-monitor 	            # View current processes and monitor system state
    gnome-terminal 	                  # GNOME terminal
    gnome-tweaks                      # Graphical interface for advanced GNOME 3 settings
    gnome-usage                       # Application to view information about use of system resources
 	  gnome-user-share 	                # Easy to use user-level file sharing for GNOME
    gvfs                              #	Virtual filesystem implementation for GIO
    gvfs-afc                          # Virtual filesystem implementation for GIO (AFC backend; Apple mobile devices)
    gvfs-goa                          # Virtual filesystem implementation for GIO (Gnome Online Accounts backend)
    gvfs-google                       # Virtual filesystem implementation for GIO (Google Drive backend)
    gvfs-gphoto2                      # Virtual filesystem implementation for GIO (PTP camera, MTP media player)
    gvfs-mtp 	                        # Virtual filesystem implementation for GIO (MTP backend; Android, media player)
    gvfs-nfs                          # Virtual filesystem implementation for GIO (NFS backend)
    gvfs-smb                          # Virtual filesystem implementation for GIO (SMB/CIFS backend)
    insync-nautilus                   # Nautilus extension and icons for integrating inSync
    mutter                            # GNOME window manager
    nautilus                          # GNOME file manager
    nautilus-sendto                   # Easily send files via mail
    nautilus-share                    # Nautilus extension to share folder using Samba
    nautilus-image-converter          # Nautilus extension to rotate/resize image files
    sushi                             # A quick previewer for Nautilus
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
