# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Terraform project for Google Cloud (GCP), at an early scaffold stage. The name suggests a challenge lab involving a managed instance group (MIG). All Terraform code is in `terraform/`, which is a single root module. There are no child modules, no remote backend, and no `.tfvars` files yet.

## Commands

Run these from `terraform/`:

```sh
terraform init        # download the google provider (~> 6.0)
terraform fmt         # format; use `terraform fmt -check` to verify only
terraform validate    # static check (requires init)
terraform plan
terraform apply
```

You need GCP credentials to run `plan` or `apply`, for example from `gcloud auth application-default login`. The project has no tests and no lint config.

## Structure and conventions

- `provider.tf`: requires Terraform >= 1.5 and `hashicorp/google ~> 6.0`. The provider reads `project` and `region` from `local.project_id` and `local.region`.
- `locals.tf`: the place for shared configuration values. The project uses locals for config, not input variables. It is currently **empty**, so `local.project_id` and `local.region` are undefined and `validate`/`plan` will fail until you add them.
- `vpc.tf`: for network resources (VPC, subnets, firewall rules). Currently empty.
- `main.tf`: for compute resources (instance template, MIG, and so on). Currently empty.

Keep this split by resource area when adding resources. Add new configuration values to `locals.tf`, not as hardcoded literals.
