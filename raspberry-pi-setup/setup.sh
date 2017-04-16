#!/bin/bash

#Check to see if the user is root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

# Enable SSH
update-rc.d ssh enable
invoke-rc.d ssh start

# Update package lists
sudo apt-get update -y

## UPGRADE ALL THE THINGS!!!
DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical sudo apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" dist-upgrade

# Remove no longer needed packages
DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical sudo apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" autoremove --purge

# Install nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | NVM_DIR=/usr/local/nvm bash

# Install gdebi tools
apt-get install gdebi-core

# Install nodejs
nvm install latest

# Download motion
wget https://github.com/Motion-Project/motion/releases/download/release-4.0.1/pi_jessie_motion_4.0.1-1_armhf.deb

# Install motion
gdebi pi_jessie_motion_4.0.1-1_armhf.deb

# Create motion directory
mkdir /home/pi/.motion

# Copy the configuration file
cp ./motion-config/motion.aws.conf /home/pi/.motion/motion.conf

# Configure the configuration file
sed "s:on_picture_save.*:on_picture_save /home/pi/.motion/motion.conf %f:g" /home/pi/.motion/motion.conf

# Move the s3-upload directory

# Change the s3-upload directory permissions


# Clean up files
rm -rf 