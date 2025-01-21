terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.1"
    }
    htpasswd = {
      source = "loafoe/htpasswd"
      version = "1.2.1"
    }    
  }
}
resource random_pet username {
  length = 1
}

resource random_string password {
  length = 15
}
resource htpasswd_password hash {
  password = random_string.password.result
}


# 
# export LIBVIRT_DEFAULT_URI="qemu+ssh://root@192.168.1.100/system"
# the user must be a member of the libvirt group on the kvm server
# and the security_driver must be adjusted as per 
# https://github.com/dmacvicar/terraform-provider-libvirt/issues/546#issuecomment-612983090
# 
provider "libvirt" {
  # Configuration options
}

resource "libvirt_cloudinit_disk" "simple_cloud_init" {
  count = var.vm_count
  name      = format("%s_cloud_init%02d",var.host_prefix,count.index)
  user_data = <<EOF
#cloud-config
hostname: ${format(var.node_name_pattern,var.host_prefix, count.index)}
fqdn: ${format(var.node_name_pattern,var.host_prefix, count.index)}
phone_home:
    url: ${var.phone_home_url}
    post: all
packages:
  - ca-certificates
  - curl
  - gnupg
  - apt-utils
  - autoconf
  - automake
  - build-essential
  - git
  - unzip
  - libcurl4-openssl-dev
  - libgeoip-dev
  - liblmdb-dev 
  - libpcre++-dev 
  - libtool 
  - libxml2-dev 
  - libyajl-dev 
  - pkgconf 
  - wget 
  - zlib1g-dev 
  - gnupg 
  - software-properties-common
growpart:
  mode: auto
  devices: ["/"]
  ignore_growroot_disabled: false
disk_setup:
  /dev/vdb:
    table_type: gpt
    layout: True
    overwrite: False
fs_setup:
  - label: DATA_XFS
    filesystem: xfs
    device: '/dev/vdb'
    partition: auto
mounts:
  - [ LABEL=DATA_XFS, /data, xfs ]
groups:
  - 'minio-user'
users:
  - name: ${var.username}
    passwd: ${htpasswd_password.hash.sha512}
    lock_passwd: false
    ssh-authorized-keys:
      - ${jsonencode(trimspace(file(var.public_key_file_path)))}
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    ssh_import_id:
      - gh:${var.username}
  - name: ${random_pet.username.id}
    lock_passwd: true
  - name: 'minio-user'
    lock_passwd: true
write_files:
  - path: /etc/default/minio
    content: |
      MINIO_VOLUMES="http://${var.host_prefix}0{0...${var.vm_count - 1}}:9000/data/{0...${var.vm_count - 1}}"
      MINIO_OPTS="--certs-dir /home/${random_pet.username.id}/.minio/certs --console-address :9001"
      MINIO_ROOT_USER=minioadmin
      MINIO_ROOT_PASSWORD=${random_string.password.result}
  - path: /var/tmp/miniodir.sh
    content: |
      #!/bin/bash
      mkdir /data/{0..${var.vm_count - 1}}
      chown minio-user:minio-user /data/{0..${var.vm_count - 1}}
    permissions: '0777'
runcmd:
  - sed -i 's/gethostname()/\"${format("%s%02d",var.host_prefix,count.index)}\"/' /etc/dhcp/dhclient.conf
  - hostnamectl set-hostname ${format("%s%02d",var.host_prefix,count.index)}
  - curl -LO https://github.com/getsops/sops/releases/download/v3.8.1/sops-v3.8.1.linux.amd64
  - mv sops-v3.8.1.linux.amd64 /usr/local/bin/sops
  - chmod +x /usr/local/bin/sops
  - apt-get update
  - wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio_20241218131544.0.0_amd64.deb -O minio.deb
  - dpkg -i minio.deb  
  - useradd -M -r -g minio-user minio-user
  - /var/tmp/miniodir.sh
  - wget https://github.com/minio/certgen/releases/download/v1.3.0/certgen_1.3.0_linux_amd64.deb
  - dpkg -i certgen_1.3.0_linux_amd64.deb
  - certgen -host ${format("%s%02d",var.host_prefix, count.index)}, $(hostname -I | awk '{print $1}')
  - mkdir -p /home/${random_pet.username.id}/.minio/certs
  - mv private.key public.crt /home/${random_pet.username.id}/.minio/certs
  - chown minio-user:minio-user /home/${random_pet.username.id}/.minio/certs/private.key
  - chown minio-user:minio-user /home/${random_pet.username.id}/.minio/certs/public.crt
  - chown minio-user:minio-user /etc/default/minio
  - systemctl enable minio
  - reboot

EOF
}

resource libvirt_volume ubuntu_instance {
  count          = var.vm_count
  name           = format("%s-volume-%02d",var.host_prefix,count.index)
  base_volume_id = var.ubuntu_base_id
  size           = 66 * 1024 * 1024 * 1024 # 66GiB. the root FS is automatically resized by cloud-init growpart (see https://cloudinit.readthedocs.io/en/latest/topics/examples.html#grow-partitions).
}


resource libvirt_volume data {
  count  = var.vm_count
  name   = format("%s-data-%02d",var.host_prefix,count.index)
  size   = var.data_disk_size * 1024 * 1024 * 1024
  format = "qcow2"
}


# Define KVM domain to create
resource "libvirt_domain" "ubuntu_instance" {
  count  = var.vm_count
  name   = format("%s-%02d",var.host_prefix,count.index)
  memory = 16384
  vcpu   = 4

  network_interface { 
    network_name = var.bridge_name # List networks with virsh net-list
  }

  cloudinit = libvirt_cloudinit_disk.simple_cloud_init[count.index].id

  disk {
    volume_id = libvirt_volume.ubuntu_instance[count.index].id
  }
  disk {
    volume_id = libvirt_volume.data[count.index].id
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}

resource local_file as3 {
  filename = "${path.module}/${var.host_prefix}-as3.json"
  content = templatefile("${path.module}/as3template.json.tftpl", 
    {
      tenant_name                 = var.host_prefix
      application_name            = var.host_prefix
      console_destination_address = var.console_destination_address
      console_destination_port    = var.console_destination_port
      api_destination_address     = var.api_destination_address
      api_destination_port        = var.api_destination_port
      api_waf_policy_url          = var.api_waf_policy_url
      addresses                   = [for i in range(var.vm_count) : format(var.node_name_pattern,var.host_prefix, i )]
    }
  )
}

resource local_file warp {
  filename = "${path.module}/warpmixed.yaml"
  content = templatefile("${path.module}/warp/mixed.yaml",
    {
      api_destination_address = var.api_destination_address
      api_destination_port    = var.api_destination_port
      minio_api_access_key    = var.minio_api_access_key
      minio_api_secret_key    = var.minio_api_secret_key
    }
  )
}
