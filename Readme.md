# ECS AWS Highly Available Infrastructure with Terraform

This repository contains Terraform code to provision a highly available, production-ready AWS infrastructure for containerized applications. It includes VPC networking, ECS Fargate clusters, load balancing, IAM roles, secrets management, and auto scaling.

---

## **Components that will be Created**

### **Networking**
- 1 VPC
- 3 Public subnets (across different AZs)
- 3 Private subnets (across different AZs)
- 1 Internet Gateway
- 1 NAT Gateway (with Elastic IP)
- 1 Public route table
- 1 Private route table

### **Compute & Container Orchestration**
- 1 ECS Cluster (Fargate)
- 1 ECS Services (App)
- Task Definitions with secrets from AWS Secrets Manager

### **Load Balancing**
- 1 Application Load Balancer (ALB)
- Target Groups and Listeners for ECS services

### **IAM & Security**
- IAM roles for ECS tasks and execution
- Security groups for ECS services and ALB

### **Secrets Management**
- Integration with AWS Secrets Manager for sensitive environment variables

### **Auto Scaling**
- ECS Service auto scaling (configurable per service)

---

## **Repository Structure**

```
.
├── main.tf                # Root Terraform configuration
├── variables.tf           # Root variables
├── outputs.tf             # Root outputs
├── modules/
│   ├── vpc_module/        # VPC and networking resources
│   ├── lb/                # Load balancer and IAM for ECS
│   └── ecs_module/        # ECS cluster, services, task definitions, scaling
└── Readme.md              # This file
```

---

## **How to Deploy**

### **1. Prerequisites**

- [Terraform](https://www.terraform.io/downloads.html) v1.0+
- AWS CLI configured (`aws configure`)
- Sufficient AWS IAM permissions to create VPC, ECS, ALB, IAM, Secrets Manager, etc.

### **2. Clone the Repository**

```bash
git clone https://github.com/eslam-adel92/terraform_aws_ecs
cd terraform_aws_ecs
```

### **3. Configure Variables**

Edit `variables.tf` or create a `terraform.tfvars` file in the root directory.  
**Required variables you may need to set:**

```hcl
aws_region         = "me-south-1"
project_name       = "app-prod"
app_image          = "<Image repo URL>"
rds_secret         = "<secret_arn>"
# ...add other variables as needed...
```

**Check each module's `variables.tf` for additional required variables.**

### **4. Initialize Terraform**

```bash
terraform init
```

### **5. Review the Plan**

```bash
terraform plan
```

### **6. Apply the Infrastructure**

```bash
terraform apply
```

---

## **Customizing Your Deployment**

- **Add/Remove ECS Services:**  
  Edit `main.tf` and add or remove `module "ecs_module_*"` blocks as needed.
- **Enable/Disable Auto Scaling:**  
  Set `enable_autoscaling = true` or `false` per ECS service module.
- **Secrets:**  
  Store your secrets in AWS Secrets Manager and provide their ARNs via variables.

---

## **Outputs**

After deployment, Terraform will output key information such as:
- VPC ID
- Subnet IDs
- NAT Gateway ID and EIP
- ALB DNS name
- ECS Cluster and Service ARNs

---

## **Destroying the Infrastructure**

To tear down all resources:

```bash
terraform destroy
```

---

## **Notes & Best Practices**

- **IAM:**  
  IAM roles and policies are created for ECS tasks and execution. Adjust permissions as needed for your workloads.
- **Secrets:**  
  Only grant ECS roles access to the specific secrets required.
- **Scaling:**  
  Auto scaling is enabled by default for app services. You can tune scaling parameters in the module inputs.
- **Environments:**  
  For multiple environments (dev, staging, prod), use [Terraform workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces) or separate state files.
- **DataBases:**  
  This project does not include creating DB, as it's not recommended to create it through IaC tools to avoid any issues caused by destroying and reapplying, also to avoid the cost in the testing phases.
---

## Quick Start

1. Clone the repo and enter the directory:
   ```bash
   git clone https://github.com/your-org/terraform_aws_ecs
   cd terraform-aws-ecs
   ```

2. Edit `terraform.tfvars`:
   ```hcl
   region      = "us-east-1"
   aws_profile = "default"
   project_name = "my-app"
   app_image    = "nginx:latest"
   rds_secret   = "<your-secret-arn>"
   ```

3. Deploy:
   ```bash
   terraform init
   terraform apply
   ```

## Variables

| Variable      | Description                | Default      | Required  |
|---------------|----------------------------|--------------|-----------|
| region        | AWS region                 | us-east-1    | yes       |
| aws_profile   | AWS CLI profile            | default      | yes       |
| project_name  | Name for tagging           | app          | yes       |
| app_image     | Docker image for the app   |              | Yes       |
| rds_secret    | ARN for DB secret          |              | No        |

## Example: Adding Another ECS Service

```hcl
module "ecs_module_worker" {
  source            = "./modules/ecs_module"
  project_name      = var.project_name
  ecs_service_name  = "${var.project_name}-worker"
  app_image         = "worker-image:latest"
  # ...other variables...
}
```
---
## **Support**

For issues or questions, please open an issue in this repository.