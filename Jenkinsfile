pipeline {
    agent any
    triggers {
        pollSCM('H/5 * * * *')  // Проверять изменения каждые 5 минут
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo '✅ Код успешно получен из GitHub'
                sh 'ls -la'
            }
        }
        stage('Build') {
            steps {
                echo '🔨 Сборка проекта...'
                // Пример для Node.js проекта:
                // sh 'npm install'
                // sh 'npm run build'
                
                // Пример для Java проекта:
                // sh 'mvn clean compile'
                
                sh 'echo "Сборка завершена"'
            }
        }
        stage('Test') {
            steps {
                echo '🧪 Запуск тестов...'
                // sh 'npm test'
                // sh 'mvn test'
                sh 'echo "Тестирование завершено"'
            }
        }
        stage('Deploy') {
            steps {
                echo '🚀 Деплой...'
                sh 'echo "Деплой выполнен"'
            }
        }
    }
    post {
        always {
            echo '📊 Пайплайн завершен'
        }
        success {
            echo '✅ Все этапы выполнены успешно!'
        }
        failure {
            echo '❌ Пайплайн завершился с ошибкой'
        }
    }
}
