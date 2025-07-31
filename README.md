# AWS EKS CI/CD Pipeline Automation

This project automates the **building**, **deployment**, and **validation** of a containerized application to **AWS EKS** using **GitHub Actions** and **Terraform**

## 🚀 Purpose

To streamline the delivery of production-ready software to AWS EKS with minimal manual intervention while following best practices in infrastructure automation and security.

## 🔧 Features

- Fully automated CI/CD pipeline using **GitHub Actions**
- Infrastructure-as-Code with **Terraform** (no `eksctl` used)
- Public service exposure via **AWS Application Load Balancer (ALB)**
- Secure design with:
  - Least privilege **IAM policies**
  - Proper **network access controls**
- GitHub repository-driven deployment to **Amazon EKS**

## 🧱 Stack

- **AWS EKS** – Managed Kubernetes cluster
- **Terraform** – Infrastructure provisioning
- **GitHub Actions** – CI/CD pipeline
- **Amazon ALB** – Public access to services
- **IAM** – Fine-grained permissions
- **Kubernetes manifests** – Application deployment

## 📦 CI/CD Flow

1. **Code Push to GitHub**  
   Triggers GitHub Actions workflow.

2. **Terraform Apply**  
   - Provisions EKS cluster  
   - Creates IAM roles, node groups, and networking resources

3. **Kubernetes Deployment**  
   - Builds and pushes container image (optional)  
   - Deploys app using `kubectl` from GitHub Actions  
   - Exposes service via ALB ingress controller

4. **Validation**  
   - Verifies service is reachable and healthy

## 🔐 Security Considerations

- **IAM roles** are restricted by principle of least privilege
- **Terraform state** should be stored securely (e.g., in S3 with encryption and DynamoDB for locking)
- **Ingress traffic** controlled via ALB security groups and subnet boundaries

## 🧪 Future Improvements

- Enhance the credential security with OIDC
- Add monitoring and alerting (e.g., with Prometheus/Grafana or CloudWatch)
- Refactor it to be more modular

