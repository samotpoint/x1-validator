# Installation guide for Testnet Validator

> Assuming you are using macOS or a Linux distributions (Some changes may be required for Windows)

> Assuming you have basic knowledge on AWS and command line.

## Prerequisites

- The Terraform CLI (1.2.0+) installed
  see [developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- AWS account and associated credentials that allow you to create resources.
- Setup AWS Shared Configuration and Credentials Files
  see [registry.terraform.io/providers/hashicorp/aws/latest/docs?product_intent=terraform#shared-configuration-and-credentials-files](https://registry.terraform.io/providers/hashicorp/aws/latest/docs?product_intent=terraform#shared-configuration-and-credentials-files)
- If you need help setting your AWS credentials (First video I found on Youtube contain may not be accurate...)
  see [www.youtube.com/watch?v=gswVHTrRX8I&ab_channel=BenDavis](https://www.youtube.com/watch?v=gswVHTrRX8I&ab_channel=BenDavis)

## 1. Install and validate

```shell
cp terraform.tfvars.example terraform.tfvars
# Update terraform.tfvars accordingly (aws_account_id and whitelist_cidr_block)

terraform init
terraform validate # Optional
terraform plan
```

## 2. Create EC2 and related resources

After this you should have an EC2 instance up and running

```shell
terraform apply
```

## 3. Connect to your EC2 instance using SSH and finish installation

Command displayed at the end of `terraform apply`.

Something like `ssh -i <ssh_key_file_path> ubuntu@<instance_public_ip>`.

```shell
cd /git/go-x1
go mod tidy
make x1
sudo cp build/x1 /usr/local/bin
x1 version # Optional to validate X1 version installed (make sure "Git Commit: 5009f457" match the latest version)
```

## 4. Sync Validator

This step could take a few hours depending on the current snapshot

```shell
# Download chaindata and unzip it (faster way to sync your node)
sudo -u x1 bash # Open bash has x1 user
cd ~
wget --no-check-certificate https://xenblocks.io/snapshots/current.snapshot.tar
tar -xvf current.snapshot.tar -C /root

# To finish syncing
screen -S "x1readonly" -dm bash -c "x1 --testnet --syncmode snap --xenblocks-endpoint ws://xenblocks.io:6668 --cache 4096 1>x1readonly.error.log 2>x1readonly.output.log"
```

## 5. To validate if syncing is completed or if you had any error

```shell
# Should not display anything if not something went wrong
tail -n 25 x1readonly.error.log

# Display last lines logged something like (if it's different it's not synced yet)
# INFO [04-17|04:38:15.716] New block index=2753240 id=5612:4389:107224 gas_used=1,050,000 txs=50/0 age=10.808s t=12.560ms
# Age should be something lower tan a few minutes otherwise continue syncing
tail -n 25 x1readonly.output.log

# When syncing is completed stop your node
screen -S x1readonly -X quit
```

## 6. Create a new validator key

```shell
cat /x1/.password # Display your password
x1 validator new
```

## 7. Stake 100,000 XN using Metamask

For this follow Jozef Jarosciak steps

> https://github.com/JozefJarosciak/X1/blob/main/Validator-Instructions_Testnet.md#step-7-stake-100000-xn-using-metamask

## 8. Start Validator

- Update `--validator.id <YOUR_VALIDATOR_ID>` See `getValidatorID`
  from [SFC Read Contract](https://explorer.x1-testnet.xen.network/address/0xFC00FACE00000000000000000000000000000000/read-contract#address-tabs)
- Update `--validator.pubkey <YOUR_PUB_KEY>` Pub key can be found inside ~/.x1/keystore/<your_filename>
- Update `--cache 7838` (only if you changed the `instance_type` from terraform.tfvars)

```shell
PUB_KEY=<YOUR_PUB_KEY> # See ~/.x1/keystore/<your_secret_filename>
VALIDATOR_ID=<YOUR_VALIDATOR_ID> # Use getValidatorID from https://explorer.x1-testnet.xen.network/address/0xFC00FACE00000000000000000000000000000000/read-contract#address-tabs
screen -S "x1validator" -dm bash -c "x1 --testnet --validator.id <YOUR_VALIDATOR_ID> --validator.pubkey <YOUR_PUB_KEY> --cache 7838 --syncmode full --xenblocks-endpoint ws://xenblocks.io:6668 --gcmode full --validator.password /var/lib/x1/.x1/.password  1>x1validator.error.log 2>x1validator.output.log"
```

## 9. To validate if it is running properly

```shell
# Should not display anything
tail -n 25 x1validator.error.log

# Display last lines logged
tail -n 25 x1validator.output.log
```

## 10. Stop Validator

```shell
screen -S x1validator -X quit
```

## 11. Permanently delete everything

Make sure to back up your password and secret file before.

```shell
terraform destroy
```

# Installation guide for Mainnet Validator

> Coming soon
