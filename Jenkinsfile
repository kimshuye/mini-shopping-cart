pipeline {
  agent any
  
  environment {
    DOCKER_HOST="tcp://localhost:2376"
  }

  stages {
    stage('code analysis') {
      steps {
        sh 'id'
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

