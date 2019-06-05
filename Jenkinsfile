pipeline {
  agent any
  stages {
    stage('Package & Verify') {
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject("development"){
              echo "tagging averticle:latest in project ${openshift.project()} in cluster ${openshift.cluster()}"
			        openshift.tag("development/averticle:latest", "staging/averticle:staging") 
            }
          }
        }
      }
    }
    stage('Promote to stage') {
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject("development"){
              echo "nothing yet"
            }

            openshift.withProject("staging"){
              input "Promote averticle to staging env?"
              openshift.replace(readFile('okd/staging.yaml'))
              def averticle = openshift.selector( 'dc', 'averticle')
              // Let's wait until at least one pod is Running
              averticle.related('pods').untilEach {
                  return it.object().status.phase == 'Running'
              }
            }
          }
        }
      }
    }
  }
}

//vim: autoindent tabstop=2 softtabstop=2 expandtab shiftwidth=2 filetype=groovy
