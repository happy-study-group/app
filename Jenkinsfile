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
        sh '''sonar-scanner \\
  -Dsonar.projectKey=app \\
  -Dsonar.sources=. \\
  -Dsonar.host.url=http://localhost:9000 \\
  -Dsonar.login=ddc581e3da2a20486790f95811c622c9899c98be'''
      }
    }

  }
}