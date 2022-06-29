# Hashistack on Digital Ocean

This repo is a playground for creating a full Hashistack environment
with Terraform on Digital ocean.

- [x] [Nomad](https://www.nomadproject.io) cluster
  - [x] [Cloud-init](https://cloud-init.io)
  - [x] [Gossip encryption](https://learn.hashicorp.com/tutorials/nomad/security-gossip-encryption?in=nomad/transport-security)
  - [x] [Mutual TLS](https://learn.hashicorp.com/tutorials/nomad/security-enable-tls?in=nomad/transport-security)
- [ ] [Consul](https://www.consul.io) cluster
- [ ] [Vault](https://www.vaultproject.io) cluster
- [ ] Add firewall to block all incoming public traffic except SSH
  - [ ] Consider a bastion host

# Running

Create a `local.tfvars` file with your relevant variables.

At a minimum you must provide a digital ocean API token and
file paths to a SSH key that can be used for provisioning.

Then you can run the following.

```sh
# Download the necessary providers
make init

# Create a plan for the stack
make plan

# Apply any changes to the stack
make apply

# Tear down the stack
make destroy
```
