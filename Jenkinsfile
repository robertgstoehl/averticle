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
              def averticle = openshift.selector( 'dc', 'averticle')

              // Model the source objects using the 'exportable' flag to strip cluster
              // specific information from the objects (i.e. like 'oc export').
              def objs = averticle.objects( exportable:true )

              // Modify the models as you see fit.
              def timestamp = "${System.currentTimeMillis()}"
              for ( obj in objs ) {
                  echo "got o from selektor of Kind: ${obj.kind} with name ${obj.metadata.name}"
                  obj.metadata.labels[ "promoted-on" ] = timestamp
                  //obj should be a map for any given match in the selctor up above
              }
              //This might break, fix it...
              def dc = objs[0]
              echo "${averticle.asJson()}"

              echo "${dc.spec.template.spec.containers}"
              //objs.spec.template.spec.containers[0][0].image = "staging/averticle:staging"
              //echo "${objs.spec.template.spec.containers[0][0]}"
              echo "${dc.spec.triggers}"
              //objs.spec.triggers.imageChangeParams.from.name = "staging/averticle:staging"
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

//vim: autoindent tabstop=2 softtabstop=2 expandtab shiftwidth=2 fil:
