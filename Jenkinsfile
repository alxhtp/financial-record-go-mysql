pipeline {
    agent { label 'devops1-alex' }

    stages {
        stage('Pull SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/alxhtp/financial-record-go-mysql.git'
            }
        }
        
        stage('Build') {
            steps {
                sh'''
                go mod tidy
                '''
            }
        }
        
        stage('Testing') {
            steps {
                sh'''
                go test -coverprofile=coverage.out -v ./config
                '''
            }
        }
        
        stage('Code Review') {
            steps {
                sh'''
                sonar-scanner   -Dsonar.projectKey=app-alex   -Dsonar.sources=.   -Dsonar.host.url=http://172.23.10.21:9000   -Dsonar.token=sqp_cb6fc81c615cbb350ed9f59708f1a29f9bd7c90e
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                sh'''
                docker build -t financial-record-go-mysql .
                docker run -d -p 8081:8000 financial-record-go-mysql
                '''
            }
        }
    }
}