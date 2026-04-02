# Monitoring Stack Deployment for Prometheus and Grafana using Helm

# Create namespace for monitoring tools in the GKE cluster
resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# Deploy Prometheus and Grafana into the namespace 
resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
  version    = "61.2.0"

  values = [
    file("${path.module}/values/monitoring-values.yaml")
  ]
}