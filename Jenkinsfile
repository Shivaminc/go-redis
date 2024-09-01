pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'shivaminc/goredis-app'  // Update with your Docker Hub username and image name
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        REPO_URL = 'https://github.com/Shivaminc/go-redis'  // Update with your Git repository URL
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                git url: "${REPO_URL}", branch: 'main'
            }
        }

        stage('Build') {
            steps {
                echo 'Building Go application...'
                sh 'go build -o myapp main.go'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    def dockerImage = "${DOCKER_IMAGE}:${DOCKER_TAG}"
                    echo "Pushing Docker image ${dockerImage}..."
                    
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                        sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
                        sh "docker push ${dockerImage}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                sh '''
                docker stop goredis-app || true
                docker rm goredis-app || true
                docker run -d --name goredis-app -p 8080:8080 ${DOCKER_IMAGE}:${DOCKER_TAG}
                '''
            }
        }
    }

    post {
        success {
            echo 'Build and deployment completed successfully!'
        }
        failure {
            echo 'Build or deployment failed!'
            sh 'docker logs goredis-app'
        }
    }
}

