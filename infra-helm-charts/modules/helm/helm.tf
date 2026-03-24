resource null_resource "kubeconfig" {
  triggers = {
    time = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
az login --service-principal --username $AZURE_CLIENT_ID --password $AZURE_SECRET --tenant $AZURE_TENANT
az aks get-credentials --name ${var.name} --resource-group ${var.rg_name} --overwrite-existing
EOF
  }
}

resource "helm_release" "external-secrets" {
  depends_on = [
    null_resource.kubeconfig
  ]
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace   = "devops"
  create_namespace = true
  set = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]
}

resource "helm_release" "argo-cd" {
  depends_on = [
    null_resource.kubeconfig
  ]
  name              = "argo-cd"
  repository        = "https://argoproj.github.io/argo-helm"
  chart             = "argo-cd"
  namespace         = "argocd"
  create_namespace  = true

  set = [
    {
      name  = "server.ingress.hostname"
      value = "argocd-${var.env}-nareshdevops1218.online"
    }
  ]

  values = [
    file("${path.module}/../../helm-values/argocd.yml")
  ]
}

resource "null_resource" "secret_store" {
  depends_on = [
    helm_release.external-secrets
  ]
  provisioner "local-exec" {
    command = <<TF
kubectl apply -f  - <<KUBE
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: "roboshop-${var.env}"
spec:
  provider:
    vault:
      server: "http://vault.nareshdevops1218.online:8200"
      path: "roboshop-${var.env}"
      version: "v2"
      auth:
        tokenSecretRef:
          name: "vault-token"
          key: "token"
          namespace: "devops"
---
apiVersion: v1
kind: Secret
metadata:
  name: vault-token
  namespace: devops
data:
  token: ${base64encode(var.token)}
KUBE
TF
  }
}

## Filebeat Helm Chart
resource "helm_release" "filebeat" {

  depends_on = [
    null_resource.kubeconfig
  ]
  name       = "filebeat"
  repository = "https://helm.elastic.co"
  chart      = "filebeat"
  namespace  = "devops"
  wait       = "false"
  create_namespace = true

  values = [
    file("${path.module}/../../helm-values/filebeat.yml")
  ]
}

# Direct Helm Chart is a Problem - https://github.com/kubernetes/ingress-nginx/issues/10863

resource "null_resource" "nginx-ingress" {
  depends_on = [null_resource.kubeconfig]
  provisioner "local-exec" {
    command = <<EOF
 kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
EOF
  }
}

