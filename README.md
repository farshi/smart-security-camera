# Smart cloud camera
This project sets out to automate the very well documented blog post series [Smarten up Your Pi Zero Web Camera with Image Analysis and Amazon Web Services](https://utbrudd.bouvet.no/2017/01/10/smarten-up-your-pi-zero-web-camera-with-image-analysis-and-amazon-web-services-part-1)

You can read more about this solution in the following blog posts: 
* [Building a Motion Activated Security Camera with the Raspberry Pi Zero](https://utbrudd.bouvet.no/2017/01/05/building-a-motion-activated-security-camera-with-the-raspberry-pi-zero/).
* [Smarten up Your Pi Zero Web Camera with Image Analysis and Amazon Web Services Part 1](https://utbrudd.bouvet.no/2017/01/10/smarten-up-your-pi-zero-web-camera-with-image-analysis-and-amazon-web-services-part-1).
* [Smarten up Your Pi Zero Web Camera with Image Analysis and Amazon Web Services Part 2](https://utbrudd.bouvet.no/2017/01/10/smarten-up-your-pi-zero-web-camera-with-image-analysis-and-amazon-web-services-part-2).

## Contents
1. **[aws-setup]**: Contains all the aws account Configuration
    
    * **[aws-lambda-functions](https://github.com/markwest1972/smart-security-camera/tree/master/aws-lambda-functions)**: Source code for all aws lambda functions for handling image analysis and processing. JSON definition for orchestration of AWS Lambda Functions.
    
    * **[aws-step-functions](https://github.com/markwest1972/smart-security-camera/tree/master/aws-step-functions)**: Source code for orchestration of AWS Lambda Functions.
2. **[raspberry-pi-setup]**: Contains all the raspberry pi setup and Configuration

    * **[s3-upload](https://github.com/markwest1972/smart-security-camera/tree/master/s3-upload)**: Handles upload of image files from Pi Zero to Amazon s3.

    * **[motion-config](https://github.com/markwest1972/smart-security-camera/tree/master/motion-config)**: Configuration files for Motion (running on a Pi Zero).


## How to use

**If you think you've found a typo, or need help getting things to work, get in contact and I'll try to help!**

Each subdirectory in this repository has simple instructions.  Note that there are naming dependancies in this project, so make sure that any naming changes are apllied across the repository.

All the code is provided as is, and it is left to the user to work out the fine details for themselves. The AWS documentation is very useful here. Remember that [GIYF](http://www.giyf.com) :)

### Prerequisites

The following prerequisites are required for working with this repository.

##### AWS Credentials

1. [AWS Credentials](http://docs.aws.amazon.com/gettingstarted/latest/awsgsg-intro/gsg-aws-intro.html).
2. You'll also need to be using a AWS Region that supports Rekognition, Step Functions, Lambda, s3 and SES (for example 'us-west-2').

##### s3 Bucket

1. You'll need a [s3 bucket](https://aws.amazon.com/documentation/s3/) where your images can be uploaded for processing.
2. The bucket will need two root directories : "/upload" and "/archive" which can be changed in the global-config.json file. 
3. Directly under the "/archive" directory, create the "/alerts" and "/falsepositives" subdirectories. 
4. In the preferences for your s3 Bucket, grant 'List' permission to any authenticated AWS user.  This is a temporary workaround that prevents a 403 error when using a [URL to add attachments to Alert emails](https://github.com/markwest1972/smart-security-camera/tree/master/aws-lambda-functions/nodemailer-send-notification).

##### Recent Version of Node.js

1. You'll need [a recent node and npm verson](https://github.com/sdesalas/node-pi-zero) on your Pi Zero.
2. You'll also require a recent node and npm verson on your build machine.

## To Do List

Coming soon: 

1. Better formatting of emails.
2. UUID for tracking calls through the AWS stack.
3. Better error handling.
4. Look into creating a digest video every day.
