pipeline {
    agent any

    environment {
        IMAGE_NAME = "danushvithiyarth/argocdproject"
        IMAGE_VERSION = "v${BUILD_NUMBER}"
    }

    tools {
        maven 'maven-3.9'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('OWASP-check') {
            steps {
                dependencyCheck additionalArguments: '''--scan target/ 
                  --format ALL 
                  --apiKey "dedd5531-0050-4e00-b986-06348bdde990"
                ''', odcInstallation: 'owasp-checker'
            }
        }

        stage('SonarQube-analysis') { 
            steps {
                echo "Sonar scanner"
                withSonarQubeEnv('sonar-server') {
                    sh '''
                        ${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=argo-project \
                        -Dsonar.projectName=argo-project \
                        -Dsonar.java.binaries=target/classes
                    '''     
                }
            }
        }

        stage('Build') {
            steps {
                echo "docker build"
                sh 'docker image prune -f'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_VERSION} -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Trivy-Check') {
            steps {
                echo "trivy scan"
                sh "trivy image --format table -o report.html ${IMAGE_NAME}:${IMAGE_VERSION}"
            }
        }
    }
}
