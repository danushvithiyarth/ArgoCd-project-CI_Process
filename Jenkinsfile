pipeline {
    agent any

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        IMAGE_NAME = "danushvithiyarth/argocdproject"
        IMAGE_NAME_FEATURE = "danushvithiyarth/argocdproject-feature"
        IMAGE_VERSION = "v${env.BUILD_NUMBER}"
    }

    tools {
        maven 'maven-3.9'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                echo "Install Dependency"
                sh 'mvn clean install'
            }
        }

        stage('OWASP-check') {
            steps {
                echo "OWASP check"
                dependencyCheck additionalArguments: '''--scan target/ 
                  --format ALL 
                  --nvdApiKey "dedd5531-0050-4e00-b986-06348bdde990"
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
                sh 'docker image prune -af'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_VERSION} -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Trivy-Check') {
            steps {
                echo "trivy scan"
                sh "trivy image --format table -o report.html ${IMAGE_NAME}:${IMAGE_VERSION}"
            }
        }

        stage('Test application - Main') {
            when {
                branch 'main'
            }
            steps {
                echo "Application testing on main branch"
                sh "docker run -d --name=test-application -p 80:80 ${IMAGE_NAME}:${IMAGE_VERSION}"
            }
        }

        stage('Test application - Feature') {
            when {
                expression { env.BRANCH_NAME.startsWith('feature-') }
            }
            steps {
                echo "Application testing on feature branch."
                sh "docker run -d --name=feature-test-application -p 80:80 ${IMAGE_NAME_FEATURE}:${IMAGE_VERSION}"
            }
        }

        stage('Push Image') {
            steps {
                timeout(time: 1, unit: 'DAYS') {
                    input message: 'Is the application build ok?', ok: 'Approved', submitter: 'admin'
                }
            }
        }

        stage('DockerHub image push - Main') {
            when {
                branch 'main'
            }
            steps {
                echo "DockerHub push (main branch)..."
                sh "docker rm -f test-application"
                withCredentials([usernamePassword(credentialsId: 'Docker_pass', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD} docker.io"
                }
                sh "docker push ${IMAGE_NAME} --all-tags"
            }
        }

        stage('DockerHub image push - Feature') {
            when {
                expression { env.BRANCH_NAME.startsWith('feature-') }
            }
            steps {
                echo "DockerHub push (feature branch)..."
                sh "docker rm -f feature-test-application"
                withCredentials([usernamePassword(credentialsId: 'Docker_pass', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD} docker.io"
                }
                sh "docker push ${IMAGE_NAME_FEATURE} --all-tags"
            }
        }
    }

    post {
        always {
            publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, icon: '', keepAll: true, reportDir: './', 
                         reportFiles: 'dependency-check-jenkins.html', reportName: 'OWASP Report', reportTitles: '', 
                         useWrapperFileDirectly: true])
            publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, icon: '', keepAll: true, reportDir: './',
                         reportFiles: 'report.html', reportName: 'Trivy Report', reportTitles: '', useWrapperFileDirectly: true])
        }
    }
}
