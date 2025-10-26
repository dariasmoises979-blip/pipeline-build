resource "helm_release" "argocd" {
  name       = "argo-cd-1761469427"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
