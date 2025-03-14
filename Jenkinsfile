pipeline {
    agent any
    tools{
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
                 --scan .
                 --out ./dependency-check-report
                 --format ALL
                 --prettyPrint
                ''', odcInstallation: 'OWASP-checker'
            }
        }
    }
}
