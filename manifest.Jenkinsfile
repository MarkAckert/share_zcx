def CONST = [
    // Artifactory URL
    artifactory: 'your.artifactory.url',
    // Docker registry name
    registry: 'your-artifactory-registry',
    // Artifactory credential ID
    artifactoryId: 'ArtifactoryCredentials',
    // image names
    finalImage: "share_zcx", // artifactory-esque alternative: artifactory.url.path/share/zcx

    // Platform Tags
    amdTag: "amd64-latest",
    zosTag: "s390x-latest"
]

stage('Build Docker Images') {
    parallel zos: {
        node('zos-build') {
            checkout scm
            withCredentials([usernamePassword(credentialsId: CONST.artifactoryId, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh "docker login -u $USERNAME -p \"$PASSWORD\" ${CONST.registry}.${CONST.artifactory}"
            }
            sh "docker build -t $finalImage:$zosTag ."
            sh "docker push $finalImage:$zosTag"
        }
    },
    amd64: {
        node('amd64-build') {
            checkout scm
            withCredentials([usernamePassword(credentialsId: CONST.artifactoryId, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh "docker login -u $USERNAME -p \"$PASSWORD\" ${CONST.registry}.${CONST.artifactory}"
            }
            sh "docker build -t $finalImage:$amdTag ."
            sh "docker push $finalImage:$amdTag"
        }
    }
}

stage('Update Docker Manifest') {
    node('amd64-build') {
        withCredentials([usernamePassword(credentialsId: CONST.artifactoryId, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh "docker login -u $USERNAME -p \"$PASSWORD\" ${CONST.registry}.${CONST.artifactory}"
        }
        // Create the manifest, with two platforms
        sh "docker manifest create ${CONST.finalImage} ${CONST.finalImage}:${CONST.amdTag} ${CONST.finalImage}:${CONST.zosTag}"
        // Optional Annotations:
        //   sh "docker manifest annotate ${CONST.finalImage} ${CONST.finalImage}:${CONST.amdTag} --os linux --arch amd64"
        //   sh "docker manifest annotate ${CONST.finalImage} ${CONST.finalImage}:${CONST.zosTag} --os linux --arch s390x"

        // Push the manifest to the registry
        sh "docker manifest push --purge ${CONST.finalImage}"
    
    }
}