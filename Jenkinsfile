pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kalyansagar5/bookmyshow"
        CONTAINER_NAME = "bookmyshow-app"
    }

    stages {

        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/your-username/bookmyshow.git'
            }
        }

        stage('Build JAR (Maven)') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t bookmyshow-app .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker_cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    bat """
                        docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                        docker tag bookmyshow-app %DOCKER_USER%/bookmyshow:latest
                        docker push %DOCKER_USER%/bookmyshow:latest
                    """
                }
            }
        }

        stage('Run Container') {
            steps {
                bat """
                    docker rm -f %CONTAINER_NAME% || exit 0
                    docker run -d -p 8080:8080 --name %CONTAINER_NAME% bookmyshow-app
                """
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Pipeline Failed!'
        }
    }
}
