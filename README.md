# terraform-confluent & Ansible

This project shows how to use terraform to build a cluster on AWS and deploy a Confluent Platform.

## Dependencies

This project uses **json2yaml** to ( do I really have to say it? ). https://www.npmjs.com/package/json2yaml

## Steps

* Create a secrets.tf file with these variables set:

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


######  SECURITY  ########
# Create a CA Generate a key and public certificate
openssl req -new -newkey rsa:4096 -days 365 -x509 -subj "/CN=Kafka-Security-CA" -keyout ca-key -out ca-cert -nodes

# Create the keystore for each of the Kafka Brokers
SRVPASS=serverpassword keytool -genkey -keystore server.keystore.jks -validity 365 -storepass $SRVPASS -keypass $SRVPASS  -dname "CN=localhost" -storetype pkcs12

# create a certification request file, to be signed by the CA
# GET A SIGNING REQUEST FROM OUR KEYSTORE
SRVPASS=mystorepassword keytool -keystore confluent.keystore.jks -certreq -file cert-file -storepass $SRVPASS -keypass $SRVPASS

# signing our own cert
SRVPASS=mystorepassword openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out cert-signed -days 365 -CAcreateserial -passin pass:$SRVPASS

# Trust the CA by creating a truststore and importing the ca-cert
# this will enable the brokers to trust all certs created from our CA
SRVPASS=mystorepassword keytool -keystore confluent.truststore.jks -alias CARoot -import -file ca-cert -storepass $SRVPASS -keypass $SRVPASS -noprompt

# Import CA and the signed server certificate into the keystore
SRVPASS=mystorepassword keytool -keystore confluent.keystore.jks -alias CARoot -import -file ca-cert -storepass $SRVPASS -keypass $SRVPASS -noprompt
keytool -keystore confluent.keystore.jks -import -file cert-signed -storepass $SRVPASS -keypass $SRVPASS -noprompt


######
## Create the client truststore and import the CA certificate
CLIPASS=serverpassword keytool -keystore truststore.jks -alias CARoot -import -file ca-cert  -storepass $CLIPASS -keypass $CLIPASS -noprompt

## create a CLIENT certificate !! put your LOCAL hostname after "CN=" and specify an alias
CLIPASS=clientpass keytool -genkey -keystore kafka.client.keystore.jks -validity 365 -storepass $CLIPASS -keypass $CLIPASS  -dname "CN=hubert.local" -alias my-local-pc -storetype pkcs12

```
