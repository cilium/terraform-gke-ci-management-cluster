#!/bin/bash -x

set -o errexit
set -o pipefail
set -o nounset

SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")

function create_service_account() {
  service_account_name="${2}"
  project="${1}"
  key_path="${SCRIPTS_DIR}/../secrets/service-account.${service_account_name}.key.json"

  iam_account="${service_account_name}@${project}.iam.gserviceaccount.com"

  gcloud iam service-accounts create \
    --project "${project}" \
    "${service_account_name}"

  gcloud projects add-iam-policy-binding \
    --member "serviceAccount:${iam_account}" \
    --role roles/owner \
    "${project}"

  gcloud iam service-accounts keys create \
    --project "${project}" \
    --iam-account "${iam_account}" \
    "${key_path}"

  echo "Generated service account key at - ${key_path}"
}

function print_help() {
  echo 'Not enough arguments'
  echo 'Use as: create-service-accounts.sh <project-id> <secret-name-1> <secret-name-2>'
  exit 1
}

if [ $# -le 1 ]; then
  print_help
fi

PROJECT_NAME=$1
shift 1

for secret_name in "$@"
do
  create_service_account "${PROJECT_NAME}" "${secret_name}"
done
