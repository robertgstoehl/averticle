pipeline {
  agent any
  stages {
    stage('Package & Verify') {
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject("development"){
              echo "tagging averticle:latest in project ${openshift.project()} in cluster ${openshift.cluster()}"
			          openshift.tag("averticle:latest", "averticle:staging") 
              }
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
              def averticle = openshift.selector( 'dc', 'averticle')

              // Model the source objects using the 'exportable' flag to strip cluster
              // specific information from the objects (i.e. like 'oc export').
              def objs = averticle.objects( exportable:true )

              // Modify the models as you see fit.
              def timestamp = "${System.currentTimeMillis()}"
              for ( obj in objs ) {
                  obj.metadata.labels[ "promoted-on" ] = timestamp
              }
              obj.spec.template.spec.containers[0].image = "averticle:staging"
              openshift.withProject("staging"){
                input "Promote averticle to staging env?"

                // Note that the selector is relative to its closure body and
                // operates on the qecluster now.
                averticle.delete( '--ignore-not-found' )

                openshift.create( objs )

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
}

//vim: ai ts=2 sts=2 et sw=2 ft=groovy