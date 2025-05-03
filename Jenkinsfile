pipeline {
    agent any
    
    tools {
        maven 'Maven 3.8.1'
    }
    
    environment {
        DOCKER_IMAGE = "dineshraja0601/spring-boot-app:${BUILD_NUMBER}"
        KUBECONFIG = "${WORKSPACE}/kubeconfig"
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
        
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-pwd', variable: 'DOCKER_HUB_PWD')]) {
                    sh 'echo ${DOCKER_HUB_PWD} | docker login -u dineshraja0601 --password-stdin'
                    sh 'docker push ${DOCKER_IMAGE}'
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh 'cp $KUBECONFIG ${WORKSPACE}/kubeconfig'
                    
                    script {
                        // Initial deployment or update deployment
                        try {
                            // Update deployment with new Docker image
                            sh 'kubectl --kubeconfig=${KUBECONFIG} set image deployment/sample-app-deployment sample-container=${DOCKER_IMAGE}'
                        } catch (Exception e) {
                            // If deployment doesn't exist, create it
                            sh 'envsubst < kubernetes/deployment.yaml | kubectl --kubeconfig=${KUBECONFIG} apply -f -'
                            sh 'kubectl --kubeconfig=${KUBECONFIG} apply -f kubernetes/service.yaml'
                        }
                    }
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh 'kubectl --kubeconfig=${KUBECONFIG} get pods -l app=spring-boot-app'
                    sh 'kubectl --kubeconfig=${KUBECONFIG} get services sample-app-service'
                }
            }
        }
    }
    
    post {
        always {
            sh 'rm -f ${WORKSPACE}/kubeconfig'
            sh 'docker logout'
        }
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }
        failure {
            echo 'CI/CD Pipeline failed!'
        }
    }
}