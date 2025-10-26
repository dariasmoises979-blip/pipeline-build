#######################################
# FIREWALL: permite HTTP, HTTPS, SSH
#######################################
resource "google_compute_firewall" "allow_http_ssh" {
  name    = "allow-http-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

#######################################
# HEALTH CHECK para el LB
#######################################
resource "google_compute_health_check" "http_hc" {
  name                = "http-hc"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port         = var.service_port
    request_path = "/"
  }
}

#######################################
# SERVICE ACCOUNT para VM
#######################################
resource "google_service_account" "vm_sa" {
  account_id   = "app-vm-sa"
  display_name = "VM Service Account for app"
}

#######################################
# Dar acceso al secreto de GitHub
#######################################
resource "google_secret_manager_secret_iam_member" "vm_access_github_secret" {
  secret_id = "projects/498555364077/secrets/github" # tu secreto existente
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.vm_sa.email}"
}

#######################################
# INSTANCE TEMPLATE con startup-script que lee el secreto
#######################################
data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

resource "google_compute_instance_template" "app_template" {
  name_prefix  = "app-tpl-"
  machine_type = var.machine_type
  tags         = ["http-server"]

  disk {
    boot         = true
    auto_delete  = true
    source_image = data.google_compute_image.debian.self_link
    disk_size_gb = 20
  }

  network_interface {
    network = "default"
    access_config {}
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata_startup_script = <<-EOT
#!/bin/bash
set -e

SECRET_NAME="github"
PROJECT_ID="${var.project}"
GIT_REPO_URL="git@github.com:dariasmoises979-blip/app.git"
APP_DIR="/opt/app_repo"
USER_HOME="/home/appuser"

# ----------------------------
# Instalar dependencias básicas
# ----------------------------
apt-get update -y
apt-get install -y git curl ca-certificates apt-transport-https gnupg make sudo lsb-release

# ----------------------------
# Instalar Docker
# ----------------------------
if ! command -v docker >/dev/null 2>&1; then
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
  apt-get update -y
  apt-get install -y docker-ce docker-ce-cli containerd.io
fi

# ----------------------------
# Instalar Docker Compose (v2 plugin)
# ----------------------------
if ! docker compose version >/dev/null 2>&1; then
  apt-get install -y docker-compose-plugin
fi

# ----------------------------
# Crear usuario appuser si no existe
# ----------------------------
id -u appuser &>/dev/null || useradd -m -s /bin/bash appuser

# ----------------------------
# Configurar SSH para GitHub
# ----------------------------
mkdir -p $${USER_HOME}/.ssh
gcloud secrets versions access latest --secret=$${SECRET_NAME} --project=$${PROJECT_ID} > $${USER_HOME}/.ssh/id_rsa
chmod 600 $${USER_HOME}/.ssh/id_rsa
chown -R appuser:appuser $${USER_HOME}/.ssh

ssh-keyscan github.com >> $${USER_HOME}/.ssh/known_hosts
chown appuser:appuser $${USER_HOME}/.ssh/known_hosts

# ----------------------------
# Clonar repositorio
# ----------------------------
rm -rf $${APP_DIR}
sudo -u appuser git clone $${GIT_REPO_URL} $${APP_DIR}
chown -R appuser:appuser $${APP_DIR}

# ----------------------------
# Ejecutar Makefile si existe
# ----------------------------
if [ -f "$${APP_DIR}/Makefile" ]; then
  cd $${APP_DIR}
  sudo -u appuser bash -lc "nohup make build >/var/log/make_up.log 2>&1 &"
  sudo -u appuser bash -lc "nohup make up >/var/log/make_up.log 2>&1 &"
fi

echo "Startup script completed" > /var/log/startup-script.log
EOT


#######################################
# INSTANCE GROUP
#######################################
resource "google_compute_region_instance_group_manager" "igm" {
  name   = "app-igm"
  region = var.region
  version {
    instance_template = google_compute_instance_template.app_template.self_link
    name              = "v1"
  }
  target_size        = var.instance_count
  base_instance_name = "app-instance"

  auto_healing_policies {
    health_check      = google_compute_health_check.http_hc.self_link
    initial_delay_sec = 60
  }
}

#######################################
# BACKEND SERVICE y LOAD BALANCER
#######################################
resource "google_compute_backend_service" "default" {
  name                  = "app-backend-service"
  protocol              = "HTTP"
  timeout_sec           = 30
  health_checks         = [google_compute_health_check.http_hc.self_link]
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_region_instance_group_manager.igm.instance_group
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "app-url-map"
  default_service = google_compute_backend_service.default.self_link
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "app-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_address" "lb_ip" {
  name = "app-lb-ip"
}

resource "google_compute_global_forwarding_rule" "http_forward" {
  name        = "app-http-forward"
  ip_address  = google_compute_global_address.lb_ip.address
  ip_protocol = "TCP"
  port_range  = "80"
  target      = google_compute_target_http_proxy.http_proxy.self_link
}
