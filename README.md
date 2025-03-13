## Deploy open source MinIO on KVM using Terraform
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_htpasswd"></a> [htpasswd](#requirement\_htpasswd) | 1.2.1 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | 0.8.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_htpasswd"></a> [htpasswd](#provider\_htpasswd) | 1.2.1 |
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | 0.8.1 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [htpasswd_password.hash](https://registry.terraform.io/providers/loafoe/htpasswd/1.2.1/docs/resources/password) | resource |
| [libvirt_cloudinit_disk.simple_cloud_init](https://registry.terraform.io/providers/dmacvicar/libvirt/0.8.1/docs/resources/cloudinit_disk) | resource |
| [libvirt_domain.ubuntu_instance](https://registry.terraform.io/providers/dmacvicar/libvirt/0.8.1/docs/resources/domain) | resource |
| [libvirt_volume.data](https://registry.terraform.io/providers/dmacvicar/libvirt/0.8.1/docs/resources/volume) | resource |
| [libvirt_volume.ubuntu_instance](https://registry.terraform.io/providers/dmacvicar/libvirt/0.8.1/docs/resources/volume) | resource |
| [local_file.as3](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.as3-tls](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.warp](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_pet.username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [random_string.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_destination_address"></a> [api\_destination\_address](#input\_api\_destination\_address) | ip address that the BIG-IP will listen for the MinIO API endpoint | `string` | n/a | yes |
| <a name="input_api_destination_port"></a> [api\_destination\_port](#input\_api\_destination\_port) | ip address that the BIG-IP will listen for the MinIO API endpoint | `string` | n/a | yes |
| <a name="input_api_waf_policy_url"></a> [api\_waf\_policy\_url](#input\_api\_waf\_policy\_url) | n/a | `string` | n/a | yes |
| <a name="input_bridge_name"></a> [bridge\_name](#input\_bridge\_name) | n/a | `string` | n/a | yes |
| <a name="input_console_destination_address"></a> [console\_destination\_address](#input\_console\_destination\_address) | ip address that the BIG-IP will listen for the MinIO console | `string` | n/a | yes |
| <a name="input_console_destination_port"></a> [console\_destination\_port](#input\_console\_destination\_port) | port that the BIG-IP will listen for the MinIO console | `string` | n/a | yes |
| <a name="input_data_disk_size"></a> [data\_disk\_size](#input\_data\_disk\_size) | size of the minio data disk in GiB | `number` | `1` | no |
| <a name="input_host_prefix"></a> [host\_prefix](#input\_host\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_minio_api_access_key"></a> [minio\_api\_access\_key](#input\_minio\_api\_access\_key) | n/a | `string` | n/a | yes |
| <a name="input_minio_api_secret_key"></a> [minio\_api\_secret\_key](#input\_minio\_api\_secret\_key) | n/a | `string` | n/a | yes |
| <a name="input_node_name_pattern"></a> [node\_name\_pattern](#input\_node\_name\_pattern) | the format pattern string used to name the nodes. There is a string value populated with host\_prefix and a digit populated with the vm count index. | `string` | n/a | yes |
| <a name="input_phone_home_url"></a> [phone\_home\_url](#input\_phone\_home\_url) | n/a | `string` | `""` | no |
| <a name="input_public_key_file_path"></a> [public\_key\_file\_path](#input\_public\_key\_file\_path) | n/a | `string` | n/a | yes |
| <a name="input_ubuntu_base_id"></a> [ubuntu\_base\_id](#input\_ubuntu\_base\_id) | n/a | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | n/a | `string` | n/a | yes |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | n/a | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip"></a> [ip](#output\_ip) | Output Server IP this does not work as desired |
| <a name="output_password"></a> [password](#output\_password) | n/a |
<!-- END_TF_DOCS -->