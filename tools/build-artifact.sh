#!/bin/bash
#
# Creates an build artifact archive
#
# Usage:
# bash build-artifact.sh -i arn:aws:cognito-idp:us-east-1:111111111111:userpool/user_pool_id -t test-v1
#
usage() {
cat << EOF
  usage: bash $0 -i arn:aws:cognito-idp:us-east-1:111111111111:userpool/user_pool_id -t test-v1
  OPTIONS:
    -i arn of the aws incognito pool
    -t tag name
EOF
exit 1;
}

while getopts "t:i:" OPTION; do
  case ${OPTION} in
    t) TAG=${OPTARG};;
    i) ARN_INCOGNITO_POOL=${OPTARG};;
  esac
done

set -e

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
cd ${SCRIPTPATH}/../

if [ -z "${TAG}" ]; then
  echo "-t param missing"
  usage
fi

if [ -z "${ARN_INCOGNITO_POOL}" ]; then
  echo "-i param missing"
  usage
fi

ARN_INCOGNITO_POOL_REPLACEMENT=$(echo ${ARN_INCOGNITO_POOL} | sed -e 's/\//\\\//g')

RELEASE_FILENAME=${TAG}-pingpongfy-apigateway.yml
cp swagger.yml ${RELEASE_FILENAME}

sed -i "s/%aws-arn-incognito-pool%/${ARN_INCOGNITO_POOL_REPLACEMENT}/" ${RELEASE_FILENAME}
sed -i "s/%version%/${TAG}/" ${RELEASE_FILENAME}
