module "argocd_dev" {
  source           = "./terraform_argocd_eks"
  eks_cluster_name = "demo"
  chart_version    = "7.8.1"
}



# Can be deployed ONLY after ArgoCD deployment: depends_on = [module.argocd_dev]
#module "argocd_dev_root" {
#  source             = "./terraform_argocd_root_eks"
#  eks_cluster_name   = "demo-cluster"
# git_source_path    = "demo-dev/applications"
#  git_source_repoURL = "git@github.com:VanDirBan/argocd.git"
#}
