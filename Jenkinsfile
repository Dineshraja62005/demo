pipeline {
    agent any
    
    tools {
        maven 'Maven' // Use the Maven installation name configured in Jenkins
    }
    
    environment {
        DOCKER_IMAGE = "spring-boot-demo:${BUILD_NUMBER}"
        APP_PORT = "8081"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
            post {
                success {
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }
        
        stage('Deploy Container') {
            steps {
                // Stop and remove any existing container
                sh 'docker stop spring-app || true'
                sh 'docker rm spring-app || true'
                
                // Run the new container
                sh 'docker run -d -p ${APP_PORT}:8080 --name spring-app ${DOCKER_IMAGE}'
                
                echo "Application deployed successfully!"
                echo "Access your application at: http://YOUR_SERVER_IP:${APP_PORT}"
            }
        }
    }
    
    post {
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check the logs for details.'
        }
    }
}