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
echo "# INSTALLING PRINTER DRIVERS - https://wiki.archlinux.org/index.php/Cups"
echo

PACKAGES=(
    cups                         # Open source printer drivers
    cups-pdf                     # PDF support for cups
    ghostscript                  # PostScript interpreter
    gsfonts                      # Adobe Postscript replacement fonts
    hplip                        # HP Drivers
    gutenprint                   # Drivers for Canon, Epson, Sony, Olympus, and PCL printers
    foomatic-db                  # XML files used to generate PPD files
    foomatic-db-engine           # Database engine that generates PPD files
    foomatic-db-nonfree          # XML files from printer manufacturers under non-free licenses
    foomatic-db-ppds             # Prebuilt PPD files
    foomatic-db-nonfree-ppds     # Prebuilt PPD files under non-free licenses
    foomatic-db-gutenprint-ppds  # Simplified prebuilt PPD files
)

for PKG in "${PACKAGES[@]}"; do
    package_install "${PKG}"
done

system_ctl enable cups.service

echo
echo "Done!"
echo

read -er -p "Press enter to continue..."