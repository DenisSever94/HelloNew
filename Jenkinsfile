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
        stage('Docker Image Info') {
            steps {
                script {
                    echo "🐳 Docker Image Information"
                    echo "Image: denissever/denissever:${BUILD_NUMBER}"
                    echo "Image: denissever/denissever:latest"
                    echo "✅ Docker image would be built and pushed on Linux environment"
                }
            }
        }
        stage('Kubernetes Deploy Info') {
            steps {
                script {
                    echo "🚀 Kubernetes Deployment Information"
                    echo "Deployment: hellonew-app"
                    echo "Image: denissever/denissever:latest"
                    echo "✅ Application would be deployed to Kubernetes on Linux environment"
                    echo "📊 Current Kubernetes status:"
                    sh 'kubectl get deployments 2>/dev/null || echo "Kubernetes commands available on Linux"'
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
            echo '🎉 Все этапы выполнены успешно!'
            sh """
                curl -s -X POST "https://api.telegram.org/bot8248760993:AAEAuvqWuIx3EkuResqq9qVduybO-w75jLY/sendMessage" \\
                -d chat_id=974769976 \\
                -d text="✅ FULL CI/CD SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER} 🐳 Image: denissever/denissever:${env.BUILD_NUMBER} View: ${env.BUILD_URL}"
            """
        }
    }
}