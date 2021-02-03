# Management Cluster Setup

The cluster is configured using Terraform (see `cluster.tf` and `network.tf`).
On top of the management cluster [Flux](https://fluxcd.io) is deployed.

> NOTE: ensure [Cloud IAM Credentials API](https://console.cloud.google.com/apis/api/iamcredentials.googleapis.com/overview) is enabled for
the project

```bash
# Create the required service account on GCP
$ ./scripts/create-service-accounts.sh ${PROJECT_ID} ci-management-cluster-admin

# Download and setup terraform - https://www.terraform.io/downloads.html
$ terraform init 
$ terraform apply \
    -var 'project_id=${PROJECT_ID}' \
    -var 'svc_account_key=ci-management-cluster-admin' \
    -var 'cluster_name=iso-test-management-cluster'

# Get the kubeconfig for the create GKE container cluster.
$ ./scripts/get-credentials.sh
```

## Flux

Setup flux for management cluster:

```bash
$ cd flux

$ terraform init && terraform apply -var 'github_owner=fristonio' \
    -var 'repository_name=iso-test-operator' \
    -var 'kubeconfig_path=./../secrets/kubeconfig' \
    -var 'release_branch=master'
```

## Terraform

> This setup is optional and is only required for terraform-controller based
infrastructure provisioning.
