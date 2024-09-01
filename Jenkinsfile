pipeline {
    agent any

    environment {
        GO_PATH = '/usr/local/go/bin'
        DOCKER_IMAGE = 'shivaminc/todo-app'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        REPO_URL = 'https://github.com/Shivaminc/go-redis'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                git url: "${REPO_URL}", branch: 'main'
            }
        }

        stage('Check Go Installation') {
            steps {
                echo 'Checking Go installation...'
                sh '''
                export PATH=${GO_PATH}:$PATH
                go version
                '''
            }
        }

        stage('Build') {
            steps {
                echo 'Building Go application...'
                sh '''
                export PATH=${GO_PATH}:$PATH
                go build -o myapp main.go
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh '''
                docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                '''
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

        stage('Deploy with Docker') {
            steps {
                echo 'Deploying application with Docker...'
                sh '''
                docker stop todo-app || true
                docker rm todo-app || true
                docker run -d --name todo-app -p 9042:80 ${DOCKER_IMAGE}:${DOCKER_TAG}
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed!'
            sh 'docker logs todo-app || true'
        }
    }
}
