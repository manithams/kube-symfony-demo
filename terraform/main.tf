##################
##  Namespaces ##
#################
resource "kubernetes_namespace" "this" {

  for_each = local.namespaces

  metadata {
    labels = merge(
      local.common_tags,
      try(each.value.labels, {})
    )
    name = each.key
  }
}

locals {
  common_tags = merge(
    {
      environment = var.environment
    },
    var.default_tags
  )
  namespaces = {
    "demo" = {
      labels = {
        "app" : "true"
      }
    }
    "mysql"          = {}
    "ingress-nginx"  = {}
    "metrics-server" = {}
  }
}

# #################
# ## Helm Charts ##
# #################
# ingress-nginx

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.0"

  namespace        = kubernetes_namespace.this["ingress-nginx"].id
  create_namespace = false

  values = [
    file("${path.module}/kubernetes_components/ingress-nginx/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.this
  ]
}

# MYSQL
# If you want to re-install SQL cluster from scratch. You may need to delete the PVC manually.
resource "helm_release" "mysql" {
  name             = "mysql"
  repository       = "https://charts.bitnami.com/bitnami"
  version          = "9.23.0"
  chart            = "mysql"
  namespace        = kubernetes_namespace.this["mysql"].id
  create_namespace = false
  max_history      = 10

  values = [
    file("${path.module}/kubernetes_components/mysql/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.this
  ]
}

# metrics-server
resource "helm_release" "metrics-server" {
  name             = "metrics-server"
  repository       = "https://charts.bitnami.com/bitnami"
  version          = "6.13.1"
  chart            = "metrics-server"
  namespace        = kubernetes_namespace.this["metrics-server"].id
  create_namespace = false
  max_history      = 10

  values = [
    file("${path.module}/kubernetes_components/metrics-server/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.this
  ]
}
# metric-server will be failed to run on KinD. Execute the following to fix it.
# kubectl patch -n metrics-server deployment metrics-server --type=json -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'