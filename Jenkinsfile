pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning the repository...'
                git branch: 'devops', url: 'https://github.com/mihalypal/PRF-Forum.git'
            }
        }
        stage('Stop terraform before test') {
            steps {
                echo 'Stop Terraform infastructure \'cause it is use the same container names'
                script {
                    sh '''
                    terraform destroy -auto-approve
                    sleep 10
                    '''
                }
            }
        }
        stage('Build and Run MongoDB') {
            steps {
                echo 'Building and starting MongoDB container...'
                script {
                    sh '''
                    if docker ps | grep my_mongo_container; then
                        docker stop /my_mongo_container || true
                        sleep 10 # Wait for stop
                    fi
                    cd backend
                    docker build -t my_mongo_image -f Dockerfile .
                    docker run --rm --name my_mongo_container -p 5000:27017 -d my_mongo_image
                    '''
                }
            }
        }
        stage('Build and Run Backend') {
            steps {
                echo 'Building and starting Backend container...'
                script {
                    sh '''
                    if docker ps | grep backend_container; then
                        docker stop /backend_container || true
                        sleep 10 # Wait for stop
                    fi
                    cd backend
                    docker build -t backend-app -f Dockerfile_be .
                    docker run --rm --name backend_container --link my_mongo_container:mongo -p 3000:3000 -d backend-app
                    '''
                }
            }
        }
        /*stage('Check Backend Health') {
            steps {
                echo 'Checking backend container health...'
                script {
                    sh '''
                    sleep 10 # Wait for the backend to start
                    if ! docker ps | grep backend_container; then
                        echo "Backend container failed to start"
                        docker logs backend_container || true
                        exit 1
                    fi
                    '''
                }
            }
        }*/
        stage('Build and Run Frontend') {
            steps {
                echo 'Building and starting Frontend container...'
                script {
                    sh '''
                    if docker ps | grep frontend_container; then
                        docker stop /frontend_container || true
                        sleep 10 # Wait for stop
                    fi
                    cd frontend
                    docker build -t frontend-app .
                    docker run --rm --name frontend_container --link backend_container:backend -p 4200:4200 -d frontend-app
                    '''
                }
            }
        }
        stage('Build and Run Nginx') {
            steps {
                echo 'Building and starting Nginx reverse proxy...'
                script {
                    sh '''
                    docker stop nginx_container || true
                    docker build -t nginx-reverse-proxy -f nginx/Dockerfile .
                    pwd
                    docker run --rm --name nginx_container --link frontend_container:frontend -p 80:80 -d nginx-reverse-proxy
                    '''
                }
            }
        }
    }
    post {
        always {
            echo 'Stopping all containers...'
            sh '''
            docker stop my_mongo_container || true
            docker stop backend_container || true
            docker stop frontend_container || true
            docker stop nginx_container || true
            '''
        }
        success {
            echo 'Pipeline completed successfully!'
            echo 'Let\'s start the deployment..'
            echo 'Running Terraform...'
            sh '''
            pwd
            cp prometheus.yml /tmp/prometheus.yml
            terraform init
            terraform apply -auto-approve
            '''
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
