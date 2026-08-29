# 🚀 Mini Project — Deploying a Static Website on AWS S3 Using Terraform

> **Focus:** AWS S3 + Terraform + Static Website Hosting + HTML + JavaScript + Infrastructure as Code

## 📌 Project Overview

This mini project demonstrates how to provision an **AWS S3 static website** using Terraform and deploy a browser-based **Basic Calculator** application.

The entire infrastructure and website deployment are managed through Terraform, eliminating the need to manually configure the S3 bucket and upload the website files through the AWS Console.





The project covers:

1. Creating an AWS S3 bucket using Terraform
2. Generating a unique S3 bucket name using Terraform `random_id`
3. Configuring S3 Static Website Hosting
4. Configuring `index.html` as the website entry point
5. Configuring `error.html` as the error page
6. Configuring S3 Public Access settings
7. Creating an S3 Bucket Policy for public object read access
8. Uploading HTML files to S3 using Terraform
9. Setting the correct S3 object `Content-Type`
10. Deploying a browser-based Calculator using HTML, CSS and JavaScript
11. Accessing the application through the S3 Website Endpoint
12. Troubleshooting S3 policy, object metadata and static website deployment issues

The project also documents implementation issues encountered during deployment and their resolutions, making it useful as both an **AWS S3 deployment example** and a **Terraform troubleshooting/learning reference**.

---

# 🎯 Objective

Build a repeatable AWS infrastructure deployment in which Terraform:

- Creates the S3 bucket
- Configures S3 Static Website Hosting
- Configures public access
- Creates the required bucket policy
- Uploads the website files
- Publishes the Calculator application through the S3 Website Endpoint

The final result is a publicly accessible static Calculator application where all calculations are performed directly in the user's browser using JavaScript.---

## 4. Terraform — S3 Bucket Website Creation Failure

### Error 9: Terraform — S3 Bucket Website Creation Failure

### Problem

While attempting to create an AWS S3 bucket for the static website, Terraform encountered a bucket creation failure when using a custom bucket name.

 `s3_tfProvider.tf`:

```hcl
terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}




---

# 🏗️ Expected Architecture

```text
                         Terraform
                            │
             ┌──────────────┴──────────────┐
             │                             │
        AWS S3 Bucket                Website Files
             │                             │
             │                     ┌───────┴────────┐
             │                     │                │
             │                index.html       error.html
             │                     │
             │                privacy.html
             │
     ┌───────┴────────────┐
     │                    │
Public Access       Bucket Policy
     │                    │
     └──────────┬─────────┘
                │
                ▼
       S3 Static Website
                │
                ▼
        S3 Website Endpoint
                │
                ▼
          User's Browser
                │
                ▼
       🧮 Basic Calculator
                │
         JavaScript executes
         calculations locally



