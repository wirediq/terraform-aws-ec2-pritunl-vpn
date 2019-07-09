<div align="center">
    <img src="./figures/binbash.png" alt="drawing" width="350"/>
</div>
<div align="right">
  <img src="./figures/binbash-leverage-terraform.png" alt="leverage" width="230"/>
</div>

# AWS EC2 Pritunl VPN Module: terraform-aws-ec2-pritunl-vpn

This module handles the creation of a AWS instance intented to run Pritunl Server, configured to run a VPN Instance on AWS.
Creates an instance that can be logged into with the username `ubuntu` and the correspoding AWS EC2 Key Pair.

## Releases
- **Versions:** `<= 0.x.y` (Terraform 0.11.x compatible)
    - eg: https://registry.terraform.io/modules/binbashar/ec2-jenkins-vault/aws/0.0.1

- **Versions:** `>= 1.x.y` (Terraform 0.12.x compatible -> **WIP**)
    - eg: https://registry.terraform.io/modules/binbashar/ec2-jenkins-vault/aws/1.0.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_ami\_os\_id | AWS AMI Operating System Identificator | string | `"ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"` | no |
| aws\_ami\_os\_owner | AWS AMI Operating System Owner | string | `"099720109477"` | no |
| aws\_key\_pair\_name | AWS ssh ec2 key pair name | string | n/a | yes |
| aws\_route53\_public\_zone\_id | List of DNS Route53 public hosted zones ID | list | `<list>` | no |
| aws\_vpc\_id | AWS VPC id | string | n/a | yes |
| aws\_vpc\_public\_subnets | List of IDs of public subnets | list | `<list>` | no |
| environment | Environment Name | string | n/a | yes |
| instance\_dns\_record\_name\_1 | Route53 DNS record name | string | n/a | yes |
| instance\_dns\_record\_name\_1\_enabled | Route53 DNS record name if set to true, otherwise don't use any specific tag | string | `"false"` | no |
| instance\_dns\_record\_name\_2 | Route53 DNS record name | string | n/a | yes |
| instance\_dns\_record\_name\_2\_enabled | Route53 DNS record name if set to true, otherwise don't use any specific tag | string | `"false"` | no |
| instance\_type | AWS EC2 Instance Type | string | `"t2.micro"` | no |
| sg\_private\_cidrs | Security group CIDR segments | string | `""` | no |
| sg\_private\_name | Security group name | string | `"vpn-private"` | no |
| sg\_private\_tpc\_ports | Security group TCP ports | string | `"22,443"` | no |
| sg\_private\_udp\_ports | Security group UDP ports | string | `"default_null"` | no |
| sg\_public\_cidrs | Security group CIDR segments | string | `"0.0.0.0/0"` | no |
| sg\_public\_name | Security group name | string | `"vpn-public"` | no |
| sg\_public\_temporary\_cidrs | Security group CIDR segments | string | `"0.0.0.0/0"` | no |
| sg\_public\_temporary\_enabled | set to 1 to create SG for temporary public access | string | `"1"` | no |
| sg\_public\_temporary\_name | Security group name | string | `"vpn-public-temp-access"` | no |
| sg\_public\_temporary\_tpc\_ports | Security group TCP ports | list | `<list>` | no |
| sg\_public\_tpc\_ports | Security group TCP ports | string | `"80"` | no |
| sg\_public\_udp\_ports | Security group UDP ports | string | n/a | yes |
| tags | A mapping of tags to assign to all resources | map | `<map>` | no |
| volume\_size | EBS volume size | string | `"16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| public\_ip | Contains the public IP address. |

## Examples
### EC2 Pritunl VPN
#### ec2-pritunl-vpn
```terraform
#
# EC2 Pritunl OpenVPN
#
module "ec2_openvpn" {
  source = "git::git@github.com:binbashar/terraform-aws-ec2-pritunl-vpn.git?ref=v0.0.2"

  environment                        = "${var.environment}"
  aws_ami_os_id                      = "${var.aws_ami_os_id}"
  aws_ami_os_owner                   = "${var.aws_ami_os_owner}"
  instance_type                      = "${var.instance_type}"
  aws_vpc_id                         = "${data.terraform_remote_state.vpc.vpc_id}"
  aws_vpc_public_subnets             = ["${data.terraform_remote_state.vpc.public_subnets[0]}"]
  aws_route53_public_zone_id         = ["${data.terraform_remote_state.vpc.aws_public_zone_id[0]}"]
  volume_size                        = "${var.volume_size}"
  sg_private_name                    = "${var.sg_private_name}"
  sg_private_tpc_ports               = "${var.sg_private_tpc_ports}"
  sg_private_udp_ports               = "${var.sg_private_udp_ports}"
  sg_private_cidrs                   = "${var.sg_private_cidrs}"
  sg_public_name                     = "${var.sg_public_name}"
  sg_public_tpc_ports                = "${var.sg_public_tpc_ports}"
  sg_public_udp_ports                = "${var.sg_public_udp_ports}"
  sg_public_cidrs                    = "${var.sg_public_cidrs}"
  sg_public_temporary_enabled        = "${var.sg_public_temporary_enabled}"
  sg_public_temporary_name           = "${var.sg_public_temporary_name}"
  sg_public_temporary_tpc_ports      = "${var.sg_public_temporary_tpc_ports}"
  sg_public_temporary_cidrs          = "${var.sg_public_temporary_cidrs}"
  aws_key_pair_name                  = "${data.terraform_remote_state.security.aws_key_pair_name}"
  instance_dns_record_name_1_enabled = "${var.instance_dns_record_name_1_enabled}"
  instance_dns_record_name_1         = "${var.instance_dns_record_name_1}"
  instance_dns_record_name_2_enabled = "${var.instance_dns_record_name_2_enabled}"
  instance_dns_record_name_2         = "${var.instance_dns_record_name_2}"
  tags                               = "${local.tags}"
}
```

---

### Provisioner
- Userdata ( native AWS EC2 provisioning is going to automatically and persistently mount
 eg: `/data` AWS EBS (cosider this script will work for EC2 `t3` family type).

- Please check provisioner/ansible-playbook-pritunl/README.md
