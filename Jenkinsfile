pipeline {
  agent any
  stages {
    stage('Git clone') {
      steps {
        git(url: 'git@github.com:happy-study-group/app.git', branch: 'master', changelog: true, credentialsId: 'e892a945-7be5-4442-a0bc-664a5b281ffe')
        sh '''pwd
git clone'''
      }
    }

  }
}