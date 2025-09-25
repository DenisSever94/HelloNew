pipeline {
    agent any

    tools {
        jdk 'Java-17'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/DenisSever94/HelloNew.git'
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean package'
            }
        }

        stage('Test') {
            steps {
                sh './mvnw test'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying...'
                # тут можно добавить скрипт деплоя, например копирование на сервер
            }
        }
    }

    post {
        always {
            junit '**/target/surefire-reports/*.xml'
        }
    }
}
