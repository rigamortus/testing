#!/usr/bin/env groovy
pipeline {
   agent any
   stages {
      stage('SSH') {
         steps {
            withCredentials([sshUserPrivateKey(
                credentialsId: 'prod', 
                keyFileVariable: 'keyfile')]) {
                    sh '''
prod=azureuser@172.208.31.40
cmd="docker ps"
ssh -i "$keyfile" -o StrictHostKeyChecking=no $prod $cmd
                       '''
                }
         }
      }
   }
}

