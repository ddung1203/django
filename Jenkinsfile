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
        git credentialsId: githubCredential, url: gitAddress, branch: 'main'
        
        sh """
          git config --global user.email ${gitEmail}
          git config --global user.name ${gitName}
          sed -i 's/django:.*/django:${currentBuild.number}/g' argocd/values.yaml
          git add .
          git commit -m 'fix:django ${currentBuild.number} image versioning'
          git branch -M main
          git remote remove origin
          git remote add origin git@github.com:ddung1203/django.git
          git push -u origin main
        """
        // script{
        //   withCredentials([string(credentialsId: githubCredential, variable: 'GITHUB_TOKEN')]) {
        //     sh """
        //       git config --global user.email ${gitEmail}
        //       git config --global user.name ${gitName}
        //       sed -i 's/django:.*/django:${currentBuild.number}/g' argocd/values.yaml
        //       git add .
        //       git commit -m 'fix:django ${currentBuild.number} image versioning'
        //       git push origin main
        //       """
        //   }
        // }
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