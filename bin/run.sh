#!/usr/bin/env bash
[[ -z "${DEBUG}" ]] || set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/util.sh || exit 1
source ${DIR}/env.sh || exit 1

info "---"
info "Kube Environment: ${DRONE_DEPLOY_TO}"
info "Kube API URL: ${KUBE_SERVER}"
info "Kube Namespace: ${KUBE_NAMESPACE}"
info "App Release Version: ${APP_VERSION}"
info "---"

case ${ACTION} in
  'deploy')
    info "Deploying the ACP Example App"
    kd --timeout 10m0s \
      -f kube/service-app-tls.yaml \
      -f kube/service-app.yaml \
      -f kube/deployment-app.yaml \
      -f kube/ingress-app-external.yaml \
      -f kube/ingress-app-internal.yaml \
      -f kube/networkpolicy-app.yaml ;;

  'destroy')
    warning "Destroying resources related to the ACP Example App (excluding secrets, ingress)"
    kd run delete service ${DEPLOYMENT_NAME} --ignore-not-found
    kd run delete deployment ${DEPLOYMENT_NAME} --ignore-not-found
    kd run delete networkpolicy ${DEPLOYMENT_NAME} --ignore-not-found ;;

  *)
    failed "Action '${ACTION}' is invalid, make sure 'ACTION' is set correctly ('deploy' or 'destroy')." ;;
esac
