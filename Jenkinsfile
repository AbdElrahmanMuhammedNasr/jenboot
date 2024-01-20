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
                script {
                    withSonarQubeEnv(credentialsId: 'sonerqube_secret_key') {
                        sh "${MAVEN_HOME}/bin/mvn sonar:sonar"
                    }
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Build and tag the Docker image
                    dockerImage = docker.build  ${DOCKER_IMAGE_TAG}

                    
                    // sh "docker build -t ${DOCKER_IMAGE_TAG} ."
                    sh "docker container run -d -p 6060:6060 --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE_TAG}"

                    // Log in to Docker registry (if needed)
                    // sh "docker login -u your-docker-username -p your-docker-password ${DOCKER_REGISTRY}"

                    // Push the Docker image to the registry
                    // sh "docker push ${DOCKER_IMAGE_TAG}"

                    //       withCredentials([usernamePassword(credentialsId: 'nexus_server', usernameVariable: 'USER', passwordVariable: 'PASS' )]){
                    //    sh ' echo $PASS | docker login -u $USER --password-stdin http://192.168.1.7:8081'
                    //    sh 'docker push http://192.168.1.7:8081/repository/jenboot:$BUILD_NUMBER'
                    // }

                    docker.withRegistry( 'http://192.168.1.7:8081', nexus_server ) {
                    dockerImage.push('latest')
                    }
                    
                }
            }
        }

        // stage('Push Docker Image to Nexus') {
        //     steps {
        //         nexusArtifactUploader(
        //             nexusVersion: 'nexus3',
        //             protocol: 'http',
        //             nexusUrl: '192.168.1.7:8081',
        //             groupId: 'QA',
        //             version: "${env.BUILD_ID}",
        //             repository: 'jenboot',
        //             credentialsId: 'nexus_server',
        //             artifacts: [
        //                 [
        //                     artifactId: 'jenboot',
        //                     classifier: '',
        //                     file: 'target/jenboot-0.0.1-SNAPSHOT.jar',
        //                     type: 'jar'
        //                 ]
        //             ]
        //         )
        //     }
        // }

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
