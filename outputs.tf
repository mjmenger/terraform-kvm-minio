# Output Server IP
# this does not work as desired
output "ip" {
  value = libvirt_domain.ubuntu_instance[*].network_interface.0.addresses
}

output password {
  value = random_string.password.result
}
