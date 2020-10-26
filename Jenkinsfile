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
        withSonarQubeEnv(installationName: 'sonarqube-scanner', credentialsId: 'sonar', envOnly: true) {
          sh '''// ${sonarqube-scanner}/bin/sonar-scanner

println ${env.SONAR_TEST} 
println ${env.SONAR_CONFIG_NAME} 
println ${env.SONAR_HOST_URL}
println ${env.SONAR_AUTH_TOKEN}
println ${sonarqube-scanner}
println ${SONAR_TEST}'''
        }

      }
    }

  }
  environment {
    SONAR_TEST = 'ruby'
  }
}