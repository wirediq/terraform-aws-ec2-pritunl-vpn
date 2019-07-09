#=============================#
# Project Variables           #
#=============================#
variable "environment" {
  description = "Environment Name"
}

#=============================#
# Compute                     #
#=============================#
variable "aws_ami_os_id" {
  description = "AWS AMI Operating System Identificator"
  default     = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"
}

variable "aws_ami_os_owner" {
  description = "AWS AMI Operating System Owner"
  default     = "099720109477"
}

variable "instance_type" {
  description = "AWS EC2 Instance Type"
  default     = "t2.micro"
}

#=============================#
# Network
#=============================#
variable "aws_vpc_id" {
  description = "AWS VPC id"
}

variable "aws_vpc_public_subnets" {
  type        = "list"
  description = "List of IDs of public subnets"
  default     = []
}

variable "aws_route53_public_zone_id" {
  type        = "list"
  description = "List of DNS Route53 public hosted zones ID"
  default     = []
}

#=============================#
# Storage                     #
#=============================#
variable "volume_size" {
  description = "EBS volume size"
  default     = 16
}

#=============================#
# Security                    #
#=============================#

#
# SG private for aws org CIDR
#
variable "sg_private_name" {
  description = "Security group name"
  default     = "vpn-private"
}

// TCP 22   ssh
// TCP 9100 prometheus node exporter
// TCP 443 https for vpc org cird
variable "sg_private_tpc_ports" {
  description = "Security group TCP ports"
  default     = "22,443"
}

variable "sg_private_udp_ports" {
  description = "Security group UDP ports"
  default     = "default_null"
}

variable "sg_private_cidrs" {
  description = "Security group CIDR segments"
  default     = ""
}

#
# SG public for www (0.0.0.0/0)
#
variable "sg_public_name" {
  description = "Security group name"
  default     = "vpn-public"
}

// TCP 80    pritunl.web.letsencrypt
// TCP 11080 pritunl.server.admin
// TCP 2709  pritunl.server.dev
// UDP 15255 pritunl.server.dev
variable "sg_public_tpc_ports" {
  description = "Security group TCP ports"
  default     = "80"
}

variable "sg_public_udp_ports" {
  description = "Security group UDP ports"
}

variable "sg_public_cidrs" {
  description = "Security group CIDR segments"
  default     = "0.0.0.0/0"
}

#
# SG public temporary
#
variable "sg_public_temporary_enabled" {
  description = "set to 1 to create SG for temporary public access"
  default     = 1
}

variable "sg_public_temporary_name" {
  description = "Security group name"
  default     = "vpn-public-temp-access"
}

variable "sg_public_temporary_tpc_ports" {
  type        = "list"
  description = "Security group TCP ports"
  default     = ["22", "443"]
}

variable "sg_public_temporary_cidrs" {
  description = "Security group CIDR segments"
  default     = "0.0.0.0/0"
}

#
# Provisioner Connections
#
variable "aws_key_pair_name" {
  description = "AWS ssh ec2 key pair name"
}

#=============================#
# DNS                         #
#=============================#
variable "instance_dns_record_name_1_enabled" {
  description = "Route53 DNS record name if set to true, otherwise don't use any specific tag"
  default     = "false"
}

variable "instance_dns_record_name_1" {
  description = "Route53 DNS record name"

  //    default   = "vpn.aws.binbash.com.ar"
}

variable "instance_dns_record_name_2_enabled" {
  description = "Route53 DNS record name if set to true, otherwise don't use any specific tag"
  default     = "false"
}

variable "instance_dns_record_name_2" {
  description = "Route53 DNS record name"

  //    default   = "webhooks.aws.binbash.com.ar"
}

#=============================#
# TAGS                        #
#=============================#
variable "tags" {
  type        = "map"
  description = "A mapping of tags to assign to all resources"
  default     = {}
}
