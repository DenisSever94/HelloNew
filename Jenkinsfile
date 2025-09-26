pipeline {
    agent any
    triggers {
        githubPush()  // Автоматический запуск при push
    }
    stages {
        stage('Checkout') {
            steps {
                echo '🎯 Забор кода из GitHub...'
                checkout scm
                sh '''
                    echo "Репо: ${env.GIT_URL}"
                    echo "Ветка: ${env.GIT_BRANCH}"
                    echo "Коммит: ${env.GIT_COMMIT}"
                '''
            }
        }
        stage('Build') {
            steps {
                echo '🔨 Сборка проекта...'
                // Ваши команды сборки
                sh 'echo "Сборка запущена из коммита: ${env.GIT_COMMIT}"'
            }
        }
        stage('Notifications') {
            steps {
                echo '📧 Уведомления...'
                sh 'echo "Пайплайн запущен автоматически по вебхуку"'
            }
        }
    }
    post {
        always {
            echo '🏁 Пайплайн завершен'
            sh 'echo "Время: $(date)"'
        }
        success {
            echo '✅ Успех! Пайплайн выполнен после коммита'
        }
        changed {
            echo '🔄 Статус изменился по сравнению с предыдущей сборкой'
        }
    }
}
