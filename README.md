# 🚀 Automated CI/CD Pipeline for Jenkins and Docker

![0_-wYqzZYZhwUuS1SI](https://github.com/user-attachments/assets/662185ab-8afc-402d-95d3-8aeea6d0af67)

## 📌 Project Overview
This project sets up an **Automated CI/CD Pipeline** for Project-2 using **Jenkins, Docker, and Maven**. It streamlines the software development lifecycle by automating **code checkout, build, test, containerization, and deployment**.

## 🎯 Objectives
- Automate **code checkout, build, and deployment** using **Jenkins**.
- Utilize **Maven** for project builds.
- Deploy application **containers with Docker**.
- Push Docker images to **Docker Hub**.
- Enable seamless integration with **GitHub**.

## 🏗️ Deployment Process

### 🔹 Prerequisites
- An **EC2 instance** running Jenkins.
- Installed Jenkins plugins:
  - **Git Plugin**
  - **Maven Integration Plugin**
  - **Docker Plugin**
- A **GitHub repository** for version control.
- A **Docker Hub account** for storing images.

### 🔹 Jenkins Setup on EC2
```bash
sudo wget -O /etc/yum.repos.d/Jenkins.repo \ 
  https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install fontconfig java-17-openjdk
sudo yum install jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
```
- **Access Jenkins UI**: `http://<jenkins-ec2-ip>:8080`
- Install required plugins: **Git, Maven, Docker**

## ⚙️ Jenkins Pipeline

### 📌 Pipeline Workflow
1. **Checkout Code** from GitHub
2. **Build the project** using Maven
3. **Remove old Docker container & image**
4. **Build and push Docker image to Docker Hub**
5. **Deploy the container**

```groovy
pipeline {
    agent { label 'dev' }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Lakshman386/gctech.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Remove Old Container & Image') {
            steps {
                sh 'sudo docker rm -f cont-1'
                sh 'sudo docker rmi lakshman386/project-2:p2'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                   withDockerRegistry(credentialsId: 'lakshman386') {
                        sh "docker build -t lakshman386/project-2:p2 ."
                        sh "docker push lakshman386/project-2:p2"
                    }
                }
            }
        }

        stage('Run Container') {
            steps {
                sh 'sudo docker run -d -p 8080:8080 --name cont-1 lakshman386/project-2:p2'
            }
        }
    }
}
```

![image](https://github.com/user-attachments/assets/516193b2-f0ea-4370-a7eb-a8872484c60a)

## 🛠️ Technologies Used
- **Jenkins** - CI/CD Automation
- **Docker** - Containerization
- **Maven** - Build Management
- **GitHub** - Version Control
- **EC2** - Deployment Server

## 📢 Contributing
Feel free to submit **pull requests** for improvements!

## 📧 Contact
For queries, reach out via **[@email.com](mailto:lakshminarayanas386@example.com)**.

---
🚀 **Automated CI/CD Deployment for Reliable Software Delivery!**
