def remote = [:]
remote.name = "production"
remote.host = "35.195.148.16"
remote.allowAnyHosts = true

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
          when {
            branch 'master'
          }
          steps {
            unstash 'code'
            sh 'ci/build_docker.sh'
          }
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
		      sh 'scp ./docker-compose.yml ubuntu@35.195.148.16:/home/ubuntu/production'
		      sh 'ssh -o StrictHostKeyChecking=no ubuntu@35.195.148.16 "cd /home/ubuntu/production && docker-compose up -d"'
		    }
	    }
	  }
  }
}
