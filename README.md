# AWS Terraform & Jenkins CI/CD Pipeline

## Project Overview

This project demonstrates the implementation of an automated Infrastructure as Code (IaC) and Continuous Integration/Continuous Deployment (CI/CD) pipeline using **Terraform, Jenkins, GitHub and Amazon Web Services (AWS)**.

The solution provisions and manages separate AWS infrastructure environments for Development, Staging and Production using reusable Terraform modules. Jenkins automates the deployment workflow, validates Terraform configurations, generates execution plans and manages production deployment through a manual approval gate.

The project demonstrates practical DevOps engineering principles, including infrastructure automation, environment separation, remote state management, IAM permissions, pipeline orchestration and deployment control.

## Architecture

The solution uses the following components:

- **GitHub:** Source code repository and version control.
- **Jenkins:** CI/CD automation server hosted on an AWS EC2 instance.
- **Terraform:** Infrastructure provisioning and configuration management.
- **AWS EC2:** Compute infrastructure for the deployed environments.
- **Amazon VPC:** Network isolation for Dev, Staging and Production.
- **Amazon S3:** Centralised remote Terraform state storage.
- **AWS IAM:** Role-based permissions for Jenkins to interact with AWS.
- **Nginx:** Web server deployed on the provisioned EC2 instances.

### Architecture Workflow

1. Terraform configurations are maintained in GitHub.
2. Jenkins checks out the latest source code from the `main` branch.
3. Jenkins verifies the installed tools and AWS account identity.
4. Terraform formatting and configuration validation are performed.
5. Terraform initialises the S3 remote backend for each environment.
6. Jenkins generates and archives Terraform execution plans.
7. Development infrastructure is provisioned automatically.
8. Staging infrastructure is provisioned automatically.
9. A Production execution plan is generated and archived.
10. Jenkins requests manual approval before Production deployment.
11. Following approval, Jenkins executes the Production Terraform plan.

## Technology Stack

| Technology | Purpose |
|---|---|
| AWS | Cloud infrastructure |
| Terraform | Infrastructure as Code |
| Jenkins | CI/CD automation |
| Git and GitHub | Version control |
| Amazon EC2 | Compute resources |
| Amazon VPC | Network isolation |
| Amazon S3 | Remote Terraform state |
| AWS IAM | Identity and access management |
| Nginx | Web server |
| Linux / Amazon Linux 2023 | Jenkins and application hosting |
| PowerShell | Local administration and AWS CLI operations |

## Repository Structure

```text
November-CICD/
│
├── .gitignore
├── Jenkinsfile
├── README.md
│
└── terraform/
    │
    ├── main.tf
    ├── provider.tf
    ├── variables.tf
    ├── outputs.tf
    ├── versions.tf
    ├── backend.tf
    │
    ├── modules/
    │   └── infrastructure/
    │       ├── main.tf
    │       ├── variables.tf
    │       └── outputs.tf
    │
    └── environments/
        │
        ├── dev/
        │   ├── backend.tf
        │   ├── main.tf
        │   ├── provider.tf
        │   ├── variables.tf
        │   ├── outputs.tf
        │   ├── versions.tf
        │   └── terraform.tfvars
        │
        ├── staging/
        │   ├── backend.tf
        │   ├── main.tf
        │   ├── provider.tf
        │   ├── variables.tf
        │   ├── outputs.tf
        │   ├── versions.tf
        │   └── terraform.tfvars
        │
        └── prod/
            ├── backend.tf
            ├── main.tf
            ├── provider.tf
            ├── variables.tf
            ├── outputs.tf
            ├── versions.tf
            └── terraform.tfvars
```

## Terraform Infrastructure

The project uses a reusable Terraform module to avoid duplicating infrastructure code across environments.

The shared module provisions:

- Amazon VPC
- Internet Gateway
- Public subnet
- Route table
- Route table association
- Security group
- EC2 instance
- Nginx web server installation and configuration

Each environment calls the shared module with its own configuration values.

### Environment Configuration

| Configuration | Development | Staging | Production |
|---|---|---|---|
| Environment | dev | staging | prod |
| VPC CIDR | 10.10.0.0/16 | 10.20.0.0/16 | 10.30.0.0/16 |
| Subnet CIDR | 10.10.1.0/24 | 10.20.1.0/24 | 10.30.1.0/24 |
| EC2 instance | t3.micro | t3.small | t3.medium |
| Web server | Nginx | Nginx | Nginx |

The environments use separate network configurations and independent Terraform state files.

## Remote Terraform State Management

Terraform state is stored remotely in an Amazon S3 bucket rather than relying on local state files.

**S3 backend configuration:**

- Bucket: `november-terraform-state-585768150796`
- AWS Region: `us-east-1`
- State encryption: Enabled
- S3 bucket versioning: Enabled
- State locking: Enabled using Terraform's native S3 lock file mechanism.

### Separate State Files

Each environment has an independent state file:

| Environment | S3 state key |
|---|---|
| Root | `november-cicd/terraform.tfstate` |
| Development | `november-cicd/dev/terraform.tfstate` |
| Staging | `november-cicd/staging/terraform.tfstate` |
| Production | `november-cicd/prod/terraform.tfstate` |

This separation prevents one environment's Terraform state from being confused with another's.

## Jenkins CI/CD Pipeline

The Jenkins pipeline is defined in the root `Jenkinsfile`.

Jenkins is hosted on an Amazon EC2 instance and uses an attached IAM instance profile to obtain AWS permissions without storing long-lived AWS access keys in the pipeline.

### Pipeline Stages

