# terraform-confluent & Ansible

This project shows how to use terraform to build a cluster on AWS and deploy a Confluent Platform.

## Dependencies

This project uses **json2yaml** to ( do I really have to say it? ). https://www.npmjs.com/package/json2yaml

## Steps

* Create a myvars.tf file with these variables set:

```terraform
variable "AWS_ACCESS_KEY" {
    default = "change me"
}

variable "AWS_SECRET_KEY" {
    default = "change me"
}

variable "USER" {
  default = "this_is_you"
}

variable "PEM" {
  default = "keyname"
}
```

* Set the USER variable in the Makefile to the same value as the terraform USER variable above.

```Makefile
USER = this_is_you

```

* Clone cp-ansible/hosts_example.yml to ./hosts.yml and change **ansible_ssh_private_key_file** to the path to your pem file.

```yml
    ansible_ssh_private_key_file: "your.pem"
```

## Commands

```bash
terraform init
terraform apply
make inventory
# paste the output over the existing inventory in host.yml and fix formatting
make ping
make go
```
