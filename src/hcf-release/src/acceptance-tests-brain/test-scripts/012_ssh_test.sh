#!/bin/bash

set -o errexit
set -o xtrace

# where do i live ?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# configuration
APP_NAME=node-env

# login
cf api --skip-ssl-validation ${CF_API}
cf auth ${CF_USERNAME} ${CF_PASSWORD}

# create org and space
cf create-org ${ORG}
cf target -o ${ORG}
cf create-space ${SPACE}
cf target -s ${SPACE}

# push an app
cd ${DIR}/../test-resources/${APP_NAME}
cf push ${APP_NAME}

# test ssh connection
cf ssh -i 0 ${APP_NAME} -c /usr/bin/env | grep CF_INSTANCE_INDEX | cut -d'=' -f 2

# cleanup
cf delete -f ${APP_NAME}
cf delete-space -f ${SPACE}
cf delete-org -f ${ORG}
