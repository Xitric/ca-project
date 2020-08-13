pipeline {
  agent any
  stages {
    stage('clone down') {
      steps {
        stash(name: 'code', excludes: '.git')
      }
    }

    stage('create artifact') {
      parallel {
        stage('create artifact') {
          steps {
            unstash 'code'
            sh 'sh \'ci/create_artifact.sh\''
            archiveArtifacts 'app.tar.gz'
          }
        }

        stage('dockerize application') {
          steps {
            unstash 'code'
            sh 'sh \'ci/build_docker.sh\''
          }
        }

      }
    }

    stage('unit test') {
      agent {
        docker {
          image 'xitric/ca-project-python:latest'
          args 'tests.py'
        }

      }
      steps {
        junit 'app/build/test-results/test/TEST-*.xml'
      }
    }

  }
}