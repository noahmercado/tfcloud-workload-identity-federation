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

inputs = {
  // Define your list of APIs to enable here
  services = [
    "serviceusage.googleapis.com",
    "servicemanagement.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudapis.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "securetoken.googleapis.com",
    "sts.googleapis.com",
  ]

  // Define your list of boolean Org Policies to disable for the project here
  boolean_policies_to_disable = [
    "iam.disableServiceAccountCreation",
  ]

  // Define your list of list constraint Org Policies to disable for the project here
  list_constraint_policies_to_disable = [
    "constraints/iam.allowedPolicyMemberDomains"
  ]
}