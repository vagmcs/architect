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
echo "# INSTALLING BLUETOOTH COMPONENTS - https://wiki.archlinux.org/index.php/Bluetooth"
echo

PACKAGES=(
    bluez                 # Daemons for the bluetooth protocol stack
    bluez-utils           # Bluetooth development and debugging utilities
    bluez-firmware        # Firmwares for Broadcom BCM203x and STLC2300 Bluetooth chips
    pulseaudio-bluetooth  # Bluetooth support for PulseAudio
)

for PKG in "${PACKAGES[@]}"; do
    package_install "${PKG}"
done

system_ctl enable bluetooth.service

echo
echo "Done!"
echo

read -er -p "Press enter to continue..."