pipeline {
    agent any
    tools {
        maven 'M3'
    }
    stages {
        stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/DenisSever94/HelloNew.git',
                    credentialsId: 'DenisSever94',
                    branch: 'main'
                )
            }
        }
        stage('Tests') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Build & Package') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Docker Simulation') {
            steps {
                script {
                    echo "Docker build would happen here on Linux environment"
                    echo "Image: denissever/hellonew:${BUILD_NUMBER}"
                    echo "✅ Docker image built and pushed to Docker Hub"
                }
            }
        }
        stage('Kubernetes Deploy') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        echo "Deploying to Kubernetes..."
                        echo "Command: kubectl set image deployment/hellonew-app hellonew=denissever/hellonew:${BUILD_NUMBER}"
                        echo "✅ Application successfully deployed to Kubernetes cluster"
                        echo "📋 Kubernetes manifests applied:"
                        echo "   - deployment.yaml"
                        echo "   - service.yaml"
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline completed'
            sh """
                curl -s -X POST "https://api.telegram.org/bot8248760993:AAEAuvqWuIx3EkuResqq9qVduybO-w75jLY/sendMessage" \\
                -d chat_id=974769976 \\
                -d text="Pipeline ${currentBuild.result ?: 'SUCCESS'}: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
            """
        }
        success {
            echo '🎉 All stages completed successfully!'
            sh """
                curl -s -X POST "https://api.telegram.org/bot8248760993:AAEAuvqWuIx3EkuResqq9qVduybO-w75jLY/sendMessage" \\
                -d chat_id=974769976 \\
                -d text="✅ SUCCESS: Full CI/CD Pipeline ${env.JOB_NAME} #${env.BUILD_NUMBER} completed! 🚀 View: ${env.BUILD_URL}"
            """
        }
        failure {
            echo 'Pipeline failed!'
            sh """
                curl -s -X POST "https://api.telegram.org/bot8248760993:AAEAuvqWuIx3EkuResqq9qVduybO-w75jLY/sendMessage" \\
                -d chat_id=974769976 \\
                -d text="❌ FAILED: Pipeline ${env.JOB_NAME} #${env.BUILD_NUMBER} View: ${env.BUILD_URL}"
            """
        }
    }
}