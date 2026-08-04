# Variables & Outputs Demo

Demonstrates Terraform variable types, validation, `.tfvars` files, locals, and outputs.

## Usage

```bash
cd variables-outputs-demo
terraform init
```

### Method 1: Interactive (prompts for required vars)

```bash
terraform apply
# Terraform will prompt for: project_name, db_password
```

### Method 2: `-var` flags

```bash
terraform apply \
  -var="project_name=my-app" \
  -var="db_password=secret123" \
  -var="instance_count=3"
```

### Method 3: `terraform.tfvars` file

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your values
terraform apply
```

### Method 4: Custom `-var-file` for environments

```bash
# Production deploy
terraform apply \
  -var-file="prod.tfvars" \
  -var="db_password=$(aws secretsmanager get-secret-value ...)"
```

## Concepts Shown

| File | Concept |
|---|---|
| `variables.tf` | Required vs optional, type constraints (`string`, `number`, `bool`, `list`, `map`, `object`), `optional()`, `nullable`, `sensitive`, `validation` block |
| `terraform.tfvars.example` | `.tfvars` file format for all types |
| `prod.tfvars` | Environment-specific overrides via `-var-file` |
| `main.tf` | `locals` for computed values, `merge()` for tags, `random_pet` for generated names |
| `outputs.tf` | `description`, `sensitive = true`, conditional values with `? :`, null outputs |
