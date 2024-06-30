pipeline {
 agent any
 stages {
    stage('build') {
        steps {
            checkout scm
            script {
                def getImageName(String appName) {
                    return "${appName}:${env.BUILD_NUMBER}"
                    }
            }
            script {
                docker.withRegistry(registry, 'shipit.dockerhub.id') {
                    def image = docker.build(getImageName(appName),"-f ${dockerfile} --network host ./chapter7")
                    image.push()
                }
            }
        }
    }
 }
}
