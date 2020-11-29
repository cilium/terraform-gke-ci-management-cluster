data "flux_install" "main" {
  target_path    = var.flux_targetpath
  namespace      = var.flux_namespace
  arch           = "amd64"
  network_policy = false
  version        = "0.4.1"
  components     = [
    "helm-controller",
    "notification-controller",
    "source-controller",
    "kustomize-controller",
  ]
}

resource "tls_private_key" "flux" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "flux_sync" "main" {
  branch      = var.release_branch
  target_path = var.flux_targetpath
  url         = "ssh://git@github.com/${var.github_owner}/${var.repository_name}.git"
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = var.flux_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

data "kubectl_file_documents" "flux_install" {
  content = data.flux_install.main.content
}

data "kubectl_file_documents" "flux_sync" {
  content = data.flux_sync.main.content
}

resource "kubectl_manifest" "flux_install" {
  for_each  = { for v in data.kubectl_file_documents.flux_install.documents : sha1(v) => v }
  depends_on = [kubernetes_namespace.flux_system]

  yaml_body = each.value
}

resource "kubectl_manifest" "flux_sync" {
	for_each  = { for v in data.kubectl_file_documents.flux_sync.documents : sha1(v) => v }
	depends_on = [kubectl_manifest.flux_install, kubernetes_namespace.flux_system]

	yaml_body = each.value
}

locals {
  known_hosts = "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
}

resource "kubernetes_secret" "flux" {
  depends_on = [
    kubectl_manifest.flux_install,
    tls_private_key.flux
  ]

  metadata {
    name      = data.flux_sync.main.name
    namespace = data.flux_sync.main.namespace
  }

  data = {
    identity       = tls_private_key.flux.private_key_pem
    "identity.pub" = tls_private_key.flux.public_key_pem
    known_hosts    = local.known_hosts
  }
}

resource "local_file" "flux_install" {
  content     = data.flux_install.main.content
  filename = "${path.module}/../../${data.flux_install.main.path}"
}

resource "local_file" "flux_sync" {
  content     = data.flux_sync.main.content
  filename = "${path.module}/../../${data.flux_sync.main.path}"
}

resource "local_file" "flux_pub_key" {
  content     = tls_private_key.flux.public_key_openssh
  filename = "${path.module}/../../${var.flux_targetpath}/${var.flux_namespace}/flux_id_rsa.pub"
}
