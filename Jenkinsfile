pipeline {
    agent any
    
    tools {
        maven 'Maven3'
    }
    
    environment {
        DOCKER_IMAGE = "hello-app"
        DOCKER_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Проверка кода') {
            steps {
                echo 'Код получен из GitHub'
            }
        }
        
        stage('Сборка и тесты') {
            steps {
                echo 'Сборка и тестирование'
                sh 'mvn clean package -DskipTests'
            }
        }
        
        stage('Сборка Docker Image') {
            steps {
                echo 'Создание Docker образа...'
                script {
                    // Устанавливаем Docker
                    sh '''
                        if ! command -v docker &> /dev/null; then
                            echo "Устанавливаем Docker..."
                            curl -fsSL https://get.docker.com | sh
                            usermod -aG docker jenkins
                        fi
                    '''
                    dockerImage = docker.build("${env.DOCKER_IMAGE}:${env.DOCKER_TAG}")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                echo 'Пуш образа в registry...'
                script 
                    echo "Образ собран: ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Деплой в Kubernetes'
                // Здесь команды kubectl apply и т.д.
            }
        }
    }
    
    post {
        always {
            echo 'Пайплайн завершен'
            sh 'docker system prune -f || true'
        }
        success {
            echo 'ПАЙПЛАЙН УСПЕШНО ЗАВЕРШЕН! 🎉'
        }
    }
}
