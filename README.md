# Project Nexus: Automated Cloud CI/CD & Infrastructure

Project Nexus is an automated, production-ready cloud deployment pipeline and infrastructure architecture for containerized web applications. The project provisions AWS infrastructure using Terraform (Infrastructure as Code) and automates continuous integration and continuous deployment (CI/CD) through GitHub Actions, Amazon ECR, and AWS Systems Manager (SSM) without exposing SSH ports.

---

## Architecture Overview

Traffic flows from the internet through an Application Load Balancer (ALB) to an isolated Docker container running on an Amazon EC2 instance. Deployments are completely hands-off and triggered on every push to the `main` branch.

```text
[ Developer ] 
      │ (git push)
      ▼
[ GitHub Actions ] 
      │ 
      ├──► [ Amazon ECR ] (Docker Image Vault)
      │
      └──► [ AWS Systems Manager (SSM) ]
                 │ (RunShellScript API)
                 ▼
          [ Amazon EC2 ]
                 │ (docker pull & run)
                 ▼
          [ Docker Container: Nexus App (Port 80) ]
                 ▲
                 │ (HTTP Forwarding)
          [ AWS Application Load Balancer (ALB) ]
                 ▲
                 │ (CNAME Alias)
          [ Custom Domain / Client Requests ]
```

---

## Tech Stack

* **Application:** Node.js, Express.js, Tailwind CSS, Lucide Icons
* **Containerization:** Docker
* **Infrastructure as Code (IaC):** Terraform
* **Cloud Platform (AWS):** EC2, ECR, Application Load Balancer (ALB), Target Groups, IAM, Systems Manager (SSM)
* **CI/CD:** GitHub Actions

---

## Key Cloud Engineering Features

* **Zero-SSH Inbound Security:** The EC2 host exposes zero inbound management ports (Port 22 is disabled). Deployments and server access execute securely via AWS Systems Manager (SSM) agent and IAM instance profiles.
* **Infrastructure as Code:** The AWS compute footprint, container registry, security groups, target groups, and load balancer are declared and managed deterministically via Terraform.
* **Continuous Delivery Pipeline:** Every merge to `main` authenticates to AWS via IAM roles/secrets, builds an immutable Docker image tagged with the commit SHA, pushes to Amazon ECR, and notifies the EC2 host via SSM to execute a zero-downtime container swap.
* **Load Balancer Abstraction:** Traffic is received and distributed via an AWS Application Load Balancer, abstracting the EC2 public IP and serving as the centralized ingress point for custom domain routing.
* **AWS Free-Tier Optimized:** Designed to run inside the AWS Free Tier, routing DNS via standard registrar CNAME records to bypass Route 53 hosted-zone costs.

---

## Repository Structure

```text
.
├── Dockerfile          # Container build specifications
├── package.json        # Node.js dependencies and project scripts
├── public              # Static assets directory
│   └── index.html      # Frontend landing page
├── README.md           # Architecture, setup, and deployment documentation
├── server.js           # Express API and static route handling
└── terraform           # Infrastructure as Code configurations
    ├── alb.tf          # Application Load Balancer and target groups
    ├── ec2.tf          # Host compute, security groups, and IAM roles
    ├── ecr_repo.tf     # Private container image registry
    ├── outputs.tf      # Exported DNS names and resource IDs
    ├── providers.tf    # AWS provider and Terraform requirements
    └── script.sh       # EC2 bootstrap and Docker startup script
```

## API Endpoints

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/` | Serves the interactive, responsive static landing page |
| `GET` | `/api/health` | Deployment validation endpoint returning JSON status |

#### Sample Health Check Response:
```json
{
  "status": "healthy",
  "pipeline": "active",
  "version": "1.0.0"
}
```

---

## Setup & Deployment Instructions

### 1. Provision Infrastructure via Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Note the outputted `alb_dns_name` and `instance_id`.

### 2. Configure GitHub Secrets

Add the following repository secrets under **Settings > Secrets and variables > Actions**:

* `AWS_ACCESS_KEY_ID`: IAM user access key with ECR and SSM deployment permissions.
* `AWS_SECRET_ACCESS_KEY`: Corresponding IAM secret key.
* `EC2_INSTANCE_ID`: Target EC2 instance ID outputted by Terraform.

### 3. Deploy Application

Push any changes to the `main` branch to trigger automated compilation and deployment:

```bash
git add .
git commit -m "feat: infrastructure and deployment setup"
git push origin main
```

---

## By Sujal Surani