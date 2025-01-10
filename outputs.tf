# Output Server IP
# this does not work as desired
output "ip" {
  value = libvirt_domain.ubuntu_instance[*].network_interface.0.addresses
}

# output "as3" {
#   value = templatefile("${path.module}/as3template.json.tftpl", 
#     {
#       tenant_name                 = var.host_prefix
#       application_name            = var.host_prefix
#       console_destination_address = var.console_destination_address
#       console_destination_port    = var.console_destination_port
#       api_destination_address     = var.api_destination_address
#       api_destination_port        = var.api_destination_port
#       api_waf_policy_url          = var.api_waf_policy_url
#       addresses                   = [for i in range(var.vm_count) : format(var.node_name_pattern,var.host_prefix, i )]
#     }
#   )
# }

output password {
  value = random_string.password.result
}
output sha512_hash {
  value = htpasswd_password.hash.sha512
}