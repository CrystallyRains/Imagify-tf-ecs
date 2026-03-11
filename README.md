# Imagify — AI SaaS Platform with Production Cloud Infrastructure

Imagify is an AI-powered image transformation SaaS platform that allows users to perform advanced generative AI operations such as image restoration, generative fill, background removal, and recoloring.

In this project, I took an existing full-stack AI SaaS application and redesigned its deployment for the cloud by implementing a **production-style DevOps and Cloud Engineering workflow**.

The application was containerized using **Docker multi-stage builds**, reducing the container size significantly, and deployed to a **fully automated AWS infrastructure using Terraform and GitHub Actions**.

This project demonstrates real-world cloud engineering practices including **Infrastructure as Code, CI/CD automation, container orchestration, and scalable AWS architecture**.

---

# Architecture Overview

User
   |
Application Load Balancer
   |
ECS Fargate Service
   |
Docker Container (Next.js App)
   |
External Services
• MongoDB
• Cloudinary
• Stripe
• Clerk

Infrastructure is provisioned entirely on **AWS** and managed through **Terraform**.

---

# Key Cloud Engineering Work

## Containerization (Docker)

The original application was containerized using **Docker multi-stage builds**.

Benefits achieved:

- Reduced final container size by ~10x
- Removed unnecessary build dependencies
- Faster CI/CD builds
- Faster container startup in ECS

Example build stages:

Stage 1 — Install dependencies  
Stage 2 — Build Next.js application  
Stage 3 — Production runtime container

---

# Infrastructure as Code (Terraform)

All infrastructure is defined and deployed using **Terraform**.

Provisioned resources include:

- VPC
- Public and Private Subnets
- Internet Gateway
- Route Tables
- Security Groups
- Application Load Balancer (ALB)
- ECS Cluster
- ECS Fargate Service
- Amazon ECR Repository
- IAM Roles and Policies

This ensures **reproducible and version-controlled infrastructure**.

---

# Terraform Remote State Management

Terraform state is stored remotely to ensure safe infrastructure management.

Backend configuration:

S3 Bucket — stores Terraform state file  
DynamoDB Table — provides state locking

Benefits:

- Prevents concurrent Terraform updates
- Enables safe infrastructure collaboration
- Protects state integrity

Backend resources are created using a **bootstrap Terraform module** located in:


infra-bootstrap/


---

# CI/CD Automation (GitHub Actions)

The project uses **three automated GitHub Actions workflows** to manage the infrastructure and application lifecycle.

## 1. Infrastructure Workflow

Triggered when Terraform files change.

Steps:


terraform init
terraform plan
terraform apply


Automatically provisions or updates the AWS infrastructure.

---

## 2. Build & Deploy Workflow

Triggered on push to the `main` branch.

Steps:


Build Docker image
Push image to Amazon ECR
Update ECS service
Trigger rolling deployment


This ensures **zero-downtime application deployments**.

---

## 3. Infrastructure Destroy Workflow

Allows automated teardown of infrastructure.


terraform destroy


Useful for avoiding unnecessary AWS costs during development.

---

# Tech Stack

### Application

- Next.js
- TypeScript
- Tailwind CSS
- MongoDB

### Cloud Infrastructure

- Amazon ECS (Fargate)
- Amazon ECR
- Application Load Balancer
- VPC
- IAM

### DevOps & Automation

- Terraform
- Docker
- GitHub Actions

### External Services

- Cloudinary
- Stripe
- Clerk Authentication

---

# Project Structure


imagify-tf-ecs
│
├── app/ # Next.js application source
├── terraform/ # Terraform infrastructure code
├── infra-bootstrap/ # Terraform backend setup (S3 + DynamoDB)
├── .github/workflows/ # CI/CD pipelines
├── Dockerfile # Multi-stage container build
└── README.md


---

# Deployment Guide

## 1. Bootstrap Terraform Backend

Create the Terraform remote state infrastructure.


cd infra-bootstrap

terraform init
terraform apply


This creates:

- S3 bucket for Terraform state
- DynamoDB table for state locking

---

## 2. Provision AWS Infrastructure


cd terraform

terraform init
terraform apply


These provisions:

- VPC
- ECS Cluster
- Application Load Balancer
- ECR repository
- IAM roles

---

## 3. Configure GitHub Secrets

Add the following repository secrets:


AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

MONGODB_URL
STRIPE_SECRET_KEY
CLOUDINARY_API_KEY
CLERK_SECRET_KEY


Public environment variables must be passed as **Docker build arguments**.

---

## 4. Deploy the Application

Push code to the main branch:


git push origin main


GitHub Actions will automatically:

1. Build the Docker image  
2. Push the image to ECR  
3. Deploy the container to ECS  

---

# Author

Snigdha Chaudhari

AWS Community Builder  
Cloud & DevOps Enthusiast
