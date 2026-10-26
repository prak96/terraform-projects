# 🚀 Mini Project — Deploying AWS EC2 Using Terraform Data Sources

**Focus:** AWS EC2 + Terraform + Data Sources + Multi-Region Providers + Ubuntu + Infrastructure as Code

## 📌 Project Overview

This mini project demonstrates how to provision an AWS EC2 instance using **Terraform Data Sources** to dynamically discover existing AWS infrastructure and configuration instead of hard-coding values such as AMI IDs, VPC IDs, Availability Zones, or regions. 

The project focuses on an important Terraform concept:

> **Resources create/manage infrastructure, while Data Sources read/discover existing infrastructure information.** 

The implementation covers:

* AWS EC2 provisioning with Terraform
* Terraform Data Sources
* Dynamic Ubuntu 22.04 AMI discovery
* Existing VPC discovery using tags
* Availability Zone discovery
* AWS Region and Caller Identity discovery
* Multiple AWS provider configurations
* Provider aliases for multi-region deployments
* Explicit region assignment to Data Sources and resources
* EC2 networking and storage configuration
* AWS Key Pair configuration
* Windows EC2 password-retrieval concepts
* Terraform troubleshooting
* Secure handling of sensitive variables

---

## 🎯 Objective

The primary objective was to build a **repeatable and dynamic Terraform deployment** where AWS infrastructure information is discovered at runtime rather than manually entered. 

The project demonstrates how Terraform can:

1. Query existing AWS infrastructure
2. Dynamically identify an appropriate AMI
3. Work across multiple AWS regions
4. Reuse existing networking resources
5. Pass discovered values into Terraform resources
6. Troubleshoot provider and regional configuration issues

---

## 🏗️ Architecture

```text
                         Terraform
                             │
              ┌──────────────┴──────────────┐
              │                             │
       AWS Data Sources              AWS Providers
              │                             │
      ┌───────┼────────┐            ┌───────┴───────┐
      │       │        │            │               │
     AMI     VPC      AZs        us-east-1      eu-west-1
                                  eastus          westeu
      │       │        │            │               │
      └───────┼────────┘            └───────┬───────┘
              │                             │
              ▼                             ▼
       Dynamically discovered       Regional AWS access
       AWS infrastructure
              │
              ▼
       Windows Server 2022 EC2 Instance
       Ubuntu EC2 Instance (commented OUT)
              │
       ┌──────┼──────────┐
       │      │          │
      VPC   Subnet   Security Group
              │
              ▼
        Running EC2 VM
```

The architecture combines **Data Sources for discovery** with **provider aliases for regional control**, allowing Terraform to query the correct AWS environment before provisioning the EC2 instance. 

---

## 📁 Project Structure

```text
003-terraform-aws-data-sources/
│
├── .gitignore
├── .terraform.lock.hcl
│
├── ds_tfProvider.tf
├── ds_tfInstance.tf
├── ds_tfNetwork.tf
├── ds_tfOutput.tf
└── ds_tfVariables.tf
```

### `ds_tfProvider.tf`

