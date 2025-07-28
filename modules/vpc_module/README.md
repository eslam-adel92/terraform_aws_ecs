# AWS Terraform Project

This project sets up a basic AWS infrastructure using Terraform in the "me-south-1" region. It includes a Virtual Private Cloud (VPC) with public and private subnets, an internet gateway, a NAT gateway, and routing tables.

## Project Structure

- `main.tf`: Contains the main configuration for the Terraform project.
- `variables.tf`: Defines input variables for the Terraform configuration.
- `outputs.tf`: Specifies output values after the infrastructure is created.
- `provider.tf`: Configures the AWS provider and region.
- `README.md`: Documentation for the project.

## Prerequisites

- Terraform installed on your local machine.
- AWS account with appropriate permissions to create resources.
- AWS CLI configured with your credentials.

## Getting Started

1. **Clone the repository**:
   ```
   git clone <repository-url>
   cd aws-terraform-project
   ```

2. **Initialize Terraform**:
   Run the following command to initialize the Terraform configuration:
   ```
   terraform init
   ```

3. **Plan the deployment**:
   To see what resources will be created, run:
   ```
   terraform plan
   ```

4. **Apply the configuration**:
   To create the resources defined in the configuration, run:
   ```
   terraform apply
   ```

5. **Review the outputs**:
   After the apply completes, review the output values to find important information such as VPC ID and subnet IDs.

## Cleanup

To remove all resources created by this project, run:
```
terraform destroy
```

## Notes

Make sure to review and modify the `variables.tf` file to suit your needs before applying the configuration.