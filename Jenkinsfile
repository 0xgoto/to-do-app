pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "nukkunda/kanban"
        DOCKER_USERNAME = "nukkunda"
        DOCKER_PASSWORD = credentials('DOCKER_SECRET')
    }
    stages {
        stage('Test') {
            steps {
                sh '''
                    echo "running the tests ......."
                '''
            }
        }
        stage('Build') {
            steps {
                sh '''
                    echo "building the docker image ......."
                    docker build -t "${DOCKER_IMAGE_NAME}" -f ./Dockerfile .
                '''
            }
        }
        stage('Push') {
            steps {
                sh '''
                    echo "pushing docker image ......."
                    docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
                    docker tag "${DOCKER_IMAGE_NAME}" "${DOCKER_IMAGE_NAME}":"$BUILD_NUMBER"
                    docker push "${DOCKER_IMAGE_NAME}":"$BUILD_NUMBER"
                    docker push "${DOCKER_IMAGE_NAME}":latest
                    echo "cleaning up the local images ......."
                    docker rmi "${DOCKER_IMAGE_NAME}":"$BUILD_NUMBER"
                    docker rmi "${DOCKER_IMAGE_NAME}":latest
                '''
            }
        }
        stage('Deploy') {
            steps {
            withAWS(profile:'bhava'){
                sh '''
                    echo "deploying the application ........"
                    kubectl apply -f kanban-deployment.yaml --force=true
                    kubectl apply -f kanban-service.yaml
                '''
                }
            }
        }
    }
}