# Imagify - Production Deployment with Terraform, ECS & CI/CD

This project demonstrates how to **take an AI SaaS application and deploy it to AWS using production-style infrastructure and CI/CD automation**.

The application is containerized using **multi-stage Docker builds** and deployed on **Amazon ECS**, with the entire infrastructure provisioned using **Terraform** and automated via **GitHub Actions**.

The goal of this project is to replicate a **real-world cloud deployment pipeline**, covering infrastructure provisioning, container registry management, automated deployment, and secure secret handling.

---

# Architecture Overview

The deployment uses the following AWS services:

- Amazon ECS (Fargate) - runs the containerized application
- Amazon ECR - stores Docker images
- Application Load Balancer (ALB) - exposes the application publicly
- VPC + Subnets - networking layer
- Security Groups - network access control
- IAM Roles & Policies - permissions for ECS and CI/CD
- S3 - Terraform remote backend for state management
- AWS Systems Manager Parameter Store (SSM) - stores infrastructure outputs for CI/CD
- GitHub Actions - CI/CD automation

---

# Key DevOps Features

## Infrastructure as Code

All infrastructure is defined using **Terraform**, including:

- VPC and networking
- ECS Cluster and Service
- Application Load Balancer
- ECR repository
- IAM roles and policies
- Security groups
- SSM parameters
- Terraform remote state backend

---

## CI/CD Automation

The project includes **three GitHub Actions workflows**.

### 1. Infrastructure Provisioning

Workflow: `.github/workflows/infra.yml`

Triggered when Terraform files change.

Responsibilities:

- Initialize Terraform
- Plan infrastructure changes
- Apply infrastructure
- Store critical infrastructure outputs in **SSM Parameter Store**

Values stored in SSM:


/imagify/dev/ecr_repository_url
/imagify/dev/ecs_cluster
/imagify/dev/ecs_service


This allows later workflows to **retrieve infrastructure values dynamically without re-running Terraform**.

---

### 2. Build & Deploy Application

Workflow: `.github/workflows/deploy.yml`

Triggered when application code changes.

Steps:

1. Retrieve infrastructure values from **SSM Parameter Store**
2. Build Docker image using **multi-stage Docker build**
3. Tag image with the **Git commit SHA**
4. Push image to **Amazon ECR**
5. Trigger **ECS rolling deployment**
6. Output the **Application Load Balancer URL**

Each deployment uses a **unique image tag**, ensuring full traceability.

---

### 3. Infrastructure Teardown

Workflow: `.github/workflows/destroy.yml`

This workflow is **manual only** and requires typing `"destroy"` as confirmation.

Steps:

1. Empty ECR repository images
2. Empty Terraform state bucket
3. Run `terraform destroy`
4. Remove infrastructure parameters from SSM

This ensures **clean infrastructure teardown without orphaned resources**.

---

# Secure Secret Management

Application secrets are **never stored in the repository**.

Instead:

1. Secrets are stored in **GitHub Actions Secrets**
2. These secrets are passed to Terraform during `terraform apply`
3. Terraform writes required values to **AWS Systems Manager Parameter Store**

Example secrets used:

- MongoDB connection string
- Clerk authentication keys
- Cloudinary credentials
- Stripe API keys

This approach ensures:

- Secrets remain secure
- Infrastructure outputs are decoupled from CI/CD workflows
- Deployments remain reproducible

---

# Docker Optimization

The application container is built using a **multi-stage Docker build**.

Benefits:

- Removes unnecessary build dependencies
- Significantly reduces final image size
- Faster deployments and smaller ECR storage footprint

This reduced the image size by **~10x compared to a naive Docker build**.

---

# Deployment Flow


Developer pushes code to GitHub
│
▼
GitHub Actions (infra.yml)
Provision AWS infrastructure via Terraform
│
▼
Infrastructure outputs saved to SSM
│
▼
GitHub Actions (deploy.yml)
Build Docker image
Push to Amazon ECR
Update ECS Service
│
▼
ECS pulls new image
Rolling deployment
│
▼
Application available via ALB


---

# Repository Structure


imagify-tf-ecs
│
├── terraform/ # Infrastructure as Code
│
├── .github/workflows
│ ├── infra.yml # Terraform provisioning
│ ├── deploy.yml # Build and deploy app
│ └── destroy.yml # Destroy infrastructure
│
├── Dockerfile # Multi-stage Docker build
│
└── application code


---

# What This Project Demonstrates

This project showcases real-world **Cloud Engineer / DevOps practices**:

- Infrastructure as Code using Terraform
- CI/CD pipelines using GitHub Actions
- Containerization with Docker
- AWS container orchestration using ECS
- Secure secret management
- Automated infrastructure lifecycle
- Production-style deployment architecture
