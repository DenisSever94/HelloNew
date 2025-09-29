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
        maven 'M3'
        jdk 'jdk21'
    }

    stages {
        stage('Checkout') {
            steps {
                // Явно указываем git репозиторий
                git branch: 'main',
                    url: 'https://github.com/DenisSever94/HelloNew.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
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
                sh 'mvn package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh """
                            docker login -u $DOCKER_USER -p $DOCKER_PASS
                            docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                        """
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    kubectl apply -f k8s/deployment.yaml -n ${KUBE_NAMESPACE}
                    kubectl apply -f k8s/service.yaml -n ${KUBE_NAMESPACE}
                    kubectl rollout status deployment/${APP_NAME} -n ${KUBE_NAMESPACE} --timeout=300s
                """
            }
        }
    }

    post {
        success {
            emailext (
                subject: "SUCCESS: Pipeline '${env.JOB_NAME}' [${env.BUILD_NUMBER}]",
                body: "Pipeline успешно завершен\nСсылка: ${env.BUILD_URL}",
                to: "${NOTIFICATION_EMAIL}"
            )
        }
        failure {
            emailext (
                subject: "FAILURE: Pipeline '${env.JOB_NAME}' [${env.BUILD_NUMBER}]",
                body: "Pipeline завершился ошибкой\nСсылка: ${env.BUILD_URL}",
                to: "${NOTIFICATION_EMAIL}"
            )
        }
    }
}
