variable console_destination_address {
  type = string
  description = "ip address that the BIG-IP will listen for the MinIO console"
}

variable console_destination_port {
  type = string
  description = "port that the BIG-IP will listen for the MinIO console"
}

variable api_destination_address {
  type = string
  description = "ip address that the BIG-IP will listen for the MinIO API endpoint"
}

variable api_destination_port {
  type = string
  description = "ip address that the BIG-IP will listen for the MinIO API endpoint"
}

variable bridge_name {
  type = string
}
variable data_disk_size {
  description = "size of the minio data disk in GiB"
  default     = 1
}
variable ubuntu_base_id {
    type = string
}
variable username {
  type = string
}
variable host_prefix {
  type = string
}
variable vm_count {
  type = number
  default = 1
}
variable public_key_file_path {
  type = string
}
variable phone_home_url {
  type    = string
  default = ""
}
variable node_name_pattern {
  type = string
  description = "the format pattern string used to name the nodes. There is a string value populated with host_prefix and a digit populated with the vm count index."
}
variable minio_api_access_key {
  type = string
}
variable minio_api_secret_key {
  type = string
}
variable api_waf_policy_url {
  type = string
}