#!/bin/bash

# variant of build.sh that does not include the CentOS Everything yum repo

###############################################################################
# Add additional packages from /vagrant/additional_packages to kickstart
###############################################################################

# /vagrant/rhel7-livemedia.ks + additional packages from /vagrant/additional_packages = /tmp/rhel7-livemedia.with_additional_packages.ks
/vagrant/add_additional_packages.py

###############################################################################
# Customize SYSLINUX and GRUB2 bootloaders
###############################################################################
sudo cp /vagrant/patches/usr/share/lorax/live/config_files/x86/grub2-efi.cfg /usr/share/lorax/live/config_files/x86/grub2-efi.cfg
sudo cp /vagrant/patches/usr/share/lorax/live/x86.noeverything.tmpl /usr/share/lorax/live/x86.tmpl
sudo cp /vagrant/patches/usr/share/lorax/live/efi.tmpl /usr/share/lorax/live/efi.tmpl

###############################################################################
# Actually build the ISO
###############################################################################

# livemedia-creator refuses to run if results_dir exists
sudo rm -rf /tmp/build

sudo livemedia-creator --make-iso --ks=/tmp/rhel7-livemedia.with_additional_packages.ks --resultdir="/tmp/build" --no-virt --project="CentOS" --releasever="7.4.1804" --volid="CentOS 7 (1804) + nCipher x86_64"

###############################################################################
# Copy ISO back to host
###############################################################################
sudo cp /tmp/build/images/boot.iso /vagrant/boot.iso
