# Smart cloud camera
This project sets out to automate the very well documented blog post series [Smarten up Your Pi Zero Web Camera with Image Analysis and Amazon Web Services](https://utbrudd.bouvet.no/2017/01/10/smarten-up-your-pi-zero-web-camera-with-image-analysis-and-amazon-web-services-part-1)

For any background information for this project, you can read more about this solution in the following blog posts: 
* [Building a Motion Activated Security Camera with the Raspberry Pi Zero](https://utbrudd.bouvet.no/2017/01/05/building-a-motion-activated-security-camera-with-the-raspberry-pi-zero/).
* [Smarten up Your Pi Zero Web Camera with Image Analysis and Amazon Web Services Part 1](https://utbrudd.bouvet.no/2017/01/10/smarten-up-your-pi-zero-web-camera-with-image-analysis-and-amazon-web-services-part-1).
* [Smarten up Your Pi Zero Web Camera with Image Analysis and Amazon Web Services Part 2](https://utbrudd.bouvet.no/2017/01/10/smarten-up-your-pi-zero-web-camera-with-image-analysis-and-amazon-web-services-part-2).

## Contents
1. **[aws-setup]**(https://github.com/julianpitt/smart-security-camera/tree/master/aws-setup/): Contains all the aws account Source code for all aws lambda functions for handling image analysis and processing. JSON definition for orchestration of AWS Lambda Functions.

2. **[raspberry-pi-setup]**: Contains all the raspberry pi setup and Configuration

    * **[s3-upload](https://github.com/julianpitt/smart-security-camera/tree/master/raspberry-pi-setup/s3-upload)**: Handles upload of image files from Pi Zero to Amazon s3.

    * **[motion-config](https://github.com/julianpitt/smart-security-camera/tree/master/raspberry-pi-setup/motion-config)**: Configuration files for Motion (running on a Pi Zero).

## How to use


### Prerequisites

The following prerequisites are required for working with this repository.

1. The aws-cli installed and set up [AWS Cli](https://aws.amazon.com/cli/) with user credentials [AWS Credentials](http://docs.aws.amazon.com/gettingstarted/latest/awsgsg-intro/gsg-aws-intro.html)
2. A recent version of node installed [NodeJs](https://nodejs.org/en/) (optional: through nvm [Node Version Manager](https://github.com/creationix/nvm) ) 
3. Serverless framework installed globally [Serverless framework](https://serverless.com/)
4. You'll also need to be using a AWS Region that supports Rekognition, Step Functions, Lambda, s3 and SES (for example 'us-west-2')

### Hardware

All hardware along with links can be found in the first blog post linked above under background information.

1. A raspberry pi (Zero W used for this project)
2. A micro SD card with minimum 8GB space formatted with [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) 
3. A raspberry pi camera with the correct camera cable
4. (optional) ZeroView camera mount
5. USB thumb drive

### Steps

This project is broken down into two parts. The first will guide you through the the setup of resources on your AWS account. The second will be the setup of your raspberry pi device

1. Clone this project to your PC
2. Open the global-config.json file in your text editor and fill out:
- Your AWS account number
- A bucket name to create for this project e.g. (my-raspberry-pi-camera-bucket)
- Your email address
- Your name
- any of the other parameters if you don't like the defaults
3. Double click on updateConfig.bat


#### AWS resource creation

We will need to create an AWS user for the raspberry pi to use in order to send the images to your S3 bucket

4. Open a terminal or command window in the aws-setup directory and run
```
npm install
```
5. Assuming you've set up your aws-cli correctly and have serverelss installed, run the servereless deploy command
```
serverless deploy
```
6. Log into your AWS console and create a new user for your raspberry pi. Give the new user programmatic access, place them in a group created by the serverless deployment called 'Raspberry-Pi-Cameras-us-west-2' and generate and save the access key and secret access key
7. Back on your PC, open and fill in the config.json file found in the raspberry-pi-setup/s3-upload directory from the user you created above
8. Copy the raspberry-pi-setup folder to your USB thumb drive


#### Raspberry pi setup

9. Start up raspbian and connect to a wireless network
10. Open a terminal window and run 
```
sudo raspi-config
```
From this window do the following:
- Enable the camera (5->PI)
- Change the locale of your Pi (4)
- Change the raspberry pi password if you havent already (1)
- (optional) change to boot into command line (3)
11. Plug in your USB and copy the raspberry-pi-setup folder to your home directory
12. Open a terminal window in the raspberry-pi-setup directory and run the following commands
```
sudo chmod +x setup.sh
sudo ./setup.sh
```
13. Sit back and relax

After the installation script has complete you should have:
- All the latest packages and updates for your pi
- Motion installed and configured
- Motion stating in the background at every reboot
- S3 scripts in your home directory (unless changed)
- ssh enabled
- jq, nodejs and npm installed

And in your aws account:
- S3 bucket
- 6 labmda functions
- Step function state machine
- Security Group for all raspberry pis outlining the actions they're available to perform

## Acknowledgements

[Mark West](github.com/markwest1972) - for writing an excellent blog post outlining the project and sharing the code in [his repo](github.com/markwest1972/smart-security-camera).

All of the lambda functions and architecture was only slightly modified by myself in efforts to automate his work in an easy and reliable fashion.