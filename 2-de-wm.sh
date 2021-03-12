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
    dunst                             # Notification helper
    dmenu                             # Generic menu for X
    lightdm                           # A lightweight display manager
    network-manager-applet            # Applet for managing network connections
    picom                             # Compositor (shadows and transparency)
    polkit-gnome                      # Legacy authentication agent for GNOME
    polybar                           # A fast and easy-to-use status bar
    rofi                              # A window switcher and application launcher
    xautolock                         # An automatic X screen-locker/screen-saver
    xdg-user-dirs-gtk                 # Creates user dirs
    i3lock-fancy

    #
    # BSP WM
    #
    bwpwm
    sxhkd

    #
    # i3-gaps
    #
    i3-gaps
    i3status

    #
    # QTile
    #
    python-psutil                     # A cross-platform process and system utilities module for Python
    qtile                             # A full-featured, pure-Python tiling window manager

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
    gnome-screenshot                  # Take pictures of your screen
    gnome-session 	                  # The GNOME Session Handler
    gnome-settings-daemon 	          # GNOME Settings Daemon
    gnome-shell 	                    # Next generation desktop shell
    gnome-shell-extensions            # Extensions for GNOME shell, including classic mode
 	  gnome-sound-recorder              # Simple audio recordings
 	  gnome-system-monitor 	            # View current processes and monitor system state
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
    sushi                             # A quick previewer for Nautilus
    tracker3                          # Desktop-neutral user information store, search tool and indexer
    tracker3-miners 	                # Collection of data extractors for Tracker/Nepomuk

    #
    # KDE (MINIMAL)
    #
    ark                                # Archiving Tool
    bluedevil 	                       # Integrate the Bluetooth technology within KDE workspace and applications
    breeze 	                           # Artwork, styles and assets for the Breeze visual style for the Plasma Desktop
    breeze-gtk 	                       # Breeze widget theme for GTK 2 and 3
    dolphin                            # KDE File Manager
    dolphin-plugins                    # Extra Dolphin plugins
    drkonqi 	                         # KDE crash handler
    ffmpegthumbs                       # FFmpeg-based thumbnail creator for video files
    kactivitymanagerd 	               # System service to manage user's activities and track the usage patterns
    kde-cli-tools 	                   # Tools based on KDE Frameworks 5 to better interact with the system
    kdegraphics-thumbnailers           # Thumbnails for various graphics file formats
    kde-gtk-config 	                   # GTK2 and GTK3 Configurator for KDE
    kdecoration 	                     # Plugin based library to create window decorations
    kdeplasma-addons                   # All kind of addons to improve your Plasma experience
    kgamma5 	                         # Adjust your monitor's gamma settings
    khotkeys 	                         # KHotKeys
    kinfocenter 	                     # A utility that provides information about a computer system
    kmenuedit 	                       # KDE menu editor
    kscreen 	                         # KDE screen management software
    kscreenlocker 	                   # Library and components for secure lock screen architecture
    ksshaskpass 	                     # ssh-add helper that uses kwallet and kpassworddialog
    ksysguard 	                       # Track and control the processes running in your system
    kwallet-pam 	                     # KWallet PAM integration
    kwayland-integration               # Provides integration plugins for various KDE frameworks for the wayland windowing system
    kwayland-server 	                 # Wayland server components built on KDE Frameworks
    kwin 	                             # An easy to use, but flexible, composited Window Manager
    kwrited 	                         # KDE daemon listening for wall and write messages
    libkscreen 	                       # KDE screen management software
    libksysguard 	                     # Library to retrieve information on the current status of computer hardware
    milou 	                           # A dedicated search application built on top of baloo
    okular                             # Document Viewer
    plasma-browser-integration 	       # Components necessary to integrate browsers into the Plasma Desktop
    plasma-desktop 	                   # KDE Plasma Desktop
    plasma-disks 	                     # Monitors S.M.A.R.T. capable devices for imminent failure
    plasma-integration 	               # Qt Platform Theme integration plugins for the Plasma workspaces
    plasma-nm 	                       # Plasma applet written in QML for managing network connections
    plasma-pa                       	 # Plasma applet for audio volume management using PulseAudio
    plasma-systemmonitor 	             # An interface for monitoring system sensors, process information and other system resources
    plasma-thunderbolt 	               # Plasma integration for controlling Thunderbolt devices
    plasma-vault 	                     # Plasma applet and services for creating encrypted vaults
    plasma-workspace 	                 # KDE Plasma Workspace
    plasma-workspace-wallpapers 	     # Additional wallpapers for the Plasma Workspace
    polkit-kde-agent 	                 # Daemon providing a polkit authentication UI for KDE
    powerdevil 	                       # Manages the power consumption settings of a Plasma Shell
    print-manager                      # A tool for managing print jobs and printers
    sddm-kcm 	                         # KDE Config Module for SDDM
    systemsettings 	                   # KDE system manager for hardware, software, and workspaces
    xdg-desktop-portal-kde 	           # A backend implementation for xdg-desktop-portal using Qt/KF5
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
