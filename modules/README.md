# Hashistack on Digital Ocean

This repo is a playground for creating a full hashistack environment
with Terraform on Digital ocean. It is not meant to be fully production
ready but it will attemp to utilize as many best practices as possible.

- [x] Nomad cluster
- [ ] Consul cluster
- [ ] Vault cluster

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
