pipeline {
    agent any

    environment {
        // Define environment variables if needed
        MAVEN_HOME = tool 'Maven'
        JAVA_HOME = tool 'JDK17'
        DOCKER_IMAGE_NAME = 'jenboot'
        DOCKER_CONTAINER_NAME ='jenbootservice'
        DOCKER_IMAGE_TAG = "${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
//         DOCKER_REGISTRY = 'your-docker-registry' // Replace with your Docker registry URL
//         DOCKER_IMAGE_TAG = "${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh "${MAVEN_HOME}/bin/mvn clean package"
            }
        }
        stage('Cleanup Old Images/Container') {
            steps {
                script {
                    sh "docker ps -a -q --filter name=${DOCKER_CONTAINER_NAME} | xargs -r docker rm -f"
                     def containersExist = sh(script: "docker ps -a -q --filter name=${DOCKER_CONTAINER_NAME}", returnStatus: true) == 0
                     // Remove old containers if they exist
                     if (containersExist) {
                           sh "docker ps -a -q --filter name=${dockerContainerName} | xargs -r docker rm -f"
                     } else {
                           echo "No containers found with name ${dockerContainerName}. Hello!"
                     }

                    def imageName = "${DOCKER_IMAGE_NAME}"
                    def currentImageTag = "${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                    def imageTags = sh(script: "docker images --format \"{{.Repository}}:{{.Tag}}\" | grep ${imageName}", returnStdout: true).trim().split('\n')
                    for (def tag in imageTags) {
                        if (tag != currentImageTag) {
                            sh "docker rmi -f $tag"
                        }
                    }
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Build and tag the Docker image
                    sh "docker build -t ${DOCKER_IMAGE_TAG} ."
                    sh "docker container run -d --name ${DOCKER_CONTAINER_NAME}  ${DOCKER_IMAGE_TAG}"



                    // Log in to Docker registry (if needed)
                    // sh "docker login -u your-docker-username -p your-docker-password ${DOCKER_REGISTRY}"

                    // Push the Docker image to the registry
                    //sh "docker push ${DOCKER_IMAGE_TAG}"
                }
            }
        }

        stage('Deploy') {
            steps {
            echo 'Deploy!'
            }
        }

        stage('Post-build') {
            steps {
            echo 'Post-build!'
            }
        }
    }

    post {
        success {
            echo 'Build and deployment successful!'
        }
        failure {
            echo 'Build or deployment failed!'
        }
    }
}
