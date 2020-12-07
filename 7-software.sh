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
echo "# INSTALLING SOFTWARE - https://wiki.archlinux.org/index.php/List_of_applications"
echo

PACKAGES=(

    # SYSTEM --------------------------------------------------------------

    linux-lts             # Long term support kernel
    pamac-aur             # Standalone GTK 3 package manager

    # TERMINAL UTILITIES --------------------------------------------------

    bash-completion       # Tab completion for Bash
    bashtop               # Resource monitor
    bat                   # Cat clone having syntax highlighting
    bc                    # Precision calculator language
    colordiff             # diff replacement
    cpio                  # Copy files into or out of an archive
    curl                  # Remote content retrieval
    emacs                 # EMACS editor
    exa                   # ls replacement
    figlet                # ASCII art from ordinary text
    fzf                   # Fuzzy finder
    gnupg                 # OpenPGP standard
    htop                  # Resource monitor
    inetutils             # A collection of common network programs
    p7zip                 # 7zip compression program
    pdftk                 # PDF tools
    prettyping            # A colorful ping wrapper
    pydf                  # A colorized df clone
    python-pywal          # Generate colorschemes on the fly
    jq                    # JSON parsing library
    lhasa                 # lhasa compression algorithm
    lpsolve               # Mixed Integer Linear Programming solver
    lrzip                 # Compression algorithm
    lz4                   # lz4 compression algorithm
    lzip                  # Compression algorithm
    lzop                  # Compression algorithm
    ncdu                  # Simple ncurses disk usage analyzer
    neofetch              # Shows system info when you launch terminal
    neovim                # Neovim editor
    ntp                   # Network Time Protocol to set time via network
    openssh               # SSH connectivity tools
    rsync                 # Remote file sync utility
    speedtest-cli         # Internet speed via terminal
    tldr                  # Simplified and community-driven man pages
    tmux                  # Terminal multiplexer
    trash-cli             # Command line trashcan interface
    unrar                 # RAR compression program
    unzip                 # Zip compression program
    wget                  # Remote content retrieval
    zip                   # Zip compression program
    zsh                   # ZSH shell
    zsh-completions       # Tab completion for ZSH

    # DOCUMENTS -----------------------------------------------------------

    pdfgrep               # Tool to search text in PDF files
    texlive-bin           # TeX Live binaries
    texlive-most          # TeX Live distribution
    texlive-langgreek     # TeX Live Greek language support
    zathura               # Minimalistic document viewer
    zotero                # A tool to collect, organize, cite, and share research sources

    # DISK UTILITIES ------------------------------------------------------

    autofs                # Auto-mounter
    e2fsprogs             # Ext2/3/4 filesystem tools
    dosfstools            # DOS filesystem tools
    exfatprogs            # exFAT filesystem tools for the Linux Kernel driver
    ntfs-3g               # Open source implementation of NTFS file system
    usbutils              # USB tools to query connected USB devices
    gptfdisk              # A text-mode partitioning tool that works on GUID Partition Table (GPT) disks

    # DEVELOPMENT ---------------------------------------------------------

    clang                 # C Lang compiler
    cmake                 # Cross-platform open-source make system
    git                   # Version control system
    github-cli            # GitHub CLI
    git-lfs               # Git extension for versioning large files
    maven                 # Java project management
    postgresql            # Sophisticated object-relational DBMS
    python                # Python language
    python-pip            # PyPA tool for installing Python packages
    jetbrains-toolbox     # Manage JetBrains Projects and Tools

    # MEDIA ---------------------------------------------------------------

    mpv                  # A free, open source, and cross-platform media player
    spotify              # A proprietary music streaming service
    spotify-tui          # Spotify client for the terminal
    streamlink           # CLI program that launches streams in a custom video player
    youtube-dl           # A command-line program to download videos from YouTube.com

    # INTERNET AND CLOUD --------------------------------------------------

    firefox              # Standalone web browser
    insync               # A Google Drive and OneDrive client
    owncloud-client      # ownCloud client
    thunderbird          # Standalone mail reader
    transmission-gtk     # Fast, easy and free torrent client

    # VECTOR GRAPHICS EDITORS ---------------------------------------------

    inkscape             # Vector graphics editor

    # GAMING --------------------------------------------------------------

    discord              # Voice and text chat for gamers
    steam                # Valve's game distribution platform
)

for PKG in "${PACKAGES[@]}"; do
    package_install "${PKG}"
done

echo
echo "Done!"
echo

read -er -p "Press enter to continue..."