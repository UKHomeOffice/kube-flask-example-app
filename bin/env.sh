#!/usr/bin/env bash
[[ -z "${DEBUG}" ]] || set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/util.sh || exit 1

export ACTION=${ACTION:-"deploy"}
export APP_IMAGE="340268328991.dkr.ecr.eu-west-2.amazonaws.com/acp/flask-example-app"
export APP_VERSION="v2.0"
export DEPLOYMENT_NAME="flask-example-app"
export KUBE_CERTIFICATE_AUTHORITY="https://raw.githubusercontent.com/UKHomeOffice/acp-ca/master/${DRONE_DEPLOY_TO}.crt"
export KUBE_NAMESPACE="acp-example"
export NGINX_IMAGE="quay.io/ukhomeofficedigital/nginx-proxy"
export NGINX_VERSION="v3.4.20"
export KEYCLOAK_IMAGE="quay.io/keycloak/keycloak-gatekeeper"
export KEYCLOAK_VERSION="10.0.0"
export KEYCLOAK_REALM="hod-test"
export KEYCLOAK_URL="https://sso-dev.notprod.homeoffice.gov.uk/auth/realms/${KEYCLOAK_REALM}"
case ${DRONE_DEPLOY_TO} in
  'acp-notprod')
    export APP_HOST_EXTERNAL="flask-app.acp-example-notprod.homeoffice.gov.uk"
    export APP_HOST_INTERNAL="flask-app.internal.acp-example-notprod.homeoffice.gov.uk"
    export KUBE_SERVER="https://kube-api-notprod.notprod.acp.homeoffice.gov.uk"
    export KUBE_TOKEN=${KUBE_TOKEN_ACP_NOTPROD}
    export ENABLE_KEYCLOAK="false"
    export REPLICAS=2 ;;

  'acp-prod')
    export APP_HOST_EXTERNAL="flask-app.acp-example.homeoffice.gov.uk"
    export APP_HOST_INTERNAL="flask-app.internal.acp-example.homeoffice.gov.uk"
    export KUBE_SERVER="https://kube-api-prod.prod.acp.homeoffice.gov.uk"
    export KUBE_TOKEN=${KUBE_TOKEN_ACP_PROD}
    export ENABLE_KEYCLOAK="false"
    export REPLICAS=2 ;;

  'acp-test')
    export APP_HOST_EXTERNAL="flask-app.acp-example-testing.homeoffice.gov.uk"
    export APP_HOST_INTERNAL="flask-app.internal.acp-example-testing.homeoffice.gov.uk"
    export KUBE_SERVER="https://kube-api-test.testing.acp.homeoffice.gov.uk"
    export KUBE_TOKEN=${KUBE_TOKEN_ACP_TEST}
    export ENABLE_KEYCLOAK="true"
    export REPLICAS=2 ;;

  *)
    failed "Environment '${DRONE_DEPLOY_TO}' is invalid, make sure 'DRONE_DEPLOY_TO' is set correctly." ;;
esac
