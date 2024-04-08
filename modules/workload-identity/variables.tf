# Copyright 2022 Google LLC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     https://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "tfcloud_organization_id" {
  description = "The Terraform Cloud Organization ID"
  type        = string

  validation {
    condition     = length(regexall("^org-[a-zA-Z0-9]{10,25}$", var.tfcloud_organization_id)) > 0
    error_message = "Must be a valid Terraform Cloud Org ID (i.e. org-asdf1234)"
  }
}

variable "tfcloud_workspaces" {
  description = "An array of Terraform Cloud Workspace Configurations to create GCP Service Accounts and IAM Role bindings for"
  type = list(object({
    workspace_id = string
    project_iam_bindings = list(object({
      project_id = string
      roles      = list(string)
    }))
  }))

  default = []

  validation {
    condition = alltrue(flatten([
      for workspace in var.tfcloud_workspaces : [
        length(regexall("^ws-[a-zA-Z0-9]{10,25}$", workspace.workspace_id)) > 0
    ]]))

    error_message = "Must be a valid Terraform Cloud Workspace ID (i.e. ws-asdf1234)"
  }
}