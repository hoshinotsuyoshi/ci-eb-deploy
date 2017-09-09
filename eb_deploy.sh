#!/bin/bash
set -e

#################################################################
# Environment Variables
#################################################################

: ${GIT_BRANCH:=$CIRCLE_BRANCH}

if [ ! -n "$GIT_BRANCH" ]
then
    echo "Missing GIT_BRANCH. Please set GIT_BRANCH or CIRCLE_BRANCH."
    exit 1
fi

if [ ! -n "$ELASTIC_BEANSTALK_DEPLOY_APP_NAME" ]
then
    echo "Missing ELASTIC_BEANSTALK_APP_NAME."
    exit 1
fi

if [ ! -n "$ELASTIC_BEANSTALK_DEPLOY_ENV_NAME" ]
then
    echo "Missing ELASTIC_BEANSTALK_ENV_NAME."
    exit 1
fi

if [ ! -n "$ELASTIC_BEANSTALK_DEPLOY_REGION" ]
then
    echo "Missing ELASTIC_BEANSTALK_REGION."
    exit 1
fi

if [ ! -n "$ELASTIC_BEANSTALK_DEPLOY_PLATFORM" ]
then
    echo "Missing ELASTIC_BEANSTALK_DEPLOY_PLATFORM."
    exit 1
fi

: ${ELASTIC_BEANSTALK_DEPLOY_TIMEOUT:=25}

#################################################################
# Executing eb commands
#################################################################

set -x

eb --version

mkdir -p "./.elasticbeanstalk/"

cat <<EOF >> "./.elasticbeanstalk/config.yml"
branch-defaults:
  default:
    environment: $ELASTIC_BEANSTALK_DEPLOY_ENV_NAME
  $GIT_BRANCH:
    environment: $ELASTIC_BEANSTALK_DEPLOY_ENV_NAME
global:
  application_name: $ELASTIC_BEANSTALK_DEPLOY_APP_NAME
  default_platform: $ELASTIC_BEANSTALK_DEPLOY_PLATFORM
  default_region: $ELASTIC_BEANSTALK_DEPLOY_REGION
  profile: null
  sc: git
EOF

cat "./.elasticbeanstalk/config.yml"

eb use $ELASTIC_BEANSTALK_DEPLOY_ENV_NAME

eb status

if [ -n "$DRY_RUN" ]
then
    set +x
    echo 'skip "eb deploy" due to DRY_RUN'
else
    eb deploy --timeout $ELASTIC_BEANSTALK_DEPLOY_TIMEOUT
    set +x
    echo 'Successfully pushed to Amazon Elastic Beanstalk'
fi
