#!/bin/bash

#Check to see if the user is root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    printf "Not running as root"
    exit
fi

# Enable SSH
printf "\n\nStep 1: Enable SSH\n\n"
update-rc.d ssh enable
invoke-rc.d ssh start

# Update package lists
printf "\n\nStep 2: Update all packages\n\n"
apt-get update -y

## UPGRADE ALL THE THINGS!!!
printf "\n\nStep 3: Update the distro\n\n"
DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical sudo apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" dist-upgrade

# Remove no longer needed packages
printf "\n\nStep 4: Removing no longer needed packages\n\n"
DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical sudo apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" autoremove --purge

printf "\n\nStep 5: Installing nodejs and npm\n\n"
wget -O - https://raw.githubusercontent.com/sdesalas/node-pi-zero/master/install-node-v7.7.1.sh | bash


printf "\n\nStep 6: Installing motion\n\n"

# Download motion
wget https://github.com/Motion-Project/motion/releases/download/release-4.0.1/pi_jessie_motion_4.0.1-1_armhf.deb

# Install motion
gdebi pi_jessie_motion_4.0.1-1_armhf.deb --n


printf "\n\nStep 7: Installing jq\n\n"
# Install jq
apt-get install jq -y

MOTION_CONFIG_DIR=$(jq -r '.pi.motionconfigpath' './s3-upload/global-config.json')
MOTION_SAVE_DIR=$(jq -r '.pi.motionsavepath' './s3-upload/global-config.json')
S3_UPLOAD_DIR=$(jq -r '.pi.s3uploadscriptspath' './s3-upload/global-config.json')


printf "\n\nStep 8: Configure motion\n\n"

# Create motion directory
mkdir "${MOTION_CONFIG_DIR}"

# Copy the configuration file
cp ./motion-config/motion.aws.conf "${MOTION_CONFIG_DIR}/motion.conf"

# Configure the configuration file
sed "s:on_picture_save.*:on_picture_save ${S3_UPLOAD_DIR}/process-picture.sh %f:g" "${MOTION_CONFIG_DIR}/motion.conf"
sed "s:target_dir.*:target_dir ${MOTION_SAVE_DIR}"

# Make it start on boot
if [[ "`tail -n1 /etc/rc.local`" != "exit 0"* ]]; then  
	printf "\n\nDid not add command to rc.local\n\n"; 
else
	sed -i -e '$i \motion -c '"${MOTION_CONFIG_DIR}"'/motion.conf &\n' /etc/rc.local
fi


printf "\n\nStep 9: Configure upload scripts\n\n"

# Move the s3-upload directory
mv ./s3-upload/ "${S3_UPLOAD_DIR}/"

# Change the s3-upload directory permissions
chown pi "${S3_UPLOAD_DIR}" --recursive
find "${S3_UPLOAD_DIR}/" -name "*.js" | xargs chmod +x
find "${S3_UPLOAD_DIR}/" -name "*.sh" | xargs chmod +x

npm install --prefix "${S3_UPLOAD_DIR}/" -y

printf "\n\nStep 10: Clean up\n\n"

# Clean up files
rm -rf -- "$(pwd -P)" && cd ..

reboot