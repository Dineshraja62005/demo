pipeline {
    agent any
    
    tools {
        maven 'Maven' // Use the Maven installation name configured in Jenkins
    }
    
    environment {
        DOCKER_IMAGE = "yourdockerhubusername/spring-boot-demo:${BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' // ID of your Docker Hub credentials in Jenkins
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
        
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    sh 'docker push ${DOCKER_IMAGE}'
                }
            }
            post {
                always {
                    sh 'docker logout'
                }
            }
        }
        
        stage('Deploy Simulation') {
            steps {
                echo "In a production environment, we would deploy to Kubernetes here"
                echo "Image ${DOCKER_IMAGE} is ready for deployment"
                
                // Create a deployment report
                sh """
                echo "Deployment Report" > deployment-report.txt
                echo "==================" >> deployment-report.txt
                echo "Build Number: ${BUILD_NUMBER}" >> deployment-report.txt
                echo "Docker Image: ${DOCKER_IMAGE}" >> deployment-report.txt
                echo "Build Timestamp: \$(date)" >> deployment-report.txt
                echo "Status: Ready for deployment" >> deployment-report.txt
                """
                
                archiveArtifacts artifacts: 'deployment-report.txt', fingerprint: true
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}