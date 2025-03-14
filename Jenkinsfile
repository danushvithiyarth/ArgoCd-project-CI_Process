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
              sh 'rm -rf ~/.dependency-check/data'  // Force CVE database refresh
              sh '/opt/dependency-check/bin/dependency-check.sh --updateonly'  // Ensure latest CVE data

              dependencyCheck additionalArguments: '''
                --scan .
                --out ./dependency-check-report
                --format ALL
                --prettyPrint
              ''', odcInstallation: 'OWASP-checker'
          }
        }
        stage('SonarQube-analysis') { 
            steps {
                script {
                    echo "Sonar scanner"
                    withSonarQubeEnv('sonar-server') {
                    sh '''
                      ${SCANNER_HOME}/bin/sonar-scanner \
                      -Dsonar.projectKey=javakey \
                      -Dsonar.projectName=java-app \
                       -Dsonar.java.binaries=target/classes
                     '''
                    }     
                }
           }
        }
    }
}
