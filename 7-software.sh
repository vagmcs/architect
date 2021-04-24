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

    linux-lts                 # Long term support kernel
    pamac-aur                 # Standalone GTK3 package manager
    lxappearance-gtk3         # GTK+ theme changer

    # TERMINAL UTILITIES --------------------------------------------------

    alacritty                 # A GPU-accelerated terminal emulator
    bash-completion           # Tab completion for Bash
    bashtop                   # Resource monitor
    bat                       # Cat clone having syntax highlighting
    bc                        # Precision calculator language
    clipmenu                  # Clipboard management
    cmus                      # Very feature-rich ncurses-based music player
    cpio                      # Copy files into or out of an archive
    cronie                    # Daemon that runs programs at scheduled times
    curl                      # Remote content retrieval
    duf                       # Disk usage/free utility
    emacs                     # EMACS editor
    exa                       # ls replacement
    ffmpeg                    # Record, convert and stream audio and video
    figlet                    # ASCII art from ordinary text
    fzf                       # Fuzzy finder
    gnupg                     # OpenPGP standard
    htop                      # Resource monitor
    inetutils                 # A collection of common network programs
    pandoc                    # Conversion between markup formats
    pass                      # Stores, retrieves, generates, and synchronizes passwords
    p7zip                     # 7zip compression program
    pdftk                     # PDF tools
    pkgfile                   # a pacman .files metadata explorer
    prettyping                # A colorful ping wrapper
    pydf                      # A colorized df clone
    python-psutil             # Process and system utilities module for Python
    python-pywal              # Generate colorschemes on the fly
    jq                        # JSON parsing library
    lazygit                   # Simple terminal UI for git commands
    lhasa                     # lhasa compression algorithm
    lpsolve                   # Mixed Integer Linear Programming solver
    lrzip                     # Compression algorithm
    lz4                       # lz4 compression algorithm
    lzip                      # Compression algorithm
    lzop                      # Compression algorithm
    ncdu                      # Simple ncurses disk usage analyzer
    neofetch                  # Shows system info when you launch terminal
    neomutt                   # Command line mail reader
    neovide                   # No nonsense Neovim client in Rust
    neovim                    # Neovim editor
    nnn                       # The fastest terminal file manager
    ntp                       # Network Time Protocol to set time via network
    openssh                   # SSH connectivity tools
    reflector                 # A script to retrieve and filter pacman mirrors.
    rsync                     # Remote file sync utility
    sc-im                     # A spreadsheet program based on SC
    shellcheck                # Shell script analysis tool
    speedtest-cli             # Internet speed via terminal
    tdrop                     # A WM-independent dropdown window creator
    tmux                      # Terminal multiplexer
    trash-cli                 # Command line trashcan interface
    ueberzug                  # Command line util that displays images in X11
    unclutter                 # A small program for hiding the mouse cursor
    unrar                     # RAR compression program
    unzip                     # Zip compression program
    wget                      # Remote content retrieval
    xbindkeys                 # Run shell commands using keyboard or mouse under X
    xclip                     # Command line interface to the X11 clipboard
    xsel                      # Command line program for copy and paste operations
    xwallpaper                # Wallpaper utility for X
    zip                       # Zip compression program
    zsh                       # ZSH shell
    zsh-completions           # Tab completion for ZSH
    zsh-syntax-highlighting   # Fish shell like syntax highlighting for Zsh
    zsh-autosuggestions       # zsh-autosuggestions

    # DOCUMENTS -----------------------------------------------------------

    pdfgrep                   # Tool to search text in PDF files
    foliate                   # Simple and modern GTK eBook reader
    texlive-bin               # TeX Live binaries
    texlive-most              # TeX Live distribution
    texlive-langgreek         # TeX Live Greek language support
    zathura                   # Minimalistic document viewer
    zathura-djvu              # DjVu support
    zathura-pdf-poppler       # PDF using the poppler engine
    zathura-ps                # PS support using the spectre library
    zotero                    # A tool to collect, organize, cite, and share research sources

    # DISK UTILITIES ------------------------------------------------------

    autofs                    # Auto-mounter
    e2fsprogs                 # Ext2/3/4 filesystem tools
    dosfstools                # DOS filesystem tools
    exfatprogs                # exFAT filesystem tools for the Linux Kernel driver
    ntfs-3g                   # Open source implementation of NTFS file system
    usbutils                  # USB tools to query connected USB devices
    gptfdisk                  # A text-mode partitioning tool for GUID Partition Table (GPT) disks

    # BACKUP --------------------------------------------------------------

    deja-dup                  # Simple backup tool
    timeshift                 # System restore utility

    # DEVELOPMENT ---------------------------------------------------------

    clang                     # C Lang compiler
    cmake                     # Cross-platform open-source make system
    git                       # Version control system
    github-cli                # GitHub CLI
    git-lfs                   # Git extension for versioning large files
    jetbrains-toolbox         # Manage JetBrains Projects and Tools
    maven                     # Java project management
    nodejs                    # Event driven I/O for V8 javascript
    npm                       # A package manager for javascript
    postgresql                # Sophisticated object-relational DBMS
    pyenv                     # Manage Python versions
    python                    # Python language
    python-pip                # PyPA tool for installing Python packages
    rustup                    # The Rust toolchain installer

    # MEDIA ---------------------------------------------------------------

    celluloid                 # Simple GTK+ frontend for mpv
    mpv                       # A free, open source, and cross-platform media player
    spotify                   # A proprietary music streaming service
    spotify-tui               # Spotify client for the terminal
    spicetify-cli             # Command-line tool to customize Spotify client
    streamlink                # CLI program that launches streams in a custom video player
    sxiv                      # Simple X Image Viewer
    youtube-dl                # A command-line program to download videos from YouTube.com

    # INTERNET AND CLOUD --------------------------------------------------

    brave-bin                 # Web browser that blocks ads and trackers by default
    firefox                   # Standalone web browser
    insync                    # A Google Drive and OneDrive client
    owncloud-client           # ownCloud client
    thunderbird               # Standalone mail reader
    transmission-gtk          # Fast, easy and free torrent client

    # VECTOR GRAPHICS EDITORS ---------------------------------------------

    inkscape                  # Vector graphics editor

    # GAMING --------------------------------------------------------------

    discord                   # Voice and text chat for gamers
    steam                     # Valve's game distribution platform
)

for PKG in "${PACKAGES[@]}"; do
    package_install "${PKG}"
done

echo
echo "Done!"
echo

read -er -p "Press enter to continue..."