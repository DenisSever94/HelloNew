pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'denissever/hellonew-app'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }

    tools {
        maven 'M3'
        jdk 'jdk21'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
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
    }
}
