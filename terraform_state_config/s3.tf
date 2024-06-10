resource "yandex_storage_bucket" "create-bucket" {
  access_key = yandex_iam_service_account_static_access_key.key-netology-dip.access_key
  secret_key = yandex_iam_service_account_static_access_key.key-netology-dip.secret_key
  bucket = "tfstate-netology"
  
   server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-s3-tfstate.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }

  depends_on = [ yandex_kms_symmetric_key.key-s3-tfstate, yandex_iam_service_account_static_access_key.key-netology-dip ]
}