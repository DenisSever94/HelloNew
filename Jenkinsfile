pipeline {
    agent any
    
    // Явно указываем триггер вебхука
    triggers {
        githubPush()
    }
    
    stages {
        stage('Webhook Debug') {
            steps {
                echo '🎯 Вебхук получен!'
                script {
                    // Покажем детали запуска
                    echo "Build URL: ${env.BUILD_URL}"
                    echo "Git Commit: ${env.GIT_COMMIT ?: 'Not available'}"
                    echo "Git Branch: ${env.GIT_BRANCH ?: 'Not available'}"
                    
                    // Покажем причину запуска
                    def causes = currentBuild.getBuildCauses()
                    echo "Build causes: ${causes}"
                }
            }
        }
        
        stage('Checkout Code') {
            steps {
                echo '📥 Забираем код из GitHub...'
                checkout scm
                sh 'git log -1 --oneline'
            }
        }
        
        stage('Simple Build') {
            steps {
                echo '🔨 Простая сборка...'
                sh '''
                    echo "Рабочая директория: $(pwd)"
                    echo "Файлы в репозитории:"
                    ls -la
                '''
            }
        }
    }
    
    post {
        success {
            echo '✅ Пайплайн успешно запущен по вебхуку!'
            emailext (
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Пайплайн выполнен успешно!",
                to: "denissedih0503@gmail.com"
            )
        }
        failure {
            echo '❌ Пайплайн завершился ошибкой'
        }
    }
}
