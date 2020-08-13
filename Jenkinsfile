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
        sh 'tar -zcvf archive.tar.gz app/'
        archiveArtifacts 'app.tar.gz'
      }
    }

  }
}