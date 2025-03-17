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

        stage('Build Docker Image on main') {
            when {
                branch 'main'
            }
            steps {
                echo "Building Docker image on main branch"
                sh 'docker image prune -af'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_VERSION} -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Build Docker Image on feature') {
            when {
                branch 'feature-*'
            }
            steps {
                echo "Building Docker image on feature branch"
                sh 'docker image prune -af'
                sh "docker build -t ${IMAGE_NAME_FEATURE}:${IMAGE_VERSION} ."
            }
        }

        stage('Trivy-Check') {
           steps {
             script {
                 if (env.BRANCH_NAME == 'main') {
                    echo "Running Trivy scan on main branch..."
                    sh "trivy image --format table -o report.html ${IMAGE_NAME}:${IMAGE_VERSION}"
                 } else if (env.BRANCH_NAME.startsWith('feature-')) {
                    echo "Running Trivy scan on feature branch..."
                    sh "trivy image --format table -o report.html ${IMAGE_NAME_FEATURE}:${IMAGE_VERSION}"
                 } else {
                    echo "Branch is neither main nor a feature branch. Skipping Trivy scan."
                 }
              }
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
                branch 'feature-*'
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
                branch 'feature-*'
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
        stage('Git Clone&Update&Push manifest repo') {
            when {
                branch 'main'
            }
            steps {
                echo 'Cloning repo'
                sh 'rm -rf ArgoCd-project-CD_Process'
                sh "git clone https://github.com/danushvithiyarth/ArgoCd-project-CD_Process.git"

                echo 'Updating repo'
                dir("ArgoCd-project-CD_Process/manifest"){
                  sh 'sed -i "s#danushvithiyarth/argocdproject:.*#${IMAGE_NAME}:${IMAGE_VERSION}#g" deployment.yaml'
                  sh 'cat deployment.yaml'

                  echo 'Commiting and Pushing the repo'
                  sh 'git config --global user.name "admin"'
                  sh 'git config --global user.email "abc@gmail.com"'
                  sh 'git add deployment.yaml'
                  sh 'git commit -m "Update image tag to ${IMAGE_NAME}:${IMAGE_VERSION}"'
                  withCredentials([usernamePassword(credentialsId: 'github-cerds', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_TOKEN')]) {
                     sh 'git remote set-url origin https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/danushvithiyarth/ArgoCd-project-CD_Process.git'
                     sh 'git push origin main'
                  }
               }     
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
