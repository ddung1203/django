pipeline {
  agent any

  environment{
    githubCredential='github'
    dockerhubCredential='dockerhub'
    gitEmail='jeonjungseok1203@gmail.com'
    gitName='Joongseok Jeon'
    gitAddress='https://github.com/ddung1203/django'
  }

  stages {
    stage('Checkout Application Git Branch') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: githubCredential, url: gitAddress]]])
      }
      post {
        failure {
          echo 'Repository Clone Failure' 
          slackSend (color: '#FF0000', message: "FAILED: Repository Clone Failure")
        }
        success {
          echo 'Repository Clone Success' 
          slackSend (color: '#0AC9FF', message: "SUCCESS: Repository Clone Success")
        }
      }
    }

    stage('Docker Image Build') {
      steps{
        sh "docker build -t ddung1203/django:${BUILD_NUMBER} ."
        sh "docker build -t ddung1203/django:latest ."
      }
      post {
        success {
          echo "The Docker Image Build stage successfully."
          slackSend (color: '#0AC9FF', message: "SUCCESS: Docker Image Build SUCCESS")
        }
        failure {
          echo "The Docker Image Build stage failed."
          slackSend (color: '#FF0000', message: "FAILED: Docker Image Build FAILED")
        }
      }
    }

    stage('Docker Image Push'){
      steps {
        script{
          docker.withRegistry('https://registry.hub.docker.com', dockerhubCredential) {
            docker.image("ddung1203/django:${BUILD_NUMBER}").push()
            docker.image("ddung1203/django:latest").push()
          }
        }
      }
      post {
        success {
          echo "The deploy stage successfully."
          slackSend (color: '#0AC9FF', message: "SUCCESS: Docker Image Upload SUCCESS")
          sh "docker rmi ddung1203/django:${BUILD_NUMBER}"
          sh "docker rmi ddung1203/django:latest"
        }
        failure {
          echo "The deploy stage failed."
          slackSend (color: '#FF0000', message: "FAILED: Docker Image Upload FAILED")
        }
      }
    }

    stage('Kubernetes Manifest Update') {
      steps {
        git credentialsId: githubCredential,
            url: gitAddress,
            branch: 'main'  

        // 이미지 태그 변경 후 메인 브랜치에 push
        sh "git config --global user.email ${gitEmail}"
        sh "git config --global user.name \"${gitName}\""
        sh "sed -i 's/django:.*/django:${currentBuild.number}/g' argocd/values.yaml"
        sh "git add ."
        sh "git commit -m 'fix:django ${currentBuild.number} image versioning'"
        sh "git push origin main"
      }
      post {
        failure {
          echo 'Kubernetes Manifest Update failure'
          slackSend (color: '#FF0000', message: "FAILED: Kubernetes Manifest Update '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
         }
        success {
          echo 'Kubernetes Manifest Update success'
          slackSend (color: '#0AC9FF', message: "SUCCESS: Kubernetes Manifest Update '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
          }
      }
    }
  }
}