exports.handler = (event, context, callback) => {

  var aws = require('aws-sdk');
  var nodemailer = require('nodemailer');
  var sesTransport = require('nodemailer-ses-transport');
  var ses = new aws.SES({apiVersion: '2010-12-01'});
  var s3 = new aws.S3();

  // Set up ses as tranport for email
  var transport = nodemailer.createTransport(sesTransport({
      ses: ses
  }));

  // Pickup parameters from calling event
  var filename = event.key;
  var labels = event.Labels;

  // Add timestamp to file name
  var localFile = filename.replace(process.env.bucketuploadpath+'/', '');

  // Set up email parameters
  var mailOptions = mailOptions = {
      from: '"Smart Security Camera" <'+process.env.useremailaddress+'>',
      to: process.env.useremailaddress,
      subject: '⏰ Alarm Event detected! ⏰',
      text: JSON.stringify(labels),
      html: '<pre>'+JSON.stringify(labels, null, 2)+'</pre>',
      attachments: [

        {
            filename: localFile,
            path: 'https://s3-'+ process.env.bucketregion +'.amazonaws.com/'+ process.env.bucketname + '/'+ filename
        }
      ]
  }

  transport.sendMail(mailOptions, function(error, info){
      if(error){
        var errorMessage =  'Error in [nodemailer-send-notification].\r' +
                              '   Function input ['+JSON.stringify(event, null, 2)+'].\r' +
                              '   Error ['+error + '].';
        console.log(errorMessage);
        callback(errorMessage, null);
      }else{
        console.log('Message sent: ' + info.response);
        callback(null, event);
      }
  });
};
