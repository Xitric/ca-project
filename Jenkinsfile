pipeline {
  agent any
  stages {
    stage('clone down') {
      steps {
        stash(name: 'code', excludes: '.git')
      }
    }

    stage('Build environments') {
      options {
        skipDefaultCheckout(true)
      }
      steps {
        unstash 'code'
        sh 'ci/build_environments.sh'
      }
    }

    stage('unit test') {
      agent {
        docker {
          image 'xitric/ca-project-test:latest'
        }

      }
      options {
        skipDefaultCheckout(true)
      }
      steps {
        unstash 'code'
        sh 'ci/test_app.sh'
      }
    }

    stage('create artifact') {
      options {
        skipDefaultCheckout(true)
      }
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

  }
}