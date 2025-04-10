def remote=[:]
remote.name = 'vm-lab1'
remote.host = '192.168.18.21'
remote.allowAnyHosts = true

pipeline {
  // agent none
  agent any
  tools {
      jfrog 'jfrog-cli'
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-jpiay')
    PI_CREDS=credentials('ssh-vm-lab1')
  }
  stages {
    stage('Build and Publish to Artifactory') {
        agent { label 'agent-maven' }
        steps {
          // build
          sh 'mvn clean package'

          // publish to Artifactory
          jf 'rt bp'
          jf 'rt u target/*.jar example-repo-local/'
        }
    }
    stage('Docker') {
        agent { label 'agent-dind' }
        steps {
          // pull and build the artifact
          jf 'rt dl example-repo-local/target/demo-0.0.1-SNAPSHOT.jar'
          sh 'docker build -t jpiay/jwa:0.0.1 .'

          // login docker
          sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'

          // push to registry
          sh 'docker push jpiay/jwa:0.0.1'

          // deploy in remote server
          script {
            remote.user=env.PI_CREDS_USR
            remote.password=env.PI_CREDS_PSW
          }
          sshCommand(remote: remote, command: "sudo docker pull jpiay/jwa:0.0.1")
          sshCommand(remote: remote, command: "sudo docker run -d --name java-web-app -p 8090:8080 --restart unless-stopped jpiay/jwa:0.0.1")
        }
    }
  }
  // post {
  //   always {
  //     script {
  //       sh 'docker logout'
  //       sleep(5)
  //       node {
  //         cleanWs()  // Deletes all files in the workspace
  //       }
  //     }
  //   }
  // }
}