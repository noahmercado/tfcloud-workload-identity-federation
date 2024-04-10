# Terraform Cloud Workload Identity Federation
Terraform for setting up Workload Identity Federation for a Terraform Cloud Organization
  
# Google Disclaimer
This is not an officially supported Google product


## Required permissions to deploy
- `roles/editor`
- `roles/owner` 
- `roles/orgpolicy.policyAdmin` _(if you need to disable org policies)_


## Dependencies (required if you choose to deploy via the devcontainer)
- `VS Code`
  - https://code.visualstudio.com/download
- `Docker`
  - https://docs.docker.com/get-docker/
- `devcontainer cli`
  - https://code.visualstudio.com/docs/devcontainers/devcontainer-cli

## Dependencies _for deploying_ (these are pre-packaged into the devcontainer and must be installed locally if you choose not to use it)
- **terraform ~> 1.5**
  - Installation via [Tfswitch](https://tfswitch.warrensbox.com/Install/) -> `(cd modules/apis && tfswitch)`
- **terragrunt ~> v0.46.3**
  - [Terragrunt Installation Docs](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- **Google Cloud SDK ~> 434.0.0**
  - [gcloud installation docs](https://cloud.google.com/sdk/docs/install)
- **sleep (GNU coreutils)**
  - Already installed on most systems

## Dependencies _for contributing_ (these are pre-packaged into the devcontainer and must be installed locally if you choose not to use it)
- **terraform-docs**
  - [terraform-docs installation](https://terraform-docs.io/user-guide/installation/)


## Required GCP APIs
All GCP APIs required for this solution are documented in [./live/shared.hcl](./live/shared.hcl#L15). By default, `terragrunt run-all apply` will enable each of these APIs

## Organization Policies
The Org Policy constraints which could prevent this solution from being deployed are documented in [./live/shared.hcl](./live/shared.hcl#L66-75). If you need to disable these policies and have the required permissions, you must set `skip = false` in [./live/org-policies/terragrunt.hcl](./live/org-policies/terragrunt.hcl). Then, rerunning `terragrunt run-all apply` will disable each of these org policies.

## How to deploy
- Create an API token for use with Terraform Cloud
  - https://app.terraform.io/app/settings/tokens
```bash
# Build and start the VS Code devcontainer which includes all the required tooling to depoy
devcontainer build && devcontainer open
```
- Your devcontainer will now build and open a brand new VS Code window. The remaining steps **must** happen within the terminal of that newly create VS Code window
```bash
# Log in to gcloud cli to authenticate Terraform. This should be your Argolis credentials 
gcloud auth login --update-adc

# Authenticate to Terraform Cloud
export TFE_TOKEN="YOUR_TFE_TOKEN"
```
- Open [config.yml](config.yml) 
  - Modify the `terraformState` configuration block. This controls the projectId and region in which your Terraform state will be stored (Terragrunt will automatically create the backend GCS bucket for you based off of these inputs)
  - Modify the `inputs` configuration block. This controls the project and region in which your resources will be deployed. Note that these **can** be the same projectId as the `terraformState` projectId
  - You can also use the `inputs` configuration block to configure the inputs for the various Terraform modules. Each Terraform module has it's inputs documented within it's relative README file (colocated in the directory of the module source code).
    - [Available inputs for workload-identity module](./-/tree/main/modules/workload-identity?ref_type=heads#inputs)

```bash
# Generate the Terraform plan and review before deploying into your project
terragrunt run-all plan -refresh=false

# Deploy the entire stack
terragrunt run-all apply -refresh=false
```