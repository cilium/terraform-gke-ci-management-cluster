# Flux

Setup flux in the management Kubernetes cluster.

```bash
$ terraform apply -var 'github_owner=fristonio' \
    -var 'repository_name=iso-test-operator' \
    -var 'kubeconfig_path=./../secrets/kubeconfig' \
    -var 'release_branch=master'
```

The output of the terraform module contains a public key that can be used as a
deploy key with the repository configured for flux.
