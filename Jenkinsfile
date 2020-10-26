pipeline {
  agent any
  stages {
    stage('Git clone') {
      steps {
        git(url: 'git@github.com:happy-study-group/app.git', branch: 'master', changelog: true, credentialsId: 'e892a945-7be5-4442-a0bc-664a5b281ffe')
        sh '''pwd
ls -al
'''
      }
    }

    stage('SonarQube') {
      steps {
        tool(name: 'sonarqube-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation')
        withSonarQubeEnv(installationName: 'sonarqube-scanner', credentialsId: 'sonar', envOnly: true) {
          sh '''${scannerHome}/bin/sonar-scanner

echo ${env.SONAR_TEST} 
echo ${env.SONAR_CONFIG_NAME} 
echo ${env.SONAR_HOST_URL}
echo ${env.SONAR_AUTH_TOKEN}
echo ${sonarqube-scanner}
echo ${SONAR_TEST}
echo ${sonarqube-scanner}/bin/sonar-scanner'''
        }

      }
    }

  }
  environment {
    SONAR_TEST = 'ruby'
  }
}