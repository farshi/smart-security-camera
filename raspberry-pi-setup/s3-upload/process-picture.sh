#!/bin/bash

echo starting s3-upload.sh

echo uploading file $1

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
node $SCRIPTPATH/s3-upload-file.js $1

if [ $1 == "$SCRIPTPATH/test.jpg" ]; then
  echo test file wont be deleted
else
  echo deleting file $1
  sudo rm $1
fi

echo completed s3-upload.sh

