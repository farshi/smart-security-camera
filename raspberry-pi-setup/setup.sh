#!/bin/bash

#Check to see if the user is root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

# Enable SSH
echo "Step 1: Enable SSH"
update-rc.d ssh enable
invoke-rc.d ssh start
echo "Step 1 Complete"

# Update package lists
echo "Step 2: Update all packages"
apt-get update -y
echo "Step 2 Complete"

## UPGRADE ALL THE THINGS!!!
echo "Step 3: Update the distro"
DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical sudo apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" dist-upgrade

# Remove no longer needed packages
echo "Step 4: Removing no longer needed packages"
DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical sudo apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" autoremove --purge

echo "Step 5: Installing nodejs via nvm"
# Install nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | NVM_DIR=/usr/local/nvm bash

# Install gdebi tools
apt-get install gdebi-core -y

# Install nodejs
nvm install latest

echo "Step 6: Installing motion"
# Download motion
wget https://github.com/Motion-Project/motion/releases/download/release-4.0.1/pi_jessie_motion_4.0.1-1_armhf.deb

# Install motion
gdebi pi_jessie_motion_4.0.1-1_armhf.deb

echo "Step 7: Installing jq"
# Install jq
apt-get install jq -y

MOTION_CONFIG_DIR=$(jq -r '.pi.motionconfigpath' './s3-upload/global-config.json')
MOTION_SAVE_DIR=$(jq -r '.pi.motionsavepath' './s3-upload/global-config.json')
S3_UPLOAD_DIR=$(jq -r '.pi.s3uploadscriptspath' './s3-upload/global-config.json')

echo "Step 8: Configure motion"
# Create motion directory
mkdir "${MOTION_CONFIG_DIR}"

# Copy the configuration file
cp ./motion-config/motion.aws.conf "${MOTION_CONFIG_DIR}/motion.conf"

# Move the s3-upload directory
mv ./s3-upload/ "${S3_UPLOAD_DIR}/"

# Configure the configuration file
sed "s:on_picture_save.*:on_picture_save ${S3_UPLOAD_DIR}/process-picture.sh %f:g" /home/pi/.motion/motion.conf

# Change the s3-upload directory permissions
chown pi "${S3_UPLOAD_DIR}" --recursive
chmod +x "${S#_UPLOAD_DIR}/*.js"
chmod +x "${S#_UPLOAD_DIR}/*.sh"

# Clean up files
#rm -rf 
