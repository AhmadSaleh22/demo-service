resource "google_secret_manager_secret" "secret" {
  secret_id = "${var.prefix}-demo-secret"
  labels = {
    used_in = "demo-service"
  }

  replication {
    auto {}
  }
}

# Securely fetch the secret from an external source
data "google_secret_manager_secret_version" "secret-latest" {
  secret  = google_secret_manager_secret.secret.id
  version = "latest"
}

resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret          = google_secret_manager_secret.secret.id
  secret_data_wo  = file(var.secret_file_path) # Securely reading from an external file
  depends_on      = [google_secret_manager_secret.secret]
}
