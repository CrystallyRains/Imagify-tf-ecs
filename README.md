# Imagify - Terraform, ECS & CI/CD Deployment

This project demonstrates how to **deploy an AI SaaS application to AWS using Infrastructure as Code and CI/CD automation**.

The application is containerized using **multi-stage Docker builds** and deployed on **Amazon ECS**, with the entire infrastructure provisioned using **Terraform** and automated via **GitHub Actions**.

The goal of this project is to replicate a **real-world cloud deployment workflow**, covering infrastructure provisioning, container registry management, automated deployment, and secure secret handling.

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
- GitHub Actions

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Imagify — TF ECS Architecture</title>
<style>
  body {
    margin: 0;
    padding: 24px;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    background: #ffffff;
    color: #1a1a1a;
  }
  svg text { font-family: inherit; }
  .th { font-size: 14px; font-weight: 500; fill: #1a1a1a; }
  .ts { font-size: 12px; font-weight: 400; fill: #555550; }
  .t  { font-size: 14px; font-weight: 400; fill: #1a1a1a; }
  .arr { stroke: #888780; stroke-width: 1.5; fill: none; }
  .leader { stroke: #888780; stroke-width: 0.5; stroke-dasharray: 4 3; fill: none; }
  .box { fill: #f1efe8; stroke: #b4b2a9; }

  /* c-purple */
  .c-purple rect, .c-purple circle, .c-purple ellipse { fill: #EEEDFE; stroke: #534AB7; }
  .c-purple .th { fill: #3C3489; }
  .c-purple .ts { fill: #534AB7; }

  /* c-teal */
  .c-teal rect, .c-teal circle, .c-teal ellipse { fill: #E1F5EE; stroke: #0F6E56; }
  .c-teal .th { fill: #085041; }
  .c-teal .ts { fill: #0F6E56; }

  /* c-blue */
  .c-blue rect, .c-blue circle, .c-blue ellipse { fill: #E6F1FB; stroke: #185FA5; }
  .c-blue .th { fill: #0C447C; }
  .c-blue .ts { fill: #185FA5; }

  /* c-gray */
  .c-gray rect, .c-gray circle, .c-gray ellipse { fill: #F1EFE8; stroke: #5F5E5A; }
  .c-gray .th { fill: #444441; }
  .c-gray .ts { fill: #5F5E5A; }

  @media (prefers-color-scheme: dark) {
    body { background: #1c1c1a; color: #e0ddd4; }
    .th { fill: #e0ddd4; }
    .ts { fill: #9c9a92; }
    .t  { fill: #e0ddd4; }
    .c-purple rect, .c-purple circle, .c-purple ellipse { fill: #3C3489; stroke: #AFA9EC; }
    .c-purple .th { fill: #CECBF6; }
    .c-purple .ts { fill: #AFA9EC; }
    .c-teal rect, .c-teal circle, .c-teal ellipse { fill: #085041; stroke: #5DCAA5; }
    .c-teal .th { fill: #9FE1CB; }
    .c-teal .ts { fill: #5DCAA5; }
    .c-blue rect, .c-blue circle, .c-blue ellipse { fill: #0C447C; stroke: #85B7EB; }
    .c-blue .th { fill: #B5D4F4; }
    .c-blue .ts { fill: #85B7EB; }
    .c-gray rect, .c-gray circle, .c-gray ellipse { fill: #444441; stroke: #B4B2A9; }
    .c-gray .th { fill: #D3D1C7; }
    .c-gray .ts { fill: #B4B2A9; }
    .arr { stroke: #888780; }
  }
</style>
</head>
<body>
<svg width="100%" viewBox="0 0 680 980" xmlns="http://www.w3.org/2000/svg">
<defs>
  <marker id="arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
    <path d="M2 1L8 5L2 9" fill="none" stroke="context-stroke" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
  </marker>
</defs>

<text class="th" x="340" y="26" text-anchor="middle">Imagify — AWS ECS deployment architecture</text>

<!-- LEGEND -->
<rect x="40" y="40" width="8" height="8" rx="2" fill="#534AB7" opacity="0.7"/>
<text class="ts" x="54" y="49">CI/CD (GitHub Actions)</text>
<rect x="170" y="40" width="8" height="8" rx="2" fill="#0F6E56" opacity="0.7"/>
<text class="ts" x="184" y="49">AWS infrastructure</text>
<rect x="290" y="40" width="8" height="8" rx="2" fill="#3C3489" opacity="0.7"/>
<text class="ts" x="304" y="49">Secrets / config</text>
<rect x="410" y="40" width="8" height="8" rx="2" fill="#185FA5" opacity="0.7"/>
<text class="ts" x="424" y="49">Networking</text>

<!-- CI/CD ZONE -->
<rect x="30" y="62" width="620" height="248" rx="14" fill="none" stroke="#AFA9EC" stroke-width="1" stroke-dasharray="6 4"/>
<text class="ts" x="46" y="78" fill="#534AB7">GitHub Actions CI/CD</text>

<g class="c-purple">
  <rect x="46" y="88" width="170" height="56" rx="8" stroke-width="0.5"/>
  <text class="th" x="131" y="110" text-anchor="middle" dominant-baseline="central">infra.yml</text>
  <text class="ts" x="131" y="130" text-anchor="middle" dominant-baseline="central">Terraform plan + apply</text>
</g>
<g class="c-purple">
  <rect x="255" y="88" width="170" height="56" rx="8" stroke-width="0.5"/>
  <text class="th" x="340" y="110" text-anchor="middle" dominant-baseline="central">deploy.yml</text>
  <text class="ts" x="340" y="130" text-anchor="middle" dominant-baseline="central">Build, push &amp; deploy</text>
</g>
<g class="c-purple">
  <rect x="464" y="88" width="170" height="56" rx="8" stroke-width="0.5"/>
  <text class="th" x="549" y="110" text-anchor="middle" dominant-baseline="central">destroy.yml</text>
  <text class="ts" x="549" y="130" text-anchor="middle" dominant-baseline="central">Manual teardown</text>
</g>

<!-- Deploy steps -->
<g class="c-gray">
  <rect x="46" y="180" width="120" height="44" rx="6" stroke-width="0.5"/>
  <text class="th" x="106" y="196" text-anchor="middle" dominant-baseline="central">Read SSM</text>
  <text class="ts" x="106" y="214" text-anchor="middle" dominant-baseline="central">Fetch infra values</text>
</g>
<g class="c-gray">
  <rect x="186" y="180" width="130" height="44" rx="6" stroke-width="0.5"/>
  <text class="th" x="251" y="196" text-anchor="middle" dominant-baseline="central">Docker build</text>
  <text class="ts" x="251" y="214" text-anchor="middle" dominant-baseline="central">Multi-stage image</text>
</g>
<g class="c-gray">
  <rect x="336" y="180" width="120" height="44" rx="6" stroke-width="0.5"/>
  <text class="th" x="396" y="196" text-anchor="middle" dominant-baseline="central">Push to ECR</text>
  <text class="ts" x="396" y="214" text-anchor="middle" dominant-baseline="central">Tag: Git SHA</text>
</g>
<g class="c-gray">
  <rect x="476" y="180" width="130" height="44" rx="6" stroke-width="0.5"/>
  <text class="th" x="541" y="196" text-anchor="middle" dominant-baseline="central">ECS deploy</text>
  <text class="ts" x="541" y="214" text-anchor="middle" dominant-baseline="central">Rolling update</text>
</g>
<line x1="166" y1="202" x2="184" y2="202" class="arr" marker-end="url(#arrow)" stroke="#888780"/>
<line x1="316" y1="202" x2="334" y2="202" class="arr" marker-end="url(#arrow)" stroke="#888780"/>
<line x1="456" y1="202" x2="474" y2="202" class="arr" marker-end="url(#arrow)" stroke="#888780"/>
<line x1="340" y1="144" x2="340" y2="180" stroke="#AFA9EC" stroke-width="1" stroke-dasharray="4 3" fill="none" marker-end="url(#arrow)"/>

<!-- SECRETS ZONE -->
<rect x="30" y="328" width="620" height="72" rx="10" fill="none" stroke="#AFA9EC" stroke-width="1" stroke-dasharray="4 3"/>
<text class="ts" x="46" y="344" fill="#3C3489">Secrets &amp; config</text>

<g class="c-purple">
  <rect x="46" y="350" width="170" height="40" rx="6" stroke-width="0.5"/>
  <text class="th" x="131" y="364" text-anchor="middle" dominant-baseline="central">GitHub Secrets</text>
  <text class="ts" x="131" y="380" text-anchor="middle" dominant-baseline="central">Mongo, Clerk, Stripe…</text>
</g>
<g class="c-purple">
  <rect x="255" y="350" width="200" height="40" rx="6" stroke-width="0.5"/>
  <text class="th" x="355" y="364" text-anchor="middle" dominant-baseline="central">SSM Parameter Store</text>
  <text class="ts" x="355" y="380" text-anchor="middle" dominant-baseline="central">Infra outputs from Terraform</text>
</g>
<g class="c-purple">
  <rect x="484" y="350" width="150" height="40" rx="6" stroke-width="0.5"/>
  <text class="th" x="559" y="364" text-anchor="middle" dominant-baseline="central">S3 backend</text>
  <text class="ts" x="559" y="380" text-anchor="middle" dominant-baseline="central">Terraform remote state</text>
</g>

<path d="M131 144 L131 318 L355 318 L355 350" fill="none" stroke="#AFA9EC" stroke-width="1" stroke-dasharray="4 3" marker-end="url(#arrow)"/>
<path d="M106 224 L106 318 L355 318" fill="none" stroke="#AFA9EC" stroke-width="1" stroke-dasharray="3 3"/>
<path d="M131 350 L131 310 L131 144" fill="none" stroke="#7F77DD" stroke-width="0.8" stroke-dasharray="3 3" marker-end="url(#arrow)"/>
<path d="M216 116 L559 116 L559 350" fill="none" stroke="#AFA9EC" stroke-width="1" stroke-dasharray="4 3" marker-end="url(#arrow)"/>

<!-- AWS INFRA ZONE -->
<rect x="30" y="422" width="620" height="530" rx="14" fill="none" stroke="#5DCAA5" stroke-width="1" stroke-dasharray="6 4"/>
<text class="ts" x="46" y="438" fill="#0F6E56">AWS infrastructure (Terraform)</text>

<!-- VPC -->
<rect x="46" y="450" width="588" height="490" rx="10" fill="none" stroke="#9FE1CB" stroke-width="0.8" stroke-dasharray="5 3"/>
<text class="ts" x="62" y="466" fill="#0F6E56">VPC + subnets + security groups</text>

<g class="c-teal">
  <rect x="62" y="474" width="130" height="44" rx="6" stroke-width="0.5"/>
  <text class="th" x="127" y="490" text-anchor="middle" dominant-baseline="central">IAM roles</text>
  <text class="ts" x="127" y="508" text-anchor="middle" dominant-baseline="central">ECS + CI/CD policies</text>
</g>
<g class="c-teal">
  <rect x="62" y="538" width="130" height="44" rx="6" stroke-width="0.5"/>
  <text class="th" x="127" y="554" text-anchor="middle" dominant-baseline="central">Amazon ECR</text>
  <text class="ts" x="127" y="572" text-anchor="middle" dominant-baseline="central">Docker image registry</text>
</g>

<g class="c-blue">
  <rect x="260" y="474" width="160" height="44" rx="6" stroke-width="0.5"/>
  <text class="th" x="340" y="490" text-anchor="middle" dominant-baseline="central">App Load Balancer</text>
  <text class="ts" x="340" y="508" text-anchor="middle" dominant-baseline="central">Public HTTPS endpoint</text>
</g>

<!-- ECS Cluster -->
<rect x="250" y="538" width="400" height="170" rx="10" fill="none" stroke="#9FE1CB" stroke-width="0.8" stroke-dasharray="4 3"/>
<text class="ts" x="266" y="554" fill="#0F6E56">ECS cluster (Fargate)</text>

<g class="c-teal">
  <rect x="266" y="562" width="155" height="44" rx="6" stroke-width="0.5"/>
  <text class="th" x="343" y="578" text-anchor="middle" dominant-baseline="central">ECS service</text>
  <text class="ts" x="343" y="596" text-anchor="middle" dominant-baseline="central">Rolling deployment</text>
</g>
<g class="c-teal">
  <rect x="440" y="562" width="196" height="44" rx="6" stroke-width="0.5"/>
  <text class="th" x="538" y="578" text-anchor="middle" dominant-baseline="central">Task definition</text>
  <text class="ts" x="538" y="596" text-anchor="middle" dominant-baseline="central">Container + env vars</text>
</g>
<g class="c-teal">
  <rect x="330" y="630" width="200" height="56" rx="8" stroke-width="0.5"/>
  <text class="th" x="430" y="648" text-anchor="middle" dominant-baseline="central">Fargate task</text>
  <text class="ts" x="430" y="666" text-anchor="middle" dominant-baseline="central">Next.js container</text>
  <text class="ts" x="430" y="682" text-anchor="middle" dominant-baseline="central">(port 3000)</text>
</g>

<g class="c-blue">
  <rect x="270" y="730" width="140" height="44" rx="6" stroke-width="0.5"/>
  <text class="th" x="340" y="750" text-anchor="middle" dominant-baseline="central">Internet user</text>
  <text class="ts" x="340" y="768" text-anchor="middle" dominant-baseline="central">HTTP/HTTPS request</text>
</g>
<g class="c-blue">
  <rect x="450" y="730" width="174" height="44" rx="6" stroke-width="0.5"/>
  <text class="th" x="537" y="750" text-anchor="middle" dominant-baseline="central">External APIs</text>
  <text class="ts" x="537" y="768" text-anchor="middle" dominant-baseline="central">Cloudinary, Clerk, Stripe</text>
</g>

<!-- Infrastructure connectors -->
<path d="M340 774 L340 518" fill="none" stroke="#378ADD" stroke-width="1.2" marker-end="url(#arrow)"/>
<path d="M340 518 L340 562" fill="none" stroke="#378ADD" stroke-width="1.2" marker-end="url(#arrow)"/>
<line x1="421" y1="584" x2="438" y2="584" stroke="#888780" stroke-width="1.5" fill="none" marker-end="url(#arrow)"/>
<path d="M343 606 L343 618 L430 618 L430 630" fill="none" stroke="#1D9E75" stroke-width="1" marker-end="url(#arrow)"/>
<path d="M538 606 L538 618 L430 618" fill="none" stroke="#1D9E75" stroke-width="1"/>
<path d="M192 560 L250 560 L266 580" fill="none" stroke="#1D9E75" stroke-width="1" stroke-dasharray="4 3" marker-end="url(#arrow)"/>
<path d="M396 224 L396 408 L127 408 L127 538" fill="none" stroke="#1D9E75" stroke-width="1" stroke-dasharray="4 3" marker-end="url(#arrow)"/>
<path d="M541 224 L541 408 L343 408 L343 562" fill="none" stroke="#1D9E75" stroke-width="1" stroke-dasharray="4 3" marker-end="url(#arrow)"/>
<path d="M537 730 L537 700 L500 700 L500 686" fill="none" stroke="#378ADD" stroke-width="1" stroke-dasharray="3 3" marker-end="url(#arrow)"/>
<line x1="192" y1="494" x2="260" y2="494" stroke="#9FE1CB" stroke-width="1.5" fill="none" marker-end="url(#arrow)"/>
</svg>
</body>
</html>
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

Values are stored in SSM. This allows later workflows to **retrieve infrastructure values dynamically without re-running Terraform**.

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
2. Run `terraform destroy`

This ensures **clean infrastructure teardown without orphaned resources**.

---

# Secure Secret Management

Application secrets are **never stored in the repository**.

Instead:

1. Secrets are stored in **GitHub Secrets**
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

## Key Learnings

Through this project, I gained hands-on experience with:

- Designing AWS infrastructure using Terraform
- Implementing CI/CD pipelines with GitHub Actions
- Deploying containerized applications on Amazon ECS (Fargate)
- Managing infrastructure outputs using AWS SSM Parameter Store
- Securely handling secrets using GitHub Actions Secrets
- Optimizing container images using multi-stage Docker builds
- Structuring infrastructure and deployment workflows separately
