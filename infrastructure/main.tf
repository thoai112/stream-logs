terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.9.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = "3.4.0"
    }
  }



  

}

provider "aws" {
  region = "ap-southeast-1"
}

module "networking_module" {
    source = "./networking"
}

module "security_module" {
    source = "./security_module"
}

module "compute_module" {
    source = "./compute"

    subnet_id=module.networking_module.subnet_id
    sg_id=module.networking_module.sg_id
    instance_profile_name=module.security_module.logsec2_instance_profile
}


module "opensearch_module" {
    source = "./opensearch_cluster"

    subnet_id=module.networking_module.subnet_id
    sg_id=module.networking_module.sg_id
}