Contains Terraform version requirements, AWS provider configuration, and regional provider aliases. 

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "eastus"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "westeu"
}
```

This allows Terraform to explicitly target different AWS regions.

### `ds_tfInstance.tf`

Contains:

* AWS Data Sources
* Ubuntu AMI discovery
* Existing VPC lookup
* Availability Zone lookup
* EC2 instance configuration 

### `ds_tfNetwork.tf`

Contains the networking configuration required by the EC2 deployment, including subnet and security-group components. 

### `ds_tfOutput.tf`

Provides useful discovered information such as:

* AWS Caller Identity
* AWS Region
* VPC ID
* Windows AMI ID (Also mentioned Ubuntu AMI ID which is commented out)
* Availability Zones 

### `ds_tfVariables.tf`

Contains Terraform variables used by the deployment, including configuration associated with EC2 and Windows-instance credentials where applicable. 

---

# 🔎 Terraform Data Sources

One of the central goals of this project was understanding how Terraform can **read information from AWS without creating the corresponding resource**. 

## 🐧 1.1 Ubuntu AMI Data Source

Instead of hard-coding an AMI ID, Terraform searches AWS for the latest matching Ubuntu 22.04 image:

```hcl
data "aws_ami" "ubuntu_eu" {
  most_recent = true
  owners      = ["099720109477"]

  provider = aws.westeu

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

The dynamically discovered AMI is then passed into the EC2 resource:

```hcl
resource "aws_instance" "Ubuntu-VM" {
  ami           = data.aws_ami.ubuntu_eu.id
  instance_type = "t2.micro"
  provider      = aws.westeu
}
```

## 🐧 1.2 Windows AMI Data Source

Instead of hard-coding an AMI ID, Terraform searches AWS for the latest matching Ubuntu 22.04 image:

```hcl
data "aws_ami" "winserv_eu" {

  most_recent = true
  owners      = ["amazon"]
  provider    = aws.westeu 

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
}
```

The dynamically discovered AMI is then passed into the EC2 resource:

```hcl
resource "aws_instance" "WinServ-VM" {
  ami           = data.aws_ami.winserv_eu.id
  instance_type = "t2.micro"
  provider      = aws.westeu
}
```

This removes the need to maintain a hard-coded AMI ID. 

---

## 🌐 2. Existing VPC Data Source

Terraform can query an already-existing VPC using its tags:

```hcl
data "aws_vpc" "test_vpc" {
  tags = {
    Env = "testenv"
  }

  provider = aws.westeu
}
```

This demonstrates how existing AWS infrastructure can be reused instead of recreated. 

---

## 🌍 3. Availability Zones

```hcl
data "aws_availability_zones" "az_available" {
  provider = aws.westeu
  state    = "available"
}
```

Terraform dynamically retrieves the currently available Availability Zones in the selected region. 

---

## 🗺️ 4. AWS Region

```hcl
data "aws_region" "current" {}
```

## 👤 5. AWS Caller Identity

```hcl
data "aws_caller_identity" "current" {}
```

Together, these Data Sources allow Terraform to discover important AWS environment and account information dynamically. 

---

# ⚙️ Deployment Flow

```text
Configure Terraform
        ↓
Configure AWS Providers
        ↓
Configure Regional Provider Aliases
        ↓
Query AWS Data Sources
        ↓
Discover Ubuntu AMI
        ↓
Discover Existing VPC
        ↓
Discover Availability Zones
        ↓
Discover AWS Region
        ↓
Discover Caller Identity
        ↓
Provision EC2 Instance
        ↓
Attach Networking & Storage
        ↓
Access EC2 Instance
```



---

The important workflow is:

```text
AWS AMI Data Source
        ↓
Latest matching Ubuntu AMI
        ↓
AMI ID
        ↓
aws_instance
        ↓
Ubuntu/Windows EC2 Instance
```

The AMI ID therefore remains dynamically discovered rather than being permanently embedded in the EC2 configuration. 

---

# 🪟 Windows EC2 Exploration

The project also explores the differences between Linux and Windows EC2 authentication.

For Windows EC2, the configuration demonstrates using an **RSA key pair** together with:

```hcl
key_name          = aws_key_pair.windows_key.key_name
get_password_data = true
```

Terraform can retrieve the encrypted Windows Administrator password data, which can then be decrypted using the corresponding RSA private key in the documented lab approach. 

> **Key distinction:** Linux EC2 commonly uses SSH keys, while Windows EC2 uses the AWS-generated encrypted Administrator password workflow.

---

# 🧪 Challenges & Troubleshooting

A major part of this project was not just deploying infrastructure, but **breaking, diagnosing and fixing real Terraform configuration issues**. 

## ❌ Challenge 1 — AMI Data Source Failure

### Problem

The initial AMI Data Source filter was too restrictive and did not match the available Ubuntu AMI naming convention.

### Fix

The filter was changed to a wildcard-based Ubuntu 22.04 pattern:

```hcl
values = [
  "ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"
]
```

### Result

Terraform successfully discovered the latest matching Ubuntu AMI without requiring a hard-coded AMI ID. 

---

## ❌ Challenge 2 — Multiple AWS Providers

### Error

```text
Error: Invalid provider configuration

Provider "registry.terraform.io/hashicorp/aws"
requires explicit configuration.

Error: invalid AWS Region
```

### Root Cause

Multiple aliased AWS providers had been configured, but a **default AWS provider configuration was missing**. 

### Fix

A default provider was added:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

alongside:

```hcl
provider "aws" {
  region = "us-east-1"
  alias  = "eastus"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "westeu"
}
```

### Result

Terraform could correctly distinguish between the default provider and the explicitly aliased regional providers. 

---

## ❌ Challenge 3 — VPC Data Source Could Not Find Existing VPC

### Problem

Terraform could not retrieve an existing VPC.

### Root Cause

The VPC existed in:

```text
eu-west-1
```

while the default provider was configured for:

```text
us-east-1
```

Terraform therefore queried the wrong region. 

### Resolution

The Data Source was explicitly associated with the correct provider:

```hcl
data "aws_vpc" "test_vpc" {
  tags = {
    Env = "testenv"
  }

  provider = aws.westeu
}
```

### Result

Terraform successfully retrieved the existing VPC from `eu-west-1`. 

> **Important multi-region lesson:** A Data Source does not magically search every AWS region. It queries AWS through the provider configuration assigned to it.

---

# 🧠 Key Terraform Learning — Resource vs Data Source

This project reinforced one of the most important Terraform concepts:

| Terraform Object | Purpose                                  |
| ---------------- | ---------------------------------------- |
| `resource`       | Creates and manages infrastructure       |
| `data`           | Reads and discovers existing information |

For example:

```hcl
data "aws_ami" "ubuntu_eu" {
  # Query AWS for an existing AMI
}
```

This **does not create an AMI**.

Instead, Terraform queries AWS and retrieves information about an existing AMI:

```text
AWS
 │
 └── Existing AMI
          ↑
          │
     Data Source
          │
          ▼
       AMI ID
          │
          ▼
    EC2 Resource
```

```hcl
resource "aws_instance" "Ubuntu-VM" {
  ami = data.aws_ami.ubuntu_eu.id
}
```

This makes infrastructure configuration more dynamic and reusable. 

---

# 🌎 Multi-Region Terraform

Provider aliases were another major learning point.

```text
                    Terraform
                        │
                   AWS Provider
                        │
              ┌─────────┴─────────┐
              │                   │
          us-east-1           eu-west-1
           eastus              westeu
              │                   │
              ▼                   ▼
       AWS Data Sources     AWS Data Sources
```

A resource or Data Source can explicitly select the required provider:

```hcl
provider = aws.westeu
```

This becomes particularly important when infrastructure is distributed across multiple AWS regions. 

---

# 🔐 Credential Management

The project also demonstrates keeping sensitive Terraform configuration outside version control.

Sensitive configuration can be placed in:

```text
terraform.tfvars
```

and excluded through:

```text
.gitignore
```

This helps prevent credentials or sensitive configuration from accidentally being committed to Git. 

> **Best practice:** Never commit AWS credentials, private keys, Terraform state containing sensitive values, or other secrets to a public repository.

---

# 🚀 Terraform Commands

### Initialize

```bash
terraform init
```

### Upgrade providers

```bash
terraform init -upgrade
```

### Format

```bash
terraform fmt
```

### Validate

```bash
terraform validate
```

### Review plan

```bash
terraform plan
```

### Deploy

```bash
terraform apply
```

### Destroy Terraform-managed infrastructure

```bash
terraform destroy
```

These commands form the basic Terraform workflow used throughout the project. 

---

# 🔄 End-to-End Workflow

```text
Developer
    │
    ▼
Terraform Configuration
    │
    ▼
Terraform
    │
    ├── AWS Provider
    │
    ├── Regional Provider Aliases
    │
    ├── AMI Data Source
    │
    ├── VPC Data Source
    │
    ├── Availability Zone Data Source
    │
    ├── Region Data Source
    │
    └── Caller Identity Data Source
    │
    ▼
AWS Environment
    │
    ├── Existing VPC
    ├── Existing AMI
    ├── Availability Zones
    └── AWS Account / Region Information
    │
    ▼
Terraform EC2 Resource
    │
    ├── Ubuntu AMI
    ├── Subnet
    ├── Security Group
    └── Storage
    │
    ▼
🖥️ AWS EC2 Instance
```



---

# 🎓 Key Takeaways

This project provided hands-on experience with:

* ☁️ AWS EC2
* 🏗️ Terraform Infrastructure as Code
* 🔎 Terraform Data Sources
* 🐧 Ubuntu 22.04 AMI discovery
* 🌐 AWS VPC Data Sources
* 🌍 Availability Zone discovery
* 🗺️ AWS Region Data Sources
* 👤 AWS Caller Identity
* 🔀 Multi-region AWS providers
* 🔗 Provider aliases
* ♻️ Dynamic resource references
* 🖥️ Linux EC2 deployment
* 🪟 Windows EC2 deployment concepts
* 🔑 AWS Key Pairs
* 🔐 Windows password retrieval
* 📦 Terraform variables
* 🔒 Sensitive variable management
* 🛡️ `.gitignore` and credential protection
* 🧪 Terraform troubleshooting
* 🌎 AWS regional troubleshooting



---

# 🏁 Final Result

The project successfully demonstrates an **Infrastructure-as-Code workflow where Terraform dynamically discovers AWS infrastructure through Data Sources and uses that information to provision an EC2 instance**.

More importantly, it demonstrates practical troubleshooting around:

```text
Data Sources
     +
Provider Aliases
     +
Multi-Region Configuration
     +
Dynamic AMI Discovery
     +
Existing VPC Reuse
     +
EC2 Provisioning
     +
Troubleshooting
```

The result is a more **dynamic, reusable and region-aware Terraform configuration**, rather than one dependent on manually hard-coded AWS infrastructure values. 

---

# 💡 What This Project Taught Me

> **Don't hard-code what AWS can tell Terraform dynamically.**

The biggest takeaway from this project was understanding how **Terraform Data Sources + Provider Aliases + Resource References** can be combined to build infrastructure that adapts to the target AWS environment.

```text
Discover → Reference → Provision → Troubleshoot → Improve
```

This project also reinforced a practical Infrastructure-as-Code mindset:

> **Learn → Build → Break → Troubleshoot → Automate → Repeat.**

---

# 🛠️ Technology Stack

| Category        | Technologies                                      |
| --------------- | ------------------------------------------------- |
| Cloud           | AWS                                               |
| Compute         | EC2                                               |
| IaC             | Terraform                                         |
| OS              | Ubuntu 22.04 / Windows Server concepts            |
| Networking      | VPC, Subnets, Security Groups, Availability Zones |
| Identity        | AWS Caller Identity                               |
| Storage         | EBS / gp3                                         |
| Authentication  | AWS Key Pairs                                     |
| Version Control | Git / GitHub                                      |
| Configuration   | Terraform Variables / `.tfvars`                   |

---
