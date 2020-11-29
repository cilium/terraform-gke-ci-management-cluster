# Management Cluster Setup

The cluster is configured using Terraform (see `cluster.tf` and `network.tf`).
On top of the management cluster [Flux](https://fluxcd.io) is deployed.

> NOTE: ensure [Cloud IAM Credentials API](https://console.cloud.google.com/apis/api/iamcredentials.googleapis.com/overview) is enabled for
the project

```bash
# Create the required service account on GCP
$ ./scripts/create-service-accounts.sh <project-id> management-cluster-admin

# Download and setup terraform - https://www.terraform.io/downloads.html
$ terraform init && terraform apply \
    -var 'project_id=<project-id>'
    -var 'svc_account_key=management-cluster-admin'

# Get the kubeconfig for the create GKE container cluster.
$ ./scripts/get-credentials.sh
```

Setup flux for management cluster:

```bash
$ cd flux

$ terraform init && terraform apply -var 'github_owner=fristonio' \
    -var 'repository_name=iso-test-operator' \
    -var 'kubeconfig_path=./../secrets/kubeconfig' \
    -var 'release_branch=flux-release'
```
