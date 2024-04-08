## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.3.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | >= 0.50.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_iam_workload_identity_pool.tf_cloud](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google_iam_workload_identity_pool_provider.tf_cloud_organization](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_project_iam_member.tfcloud_workspace](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.tfcloud_workspace](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_binding.tfcloud_workspace](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [tfe_variable.gcp_provider_auth](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.gcp_run_sa_email](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.gcp_workload_provider](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tfcloud_organization_id"></a> [tfcloud\_organization\_id](#input\_tfcloud\_organization\_id) | The Terraform Cloud Organization ID | `string` | n/a | yes |
| <a name="input_tfcloud_workspaces"></a> [tfcloud\_workspaces](#input\_tfcloud\_workspaces) | An array of Terraform Cloud Workspace Configurations to create GCP Service Accounts and IAM Role bindings for | <pre>list(object({<br>    workspace_id = string<br>    project_iam_bindings = list(object({<br>      project_id = string<br>      roles      = list(string)<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workload_identity_provider"></a> [workload\_identity\_provider](#output\_workload\_identity\_provider) | The Workload Identity Pool Provider |
| <a name="output_workspace_service_accounts"></a> [workspace\_service\_accounts](#output\_workspace\_service\_accounts) | n/a |
