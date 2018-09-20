# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ALLOW OTHER AWS ACCOUNTS TO ACCESS THIS AWS ACCOUNT
# This module creates IAM roles that allow users in other AWS accounts to access certain IAM roles in this account.
# Note that while these templates allow other accounts to access this account, you will also need to add IAM policies
# in those other accounts for users to actually be able to switch between accounts.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "${var.aws_region}"
  # Only this AWS Account ID may be operated on by this template
  allowed_account_ids = ["${var.aws_account_id}"]
}

# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE REMOTE STATE STORAGE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE IAM ROLES THAT ALLOW CROSS-ACCOUNT ACCESS
# ---------------------------------------------------------------------------------------------------------------------

module "cross_account_iam_roles" {
  source = "git::git@github.com:gruntwork-io/module-security.git//modules/cross-account-iam-roles?ref=v0.5.1"

  aws_account_id = "${var.aws_account_id}"

  should_require_mfa = "${var.should_require_mfa}"
  dev_permitted_services = ["${var.dev_permitted_services}"]

  allow_read_only_access_from_other_account_arns = ["${var.allow_read_only_access_from_other_account_arns}"]
  allow_billing_access_from_other_account_arns = ["${var.allow_billing_access_from_other_account_arns}"]
  allow_ssh_iam_access_from_other_account_arns = ["${var.allow_ssh_iam_access_from_other_account_arns}"]
  allow_dev_access_from_other_account_arns = ["${var.allow_dev_access_from_other_account_arns}"]
  allow_full_access_from_other_account_arns = ["${var.allow_full_access_from_other_account_arns}"]

  auto_deploy_permissions = ["${var.auto_deploy_permissions}"]
  allow_auto_deploy_from_other_account_arns = ["${var.allow_auto_deploy_from_other_account_arns}"]
}


