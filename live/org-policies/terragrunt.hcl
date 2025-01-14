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

skip = true

include "common" {
  path = find_in_parent_folders("common.hcl")
}

dependencies {
  paths = [
    "${get_terragrunt_dir()}/../apis"
  ]
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("shared.hcl"))
  moduleName  = basename(path_relative_to_include())
}

terraform {
  source = "${get_repo_root()}/modules/${local.moduleName}"

  after_hook "allow_org_policy_propagation" {
    commands     = ["apply"]
    execute      = ["sleep", "90"]
    run_on_error = false
  }
}

inputs = {
  // Define your list of boolean Org Policies to disable for the project here
  boolean_policies_to_disable = local.common_vars.inputs.boolean_policies_to_disable

  // Define your list of list constraint Org Policies to disable for the project here
  list_constraint_policies_to_disable = local.common_vars.inputs.list_constraint_policies_to_disable
}