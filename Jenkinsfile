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


     stage("SonarQube Analysis"){
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
                    sh "docker build -t ${DOCKER_IMAGE_TAG} ."
                    sh "docker container run -d  -p 6060:6060  --name ${DOCKER_CONTAINER_NAME}  ${DOCKER_IMAGE_TAG}"



                    // Log in to Docker registry (if needed)
                    // sh "docker login -u your-docker-username -p your-docker-password ${DOCKER_REGISTRY}"

                    // Push the Docker image to the registry
                    //sh "docker push ${DOCKER_IMAGE_TAG}"
                }
            }
        }
	stage('Push Docker Image to Nexus') {
            steps {
                  nexusArtifactUploader(
		        nexusVersion: 'nexus3',
		        protocol: 'http',
		        nexusUrl: 'http://192.168.1.7:8081',
		        groupId: 'com.jenboot',
		        version: '1.020',
		        repository: 'jenboot',
		        credentialsId: 'nexus_server',
		        artifacts: [
		            [artifactId: 'jenboot',
		             classifier: '',
		             file: 'jenservuce.jar',
		             type: 'jar']
		        ]
		     )
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
