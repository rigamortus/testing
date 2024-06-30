def getImageName(String appName) {
    return "${dockerHubUsername}/${appName}:${env.BUILD_NUMBER}"
}

pipeline {
 agent any
 environment {
  registry = 'https://index.docker.io/v1/'
  appName = 'newdocker234'
  dockerHubUsername = 'rigamortus'
 }
 stages {
    stage('build') {
        steps {
            checkout scm
            script {
                docker.withRegistry("${registry}", 'shipit.dockerhub.id') {
                    def image = docker.build(getImageName("${appName}"),"-f Dockerfile --network host .")
                    image.push()
                }
            }
        }
    }
 }
}
