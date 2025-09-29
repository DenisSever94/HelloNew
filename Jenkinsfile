pipeline {
    agent any
       tools {
        maven 'Maven3' 
    }
    triggers {
        githubPush()
    }

    environment {

        DOCKER_REGISTRY = 'docker.io'
        DOCKER_IMAGE = 'DenisSever/hellonew-app'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        // email
        NOTIFICATION_EMAIL = 'denissedih0503@gmail.com'
        // Kubernetes
        KUBE_NAMESPACE = "default"
        APP_NAME = "hellonew-app"
        
    }

    stages {
        stage('Проверка кода') {
            steps {
                checkout scm
                echo 'Код получен из GitHub'
            }
        }

        stage('Сборка и тесты') {
            steps {
                echo 'Сборка и тестирование'
                sh 'mvn clean package'
            }
            post {
                always {
                    // Публикация тестов
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

              stage('Сборка Docker Image') {
            steps {
                echo 'Создание Docker образа...'
                script {
                    // Проверяем есть ли Docker, если нет - пропускаем
                    sh '''
                        if command -v docker &> /dev/null; then
                            echo "Docker уже установлен, собираем образ..."
                            docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        else
                            echo "Docker не установлен, пропускаем сборку образа"
                        fi
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Публикация Docker образа в Docker Hub...'
                script {
                    sh '''
                        if command -v docker &> /dev/null; then
                            withCredentials([usernamePassword(
                                credentialsId: 'docker-hub-credentials',
                                usernameVariable: 'DOCKER_USER',
                                passwordVariable: 'DOCKER_PASS'
                            )]) {
                                sh """
                                    docker login -u $DOCKER_USER -p $DOCKER_PASS
                                    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                                    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                                    docker push ${DOCKER_IMAGE}:latest
                                """
                            }
                        else
                            echo "Docker не установлен, пропускаем публикацию"
                        fi
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Деплой в Kubernetes...'
                sh """
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    kubectl rollout status deployment/${APP_NAME} --timeout=300s
                """
            }
        }

        stage('Smoke Test') {
            steps {
                echo 'Smoke тестирование...'
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
            echo 'Пайплайн завершен'
            // Очистка
            sh 'docker system prune -f'
        }
        success {
            echo 'Пайплайн выполнен успешно!'
            // Отправка email при успехе
            emailext (
                subject: "SUCCESS: Pipeline '${env.JOB_NAME}' [${env.BUILD_NUMBER}]",
                body: """
                <h2>Пайплайн выполнен успешно!</h2>
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
            echo 'Пайплайн завершился ошибкой'
            // Отправка email
            emailext (
                subject: "FAILURE: Pipeline '${env.JOB_NAME}' [${env.BUILD_NUMBER}]",
                body: """
                <h2>Пайплайн завершился ошибкой!</h2>
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
