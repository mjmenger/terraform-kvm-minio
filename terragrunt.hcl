locals {
    secret_input_vars = yamldecode(sops_decrypt_file("${get_path_to_repo_root()}/input.sops.yaml"))
    secret_env_vars   = yamldecode(sops_decrypt_file("${get_path_to_repo_root()}/env.sops.yaml"))
}

inputs = local.secret_input_vars

terraform {
    extra_arguments "kvm" {
        commands = ["apply","plan","destroy"]
        arguments = []
        env_vars = local.secret_env_vars
    }
}

