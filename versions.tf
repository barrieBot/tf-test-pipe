#
# Terraform block
# Defines terraform itself
# Includes which providers should be used
# And also which terraform version is required
#
terraform {
  #
  # define the required aws provider and its version
  #
  required_providers {
    aws = {
      source  = "hashicorp/aws" # shortform for the registry address of the aws provider - registry.terraform.io/hashicorp/aws
      version = "~> 6.72"       # constraint for terraform to use any version of 6.72.X
    }
  }

  # required terraform version constraint for currently used one or higher
  required_version = ">= 1.17"
}
