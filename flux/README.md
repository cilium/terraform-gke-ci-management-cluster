# Flux

Setup flux in the management Kubernetes cluster.

```bash
$ terraform apply -var 'github_owner=fristonio' \
    -var 'repository_name=iso-test-operator' \
    -var 'kubeconfig_path=./../secrets/kubeconfig' \
    -var 'release_branch=flux-release'
```
