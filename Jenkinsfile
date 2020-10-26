pipeline {
  agent any
  stages {
    stage('Git clone') {
      steps {
        git(url: 'git@github.com:happy-study-group/app.git', branch: '/origin/master', changelog: true)
      }
    }

  }
}