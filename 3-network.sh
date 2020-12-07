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
echo "INSTALLING NETWORK COMPONENTS - https://wiki.archlinux.org/index.php/Network_configuration"
echo

echo " 1) NetworkManager"
echo " 2) Systemd"
read -p "${PROMPT_1}" -r OPTION
case "${OPTION}" in
1)
  package_install networkmanager
  system_ctl enable NetworkManager.service
  ;;
2)
  # Find ethernet and/or wireless devices
  WIRED_DEV=$(ip link | grep "ens\|eno\|enp" | awk '{print $2}' | sed 's/://' | sed '1!d')
  WIRELESS_DEV=$(ip link | grep wl | awk '{print $2}' | sed 's/://' | sed '1!d')

  # Create configuration files for both ethernet and wireless devices
  if [[ -n "${WIRED_DEV}" ]]; then
    {
      "[Match]"
      "Name=${WIRED_DEV}"
      "[Network]"
      "DHCP=yes"
    } >>/etc/systemd/network/20-wired.network
  fi
  if [[ -n "${WIRELESS_DEV}" ]]; then
    {
      "[Match]"
      "Name=${WIRELESS_DEV}"
      "[Network]"
      "DHCP=yes"
    } >>/etc/systemd/network/25-wireless.network
  fi

  package_install iwd
  systemctl enable iwd.service

  system_ctl enable systemd-resolved.service
  system_ctl enable systemd-networkd.service
  ;;
esac

timedatectl set-ntp true

echo
echo "Done!"
echo

read -er -p "Press enter to continue..."
