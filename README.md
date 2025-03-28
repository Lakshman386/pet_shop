# Jenkins CI/CD Pipeline with Docker

## Overview
This project sets up a **Jenkins-based CI/CD pipeline** to automate building, testing, and deploying a Java-based application using **Maven, Docker, and AWS EC2**.

## Prerequisites
Before starting, ensure you have the following:

- **Jenkins Server**: Running on an AWS EC2 instance or local server.
- **Jenkins Plugins**:
  - Git Plugin
  - Maven Integration Plugin
  - Docker Plugin
- **Git Repository**: Stores the application source code.
- **Deployment Server**: An EC2 instance where the application will be deployed.

## Jenkins Pipeline Workflow
The pipeline performs the following tasks:

1. **Check out the code** from a Git repository.
2. **Build the project** using Maven.
3. **Run unit tests** and publish results.
4. **Remove old Docker containers & images**.
5. **Build a new Docker image** and push it to Docker Hub.
6. **Run the new Docker container** on the EC2 instance.

## Setup Instructions

### 1. Install & Configure Jenkins
Connect to the EC2 instance, install Jenkins, and start the service:
```sh
sudo yum install -y java-17-openjdk-devel
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
```
Access Jenkins UI: `http://<EC2-PUBLIC-IP>:8080`

### 2. Configure Jenkins Pipeline
- **Create a new Pipeline Job**
- **Add the following script:**

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
                sh 'sudo docker rm -f cont-1 || true'
                sh 'sudo docker rmi lakshman386/project-2:p2 || true'
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
        
        stage('Run New Container') {
            steps {
                sh 'sudo docker run -d -p 8080:8080 --name cont-1 lakshman386/project-2:p2'
            }
        }
    }
}
```

### 3. Configure Node (Jenkins Slave)
- Open **Manage Jenkins** → **Manage Nodes and Clouds**
- Add a new **Amazon Linux 2** node with Java installed
- Install required dependencies:
  ```sh
  sudo yum install -y git docker maven
  sudo systemctl start docker
  sudo systemctl enable docker
  ```

### 4. Docker Configuration
- Install the **Docker Plugin** in Jenkins
- Configure **Docker Hub Credentials**
- Open **Security Groups** and allow **port 8080**

### 5. Trigger the Build
- Click **Build Now** in Jenkins
- Monitor the pipeline execution
- Copy the **slave server IP** and access the application:
  ```sh
  http://<SLAVE_SERVER_IP>:8080
  ```

![image](https://github.com/user-attachments/assets/16dd399e-a3e4-403c-aa9f-0761673f995c)


## Conclusion
This pipeline automates the CI/CD process for a Java application using Jenkins, Docker, and AWS EC2. The build pipeline ensures **code quality, efficient deployment, and scalability**.

---
