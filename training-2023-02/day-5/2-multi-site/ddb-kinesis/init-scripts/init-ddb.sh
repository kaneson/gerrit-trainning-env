#!/bin/bash
echo "########### Creating profile ###########"
aws configure set aws_access_key_id default_access_key --profile=localstack
aws configure set aws_secret_access_key default_secret_key --profile=localstack
aws configure set region us-east-1 --profile=localstack

echo "########### Setting default profile ###########"
export AWS_DEFAULT_PROFILE=localstack

echo "########### Listing profile ###########"
aws configure list

echo "########### Creating table ###########"
aws --endpoint-url=http://localhost:4566 \
      dynamodb create-table \
         --table-name refsDb \
         --attribute-definitions \
           AttributeName=refPath,AttributeType=S \
        --key-schema AttributeName=refPath,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

aws --endpoint-url=http://localhost:4566 \
      dynamodb create-table \
         --table-name lockTable \
         --attribute-definitions \
           AttributeName=lockKey,AttributeType=S \
           AttributeName=lockValue,AttributeType=S \
        --key-schema  AttributeName=lockKey,KeyType=HASH \
                      AttributeName=lockValue,KeyType=RANGE \
        --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
