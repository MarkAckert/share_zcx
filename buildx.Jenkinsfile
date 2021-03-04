

def CONST = [
    // Docker Hub ID
    dockerHubCredentials: 'ArtifactoryCredentials',
    // Multiplatform image 
    finalImage: "<docker_hub_id>/share_zcx", // replace <docker_hub_id>
]

stage('Build Docker Images') {
    node('amd64-build') {
        checkout scm
        withCredentials([usernamePassword(credentialsId: CONST.dockerHubCredentials, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh "docker login -u $USERNAME -p \"$PASSWORD\" ${CONST.registry}.${CONST.artifactory}"
        }
        sh "docker buildx build --platform linux/s390x,linux/amd64 --tag $finalImage --push ."
    }
}