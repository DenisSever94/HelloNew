pipeline {
    agent any

    tools {
        jdk 'Java-17'
        git 'Git'
    }

    stages {
        stage('Checkout') {
            steps {
              git branch: 'main', url: 'https://github.com/DenisSever94/HelloNew.git'
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
            }
        }
    }

    post {
        always {
            junit '**/target/surefire-reports/*.xml'
        }
    }
}
