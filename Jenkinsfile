pipeline {
    agent any

    environment {
        // DockerHub username
        DOCKER_HUB_USER = 'kalyansagar5'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/kalyansagar5/bookmyshow.git',
                    credentialsId: 'git_cred'
            }
        }

        stage('Build JAR (Maven)') {
            steps {
                echo 'Building Spring Boot JAR...'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t bookmyshow-app ."
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                echo 'Pushing Docker image to DockerHub...'
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker tag bookmyshow-app $DOCKER_USER/bookmyshow-app:latest
                        docker push $DOCKER_USER/bookmyshow-app:latest
                    """
                }
            }
        }

        stage('Deploy Container') {
            steps {
                echo 'Stopping old container and running new one...'
                sh '''
                    docker rm -f bookmyshow-app || true
                    docker run -d -p 8080:8080 --name bookmyshow-app bookmyshow-app
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline succeeded! Application is running."
        }
        failure {
            echo "❌ Pipeline failed! Check logs for details."
        }
    }
}
