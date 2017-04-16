//
// Uploads pictures to s3, where they will trigger a Lambda process.
//
// This module requires two command-line arguments:
// 1. Destination bucket
// 2. File to upload
//
// Example : "node s3-upload-image-file.js <s3-bucket> <path-to-image>"
//
// Requires config.json file with AWS authorisation and locale parameters.
//

// Load the SDK for JavaScript
var AWS = require('aws-sdk');
var path = require('path');
var fs = require('fs');

//Load the global configuration file
var globalConfig = require(__dirname + "/globalconfig.json");

// Load configration file
AWS.config.loadFromPath(__dirname + '/config.json');

// Create S3 service object
s3 = new AWS.S3({apiVersion: '2006-03-01'});

console.log("Listing all files in bucket: " + globalConfig);

// call S3 to list all files in the bucket
s3.listObjects ({Bucket:globalConfig}, function (err, data) {
  if (err) {
    console.log('List Error', err);
  } if (data) {
    console.log(data);
  }
});

