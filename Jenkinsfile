pipeline {
  agent any
  tools {
    // a bit ugly because there is no `@Symbol` annotation for the DockerTool
    // see the discussion about this in PR 77 and PR 52: 
    // https://github.com/jenkinsci/docker-commons-plugin/pull/77#discussion_r280910822
    // https://github.com/jenkinsci/docker-commons-plugin/pull/52
    'org.jenkinsci.plugins.docker.commons.tools.DockerTool' '18.09'
  }
  environment {
    DOCKER_OPTS="-H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock"
  }

  stages {
    stage('code analysis') {
      steps {
        sh 'make code_analysis_backend' 
      }
    }
    stage('run unit test') {
      steps {
            sh 'make run_unittest_backend'
      }
    }
    stage('run integration test') {
      steps {
        sh 'make run_integratetest_backend'
      }
    }
    stage('build') {
      steps {
            sh 'make build_backend'
          }     
    }
    stage('run ATDD') {
      steps {
        sh 'make start_service'
        sh 'make run_robot_requests'
        sh 'make run_robot_selinium'
        sh 'make stop_service'
      }
    }
  }

  post { 
    always { 
      sh "make stop_service"
      sh "docker volume prune -f"
    }
  }
}

