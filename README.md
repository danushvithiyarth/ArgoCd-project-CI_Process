# 🛠️ ArgoCD Project – CI Pipeline

**Purpose:** This repository focuses on the **Continuous Integration (CI)** process for the ArgoCD Project.  
It automates building, testing, scanning, and pushing container images to DockerHub.  

The application source code is based on: [Boardgame](https://github.com/jaiswaladi246/Boardgame.git)

---

## 🧰 Technologies & Tools

| Category | Tools |
|----------|-------|
| Infrastructure | Terraform, AWS EC2 |
| CI/CD | Jenkins, Maven |
| Containerization | Docker |
| Security & Quality | Trivy, OWASP Dependency-Check, SonarQube |
| GitOps Integration | Git, DockerHub |

---

## ⚡ CI Workflow Overview

1. **Infrastructure Setup (Terraform)**
   - Provisioned AWS VPC, subnets, Internet/NAT gateways, and EC2 instances.
   - Dedicated CI machine for building and pushing images.

2. **Build & Test Application**
   - Maven builds and dependency management.
   - SonarQube code quality checks.
   - OWASP Dependency-Check for security vulnerabilities.

3. **Containerization & Image Scanning**
   - Multi-stage Docker builds for optimized images.
   - Security scanning using Trivy.

4. **Local Deployment Test**
   - Docker Compose deployment for verification.

5. **DockerHub Push**
   - Tagged with latest and build ID.
   - Images pushed to DockerHub for CD repository.

6. **GitOps Integration**
   - Feature branch workflow for CI validation.
   - Merged changes update CD repo deployment manifest automatically.

---

## 📝 Activity Logs

- All project steps, screenshots, and Jenkins logs are stored in the `logs` branch.
- Includes visual reference of Docker builds, test runs, and vulnerability scan reports.

---

## 🔧 Troubleshooting Highlights

- Terraform subnets didn’t assign public IP → `associate_public_ip_address = true`.
- OWASP Dependency-Check failed intermittently → Used NVD API key.
- Docker image cleanup prompts → Used `docker image prune -af`.
- Disk space issues on CI machine → Removed old images, containers, volumes, and SonarQube projects.

---

## 🎯 Outcome

- Fully automated CI pipeline for Java application.
- Secure, quality-checked Docker images ready for GitOps deployment.
- Complete visibility into builds and vulnerabilities via Jenkins & activity logs.

---

## 👤 Contributors
**Danush Vithiyarth Jaiganesh** – DevOps Engineer 

---

> **Note:** This repository only covers **CI (build, test, scan, push)**. The **CD process** is in the separate repository: [ArgoCD Project – CD Process](https://github.com/danushvithiyarth/ArgoCd-project-CD_Process.git)
