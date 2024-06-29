#!/usr/bin/env groovy
pipeline {
 agent any
 stages {
    stage('build') {
        steps {
            checkout scm
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
