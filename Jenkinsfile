pipeline {
    agent any
    triggers {
        githubPush()
    }

    environment {
        DOCKER_IMAGE = "your-dockerhub-username/hellonew-app"
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        KUBE_NAMESPACE = "default"
        APP_NAME = "hellonew-app"
        NOTIFICATION_EMAIL = "denissedih0503@gmail.com"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
                echo '✅ Код получен из GitHub'
            }
        }

        stage('Build and Test') {
            steps {
                echo '🔨 Сборка и тестирование Spring Boot...'
                sh 'mvn clean package'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Создание Docker образа...'
                script {
                    sh 'ls -la target/'
                    dockerImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                echo '📤 Публикация Docker образа...'
                script {
                    // Для теста просто тегируем, без push в registry
                    sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                    echo "Образ готов: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo '🚀 Деплой в Kubernetes...'
                sh """
                    echo 'Применяем Kubernetes манифесты:'
                    ls -la k8s/
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    kubectl get pods
                """
            }
        }
    }

    post {
        always {
            echo '📊 Пайплайн завершен'
        }
        success {
            echo '✅ Успех! Приложение развернуто'
            emailext (
                subject: "SUCCESS: HelloNew App deployed",
                body: "Spring Boot приложение успешно развернуто через CI/CD",
                to: "${NOTIFICATION_EMAIL}"
            )
        }
        failure {
            echo '❌ Ошибка в пайплайне'
        }
    }
}