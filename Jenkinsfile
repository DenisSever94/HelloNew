pipeline {
    agent any
    triggers {
        githubPush()
    }

    environment {
        // Настройки Docker Hub
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_IMAGE = 'your-dockerhub-username/hellonew-app'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        // Настройки email
        NOTIFICATION_EMAIL = 'denissedih0503@gmail.com'
        // Настройки Kubernetes
        KUBE_NAMESPACE = "default"
        APP_NAME = "hellonew-app"
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
                    // Публикация результатов тестов
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Создание Docker образа...'
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                echo '📤 Публикация Docker образа в Docker Hub...'
                script {
                    // Используем credentials ID 'docker-hub-credentials' (нужно создать в Jenkins)
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-hub-credentials') {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo '🚀 Деплой в Kubernetes...'
                sh """
                    # Применяем манифесты
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml

                    # Ждем готовности
                    kubectl rollout status deployment/${APP_NAME} --timeout=300s
                """
            }
        }

        stage('Smoke Test') {
            steps {
                echo '🧪 Smoke тестирование...'
                script {
                    def serviceUrl = sh(
                        script: "minikube service ${APP_NAME}-service --url",
                        returnStdout: true
                    ).trim()
                    sh "curl -f ${serviceUrl}/health"
                }
            }
        }
    }

    post {
        always {
            echo '📊 Пайплайн завершен'
            // Очистка
            sh 'docker system prune -f'
        }
        success {
            echo '✅ Пайплайн выполнен успешно!'
            // Отправка email при успехе
            emailext (
                subject: "SUCCESS: Pipeline '${env.JOB_NAME}' [${env.BUILD_NUMBER}]",
                body: """
                <h2>✅ Пайплайн выполнен успешно!</h2>
                <p><strong>Проект:</strong> ${env.JOB_NAME}</p>
                <p><strong>Номер сборки:</strong> ${env.BUILD_NUMBER}</p>
                <p><strong>Ветка:</strong> ${env.GIT_BRANCH}</p>
                <p><strong>Коммит:</strong> ${env.GIT_COMMIT}</p>
                <p><strong>Ссылка на сборку:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                <p><strong>Docker образ:</strong> ${DOCKER_IMAGE}:${DOCKER_TAG}</p>
                """,
                to: "${NOTIFICATION_EMAIL}",
                mimeType: "text/html"
            )
        }
        failure {
            echo '❌ Пайплайн завершился ошибкой'
            // Отправка email при ошибке
            emailext (
                subject: "FAILURE: Pipeline '${env.JOB_NAME}' [${env.BUILD_NUMBER}]",
                body: """
                <h2>❌ Пайплайн завершился ошибкой!</h2>
                <p><strong>Проект:</strong> ${env.JOB_NAME}</p>
                <p><strong>Номер сборки:</strong> ${env.BUILD_NUMBER}</p>
                <p><strong>Ссылка на сборку:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                <p>Пожалуйста, проверьте логи сборки.</p>
                """,
                to: "${NOTIFICATION_EMAIL}",
                mimeType: "text/html"
            )
        }
    }
}