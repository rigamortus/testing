def getImageName(String appName) {
    return "${dockerHubUsername}/${appName}:${env.BUILD_NUMBER}"
}
def getTarget() {
 env.BRANCH_NAME == 'staging' ? 'staging' : 'prod'
}

pipeline {
 agent any
 environment {
  registry = 'https://index.docker.io/v1/'
  appName = 'newdocker234'
  dockerHubUsername = 'rigamortus'
  shipit_prod_host = '48.217.82.28'
  shipit_prod_user = 'azureuser'
  shipit_staging_host = '172.178.102.202'
  shipit_staging_user = 'azureuser'
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
    stage('deploy') {
        when {
            anyOf {
                branch 'master'
                branch 'staging'
            }
        }
        steps {
            echo "BRANCH_NAME is ${env.BRANCH_NAME}"
            echo "Deploying to ${getTarget()}"
            withCredentials([sshUserPrivateKey(credentialsId: "${getTarget()}",keyFileVariable: 'keyfile')]) {
                sh """
                    set -a
                    target=${getTarget()}
                    image=${getImageName(appName)}
                    keyfile=${keyfile}
                    bin/ssh-dep.sh
                    """
            }
        }
    }
 }
}
