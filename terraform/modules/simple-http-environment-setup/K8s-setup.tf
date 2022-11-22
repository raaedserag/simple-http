locals {
  labels = {
    environment = var.environment
    version     = var.version_number
    app         = var.app_name
  }
  app_environment_variables = merge(
    var.app_static_environment_variables,
    {
      NODE_ENV       = var.environment
      PORT           = 80
      MYSQL_HOST     = aws_db_instance.default.address
      MYSQL_PORT     = aws_db_instance.default.port
      MYSQL_USER     = var.rds_config.db_user
      MYSQL_PASSWORD = var.rds_config.db_password
      MYSQL_DATABASE = aws_db_instance.default.db_name
    }
  )
}
resource "aws_ecr_repository" "default_repo" {
  name                 = "${var.app_name}-${var.environment}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "kubernetes_namespace" "current_namespace" {
  metadata {
    labels = local.labels
    name   = "${var.app_name}-${var.environment}"
  }
}
resource "kubernetes_secret" "environment_variables" {
  type = "Opaque"
  metadata {
    name      = "${var.app_name}-${var.environment}-environment-variables"
    namespace = kubernetes_namespace.current_namespace.metadata.0.name
    labels    = local.labels
  }

  data = { for key, value in local.app_environment_variables : key => value }

}

resource "kubernetes_replication_controller" "simple-http-deployment" {
  metadata {
    name      = "${var.app_name}-${var.environment}-deployment"
    namespace = kubernetes_namespace.current_namespace.metadata.0.name
    labels    = local.labels
  }
  spec {
    replicas          = var.app_replicas_count
    selector          = local.labels
    min_ready_seconds = 10
    template {
      metadata {
        name      = "${var.app_name}-${var.environment}-pod"
        namespace = kubernetes_namespace.current_namespace.metadata.0.name
        labels    = local.labels
      }
      spec {
        container {
          name  = "${var.app_name}-${var.environment}-api"
          image = aws_ecr_repository.default_repo.repository_url
          port {
            name           = "http"
            container_port = local.app_environment_variables.PORT
          }

          dynamic "env" {
            for_each = local.app_environment_variables
            content {
              name = env.key
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.environment_variables.metadata.0.name
                  key  = env.key
                }
              }

            }
          }


          # liveness_probe {
          #   http_get {
          #     path = "/"
          #     port = var.app_http_port

          #     http_header {
          #       name  = "X-Custom-Header"
          #       value = "Awesome"
          #     }
          #   }

          #   initial_delay_seconds = 3
          #   period_seconds        = 3
          # }
        }
      }
    }
  }
}

resource "kubernetes_service" "simple-http-service" {
  metadata {
    name      = "${var.app_name}-${var.environment}-service"
    namespace = kubernetes_namespace.current_namespace.metadata.0.name
    labels    = local.labels
  }
  spec {
    selector = local.labels
    type     = "LoadBalancer"
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }

  }
}
