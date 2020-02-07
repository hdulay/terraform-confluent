USER = hubert

z:
	aws2 ec2 describe-instances \
		--filters "Name=tag:Name,Values=$(USER)-tf-zk" "Name=instance-state-name,Values=running" \
		--output json \
		| jq ".Reservations[].Instances[].PublicDnsName" -r

b:
	aws2 ec2 describe-instances \
		--filters "Name=tag:Name,Values=$(USER)-tf-broker" "Name=instance-state-name,Values=running" \
		--output json \
		| jq ".Reservations[].Instances[].PublicDnsName" -r

sr:
	aws2 ec2 describe-instances \
		--filters "Name=tag:Name,Values=$(USER)-tf-sr" "Name=instance-state-name,Values=running" \
		--output json \
		| jq ".Reservations[].Instances[].PublicDnsName" -r

c3:
	aws2 ec2 describe-instances \
		--filters "Name=tag:Name,Values=$(USER)-tf-c3" "Name=instance-state-name,Values=running" \
		--output json \
		| jq ".Reservations[].Instances[].PublicDnsName" -r

connect:
	aws2 ec2 describe-instances \
		--filters "Name=tag:Name,Values=$(USER)-tf-connect" "Name=instance-state-name,Values=running" \
		--output json \
		| jq ".Reservations[].Instances[].PublicDnsName" -r

ksql:
	aws2 ec2 describe-instances \
		--filters "Name=tag:Name,Values=$(USER)-tf-ksql" "Name=instance-state-name,Values=running" \
		--output json \
		| jq ".Reservations[].Instances[].PublicDnsName" -r

hosts:
	aws2 ec2 describe-instances \
		--filters "Name=tag:Name,Values=$(USER)-tf*" "Name=instance-state-name,Values=running" \
		--output json \
		| jq ".Reservations[].Instances[].PublicDnsName" -r

list-tags:
	aws2 ec2 describe-instances \
		--filters "Name=tag:Name,Values=$(USER)*" "Name=instance-state-name,Values=running" \
		--output json \
		| jq ".Reservations[].Instances[] | [.PublicDnsName, .Tags[]] "

inventory:
	terraform output -json \
		| jq  'to_entries[] | {(.key): {hosts: .value.value}} ' \
		| jq -s \
		| json2yaml \
		| sed 's/ - / /g' \
		| sed 's/ "/ /g' \
		| sed 's/"/:/g'

ping:
	ansible -i hosts.yml all -m ping

go:
	ansible-playbook -i hosts.yml cp-ansible/all.yml

