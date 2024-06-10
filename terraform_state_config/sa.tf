resource "yandex_iam_service_account" "netology-dip" {
    name = "netology-dip"
}

resource "yandex_resourcemanager_folder_iam_member" "role-storage-netology-dip" {
    depends_on = [ yandex_iam_service_account.netology-dip ]
    folder_id  = var.folder_id
    role       = "storage.editor"
    member     =  "serviceAccount:${yandex_iam_service_account.netology-dip.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "role-compute-netology-dip" {
    depends_on = [ yandex_iam_service_account.netology-dip ]
    folder_id  = var.folder_id
    role       = "compute.admin"
    member     =  "serviceAccount:${yandex_iam_service_account.netology-dip.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "role-kms-netology-dip" {
    depends_on = [ yandex_iam_service_account.netology-dip ]
    folder_id  = var.folder_id
    role       = "kms.editor"
    member     =  "serviceAccount:${yandex_iam_service_account.netology-dip.id}"
}


resource "yandex_resourcemanager_folder_iam_member" "role-resource-manage-dip" {
    depends_on = [ yandex_iam_service_account.netology-dip ]
    folder_id  = var.folder_id
    role       = "resource-manager.editor"
    member     =  "serviceAccount:${yandex_iam_service_account.netology-dip.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "role-vpc-netology-dip" {
    depends_on = [ yandex_iam_service_account.netology-dip ]
    folder_id  = var.folder_id
    role       = "vpc.admin"
    member     =  "serviceAccount:${yandex_iam_service_account.netology-dip.id}"
}

resource "yandex_iam_service_account_static_access_key" "key-netology-dip" {
    depends_on         = [ yandex_resourcemanager_folder_iam_member.role-storage-netology-dip,
    yandex_resourcemanager_folder_iam_member.role-compute-netology-dip,
    yandex_resourcemanager_folder_iam_member.role-container-netology-dip,
    yandex_resourcemanager_folder_iam_member.role-gitlab-netology-dip,
    yandex_resourcemanager_folder_iam_member.role-kms-netology-dip ]
    service_account_id = yandex_iam_service_account.netology-dip.id  
}

resource "local_file" "key-s3-access" {
    depends_on = [ yandex_iam_service_account_static_access_key.key-netology-dip ]
    content    = yandex_iam_service_account_static_access_key.key-netology-dip.access_key
    filename   = "/home/cfdata/key/.access_key"  
}

resource "local_file" "key-s3-secret" {
  depends_on = [ yandex_iam_service_account_static_access_key.key-netology-dip ]
  content    = yandex_iam_service_account_static_access_key.key-netology-dip.secret_key
  filename   = "/home/cfdata/key/.secret_key"
}


