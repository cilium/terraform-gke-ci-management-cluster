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

## Flux

Setup flux for management cluster:

```bash
$ cd flux

$ terraform init && terraform apply -var 'github_owner=fristonio' \
    -var 'repository_name=iso-test-operator' \
    -var 'kubeconfig_path=./../secrets/kubeconfig' \
    -var 'release_branch=flux-release'
```

## Cluster-API

> The setup for cluster api is optional and is only requrired if the operator
is required to manage cluster based on ClusterAPI provisioner.

First download clusterctl utiltiy provided by Cluster-API project and run `init` to set
up cluster-api on the management cluster.

```bash
# Download
$ curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v0.3.11/clusterctl-linux-amd64 \
    -o clusterctl && chmod +x clusterctl

$ export GCP_B64ENCODED_CREDENTIALS=$( cat secrets/service-account.management-cluster-admin.key.json | base64 | tr -d '\n' )

# Install cluster-api with the required components in the manaagement cluster.
$ ./clusterctl init --kubeconfig=secrets/kubeconfig \
    --config=cluster-api/clusterctl.yaml \
    --core cluster-api \
    --bootstrap kubeadm \
    --control-plane kubeadm
    --infrastructure aws,gcp,azure
```

## Terraform

> This setup is optional and is only required for terraform-controller based
infrastructure provisioning.
