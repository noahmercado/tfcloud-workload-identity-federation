
# https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/gcp-configuration#configure-terraform-cloud
resource "tfe_variable" "gcp_provider_auth" {
  for_each = local.tfcloud_workspaces

  key      = "TFC_GCP_PROVIDER_AUTH"
  value    = true
  category = "env"

  workspace_id = each.value.workspace_id
  description  = "Required for TF Cloud -> GCP WIF"
}

resource "tfe_variable" "gcp_run_sa_email" {
  for_each = google_service_account.tfcloud_workspace

  key      = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
  value    = each.value.name
  category = "env"

  workspace_id = local.tfcloud_workspaces[each.key].workspace_id
  description  = "The GCP WIF SA for this Terraform Workspace"
}

resource "tfe_variable" "gcp_workload_provider" {
  for_each = google_service_account.tfcloud_workspace

  key      = "TFC_GCP_WORKLOAD_PROVIDER_NAME"
  value    = google_iam_workload_identity_pool_provider.tf_cloud_organization.id
  category = "env"

  workspace_id = local.tfcloud_workspaces[each.key].workspace_id
  description  = "The GCP WIF Pool Provider"
}