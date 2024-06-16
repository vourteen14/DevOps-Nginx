pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'vourteen14/devops_nginx'
        GCP_PROJECT = credentials('gcp_project_id')
        GCP_ZONE = credentials('gcp_instance_zone')
        GCP_INSTANCE = credentials('gcp_instance_name')
        DOCKER_CREDENTIALS = credentials('DOCKER_CREDENTIALS')
        GITHUB_BRANCH = "${GIT_BRANCH.split("/")[1]}"
    }

    stages {

        stage('Login to Dockerhub') {
            steps {
                script {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME'
                }
            }
        }      

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE:$GITHUB_BRANCH .'
                }
            }
        }

        stage('Tagging Docker image to latest') {
            steps {
                script {
                    sh 'docker tag $DOCKER_IMAGE:$GITHUB_BRANCH $DOCKER_IMAGE:latest'
                }
            }
        }

        stage('Push Image to Dockerhub') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS) {
                        sh 'docker push -u $DOCKER_USERNAME/$DOCKER_IMAGE:$GITHUB_BRANCH'
                        sh 'docker push -u $DOCKER_USERNAME/$DOCKER_IMAGE:latest'
                    }
                }
            }
        }

        stage('Authenticate with GCP') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'GCLOUD_SERVICE_KEY', variable: 'GCLOUD_SERVICE_KEY')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GCLOUD_SERVICE_KEY'
                        sh 'gcloud config set project $GCP_PROJECT'
                    }
                }
            }
        }
        stage('Run gcloud') {
            steps {
                withCredentials([file(credentialsId: 'GCLOUD_SERVICE_KEY', variable: 'GCLOUD_SERVICE_KEY')]) {
                    sh '''
                        gcloud compute ssh $GCP_INSTANCE --zone $GCP_ZONE --command "
                        sudo docker ps -a
                        "
                    '''
                }
            }
        }
    }
}