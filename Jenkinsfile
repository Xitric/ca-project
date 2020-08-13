pipeline {
  agent any
  stages {
    stage('clone down') {
      steps {
        stash(name: 'code', excludes: '.git')
      }
    }

    stage('create artifact') {
      steps {
        unstash 'code'
        sh 'gzip -r app'
        archiveArtifacts 'app.zip'
      }
    }

  }
}