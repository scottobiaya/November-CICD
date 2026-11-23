# November AWS Infrastructure Automation with Terraform and Jenkins

## Project Overview

This project demonstrates how to automate AWS infrastructure provisioning using **Terraform, Jenkins, GitHub, and AWS IAM**.

The objective is to implement an Infrastructure as Code (IaC) workflow in which Terraform manages AWS resources, GitHub stores the project source code, and Jenkins automates the Terraform deployment process through a CI/CD pipeline.

The pipeline performs Terraform initialization, formatting checks, validation, planning, and a manual approval before applying infrastructure changes.

## Technologies Used

- **Amazon Web Services (AWS):** Cloud infrastructure
- **Terraform:** Infrastructure as Code
- **Jenkins:** CI/CD automation
- **Git and GitHub:** Source code management and version control
- **Amazon S3:** Remote Terraform state storage
- **AWS IAM:** Identity and access management
- **Amazon EC2:** Virtual server hosting Jenkins

## Project Architecture

The workflow follows this sequence:

1. Terraform configuration files are maintained in the local project repository.
2. Changes are committed and pushed to GitHub.
3. Jenkins retrieves the source code from the GitHub repository.
4. Jenkins executes the Terraform pipeline on the EC2 instance.
5. Terraform authenticates with AWS using the EC2 instance's IAM role.
6. Terraform stores its state file remotely in an Amazon S3 bucket.
7. Jenkins executes Terraform initialization, formatting, validation, and planning.
8. The pipeline archives the Terraform plan for review.
9. A manual approval is required before Terraform applies the changes.
10. Terraform applies the approved infrastructure changes to AWS.

## AWS Infrastructure

The project uses Terraform to manage the following AWS resources:

- Amazon VPC
- Public and private subnets
- Internet Gateway
- Public route table
- Route table association
- Security Group
- EC2 instance
- EC2 key pair

The infrastructure is defined as code, allowing resources to be provisioned and managed consistently.

## Terraform Remote State Management

Terraform uses an Amazon S3 backend to store its state file remotely.

The S3 backend configuration provides:

- Centralised state storage.
- Encryption at rest.
- S3 bucket versioning for state recovery.
- S3 lockfile-based state locking to help prevent concurrent state modifications.

The backend configuration is maintained in the Terraform configuration.

**Important:** Terraform state files can contain sensitive infrastructure information. They should not be committed to GitHub.

## AWS IAM Configuration

The Jenkins EC2 instance uses an IAM instance profile to obtain temporary AWS credentials.

The IAM configuration consists of:

### 1. IAM Role

An IAM role named:

`Jenkins-EC2-Terraform-Role`

This role is trusted by the EC2 service and allows the EC2 instance to assume the role.

### 2. IAM Policies

The role has the required managed policies attached to provide permissions for Terraform operations.

These include permissions for:

- Managing the required EC2 resources.
- Managing the required networking resources.
- Accessing the S3 bucket used for Terraform remote state.

### 3. IAM Instance Profile

The instance profile:

`Jenkins-EC2-Terraform-Profile`

contains the IAM role and is attached to the Jenkins EC2 instance.

This allows Jenkins and Terraform to authenticate with AWS without storing long-term AWS access keys on the EC2 server.

## Jenkins Configuration

Jenkins is installed on an Amazon Linux EC2 instance.

The Jenkins server runs the tools required for the pipeline, including:

- Java
- Git
- Terraform
- AWS CLI

Jenkins retrieves the project from GitHub and executes the pipeline defined in the root-level `Jenkinsfile`.

### Jenkins Credentials

The following credentials are configured in Jenkins:

**1. GitHub Repository Credential**

Used to authenticate Jenkins with the GitHub repository over HTTPS.

**2. Terraform Public Key Credential**

- Credential type: Secret text
- Credential ID: `terraform-public-key`
- Purpose: Supplies the SSH public key to Terraform securely during the pipeline execution.

The credential is exposed to Terraform through the environment variable:

`TF_VAR_public_key`

Terraform automatically maps this environment variable to the input variable `public_key`.

The SSH public key is used by Terraform when managing the AWS EC2 key pair resource.

No private SSH key is stored in this Jenkins credential.

## Jenkins CI/CD Pipeline

The pipeline is defined in the `Jenkinsfile`.

It contains the following stages:

| Stage | Description |
|---|---|
| Checkout | Retrieves the latest source code from GitHub. |
| Verify Tools and AWS Identity | Checks Terraform and confirms the AWS identity used by Jenkins. |
| Terraform Init | Initialises Terraform and configures the S3 backend. |
| Terraform Format Check | Checks Terraform files for consistent formatting. |
| Terraform Validate | Checks the Terraform configuration for errors. |
| Terraform Plan | Generates an execution plan showing proposed infrastructure changes. |
| Approval | Pauses the pipeline for manual approval before applying changes. |
| Terraform Apply | Applies the approved Terraform execution plan. |

