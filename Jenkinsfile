pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'vourteen14/devops_nginx'
        GCP_PROJECT = credentials('gcp_project_id')
        GCP_ZONE = credentials('gcp_instance_zone')
        GCP_INSTANCE = credentials('gcp_instance_name')
    }

    stages {

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