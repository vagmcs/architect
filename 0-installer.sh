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

source globals

# GLOBAL VARIABLES AND UTILITY FUNCTIONS {{{
CHECKLIST=(0 0 0 0 0 0 0 0 0 0 0 0)

UEFI=0
TRIM=0
LVM=0
LUKS=0

EFI_MOUNT_POINT=""
BOOT_MOUNT_POINT=""
ROOT_MOUNT_POINT=""
MOUNT_POINT="/mnt"

EDITOR="vim"

arch_chroot() {
  arch-chroot "${MOUNT_POINT}" /bin/bash -c "${1}"
}
#}}}
# CHECK BOOT SYSTEM {{{
check_boot_system() {
  echo
  echo "# BOOT MODE - https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface"
  echo

  if [[ "$(cat /sys/class/dmi/id/sys_vendor)" == 'Apple Inc.' ]] ||
    [[ "$(cat /sys/class/dmi/id/sys_vendor)" == 'Apple Computer, Inc.' ]]; then
    modprobe -r -q efivars || true # if MAC
  else
    modprobe -q efivarfs # all others
  fi
  if [[ -d "/sys/firmware/efi/" ]]; then
    ## Mount EFI variable filesystem if it is not already mounted by systemd
    # shellcheck disable=SC2143
    if [[ -z $(mount | grep /sys/firmware/efi/efivars) ]]; then
      mount -t efivarfs efivarfs /sys/firmware/efi/efivars
    fi
    UEFI=1
    info_msg "UEFI mode detected.\n"
  else
    UEFI=0
    info_msg "BIOS mode detected.\n"
  fi
  read -e -sn 1 -r -p "Press enter to continue..."
}
#}}}
# SELECT KEYMAP {{{
select_keymap() {
  echo
  echo "# KEYMAP - https://wiki.archlinux.org/index.php/Keymap"
  echo

  echo "Keymap list in '/usr/share/kbd/keymaps':"
  readarray keymaps < <(localectl list-keymaps | sort -V) # read all available keymaps
  local keymap_list=()
  for entry in "${keymaps[@]}"; do
    keymap_list+=("${entry::-1}") # remove trailing \n
  done

  PS3="${PROMPT_1}"
  select KEYMAP in "${keymap_list[@]}"; do
    if contains_element "${KEYMAP}" "${keymap_list[@]}"; then
      loadkeys "${KEYMAP}"
      break
    else
      echo "Invalid option. Try another one."
      read -e -sn 1 -r -p "Press enter to continue..."
    fi
  done
}
#}}}
# MIRROR LIST {{{
configure_mirror_list() {

  # shellcheck disable=SC2207
  readarray -t countries_name <<<"$(reflector --list-countries | awk -F'[[:space:]][[:space:]]' '{if (NR>2) print $1}')"

  country_list() {
    PS3="${PROMPT_1}"
    echo "Select your country:"
    select COUNTRY_NAME in "${countries_name[@]}"; do
      if contains_element "${COUNTRY_NAME}" "${countries_name[@]}"; then
        break
      else
        echo "Invalid option. Try another one."
        read -e -sn 1 -r -p "Press enter to continue..."
      fi
    done
  }

  echo
  echo "# MIRROR LIST - https://wiki.archlinux.org/index.php/Mirrors"
  echo

  OPTION=n
  while [[ "${OPTION}" != y ]]; do
    country_list
    read_input_text "Confirm country: ${COUNTRY_NAME}"
  done

  # Get the latest mirror list
  reflector --latest 5 --sort rate --country "${COUNTRY_NAME}" --save /etc/pacman.d/mirrorlist

  # Fastest repo should go first
  pacman -Sy pacman-contrib
  cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.tmp
  rankmirrors /etc/pacman.d/mirrorlist.tmp > /etc/pacman.d/mirrorlist
  rm /etc/pacman.d/mirrorlist.tmp

  # WARN: Allow global read access (required for non-root AUR helper execution)
  chmod +r /etc/pacman.d/mirrorlist
  "${EDITOR}" /etc/pacman.d/mirrorlist
}
#}}}
# UMOUNT PARTITIONS {{{
umount_partitions() {
  # shellcheck disable=SC2207
  mounted_partitions=($(lsblk | grep "${MOUNT_POINT}" | awk '{print $7}' | sort -r))
  swapoff -a # disable swap devices
  for p in "${mounted_partitions[@]}"; do
    umount "${p}"
  done
}
#}}}
# SELECT DEVICE {{{
select_device() {
  # shellcheck disable=SC2207
  devices=($(lsblk -d | awk '{print "/dev/" $1}' | grep 'sd\|hd\|vd\|nvme\|mmcblk'))
  PS3="${PROMPT_1}"
  echo -e "\nAvailable devices:\n"
  lsblk -lnp -I 2,3,8,9,22,34,56,57,58,65,66,67,68,69,70,71,72,91,128,129,130,131,132,133,134,135,259 | awk '{print $1,$4,$6,$7}' | column -t
  echo -e "\nSelect device to partition:\n"
  select device in "${devices[@]}"; do
    if contains_element "${device}" "${devices[@]}"; then
      break
    else
      echo "Invalid option. Try another one."
      read -e -sn 1 -r -p "Press enter to continue..."
    fi
  done
  BOOT_MOUNT_POINT="${device}"
}
#}}}
# CREATE PARTITION SCHEME {{{
create_partition_scheme() {
  echo
  echo "# DISK PARTITION - https://wiki.archlinux.org/index.php/Partitioning"
  echo
  PS3="${PROMPT_1}"
  echo -e "Select partition scheme:\n"
  select OPT in "Simple" "Custom [LVM, RAID, LUKS]"; do
    partition_layout="${OPT}"
    case "${REPLY}" in
    1)
      create_partition
      ;;
    2)
      # custom partitioning
      bash -i
      # check if LVM and/or LUKS is used
      check_lvm=$(lsblk -lp | grep lvm)
      [[ -z "${check_lvm}" ]] && LVM=1
      check_luks=$(blkid | grep LUKS)
      [[ -z "${check_luks}" ]] && LUKS=1
      ;;
    *)
      echo "Invalid option. Try another one."
      read -e -sn 1 -r -p "Press enter to continue..."
      ;;
    esac
    [[ -n "${OPT}" ]] && break
  done
}
#}}}
# SETUP PARTITION {{{
create_partition() {
  apps_list=("cfdisk" "cgdisk" "fdisk" "gdisk" "parted")
  PS3="${PROMPT_1}"
  echo -e "\nSelect partition program:\n"
  select OPT in "${apps_list[@]}"; do
    if contains_element "${OPT}" "${apps_list[@]}"; then
      select_device
      case "${OPT}" in
      parted)
        parted -a optimal "${device}" # use optimal sector alignment
        ;;
      *)
        $OPT "${device}"
        ;;
      esac
      break
    else
      echo "Invalid option. Try another one."
      read -e -sn 1 -r -p "Press enter to continue..."
    fi
  done
}
#}}}
# SELECT | FORMAT PARTITIONS {{{
format_partitions() {
  echo
  echo "# FORMAT PARTITIONS - https://wiki.archlinux.org/index.php/File_Systems"
  echo
  danger_msg "All data on the ROOT and SWAP partition will be LOST.\n"

  i=0

  # shellcheck disable=SC2207
  partitions_list=($(lsblk -lp | grep 'part\|lvm' | awk '{print substr($1,1)}'))

  # check if there are no partitions
  if [[ "${#partitions_list[@]}" -eq 0 ]]; then
    error_msg "No partitions found."
  fi

  # partitions based on boot system (root MUST always be mounted first)
  if [[ "${UEFI}" -eq 1 ]]; then
    partition_name=("root" "EFI" "swap" "another")
  else
    partition_name=("root" "swap" "another")
  fi

  select_filesystem() {
    filesystems_list=("vfat" "ext2" "ext3" "ext4" "ntfs" "btrfs" "f2fs" "jfs" "nilfs2" "reiserfs" "xfs")
    PS3="${PROMPT_1}"
    echo -e "Select filesystem:\n"
    select filesystem in "${filesystems_list[@]}"; do
      if contains_element "${filesystem}" "${filesystems_list[@]}"; then
        break
      else
        echo "Invalid option. Try another one."
        read -e -sn 1 -r -p "Press enter to continue..."
      fi
    done
  }

  disable_partition() {
    # remove the selected partition from list
    unset partitions_list["${partition_number}"]
    partitions_list=("${partitions_list[@]}")
    # increase i
    [[ "${partition_name[i]}" != another ]] && i=$((i + 1))
  }

  format_partition() {
    read_input_text "Confirm format ${1} partition"
    if [[ "${OPTION}" == y ]]; then
      [[ -z "${3}" ]] && select_filesystem || filesystem="${3}"
      # shellcheck disable=SC2046
      mkfs."${filesystem}" "${1}" \
        $([[ "${filesystem}" == xfs || "${filesystem}" == btrfs || "${filesystem}" == reiserfs ]] && echo "-f") \
        $([[ "${filesystem}" == vfat ]] && echo "-F32") \
        $([[ "${TRIM}" -eq 1 && "${filesystem}" == ext4 ]] && echo "-E discard")
      fsck "${1}"
      mkdir -p "${2}"
      mount -t "${filesystem}" "${1}" "${2}"
      disable_partition # remove partition from the list
    fi
  }

  format_swap_partition() {
    read_input_text "Confirm format ${1} partition"
    if [[ "${OPTION}" == y ]]; then
      mkswap "${1}"
      swapon "${1}"
      disable_partition # remove partition from the list
    fi
  }

  create_swap() {
    PS3="${PROMPT_1}"
    echo -e "\nSelect ${Bold:?}${Yellow:?}${partition_name[i]}${Reset:?} filesystem:\n"
    select OPT in "partition" "file" "skip"; do
      case "${REPLY}" in
      1)
        select partition in "${partitions_list[@]}"; do
          # get the selected number - 1
          partition_number=$((REPLY - 1))
          if contains_element "${partition}" "${partitions_list[@]}"; then
            format_swap_partition "${partition}"
          fi
          break
        done
        swap_type="partition"
        break
        ;;
      2)
        total_memory=$(grep MemTotal /proc/meminfo | awk '{print $2/1024}' | sed 's/\..*//')
        dd if=/dev/zero of="${MOUNT_POINT}"/swapfile bs=1M count="${total_memory}" status=progress
        chmod 600 "${MOUNT_POINT}"/swapfile
        mkswap "${MOUNT_POINT}"/swapfile
        swapon "${MOUNT_POINT}"/swapfile
        i=$((i + 1))
        swap_type="file"
        break
        ;;
      3)
        i=$((i + 1))
        swap_type="none"
        break
        ;;
      *)
        echo "Invalid option. Try another one."
        read -e -sn 1 -r -p "Press enter to continue..."
        ;;
      esac
    done
  }

  check_mount_point() {
    if mount | grep "${2}"; then
      info_msg "Successfully mounted."
      disable_partition "${1}"
    else
      warn_msg "Not successfully mounted."
    fi
  }

  set_EFI_partition() {
    EFI_options=("/boot" "/boot/efi")
    PS3="${PROMPT_1}"
    echo -e "Select EFI mount point:\n"
    select EFI_MOUNT_POINT in "${EFI_options[@]}"; do
      if contains_element "${EFI_MOUNT_POINT}" "${EFI_options[@]}"; then
        break
      else
        echo "Invalid option. Try another one."
        read -e -sn 1 -r -p "Press enter to continue..."
      fi
    done
  }

  while true; do
    PS3="${PROMPT_1}"
    if [[ "${partition_name[i]}" == swap ]]; then
      create_swap
    else
      echo -e "Select ${Bold}${Yellow}${partition_name[i]}${Reset} partition:\n"
      select partition in "${partitions_list[@]}"; do
        # get the selected number - 1
        partition_number=$((REPLY - 1))
        if contains_element "${partition}" "${partitions_list[@]}"; then
          case ${partition_name[i]} in
            root)
              ROOT_MOUNT_POINT="${partition}"
              format_partition "${partition}" "${MOUNT_POINT}"
              ;;
            EFI)
              set_EFI_partition
              read_input_text "Format ${partition} partition"
              if [[ "${OPTION}" == y ]]; then
                format_partition "${partition}" "${MOUNT_POINT}${EFI_MOUNT_POINT}" vfat
              else
                mkdir -p "${MOUNT_POINT}${EFI_MOUNT_POINT}"
                mount -t vfat "${partition}" "${MOUNT_POINT}${EFI_MOUNT_POINT}"
                check_mount_point "${partition}" "${MOUNT_POINT}${EFI_MOUNT_POINT}"
              fi
              ;;
            another)
              read -p "Mount point [example: /home]:" -r directory
              [[ "${directory}" == "/boot" ]] && BOOT_MOUNT_POINT="${partition/[0-9]/}"
              select_filesystem
              read_input_text "Format ${partition} partition"
              if [[ "${OPTION}" == y ]]; then
                format_partition "${partition}" "${MOUNT_POINT}${directory}" "${filesystem}"
              else
                read_input_text "Confirm fs=""${filesystem}"" part=""${partition}"" dir=""${directory}"""
                if [[ "${OPTION}" == y ]]; then
                  mkdir -p "${MOUNT_POINT}${directory}"
                  mount -t "${filesystem}" "${partition}" "${MOUNT_POINT}${directory}"
                  check_mount_point "${partition}" "${MOUNT_POINT}${directory}"
                fi
              fi
              ;;
            esac
          break
        else
          echo "Invalid option. Try another one."
          read -e -sn 1 -r -p "Press enter to continue..."
        fi
      done
    fi

    # Check if there is no partitions left
    if [[ "${#partitions_list[@]}" -eq 0 && "${partition_name[i]}" != swap ]]; then
      break
    elif [[ "${partition_name[i]}" == another ]]; then
      read_input_text "Configure more partitions"
      [[ "${OPTION}" != y ]] && break
    fi
  done
  read -e -sn 1 -r -p "Press enter to continue..."
}
#}}}
# INSTALL BASE SYSTEM {{{
select_linux_kernel() {
  echo
  echo "# LINUX KERNEL - https://wiki.archlinux.org/index.php/Kernel"
  echo
  version_list=("linux (default)" "linux-lts (long term support)" "linux-hardened (security)" "linux-zen (tuned)")
  PS3="${PROMPT_1}"
  echo "Select linux kernel version to install:"
  select VERSION in "${version_list[@]}"; do
    if contains_element "${VERSION}" "${version_list[@]}"; then
      if [ "linux (default)" == "${VERSION}" ]; then
        pacstrap "${MOUNT_POINT}" base linux linux-headers linux-firmware
      elif [ "linux-lts (long term support)" == "${VERSION}" ]; then
        pacstrap "${MOUNT_POINT}" base linux-lts linux-lts-headers linux-firmware
      elif [ "linux-hardened (security features)" == "${VERSION}" ]; then
        pacstrap "${MOUNT_POINT}" base linux-hardened linux-hardened-headers linux-firmware
      elif [ "linux-zen (tuned kernel)" == "${VERSION}" ]; then
        pacstrap "${MOUNT_POINT}" base linux-zen linux-zen-headers linux-firmware
      fi
      # shellcheck disable=SC2001
      KERNEL_VERSION=$(echo "${VERSION}" | sed 's/ .*//') # keep only the package name (remove the parenthesis)
      break
    else
      echo "Invalid option. Try another one."
      read -e -sn 1 -r -p "Press enter to continue..."
    fi
  done
}
install_base_system() {
  echo
  echo "# INSTALL BASE SYSTEM"
  echo

  pacman -Sy archlinux-keyring
  rm "${MOUNT_POINT}${EFI_MOUNT_POINT}"/vmlinuz-linux

  # Install Linux kernel and basic packages
  clear && select_linux_kernel
  # shellcheck disable=SC2181
  [[ $? -ne 0 ]] && error_msg "Installing base system to ${MOUNT_POINT} failed. Check the error messages above."

  # Install lvm and crypt setup system tools if LVM and/or LUKS is detected
  [[ "${LVM}" -eq 1 ]] && pacstrap "${MOUNT_POINT}" lvm2
  [[ "${LUKS}" -eq 1 ]] && pacstrap "${MOUNT_POINT}" cryptsetup

  # Install basic system tools and networking
  pacstrap "${MOUNT_POINT}" base-devel man-db man-pages neovim networkmanager
  arch_chroot "systemctl enable NetworkManager.service"

  # Add KEYMAP to the setup
  echo "KEYMAP=${KEYMAP}" > "${MOUNT_POINT}"/etc/vconsole.conf
  read -e -sn 1 -r -p "Press enter to continue..."
}
#}}}
# CONFIGURE FSTAB {{{
configure_fstab() {
  echo
  echo "# FSTAB - https://wiki.archlinux.org/index.php/Fstab"
  echo
  PS3="${PROMPT_1}"
  echo "Configure fstab based on:"
  select OPT in "DEV" "UUID" "LABEL"; do
    case "${REPLY}" in
    1) genfstab -p "${MOUNT_POINT}" > "${MOUNT_POINT}"/etc/fstab ;;
    2)
      [[ "${UEFI}" -eq 1 ]] && genfstab -t PARTUUID -p "${MOUNT_POINT}" > "${MOUNT_POINT}"/etc/fstab
      [[ "${UEFI}" -eq 0 ]] && genfstab -U -p "${MOUNT_POINT}" > "${MOUNT_POINT}"/etc/fstab
      ;;
    3) genfstab -L -p "${MOUNT_POINT}" > "${MOUNT_POINT}"/etc/fstab ;;
    *)
      echo "Invalid option. Try another one."
      read -e -sn 1 -r -p "Press enter to continue..."
      ;;
    esac
    [[ -n "${OPT}" ]] && break
  done
  FSTAB="${OPT}"

  echo "Check your fstab"
  read -e -sn 1 -r -p "Press enter to continue..."
  "${EDITOR}" "${MOUNT_POINT}"/etc/fstab
}
#}}}
# CONFIGURE HOSTNAME {{{
configure_hostname() {
  echo
  echo "# HOSTNAME - https://wiki.archlinux.org/index.php/Hostname"
  echo
  read -p "Hostname [example: archlinux]: " -r HOSTNAME
  echo "${HOSTNAME}" > "${MOUNT_POINT}"/etc/hostname

  # populate the /etc/hosts file
  {
    echo -e "127.0.0.1\tlocalhost"
    echo -e "::1\t\tlocalhost"
    echo -e "127.0.0.1\t${HOSTNAME}.localdomain\t${HOSTNAME}"
  } > "${MOUNT_POINT}"/etc/hosts

  "${EDITOR}" "${MOUNT_POINT}"/etc/hosts
}
#}}}
# CONFIGURE TIMEZONE {{{
configure_timezone() {
  set_timezone() {
    # shellcheck disable=SC2207
    local _zones=($(timedatectl list-timezones | sed 's/\/.*$//' | uniq))
    PS3="${PROMPT_1}"
    echo "Select zone:"
    select ZONE in "${_zones[@]}"; do
      if contains_element "${ZONE}" "${_zones[@]}"; then
        # shellcheck disable=SC2207
        local _sub_zones=($(timedatectl list-timezones | grep "${ZONE}" | sed 's/^.*\///'))
        PS3="${PROMPT_1}"
        echo "Select sub-zone:"
        select SUBZONE in "${_sub_zones[@]}"; do
          if contains_element "${SUBZONE}" "${_sub_zones[@]}"; then
            break
          else
            echo "Invalid option. Try another one."
            read -e -sn 1 -r -p "Press enter to continue..."
          fi
        done
        break
      else
        echo "Invalid option. Try another one."
        read -e -sn 1 -r -p "Press enter to continue..."
      fi
    done
  }

  echo
	echo "# TIMEZONE - https://wiki.archlinux.org/index.php/Timezone"
	echo
  OPTION=n
  while [[ "${OPTION}" != y ]]; do
    set_timezone
    read_input_text "Confirm timezone (${ZONE}/${SUBZONE})"
  done
  arch_chroot "ln -sf /usr/share/zoneinfo/${ZONE}/${SUBZONE} /etc/localtime"

  # See systemd-timesyncd configuration for more details
  arch_chroot "sed -i '/#NTP=/d' /etc/systemd/timesyncd.conf"
  arch_chroot "sed -i 's/#Fallback//' /etc/systemd/timesyncd.conf"
  arch_chroot "sed -i '/Root/d' /etc/systemd/timesyncd.conf"
  arch_chroot "sed -i '/Poll/d' /etc/systemd/timesyncd.conf"
  arch_chroot "echo 'FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org' >> /etc/systemd/timesyncd.conf"
  arch_chroot "systemctl enable systemd-timesyncd.service"
}
#}}}
# CONFIGURE HARDWARE CLOCK {{{
configure_hardware_clock() {
  echo
  echo "# HARDWARE CLOCK TIME"
  echo
  warn_msg "Use the same hardware clock mode among your operating systems, otherwise they may cause clock shifts.\n"
  PS3="${PROMPT_1}"
  select OPT in "UTC" "Localtime"; do
    case "${REPLY}" in
    1) arch_chroot "hwclock --systohc --utc" ;;
    2) arch_chroot "hwclock --systohc --localtime" ;;
    *)
      echo "Invalid option. Try another one."
      read -e -sn 1 -r -p "Press enter to continue..."
      ;;
    esac
    [[ -n "${OPT}" ]] && break
  done
  HW_CLOCK="${OPT}"
}
#}}}
# CONFIGURE LOCALE {{{
configure_locale() {
  set_locale() {
    # shellcheck disable=SC2207
    local _locale_list=($(grep UTF-8 </etc/locale.gen | sed 's/\..*$//' | sed '/@/d' | awk '{print $1}' | uniq | sed 's/#//g'))
    PS3="${PROMPT_1}"
    echo "Select locale:"
    select LOCALE in "${_locale_list[@]}"; do
      if contains_element "${LOCALE}" "${_locale_list[@]}"; then
        LOCALE_UTF8="${LOCALE}.UTF-8"
        break
      else
        echo "Invalid option. Try another one."
        read -e -sn 1 -r -p "Press enter to continue..."
      fi
    done
  }

  echo
  echo "# LOCALE - https://wiki.archlinux.org/index.php/Locale"
  echo
  OPTION=n
  while [[ "${OPTION}" != y ]]; do
    set_locale
    read_input_text "Confirm locale (${LOCALE})"
  done

  echo 'LANG="'"${LOCALE_UTF8}"'"' > "${MOUNT_POINT}"/etc/locale.conf
  arch_chroot "sed -i 's/#\('${LOCALE_UTF8}'\)/\1/' /etc/locale.gen"
  arch_chroot "locale-gen"
}
#}}}
# CONFIGURE MKINITCPIO {{{
configure_mkinitcpio() {
  echo
  echo "# MKINITCPIO - https://wiki.archlinux.org/index.php/Mkinitcpio"
  echo
  # Do not forget to add hooks for LUKS encryption and LVM in case they are enabled
  # See:
  # 1. https://wiki.archlinux.org/index.php/Install_Arch_Linux_on_LVM#Adding_mkinitcpio_hooks
  # 2. https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration#mkinitcpio
  "${EDITOR}" "${MOUNT_POINT}"/etc/mkinitcpio.conf
  arch_chroot "mkinitcpio -p ${KERNEL_VERSION}"
}
#}}}
# INSTALL BOOTLOADER {{{
install_bootloader() {
  echo
  echo "# BOOTLOADER - https://wiki.archlinux.org/index.php/Bootloader"
  echo
  [[ "${UEFI}" -eq 1 ]] && info_msg "EFI partition: ${EFI_MOUNT_POINT}"
  info_msg "ROOT partition: ${ROOT_MOUNT_POINT}"

  if [[ "${UEFI}" -eq 1 ]]; then
    warn_msg "UEFI mode detected.\n"
    bootloaders_list=("GRUB" "systemd-boot" "None")
  else
    warn_msg "BIOS mode detected.\n"
    bootloaders_list=("GRUB" "None")
  fi

  PS3="${PROMPT_1}"
  echo "Install bootloader:"
  select BOOTLOADER in "${bootloaders_list[@]}"; do
    case "${REPLY}" in
    1) pacstrap "${MOUNT_POINT}" grub os-prober && break ;;
    2) break ;;
    *)
      echo "Invalid option. Try another one."
      read -e -sn 1 -r -p "Press enter to continue..."
      ;;
    esac
  done
  [[ "${UEFI}" -eq 1 ]] && pacstrap "${MOUNT_POINT}" efibootmgr
}
#}}}
# CONFIGURE BOOTLOADER {{{
configure_bootloader() {
  case "${BOOTLOADER}" in
  GRUB)
    echo
    echo "# GRUB - https://wiki.archlinux.org/index.php/GRUB"
    echo
    PS3="${PROMPT_1}"
    echo "Grub Install:"
    select OPT in "Automatic" "Manual"; do
      case "${REPLY}" in
      1)
        if [[ "${UEFI}" -eq 1 ]]; then
          arch_chroot "grub-install --target=x86_64-efi --efi-directory=${EFI_MOUNT_POINT} --bootloader-id=arch_grub --recheck"
        else
          arch_chroot "grub-install --target=i386-pc --recheck ${BOOT_MOUNT_POINT}"
        fi
        break
        ;;
      2)
        arch-chroot "${MOUNT_POINT}"
        break
        ;;
      *)
        echo "Invalid option. Try another one."
        read -e -sn 1 -r -p "Press enter to continue..."
        ;;
      esac
    done
    arch_chroot "grub-mkconfig -o /boot/grub/grub.cfg"
    ;;
  systemd-boot)
    echo
    echo "# SYSTEMD-BOOT - https://wiki.archlinux.org/index.php/Systemd-boot"
    echo
    warn_msg "Systemd-boot heavily suggests that /boot is mounted to the EFI partition, not /boot/efi, in order to simplify updating and configuration.\n"
    PS3="${PROMPT_1}"
    echo "Systemd-boot install:"
    select OPT in "Automatic" "Manual"; do
      case "${REPLY}" in
      1)
        arch_chroot "bootctl --path=${EFI_MOUNT_POINT} install"
        warn_msg "Please check your .conf file"
        uuid=$(blkid -s PARTUUID "${ROOT_MOUNT_POINT}" | awk '{print $2}' | sed 's/"//g' | sed 's/^.*=//')

        {
          echo -e "title Arch Linux"
          echo -e "linux /vmlinuz-${KERNEL_VERSION}"
          echo -e "initrd /initramfs-${KERNEL_VERSION}.img"
          echo -e "options root=PARTUUID=${uuid} rw"
        } > "${MOUNT_POINT}${EFI_MOUNT_POINT}"/loader/entries/arch.conf

        {
          echo -e "default arch"
          echo -e "timeout 5"
        } > "${MOUNT_POINT}${EFI_MOUNT_POINT}"/loader/loader.conf

        read -e -sn 1 -r -p "Press enter to continue..."
        "${EDITOR}" "${MOUNT_POINT}${EFI_MOUNT_POINT}"/loader/entries/arch.conf
        "${EDITOR}" "${MOUNT_POINT}${EFI_MOUNT_POINT}"/loader/loader.conf
        break
        ;;
      2)
        arch-chroot "${MOUNT_POINT}"
        break
        ;;
      *)
        echo "Invalid option. Try another one."
        read -e -sn 1 -r -p "Press enter to continue..."
        ;;
      esac
    done
    ;;
  esac
  read -e -sn 1 -r -p "Press enter to continue..."
}
#}}}
# ROOT PASSWORD {{{
root_password() {
  echo
  echo "# ROOT PASSWORD"
  echo
  warn_msg "Enter a root password.\n"
  arch_chroot "passwd"
  read -e -sn 1 -r -p "Press enter to continue..."
}
#}}}
# FINISH {{{
finish() {
  echo
  echo "# INSTALLATION COMPLETED"
  echo
  warn_msg "A copy of the repo is placed in /root directory of the installed system.\n"
  cp -R "$(pwd)" "${MOUNT_POINT}"/root
  read_input_text "Reboot system"
  [[ "${OPTION}" == y ]] && umount_partitions && reboot
  exit 0
}
#}}}
# MAIN FUNCTION {{{
# shellcheck disable=SC2143
[[ -n $(hdparm -I /dev/sda | grep TRIM 2>/dev/null) ]] && TRIM=1 # check for TRIM support (SSDs only)
clear && read_input_text "Do you need a larger font"
if [[ "${OPTION}" == y ]]; then # set console font and keymap
  pacman -Sy terminus-font && setfont ter-v32b && loadkeys "${KEYMAP}"
