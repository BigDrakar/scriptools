#!/bin/bash

# Constants
sagemaker_folder=SageMaker

# Command args
req_action=$1
tar_file=$2

# TAR SageMaker folder content and upload it to S3
upload()
{
  echo "Compressing SageMaker content..."
  tar -czvf /tmp/archive.tar.gz $sagemaker_folder
  echo "Completed!"
  echo "Upload to S3.."
  aws s3 cp /tmp/archive.tar.gz "$1"
  echo "Completed!"
}

# Download archive from S3 and UNTAR it into SageMaker folder
download()
{
  echo "Download SageMaker archive..."
  aws s3 cp "$1" /tmp/archive.tar.gz
  echo "Completed!"
  echo "Decompressing SageMaker content..."
  tar -xzvf /tmp/archive.tar.gz
  echo "Completed!"
}

case $req_action in
backup)
  upload "$tar_file"
  echo "Notebook image has been CREATED successfully"
  ;;
restore)
  download "$tar_file"
  echo "Notebook image has been RESTORED successfully"
  ;;
*)
  echo "Unknown command [$req_action]. Usage backup [s3 path] or restore [s3 path]"
  ;;
esac
