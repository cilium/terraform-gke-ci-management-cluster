#!/bin/bash -x

set -o errexit
set -o pipefail
set -o nounset

SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")

CLUSTER_NAME=$(terraform output cluster_name)
CLUSTER_ZONE=$(terraform output cluster_zone)

export KUBECONFIG="${SCRIPTS_DIR}/../secrets/kubeconfig"

function print_help() {
  echo 'Not enough arguments'
  echo 'Use as: get-credentials.sh <project-id>'
  exit 1
}

if [ $# -le 0 ]; then
  print_help
fi

gcloud container clusters get-credentials \
  --project "${1}" \
  --zone="${CLUSTER_ZONE}" \
  "${CLUSTER_NAME}"
