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

# Detect kernel version
# shellcheck disable=SC2010
KERNEL_VERSION="$(ls /boot | grep vmlinuz | sed s/vmlinuz-//)"

echo
echo "# INSTALLING XORG - https://wiki.archlinux.org/index.php/Xorg"
echo

PACKAGES=(

    # Xorg
    xorg-server                    # XOrg server
    xorg-apps                      # XOrg apps group
    xorg-xinit                     # XOrg init
    xorg-xinput                    # Tool for configuring devices

    # Intel Drivers
    xf86-video-intel               # 2D/3D Intel video driver
    mesa                           # Open source version of OpenGL
    lib32-mesa                     # Open source version of OpenGL (32-bit)
    vulkan-intel                   # Intel's Vulkan mesa driver
    lib32-vulkan-intel             # Intel's Vulkan mesa driver (32-bit)

    # AMD Drivers
    xf86-video-amdgpu              # 2D/3D AMD video driver
    vulkan-radeon                  # AMD's Vulkan mesa driver
    lib32-vulkan-radeon            # AMD's Vulkan mesa driver (32bit)
    mesa                           # Open source version of OpenGL
    lib32-mesa                     # Open source version of OpenGL (32-bit)
    mesa-vdpau                     # Mesa Video Decode and Presentation API drivers
    lib32-mesa-vdpau               # Mesa Video Decode and Presentation API drivers (32bit)
    libva-mesa-driver              # VA-API implementation for gallium
    lib32-libva-mesa-driver        # VA-API implementation for gallium

    # ATI Drivers
    xf86-video-ati                 # 2D/3D ATI video driver
    vulkan-radeon                  # AMD's Vulkan mesa driver
    lib32-vulkan-radeon            # AMD's Vulkan mesa driver (32bit)
    mesa                           # Open source version of OpenGL
    lib32-mesa                     # Open source version of OpenGL (32-bit)
    mesa-vdpau                     # Mesa Video Decode and Presentation API drivers
    lib32-mesa-vdpau               # Mesa Video Decode and Presentation API drivers (32bit)

    # NVIDIA Drivers
    nvidia                         # 2D/3D NVIDIA video driver
    nvidia-lts                     # 2D/3D NVIDIA video driver for the Linux LTS kernel
    nvidia-dkms                    # 2D/3D NVIDIA video driver for custom Linux kernels
    nvidia-utils                   # NVIDIA drivers utilities
    lib32-nvidia-utils             # NVIDIA drivers utilities (32bit)

    # VirtualBox Drivers
    virtualbox-guest-utils         # VirtualBox guest userspace utilities
    virtualbox-guest-dkms          # Virtualbox guest kernel modules for custom and LTS kernels
)

for PKG in "${PACKAGES[@]}"; do
    package_install "${PKG}"
done

mkinitcpio "${KERNEL_VERSION}"

echo
echo "Done!"
echo

read -er -p "Press enter to continue..."