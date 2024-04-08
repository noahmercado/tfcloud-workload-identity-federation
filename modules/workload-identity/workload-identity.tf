# Copyright 2024 Google LLC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     https://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "google_iam_workload_identity_pool" "tf_cloud" {

  workload_identity_pool_id = "tfcloud-pool-${random_id.random.hex}"
}

resource "google_iam_workload_identity_pool_provider" "tf_cloud_organization" {

  workload_identity_pool_id          = google_iam_workload_identity_pool.tf_cloud.workload_identity_pool_id
  workload_identity_pool_provider_id = "tfcloud-jwt-${random_id.random.hex}"

  display_name = "tfcloud/${var.tfcloud_organization_id}"
  description  = "Terraform Cloud Pool for Org Id: ${var.tfcloud_organization_id}"

  attribute_condition = "assertion.terraform_organization_id == '${var.tfcloud_organization_id}'"

  # https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/workload-identity-tokens#payload
  attribute_mapping = {
    "google.subject"                  = "assertion.terraform_workspace_id", # Required
    "attribute.aud"                   = "assertion.aud"
    "attribute.tfc_organization_id"   = "assertion.terraform_organization_id",
    "attribute.tfc_organization_name" = "assertion.terraform_organization_name",
    "attribute.tfc_project_id"        = "assertion.terraform_project_id",
    "attribute.tfc_project_name"      = "assertion.terraform_project_name",
    "attribute.tfc_workspace_name"    = "assertion.terraform_workspace_name",
    "attribute.tfc_workspace_id"      = "assertion.terraform_workspace_id",
    "attribute.tfc_full_workspace"    = "assertion.terraform_full_workspace",
    "attribute.tfc_run_id"            = "assertion.terraform_run_id",
    "attribute.tfc_run_phase"         = "assertion.terraform_run_phase"
  }

  oidc {
    issuer_uri = "https://app.terraform.io"
  }
}

locals {
  tfcloud_workspaces = {
    for idx, workspace in var.tfcloud_workspaces :
    idx => workspace
  }

  bindings = toset(flatten([
    for idx, workspace in local.tfcloud_workspaces : flatten([
      for binding in workspace.project_iam_bindings : flatten([
        for role in binding.roles :
        "${idx}:${workspace.workspace_id}:${binding.project_id}:${role}"
      ])
    ])
  ]))
}

/*
  
*/
resource "google_service_account" "tfcloud_workspace" {
  for_each = local.tfcloud_workspaces

  account_id   = "tfcloud-${lower(each.value.workspace_id)}"
  display_name = "SA for Terraform Cloud Workspace: ${each.value.workspace_id}"
}

resource "google_project_iam_member" "tfcloud_workspace" {
  for_each = local.bindings

  project = split(":", each.value)[2]
  role    = split(":", each.value)[3]
  member  = "serviceAccount:${google_service_account.tfcloud_workspace[split(":", each.value)[0]].email}"
}

resource "google_service_account_iam_binding" "tfcloud_workspace" {
  for_each = google_service_account.tfcloud_workspace

  service_account_id = each.value.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tf_cloud.name}/attribute.tfc_workspace_id/${local.tfcloud_workspaces[each.key].workspace_id}"
  ]
}