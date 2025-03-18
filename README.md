# ArgoCD Project - CI Process

## Introduction

This project demonstrates the DevOps and GitOps methodology using Kubernetes and ArgoCD for continuous deployment. The CI process is responsible for building, testing, scanning, and pushing containerized application images to DockerHub. The project utilizes Jenkins, Terraform, Docker, Trivy, SonarQube, and OWASP Dependency-Check to ensure a robust CI pipeline.

The application source code is taken from public repository - "https://github.com/jaiswaladi246/Boardgame.git". This repository primarily focuses on the CI (Continuous Integration) process, where application code is built and tested before being pushed to the container registry. This repository contains Source code, Dockerfile, Jenkinsfile, Terraform script and all Activity logs.

## Technologies Used

Terraform - To provision AWS infrastructure

Jenkins - For automating CI processes

Docker - To containerize the Java application

Maven - For dependency management and build

OWASP Dependency-Check - For security vulnerability analysis

SonarQube - For code quality and code coverage analysis

Trivy - For container image vulnerability scanning

DockerHub - For storing the containerized application images

## Workflow

### 1. Infrastructure Setup

- Used Terraform to create AWS resources:

    VPC, Public and Private Subnets

    Internet Gateway, NAT Gateway, and Route Tables

- EC2 Instances:

    CI Machine for building and pushing images

    CD Machine for Kubernetes deployments

### 2. CI Process on the CI Machine

- Build and Test the Application

   * Used Maven to install dependencies and build the Java application.

   * Performed security dependency scanning using OWASP Dependency-Check.
     
   * Checked code quality using SonarQube.

- Containerization & Image Scanning

   * Used Docker multistage build to create an optimized application image.

   * Scanned the Docker image for vulnerabilities using Trivy.
    
- Local Deployment Test

   * Deployed the image using Docker Compose for testing.

   * Implemented a manual input prompt to verify if the deployment was successful.

- Pushing Image to DockerHub

   * Tagged the Docker image with latest and build ID.

   * Pushed the image to DockerHub.

- Reports & Notifications
  
   * Reports from Trivy and OWASP are generated and published.

   * Jenkins logs are monitored using Blue Ocean UI.  

### 3. GitOps Workflow Implementation

- Created a feature branch (feature-1) for code modifications.

- Added additional Jenkins pipeline stages to support branch-based CI workflows.

- Once validated, merged the feature branch into the main branch.

- The final stage updated the CD process repository by modifying the Kubernetes deployment manifest.

## Troubleshooting

### 1.Terraform VPC Setup Issue

- Initially, the created subnets did not assign a public IP by default.

- Solution: Added associate_public_ip_address = true to ensure EC2 instances in the public subnet receive a public IP.

### 2.OWASP Dependency Check Issue

- The dependency check was failing intermittently without completing.

- Solution: Used an NVD API key, which resolved the issue and allowed OWASP to complete successfully.

### 3.Docker Image Cleanup Issue

- docker image prune -a was not removing old images due to the manual confirmation prompt.

- Solution: Used docker image prune -af to forcefully delete all unused images.

### 4.Automating PR Creation with GitHub CLI/API

- Attempted to automate pull request (PR) creation by API but was unsuccessful.

- Solution: Manually created the PR via GitHub UI.

- Alternate Fix: Implement an admin-only input dialog box in Jenkins to approve and trigger a git merge stage automatically.

### 5.Disk Space Management on CI Machine

- After multiple builds, the instance ran out of disk space.

- Solution:

  * Deleted SonarQube projects to free up space.

  * Used docker system prune -a -f --volumes to remove unused Docker images, containers, and volumes

## Contributors & Credits

DevOps Implementation: Danush Vithiyarth Jaiganesh - DevOps Engineer

Application Source Code: Boardgame Repository - "https://github.com/jaiswaladi246/Boardgame.git"

CI/CD Automation & Infrastructure as Code: Danush Vithiyarth Jaiganesh - DevOps Engineer

## Note:
This repository focuses on the CI (Continuous Integration) process for automating application build and validation before deployment. The CD (Continuous Deployment) process is handled separately in the CD Process Repository - "https://github.com/danushvithiyarth/ArgoCd-project-CD_Process.git".

       
