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
echo "# SYSTEM CONFIGURATION"
echo

echo fs.inotify.max_user_watches=524288 | tee /etc/sysctl.d/40-max-user-watches.conf && sysctl --system >/dev/null

# Clean packages
pacman -Rsc --noconfirm "$(pacman -Qqdt)"

# Delete the builder user and restore the sudoers configuration
userdel builder && rm -r /home/builder
sed -i '$d' /etc/sudoers

# Use terminus font for console
echo "FONT=ter-v32b" > /etc/vconsole.conf

# Enable pacman colors and fancy progress bar
read_input_text "Do you need to enable edit pacman.conf (e.g. enable colors and ILoveCandy)"
if [[ "${OPTION}" == y ]]; then
  nvim /etc/pacman.conf
fi

read -er -p "Press enter to continue..."
clear


echo
echo "# USER ENVIRONMENT CONFIGURATION"
echo

# Make directories
su - "${USERNAME}" -c "
  mkdir -p .local/bin
  mkdir -p .local/opt
  mkdir -p .local/share
  mkdir -p Work/dev
"

# Download dotfiles and checkout
su - "${USERNAME}" -c "
  git clone --bare https://github.com/vagmcs/dotfiles /home/${USERNAME}/Work/dev/dotfiles
  git --git-dir=Work/dev/dotfiles --work-tree=. reset --hard HEAD
  git --git-dir=Work/dev/dotfiles --work-tree=. config --local status.showUntrackedFiles no
"

# Download Java, Scala and SBT
su - "${USERNAME}" -c "
wget https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u275-b01/OpenJDK8U-jdk_x64_linux_hotspot_8u275b01.tar.gz
tar -zxf OpenJDK8U-jdk_x64_linux_hotspot_8u275b01.tar.gz
mv jdk8u275-b01 /home/${USERNAME}/.local/opt
ln -sf /home/${USERNAME}/.local/opt/jdk8u275-b01 /home/${USERNAME}/.local/opt/java
rm -rf OpenJDK8U-jdk_x64_linux_hotspot_8u275b01.tar.gz
"

su - "${USERNAME}" -c "
wget https://downloads.lightbend.com/scala/2.13.4/scala-2.13.4.tgz
tar -zxf scala-2.13.4.tgz
mv scala-2.13.4 /home/${USERNAME}/.local/opt
ln -sf /home/${USERNAME}/.local/opt/scala-2.13.4 /home/${USERNAME}/.local/opt/scala
rm -rf scala-2.13.4.tgz
"

su - "${USERNAME}" -c "
wget https://github.com/sbt/sbt/releases/download/v1.4.5/sbt-1.4.5.tgz
tar -zxf sbt-1.4.5.tgz
mv sbt /home/${USERNAME}/.local/opt/sbt-1.4.5
ln -sf /home/${USERNAME}/.local/opt/sbt-1.4.5 /home/${USERNAME}/.local/opt/sbt
rm -rf sbt-1.4.5.tgz
"

# Download wallpapers
su - "${USERNAME}" -c "
git clone https://github.com/vagmcs/wallpapers /home/${USERNAME}/Pictures/wallpapers
"

# Download personal projects
su - "${USERNAME}" -c "
git clone https://github.com/vagmcs/ScalaTIKZ /home/${USERNAME}/Work/dev/ScalaTIKZ
git clone https://github.com/vagmcs/Optimus /home/${USERNAME}/Work/dev/Optimus
git clone https://github.com/vagmcs/PRML /home/${USERNAME}/Work/dev/PRML
git clone https://github.com/vagmcs/architect /home/${USERNAME}/Work/dev/architect
"

# Install Z-PLUG plugin manager for ZSH
su - "${USERNAME}" -c "
git clone https://github.com/zplug/zplug ${ZPLUG_HOME}
chsh -s $(which zsh)
"

# Install VIM plugin manager
curl -fLo /home/"${USERNAME}"/.config/nvim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Globally install VIM essentials
pip install pynvim
npm i -g neovim

# Install Ammonite
curl -L https://github.com/lihaoyi/ammonite/releases/download/2.3.8/2.13-2.3.8-bootstrap > \
     /home/"${USERNAME}"/.local/bin/amm && chmod +x /home/"${USERNAME}"/.local/bin/amm

# Cleanup
rm /home/"${USERNAME}"/.bash_logout
