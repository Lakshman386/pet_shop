CI/CD Pipeline with Jenkins, Docker, and Maven

Install and configure Jenkins software in your EC2:
Overview
This document outlines creating a continuous integration and continuous deployment (CI/CD) pipeline using Jenkins. The pipeline automates the process of building, testing, and deploying code, providing a reliable and scalable way to deliver software.

1. Prerequisites
Before starting, ensure you have the following:
•	Jenkins Server: Running on a local server, EC2 instance, or any machine with internet access.
•	Jenkins Plugins:
o	Git Plugin 
o	Maven integration
o	Docker plugins
•	Git Repository: A version control repository that stores your code (e.g., GitHub, …).
•	Deployment Server: A server (e.g., EC2 instance) where the application will be deployed

2. Jenkins Pipeline
Jenkins File Structure
The pipeline described below will perform the following tasks:
•	Check out the code from a Git repository.
•	Build the project using Maven.
•	Run unit tests and publish results.
•	Deploy the built artefact to a server.
•	Notify on building success or failure.

3. Step-by-step Instructions
•	Open the EC2 Instance dashboard and connect to the Jenkins server. Now copy the public IP paste it into the new tab and provide the port number 8080.
•	It will redirect to the Jenkins admin portal and log in with administrator privileges.
•	Select a new item from the dashboard, enter the job name select an item type as a pipeline and click ok.
•	It will redirect to the configuration page. On the left-hand side, select pipeline, and the script tab will appear.
•	Write the pipeline script.

4. Node configuration
•	Now from manage Jenkins open nodes and configure the node.
•	We should have a new slave server with Amazon 2 and Java installed.
•	We should also install Git, Docker and Maven on the slave server.
![image](https://github.com/user-attachments/assets/a5ce4d2a-d38a-41a0-bc11-b9a940e5b190)
![image](https://github.com/user-attachments/assets/670271ae-30b1-4e81-92ac-1302e6991956)
![image](https://github.com/user-attachments/assets/0a28c8b9-9244-408e-b238-de118c0c8951)
![image](https://github.com/user-attachments/assets/aa77d6be-ba6f-4445-a8b1-2e3f21191361)
•	Now save the node will be online.
•	In the script call the label expression.
 ![image](https://github.com/user-attachments/assets/cd8f997d-4cf9-40aa-ab9a-4fe4272737cb)
•	Now in the stage age provide a Git repository URL to bring the code.
•	[https://github.com/Lakshman386/gctech.git](https://github.com/Lakshman386/pet_shop.git)
 ![image](https://github.com/user-attachments/assets/9ee16f0f-2b5d-4201-b234-8901d989421e)
•	In the next stage build with maven for the war file.
•	Now save the script and click build now at the bottom the build history gets success.
•	In the next stage the container and image should be removed.
 ![image](https://github.com/user-attachments/assets/47bb35f7-d6c5-4186-9d00-e6bccdaa1d76)
5. Docker configuration
•	Install the Docker plugins and configure the credentials.
•	Add a new stage for the build and push to the hub.
•	In this an image is built and created as a container and pushed the image to the Docker hub.
•	The next stage is to run the container 
•	We should mention the port and the port should be open in the security groups.
 ![image](https://github.com/user-attachments/assets/1329a25f-9e12-48a2-b913-291aadad9dfd)
•	Save the pipeline script.
•	Click on build now the build is success.
 ![image](https://github.com/user-attachments/assets/cf9bc0f6-d39b-440a-b2a7-32c84a9d10e7)
•	Open the new tab copy the slave server IP and open with the 8080 port the output is displayed.
![image](https://github.com/user-attachments/assets/01fbf5f7-999b-4c86-a882-13c4306dde81)

Pipeline script
pipeline {
    agent { label 'dev' }

    stages {
        stage('git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Lakshman386/pet_shop.git'
            }
        }
        stage('maven build') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('container & image remove') {
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
        stage('run') {
            steps {
                sh 'sudo docker run -d -p 8080:8080 --name cont-1 lakshman386/project-2:p2'
            }
        }
    }
}
