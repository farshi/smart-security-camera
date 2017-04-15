exports.handler = (event, context, callback) => {
    
    //
    // Evaluates labels from Rekognition and decides whether or not an emergency situation has been detected.
    //
    
    try {
    
        var labels = event.Labels;
        var key = 'Name';
      
        // List should be extended with all "trigger" labels from Rekognition
        for (key in labels) {
          if (labels.hasOwnProperty(key)) {
              var triggers = [
                  'Human',
                  'People',
                  'Person',
                  'Male',
                  'Female',
                  'Apparel',
                  'Clothing',
                  'Selfie',
                  'Costume',
                  'Portrait'
              ];

              for(var i=0; i<triggers.length; i++) {
                  if (labels[key].Name.indexOf(triggers[i]) > -1) {
                    callback(null, Object.assign({"Alert": "true"}, event));
                    break;
                  }
              }
          }
        }
    
    }catch(err){
        
        // Log errors
        var errorMessage =  'Error in [evaluate-rekognition-labels].\r' + 
                                '   Function input ['+JSON.stringify(event, null, 2)+'].\r' +  
                                '   Error ['+err+'].';
        log.console(errorMessage);
        callback(errorMessage, null); // Convert to error string
    }
        
    // If we get this far then no 'alert' label was found        
    callback(null, Object.assign({"Alert": "false"}, event));
};