### Manual Approval

The pipeline includes a manual approval stage to prevent Terraform from applying infrastructure changes automatically.

Before proceeding, the user reviews the generated Terraform plan.

The user can either:

- Approve the deployment by selecting **Yes, apply**.
- Stop the deployment by selecting **Abort**.

This provides an additional control before infrastructure changes are made.

## Project Structure

The repository is organised as follows:

```text
November/
│
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   └── .terraform.lock.hcl
│
├── Jenkinsfile
├── README.md
└── .gitignore
```

### Terraform Files

| File | Purpose |
|---|---|
| `main.tf` | Defines the AWS infrastructure resources. |
| `provider.tf` | Configures the AWS provider and region. |
| `variables.tf` | Defines input variables used by Terraform. |
| `outputs.tf` | Defines useful Terraform output values. |
| `versions.tf` | Specifies Terraform and provider version requirements and backend configuration. |
| `.terraform.lock.hcl` | Records the selected provider versions. |

### Other Files

- `Jenkinsfile`: Defines the Jenkins declarative pipeline.
- `.gitignore`: Excludes sensitive files, Terraform state files, and temporary files from Git.
- `README.md`: Provides project documentation.

## Prerequisites

Before reproducing this project, the following are required:

- An AWS account.
- An EC2 instance running Amazon Linux.
- An IAM role with the required Terraform permissions.
- An IAM instance profile attached to the EC2 instance.
- Jenkins installed and configured.
- Git installed on the Jenkins server.
- Terraform installed on the Jenkins server.
- AWS CLI installed on the Jenkins server.
- A GitHub repository.
- Jenkins credentials configured for GitHub and the Terraform public key.

## Running the Project

### Step 1: Clone the Repository

```bash
git clone https://github.com/scottobiaya/November-CICD.git
```

### Step 2: Navigate to the Project

```bash
cd November-CICD
```

### Step 3: Initialise Terraform

```bash
cd terraform
terraform init
```

### Step 4: Check Terraform Formatting

```bash
terraform fmt -recursive
```

### Step 5: Validate the Configuration

```bash
terraform validate
```

### Step 6: Generate a Terraform Plan

The public key variable must be supplied when running Terraform independently, for example through a securely configured `TF_VAR_public_key` environment variable.

```bash
terraform plan
```

### Step 7: Run the Jenkins Pipeline

In Jenkins:

1. Open the configured November CI/CD job.
2. Select **Build Now**.
3. Open the running build.
4. Monitor the pipeline stages in Console Output.
5. Review the generated Terraform plan.
6. Approve or abort the deployment when prompted.

## Security Considerations

Security is an important part of this project.

The following practices are implemented:

- AWS permissions are assigned through IAM roles rather than hardcoded access keys.
- The EC2 instance accesses AWS using its attached IAM instance profile.
- Terraform state is stored remotely in Amazon S3.
- S3 bucket versioning is enabled.
- Sensitive Terraform variables are supplied through Jenkins credentials.
- The SSH public key is not hardcoded into the Terraform configuration.
- Git ignores Terraform state files, private keys, and sensitive configuration files.
- A manual approval stage is included before Terraform applies changes.

**Never commit the following files to GitHub:**

- `terraform.tfstate`
- `terraform.tfstate.backup`
- `.tfvars` files containing secrets
- Private SSH keys (`.pem`)
- AWS access keys and secret access keys
- Jenkins credentials or tokens

## Project Outcome

The project successfully demonstrates an automated Infrastructure as Code deployment workflow using Terraform and Jenkins.

The pipeline successfully:

- Connects to the GitHub repository.
- Authenticates with AWS through the EC2 IAM role.
- Initialises Terraform with the S3 remote backend.
- Performs Terraform formatting and validation checks.
- Generates a Terraform execution plan.
- Archives the plan for review.
- Pauses for manual approval before applying infrastructure changes.

This project demonstrates practical experience with AWS infrastructure automation, Terraform, IAM, remote state management, GitHub integration, and Jenkins CI/CD pipelines.

## Future Improvements

Potential improvements include:

- Introducing automated testing and security scanning.
- Integrating Terraform security tools such as Checkov or tfsec.
- Adding automated notifications for pipeline success or failure.
- Introducing separate development, staging, and production environments.
- Implementing more restrictive IAM permissions following least-privilege principles.
- Integrating additional monitoring and logging.

## Author

**Scott Obiaya**

Cloud Infrastructure | AWS | Terraform | Jenkins | Infrastructure as Code | CI/CD

GitHub: https://github.com/scottobiaya