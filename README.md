# terraform-confluent & Ansible

This project shows how to use terraform to build a cluster on AWS and deploy a Confluent Platform.

* Create a tf file with these variables set:

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

```

* Set the USER variable in the Makefile to the same value as the terraform USER variable above.

```Makefile
USER = this_is_you

```

## Commands

```bash
terraform apply
make inventory
# append to host.yml and fix formatting
make ping
make go
```
