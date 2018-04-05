#!/bin/bash

ECR_URI_BASE=764791742448.dkr.ecr.ap-northeast-1.amazonaws.com
TEMPORARY_IMAGE_NAME=k-masatany/rails-app

# Build
docker build -t $TEMPORARY_IMAGE_NAME .

# ECR_URI
if [ -z "$ECR_URI_BASE" ]; then
    echo "Need to set ECR_URI_BASE"
    exit 1
fi
if [ -z "$IMAGE_TAG" ]; then
    echo "Need to set IMAGE_TAG"
    exit 1
fi
ECR_URI=$ECR_URI_BASE/$TEMPORARY_IMAGE_NAME:$IMAGE_TAG

# Login
if [ -z "$AWS_DEFAULT_REGION" ]; then
    echo "Need to set AWS_DEFAULT_REGION"
    exit 1
fi
login_cmd=`aws ecr get-login --no-include-email $AWS_DEFAULT_REGION`
echo $login_cmd
eval $login_cmd

echo "Start pushing to $ECR_URI"
docker tag $TEMPORARY_IMAGE_NAME:latest $ECR_URI
docker push $ECR_URI