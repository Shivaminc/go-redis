pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'shivaminc/simple-go-redis'
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

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running tests...'
                sh '''
                docker run --rm --name go-app ${DOCKER_IMAGE}:${DOCKER_TAG} go test -v -coverprofile=coverage.out -json | tee test_output.json | gotestsum --format=short-verbose --junitfile=report.xml
                '''
            }
        }

        stage('Publish Test Reports') {
            steps {
                echo 'Publishing test reports...'
                junit '**/report.xml'
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
                docker stop simple-go-redis || true
                docker rm simple-go-redis || true
                docker run -d --name simple-go-redis -p 9042:9042 ${DOCKER_IMAGE}:${DOCKER_TAG}
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
            sh 'docker logs simple-go-redis'
        }
    }
}
