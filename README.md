# terraform-confluent

## journal

```bash
sudo journalctl -u confluent-control-center
```

## YAML from jq
```bash
terraform output -json | jq  -r 'keys[] as $k | "\($k)\n" | "  \(.[$k] | .value[])"'

terraform output -json | jq  'to_entries[] | {(.key): .value.value} '

terraform output -json | jq  'to_entries[] | {(.key): .value.value} ' | jq -s | json2yaml

```
