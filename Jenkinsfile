pipeline {
    agent any

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
                dependencyCheck additionalArguments: '''
                    --scan target/
                    --format ALL
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
    }
}

