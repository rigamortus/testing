def getImageName(String appName) {
    return "${appName}:${env.BUILD_NUMBER}"
}

pipeline {
 agent any
 environment {
  registry = 'https://index.docker.io/v1/'
  appName = 'newdocker234'
 }
 stages {
    stage('build') {
        steps {
            checkout scm
            script {
                docker.withRegistry("${registry}", 'shipit.dockerhub.id') {
                    def image = docker.build(getImageName("${appName}"),"-f ${dockerfile} --network host .")
                    image.push()
                }
            }
        }
    }
 }
}
