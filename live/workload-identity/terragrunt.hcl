# Copyright 2023 Google LLC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     https://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

skip = false

include "common" {
  path = find_in_parent_folders("common.hcl")
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("shared.hcl"))
  config      = yamldecode(file("${get_repo_root()}/config.yml"))
  moduleName  = basename(path_relative_to_include())
}

dependencies {
  paths = [
    "${get_terragrunt_dir()}/../apis",
    "${get_terragrunt_dir()}/../org-policies"
  ]
}

generate "tfc-provider" {

  path      = "tfc-provider.tf"
  if_exists = "overwrite"

  contents = <<EOF
provider "tfe" {
  organization  = "${local.config.inputs.modules[local.moduleName]["tfcloud_organization_id"]}"
}
EOF
}

terraform {
  source = "${get_repo_root()}/modules/${local.moduleName}"
}

inputs = local.config.inputs.modules[local.moduleName]