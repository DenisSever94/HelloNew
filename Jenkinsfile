pipeline {
    agent any

    tools {
        maven 'M3'
        jdk 'jdk21'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/DenisSever94/HelloNew.git',
                    credentialsId: '' // оставьте пустым если репозиторий публичный
            }
        }

        stage('Test') {
            steps {
                sh 'mvn --version'
                sh 'java -version'
            }
        }
    }
}
