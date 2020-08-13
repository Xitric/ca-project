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
      steps {
        sh 'docker save -o ca-project-test.tar xitric/ca-project-python:latest'
        sshagent(credentials: ['ssh_production']) {
          sh 'scp ./ca-project-test.tar ubuntu@34.76.76.30:/home/ubuntu/test/ca-project-test.tar'
          sh 'scp ./docker-compose.yml ubuntu@34.76.76.30:/home/ubuntu/test'
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@34.76.76.30 "cd /home/ubuntu/test && docker load -i ca-project-test.tar"'
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@34.76.76.30 "cd /home/ubuntu/test && docker-compose up -d"'
        }
      }
    }
    
    stage('Publish DockerHub') {
      when {
        branch 'master'
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
	    steps {
	      sshagent(credentials: ['ssh_production']) {
		      sh 'ci/deploy_production.sh'
		    }
	    }
	  }
  }
}