else
  pacman -Sy terminus-font && setfont ter-v16b && loadkeys "${KEYMAP}"
fi
clear && check_boot_system
pacman -Sy "${EDITOR}"

while true; do
  clear
  echo
  echo "# ARCHITECT INSTALLER - https://github.com/vagmcs/architect"
  echo
  echo " 1) $(main_menu_item "${CHECKLIST[1]}" "Select Keymap" "${KEYMAP}")"
  echo " 2) $(main_menu_item "${CHECKLIST[2]}" "Configure Mirrors" "${COUNTRY_NAME}")"
  echo " 3) $(main_menu_item "${CHECKLIST[3]}" "Partition Scheme" "${partition_layout}: ${partition}(${filesystem}) swap(${swap_type})")"
  echo " 4) $(main_menu_item "${CHECKLIST[4]}" "Install Base System" "${KERNEL_VERSION}")"
  echo " 5) $(main_menu_item "${CHECKLIST[5]}" "Configure Fstab" "${FSTAB}")"
  echo " 6) $(main_menu_item "${CHECKLIST[6]}" "Configure Hostname" "${HOSTNAME}")"
  echo " 7) $(main_menu_item "${CHECKLIST[7]}" "Configure Timezone" "${ZONE}/${SUBZONE}")"
  echo " 8) $(main_menu_item "${CHECKLIST[8]}" "Configure Hardware Clock" "${HW_CLOCK}")"
  echo " 9) $(main_menu_item "${CHECKLIST[9]}" "Configure Locale" "${LOCALE}")"
  echo "10) $(main_menu_item "${CHECKLIST[10]}" "Configure mkinitcpio")"
  echo "11) $(main_menu_item "${CHECKLIST[11]}" "Install Bootloader" "${BOOTLOADER}")"
  echo "12) $(main_menu_item "${CHECKLIST[12]}" "Root Password")"
  echo ""
  echo " d) Done"
  echo ""
  read_input_options
  # shellcheck disable=SC2153
  for OPT in "${OPTIONS[@]}"; do
    case "$OPT" in
    1)
      clear && select_keymap
      CHECKLIST[1]=1
      ;;
    2)
      clear && configure_mirror_list
      CHECKLIST[2]=1
      ;;
    3)
      umount_partitions
      clear && create_partition_scheme
      clear && format_partitions
      CHECKLIST[3]=1
      ;;
    4)
      clear && install_base_system
      CHECKLIST[4]=1
      ;;
    5)
      clear && configure_fstab
      CHECKLIST[5]=1
      ;;
    6)
      clear && configure_hostname
      CHECKLIST[6]=1
      ;;
    7)
      clear && configure_timezone
      CHECKLIST[7]=1
      ;;
    8)
      clear && configure_hardware_clock
      CHECKLIST[8]=1
      ;;
    9)
      clear && configure_locale
      CHECKLIST[9]=1
      ;;
    10)
      clear && configure_mkinitcpio
      CHECKLIST[10]=1
      ;;
    11)
      clear && install_bootloader
      clear && configure_bootloader
      CHECKLIST[11]=1
      ;;
    12)
      clear && root_password
      CHECKLIST[12]=1
      ;;
    "d")
      clear && finish
      ;;
    *)
      echo "Invalid option. Try another one."
      read -e -sn 1 -r -p "Press enter to continue..."
      ;;
    esac
  done
done
#}}}
