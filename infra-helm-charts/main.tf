module "helm" {
  source    = "./modules/helm"
  env       = var.env
  rg_name   = var.rg_name
  token     = var.token
  name      = var.name
}