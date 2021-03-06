<h1 align="center">Architect</h1>

<p align="center">
<img alt="Maintenance" src="https://img.shields.io/maintenance/yes/2021?style=for-the-badge">
<img alt="GitHub" src="https://img.shields.io/github/license/vagmcs/architect?color=blue&style=for-the-badge">
</p>

### Arch Linux Installation Scripts

This README contains the steps I do to install and configure a fully-functional Arch Linux installation including a desktop environment, support packages (networking, bluetooth, audio, printers, etc.), my preferred programs and tools. The shell scripts in this repo allow for the entire process to be automated.

Installing an Arch system from scratch is time-consuming, and I am pretty lazy. My goal in developing these scripts was to learn more about Arch linux and to be able to go from a blank hard drive to a fully functional Arch system as fast as possible.

Some of these scripts include alternative listings of packages and certainly there is no need to install everything. Moreover, package choices and configuration are specific to my needs. Thus, please **do not just run these scripts.** Examine them. Customize them and create your own versions.

Happy hacking!

### Install Arch Linux

To install Arch linux run the `0-installer.sh` script or read the instructions [here](https://wiki.archlinux.org/index.php/Installation_guide).

### Run Architect scripts

Boot into the installed system, **connect to the network** and run the following scripts:

    $   ./1-xorg.sh
    $   ./2-de-wn.sh 
    $   ./3-network.sh 
    $   ./4-bluetooth.sh 
    $   ./5-audio.sh 
    $   ./6-printers.sh 
    $   ./7-software.sh
    $   ./8-fonts.sh
    $   ./9-configure.sh

### Reboot

    $   reboot

Congratulations!

You should have an Arch Linux system running all the base packages that allow network connectivity, bluetooth, printers, etc., and a curated selection of programs.