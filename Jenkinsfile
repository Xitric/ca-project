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
        junit 'test-reports/TEST-*.xml'
      }
    }

    stage('create artifact') {
      options {
        skipDefaultCheckout(true)
      }
      parallel {
        stage('create artifact') {
          agent {
            docker {
              image 'xitric/ca-project-zip:latest'
            }
          }
          steps {
            unstash 'code'
            sh 'ci/create_artifact.sh'
            archiveArtifacts 'app.zip'
          }
        }

        stage('dockerize application') {
          steps {
            unstash 'code'
            sh 'ci/build_docker.sh'
          }
        }
      }
    }

    stage('Deploy test server') {
      when {
        anyOf {
          changeRequest()
          branch pattern: "dev/.+", comparator: "REGEXP"
        }
      }
      options {
        skipDefaultCheckout(true)
      }
      steps {
        sh 'ci/package_test.sh'
        sshagent(credentials: ['ssh_production']) {
          sh 'ci/deploy_test.sh'
        }
      }
    }
    
    stage('Publish DockerHub') {
      when {
        branch 'master'
      }
      options {
        skipDefaultCheckout(true)
      }
      environment {
        DOCKERCREDS = credentials('docker_creds')
      }
      steps {
        sh 'ci/publish_docker.sh'
      }
    }
    
	  stage('Deploy to production') {
      when {
        branch 'master'
      }
      options {
        skipDefaultCheckout(true)
      }
	    steps {
	      sshagent(credentials: ['ssh_production']) {
		      sh 'ci/deploy_production.sh'
		    }
	    }
	  }
  }

  post {
    always {
        deleteDir()
    }
  }
}
