
# kubernetes_deployment.demo-nfs-deploy:
resource "kubernetes_deployment" "demo-nfs-deploy" {

    metadata {
        name             = "demo-nfs-deploy"
        namespace        = "default"
    }

    spec {
        paused                    = false
        replicas                  = 1
        revision_history_limit    = 10

        selector {
            match_labels = {
                "app" = "nginx-nfs-demo"
            }
        }

        strategy {
            type = "RollingUpdate"

            rolling_update {
                max_surge       = "25%"
                max_unavailable = "25%"
            }
        }

        template {
            metadata {
                labels      = {
                    "app" = "nginx-nfs-demo"
                }
            }

            spec {
                automount_service_account_token  = false
                dns_policy                       = "ClusterFirst"
                host_ipc                         = false
                host_network                     = false
                host_pid                         = false
                node_selector                    = {}
                restart_policy                   = "Always"
                share_process_namespace          = false
                termination_grace_period_seconds = 30

                container {
                    args                     = []
                    command                  = []
                    image                    = "nginx"
                    image_pull_policy        = "Always"
                    name                     = "nginx-nfs-demo"
                    stdin                    = false
                    stdin_once               = false
                    tty                      = false

                    port {
                        container_port = 80
                        host_port      = 0
                        protocol       = "TCP"
                    }

                    resources {
                    }

                    volume_mount {
                        mount_path = "/usr/share/nginx/"
                        name       = "nfs-pvc-storage"
                        read_only  = false
                    }
                }

                volume {
                    name = "nfs-pvc-storage"

                    persistent_volume_claim {
                        claim_name = "pv-nfs-claim"
                        read_only  = false
                    }
                }
            }
        }
    }

    timeouts {}
}

# kubernetes_persistent_volume.pv-nfs:
# kubernetes_persistent_volume_claim.pv-nfs-claim:

# kubernetes_service.demo-nfs-svc:
resource "kubernetes_service" "demo-nfs-svc" {

    metadata {
        name             = "demo-nfs-svc"
        namespace        = "default"
    }

    spec {
    #    cluster_ip                  = "10.99.42.118"
    #    external_ips                = [
    #        "172.17.172.203",
    #        "192.168.251.66",
    #    ]
        external_traffic_policy     = "Cluster"
    #    load_balancer_source_ranges = []
        publish_not_ready_addresses = false
        selector                    = {
            "app" = "nginx-nfs"
        }
        session_affinity            = "None"
     #   type                        = "LoadBalancer"
        type                        = "NodePort"

        port {
            name        = "http"
            node_port   = 30080
            port        = 80
            protocol    = "TCP"
            target_port = "80"
        }
    }
}




