provider "kubernetes" {}

resource "kubernetes_persistent_volume" "pv-nfs" {}

resource "kubernetes_persistent_volume_claim" "pv-nfs-claim" {}

resource "kubernetes_deployment" "nginx-nfs-deploy" {}

resource "kubernetes_service" "nginx-nfs-svc" {}

