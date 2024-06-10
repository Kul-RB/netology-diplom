resource "yandex_kms_symmetric_key" "key-s3-tfstate" {
  name              = "tfstate-kms"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}