| Stage | Description |
|---|---|
| Checkout | Retrieves source code from GitHub |
| Verify Tools and AWS Identity | Checks Terraform, AWS CLI and AWS account identity |
| Terraform Format Check | Checks formatting recursively |
| Deploy Dev | Initialises, validates, plans and applies Development infrastructure |
| Deploy Staging | Initialises, validates, plans and applies Staging infrastructure |
| Production Plan | Generates and archives the Production execution plan |
| Production Approval | Requires manual approval |
| Deploy Production | Applies the approved Production plan |

### Production Approval

Production deployment is protected by a manual approval gate.

This prevents Production infrastructure from being deployed automatically without an explicit approval decision.

The pipeline also includes:

- Build timestamps
- Concurrent build prevention
- Pipeline timeout
- Terraform automation environment variables
- Terraform plan artifact archiving
- Post-build cleanup of temporary plan files

## AWS IAM and Security

The Jenkins EC2 instance uses an IAM instance profile:

`Jenkins-EC2-Terraform-Profile`

The associated IAM role is:

`Jenkins-EC2-Terraform-Role`

The role provides the permissions needed for Terraform to manage the project infrastructure and access the remote S3 backend.

Security measures include:

- IAM role-based access for Jenkins.
- Restricted S3 access to the project state prefix.
- Separate Terraform state files for each environment.
- SSH access restricted through a configurable allowed CIDR.
- HTTP access through the application security group.
- No AWS access keys embedded in the Jenkinsfile.
- Terraform state and temporary plan files excluded from Git.

## Deployment and Validation

The following commands can be used to validate an environment locally.

For example, Development:

```powershell
cd terraform/environments/dev

terraform init

terraform fmt -check -recursive

terraform validate

terraform plan -var-file="terraform.tfvars"
```

Repeat the same process from the `staging` and `prod` directories.

To apply an environment manually, review the plan first and then run:

```powershell
terraform apply -var-file="terraform.tfvars"
```

The Jenkins pipeline handles these operations automatically according to the configured deployment stages.

## Project Demonstration Results

The project was executed through Jenkins, with the following results:

| Component | Result |
|---|---|
| GitHub source integration | Successful |
| Jenkins pipeline execution | Successful |
| AWS identity verification | Successful |
| Terraform formatting and validation | Successful |
| S3 remote state access | Successful after IAM policy correction |
| Development deployment | Successful |
| Staging deployment | Successful |
| Production planning | Successful |
| Production approval gate | Reached and approved |
| Production infrastructure deployment | Blocked by AWS VPC quota |

### Production Deployment Limitation

During the demonstration, AWS returned:

```text
VpcLimitExceeded:
The maximum number of VPCs has been reached.
```

The AWS account had reached its regional VPC quota in `us-east-1`.

As a result, Terraform could not create the additional Production VPC.

This was an AWS account service quota limitation rather than a Terraform configuration or Jenkins pipeline syntax error.

The Production configuration and deployment stage remain part of the project. Completing the deployment requires an increased VPC quota or an architectural change to reuse an existing VPC.

## Prerequisites

To reproduce this project, the following are required:

- An AWS account.
- AWS CLI installed and configured.
- Terraform CLI installed.
- Git installed.
- A GitHub repository.
- A Jenkins server running on Amazon EC2.
- An EC2 IAM instance profile with appropriate AWS permissions.
- An S3 bucket configured for Terraform remote state.
- An AWS EC2 key pair.
- Appropriate AWS service quotas for the infrastructure being provisioned.

## Running the Project

### 1. Clone the Repository

```bash
git clone https://github.com/scottobiaya/November-CICD.git

cd November-CICD
```

### 2. Configure AWS Access

For local Terraform execution, configure the AWS CLI with an authorised AWS identity.

```bash
aws configure
```

Verify the AWS identity:

```bash
aws sts get-caller-identity
```

Jenkins uses its attached EC2 IAM role instead of locally configured access keys.

### 3. Initialise Terraform

Navigate to the required environment:

```bash
cd terraform/environments/dev
```

Initialise the backend:

```bash
terraform init
```

### 4. Validate and Review

```bash
terraform fmt -check -recursive

terraform validate

terraform plan -var-file="terraform.tfvars"
```

### 5. Execute Through Jenkins

Configure the Jenkins Pipeline job to use:

- Definition: Pipeline script from SCM
- SCM: Git
- Repository: `https://github.com/scottobiaya/November-CICD.git`
- Branch: `*/main`
- Script Path: `Jenkinsfile`

Run the pipeline and monitor the individual deployment stages in Jenkins Console Output.

## Cost Management and Cleanup

AWS resources created by Terraform may incur charges while running.

Before destroying any environment, ensure that the correct Terraform state and environment are selected.

To destroy an environment manually, navigate to its directory and run:

```bash
terraform destroy -var-file="terraform.tfvars"
```

Review the proposed destruction carefully before confirming.

Do not delete the S3 backend bucket or Terraform state files while the infrastructure is still managed by Terraform.

## Key Learning Outcomes

This project provided practical experience in:

- Designing reusable Terraform modules.
- Implementing Infrastructure as Code.
- Building Jenkins declarative pipelines.
- Integrating GitHub with Jenkins.
- Automating multi-environment deployments.
- Managing remote Terraform state and locking.
- Configuring AWS IAM roles and permissions.
- Implementing manual Production approval.
- Troubleshooting AWS IAM and S3 access issues.
- Diagnosing AWS service quota limitations.
- Applying DevOps automation and infrastructure management practices.

## Author

**Scott Obiaya**

Cloud Infrastructure | AWS | Terraform | Jenkins | DevOps | Infrastructure as Code

GitHub: [scottobiaya](https://github.com/scottobiaya)

Project Repository: [November-CICD](https://github.com/scottobiaya/November-CICD)