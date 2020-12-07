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

source utils

echo
echo "# CREATE USER - https://wiki.archlinux.org/index.php/Users_and_Groups"
echo

read -p "Username: " -r USERNAME
USERNAME=$(echo "${USERNAME}" | tr '[:upper:]' '[:lower:]')
useradd -m -g users -G wheel -s /bin/bash "${USERNAME}"
passwd "${USERNAME}"
# shellcheck disable=SC2181
while [[ $? -ne 0 ]]; do
  passwd "${USERNAME}"
done
cp /etc/skel/.bashrc /home/"${USERNAME}"
chown -R "${USERNAME}":users /home/"${USERNAME}"

read -er -p "Press enter to continue..."
clear

echo
echo "# SYSTEM OPTIMIZATION"
echo

#
echo fs.inotify.max_user_watches=524288 | tee /etc/sysctl.d/40-max-user-watches.conf && sysctl --system >/dev/null

# Clean packages
pacman -Rsc --noconfirm "$(pacman -Qqdt)"

# Delete the builder user and restore the sudoers configuration
userdel builder && rm -r /home/builder
sed -i '$d' /etc/sudoers

read -er -p "Press enter to continue..."