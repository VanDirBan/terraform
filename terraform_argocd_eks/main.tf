# Получаем данные о существующем EKS-кластере
data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

# Настраиваем провайдер Kubernetes для связи с EKS
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  token                  = data.aws_eks_cluster_auth.this.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    token                  = data.aws_eks_cluster_auth.this.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  }
}

# Создаём namespace для ArgoCD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Устанавливаем ArgoCD через Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm" # Официальный Helm-репозиторий
  chart      = "argo-cd" # Указываем только имя чарта
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = var.chart_version

  depends_on = [kubernetes_namespace.argocd] # Убеждаемся, что namespace создан
}
