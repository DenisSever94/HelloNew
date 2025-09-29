pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'denissever/hellonew-app'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        NOTIFICATION_EMAIL = 'denissedih0503@gmail.com'
        KUBE_NAMESPACE = "default"
        APP_NAME = "hellonew-app"
    }

    
    tools {
        maven 'Maven3'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Код получен из GitHub'
            }
        }

        stage('Build') {
            steps {
                echo 'Сборка Java приложения'
                sh 'mvn clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
                echo 'Запуск Unit-тестов'
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package') {
            steps {
                echo 'Создание JAR файла'
                sh 'mvn package'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Создание Docker образа приложения'
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        // stage('Push Docker Image') {
        //     steps {
        //         echo 'Публикация Docker образа в Docker Hub'
        //         script {
        //             withCredentials([usernamePassword(
        //                 credentialsId: 'docker-hub-credentials',
        //                 usernameVariable: 'DOCKER_USER',
        //                 passwordVariable: 'DOCKER_PASS'
        //             )]) {
        //                 sh """
        //                     docker login -u $DOCKER_USER -p $DOCKER_PASS
        //                     docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
        //                 """
        //             }
        //         }
        //     }
        // }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Деплой в Kubernetes кластер'
                sh """
                    kubectl apply -f k8s/deployment.yaml -n ${KUBE_NAMESPACE}
                    kubectl apply -f k8s/service.yaml -n ${KUBE_NAMESPACE}
                    kubectl rollout status deployment/${APP_NAME} -n ${KUBE_NAMESPACE} --timeout=300s
                """
            }
        }
    }

    post {
        always {
            echo 'Pipeline завершен'
        }
        success {
            echo 'Pipeline выполнен успешно!'
            emailext (
                subject: "SUCCESS: Pipeline '${env.JOB_NAME}' [${env.BUILD_NUMBER}]",
                body: """
                <h2>Pipeline выполнен успешно! ✅</h2>
                <p><strong>Проект:</strong> ${env.JOB_NAME}</p>
                <p><strong>Номер сборки:</strong> ${env.BUILD_NUMBER}</p>
                <p><strong>Ветка:</strong> ${env.GIT_BRANCH}</p>
                <p><strong>Docker образ:</strong> ${DOCKER_IMAGE}:${DOCKER_TAG}</p>
                <p><strong>Ссылка:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                """,
                to: "${NOTIFICATION_EMAIL}",
                mimeType: "text/html"
            )
        }
        failure {
            echo 'Pipeline завершился ошибкой'
            emailext (
                subject: "FAILURE: Pipeline '${env.JOB_NAME}' [${env.BUILD_NUMBER}]",
                body: """
                <h2>Pipeline завершился ошибкой! ❌</h2>
                <p><strong>Проект:</strong> ${env.JOB_NAME}</p>
                <p><strong>Номер сборки:</strong> ${env.BUILD_NUMBER}</p>
                <p><strong>Ссылка:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                <p>Проверьте логи сборки.</p>
                """,
                to: "${NOTIFICATION_EMAIL}",
                mimeType: "text/html"
            )
        }
    }
}
