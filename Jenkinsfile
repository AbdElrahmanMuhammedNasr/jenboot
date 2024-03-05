pipeline {
    agent any

    environment {
        MAVEN_HOME = tool 'Maven'
        JAVA_HOME = tool 'JDK17'
        DOCKER_IMAGE_NAME = 'jenboot'
        DOCKER_CONTAINER_NAME ='jenbootservice'
        DOCKER_IMAGE_TAG = "${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
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

        stage("SonarQube Analysis") {
            steps {
                                echo 'Deploy!'

                // script {
                //     withSonarQubeEnv(credentialsId: 'sonerqube_secret_key') {
                //         sh "${MAVEN_HOME}/bin/mvn sonar:sonar"
                //     }
                // }
            }
        }

        stage('Build iamge and run container') {
            steps {
                script {
                    // Build and tag the Docker image
                    // dockerImage = docker.build  ${DOCKER_IMAGE_TAG}

                    
                    sh "docker build -t ${DOCKER_IMAGE_TAG} ."
                    // sh "docker container run -d -p 6060:6060 --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE_TAG}"

                    // Log in to Docker registry (if needed)
                    // sh "docker login -u admin -p root 192.168.1.4:6060"
 
                    
                    
                }
            }
        }
         stage('Push image to Nexus') {
            steps {
                script {
                     withCredentials([usernamePassword(credentialsId: 'nexus_server', usernameVariable: 'USER', passwordVariable: 'PASS' )]){
                      sh ' echo $PASS | docker login -u $USER --password-stdin https://192.168.1.4:6060'
                      sh 'docker tag   jenboot:$BUILD_NUMBER  192.168.1.4:6060/jenboot:$BUILD_NUMBER'
                      sh 'docker push 192.168.1.4:6060/jenboot:$BUILD_NUMBER'
                    }
            }
        }

      

        stage('Deploy') {
            steps {
                echo 'Deploy!'
                // Add deployment steps if needed
            }
        }

        stage('Post-build') {
            steps {
                echo 'Post-build!'
                // Add post-build steps if needed
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
