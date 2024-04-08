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

output "workload_identity_provider" {
  description = "The Workload Identity Pool Provider"
  value       = google_iam_workload_identity_pool_provider.tf_cloud_organization
}

output "workspace_service_accounts" {
  description = ""
  value = {
    for idx, sa in google_service_account.tfcloud_workspace :
    local.tfcloud_workspaces[idx].workspace_id => sa.email
  }
}