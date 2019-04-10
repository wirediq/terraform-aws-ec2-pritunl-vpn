# Secrets Provisioning - Ssh private key file for Provisioner Connections

## Requirements
- Install terraform >= v0.11.13
- Install ansible >= 2.4.3.0

## Instructions
- Ensure provisioner/keys/id_rsa exists and is decrypted (read below)
    - Run `make decrypt` to decrypt the ssh private key file for
    - You'll have to provide the vault password
- Then use the commands in the Makefile to work with Terraform in order to apply those changes
    - Terraform will fail if the ssh private key file is encrypted

## IMPORTANT
- To keep the secrets file decrypted in your local computer is highly discouraged
- It is even more dangerous to commit/push the secrets file to the remote repository
- You can run `make encrypt` to encrypt the secrets file before committing/pushing any changes to it

## OS Provision
Pritunl OpenVPN Ansible Playbook: **PENDING LINK HERE**
This folder contains an ansible playbook to install Pritunl OpenVPN and its dependencies.
You can use this script, to create a Vault Amazon Machine Image (AMI) that can be deployed in AWS EC2.

This script has been tested on the following operating systems:

Ubuntu 16.04
There is a good chance it will work on other flavors of Debian, CentOS, and RHEL as well.
remember ssh key file before committing/pushing any changes to it
