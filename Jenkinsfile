pipeline {
    agent any
    triggers {
        githubPush()
    }
    
    environment {
        // Настройки Docker
        DOCKER_IMAGE = "DenisSever/java-app"
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        
        // Настройки Kubernetes
        KUBE_NAMESPACE = "default"
        APP_NAME = "java-app"
        
        // Уведомления
        NOTIFICATION_EMAIL = "denissedih@bk.ru"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
                echo '✅ Код получен из GitHub'
            }
        }
        
        stage('Build Java Application') {
            steps {
                echo '🔨 Сборка Java приложения...'
                sh 'mvn clean compile'
            }
        }
        
        stage('Run Unit Tests') {
            steps {
                echo '🧪 Запуск Unit-тестов...'
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Package Application') {
            steps {
                echo '📦 Создание JAR пакета...'
                sh 'mvn package -DskipTests'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo '🐳 Создание Docker образа...'
                script {
                    // Сначала проверяем что JAR файл существует
                    sh 'ls -la target/'
                    dockerImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                echo '📤 Публикация Docker образа...'
                script {
                    // Для начала используем простую публикацию без credentials
                    sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                    echo "Образ подготовлен: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                echo '🚀 Деплой в Kubernetes...'
                sh """
                    # Проверяем доступность Kubernetes
                    kubectl cluster-info
                    
                    # Применяем манифесты (пока просто проверяем их наличие)
                    ls -la k8s/
                    echo 'Kubernetes манифесты готовы к применению'
                """
            }
        }
    }
    
    post {
        always {
            echo '📊 Пайплайн завершен'
        }
        success {
            echo '✅ Пайплайн выполнен успешно!'
        }
        failure {
            echo '❌ Пайплайн завершился ошибкой'
        }
    }
}
