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
  tar -czvf $sagemaker_folder/sgm_fld_bkp.tar.gz $sagemaker_folder
  echo "Completed!"
  echo "Upload to S3.."
  aws s3 cp $sagemaker_folder/sgm_fld_bkp.tar.gz "$1"
  rm -fr $sagemaker_folder/sgm_fld_bkp.tar.gz
  echo "Completed!"
}

# Download archive from S3 and UNTAR it into SageMaker folder
download()
{
  echo "Download SageMaker archive..."
  aws s3 cp "$1" $sagemaker_folder/sgm_fld_bkp.tar.gz
  echo "Completed!"
  echo "Decompressing SageMaker content..."
  tar -xzvf $sagemaker_folder/sgm_fld_bkp.tar.gz
  rm -fr $sagemaker_folder/sgm_fld_bkp.tar.gz
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
