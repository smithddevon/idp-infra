# ArgoCD Deployment using Helm

# Create ArgoCD namespace in GKE cluster
resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Deploy ArgoCD into the namespace 
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  version    = "7.3.0"

  values = [
    file("${path.module}/values/argocd-values.yaml")
  ]
}