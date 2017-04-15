#!/bin/bash

echo starting s3-upload.sh

echo uploading file $2

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
node $SCRIPTPATH/s3-upload-file.js $1  $2

if [ $2 == "$SCRIPTPATH/test.jpg" ]; then
  echo test file wont be deleted
else
  echo deleting file $2
  sudo rm $2
fi

echo completed s3-upload.sh

