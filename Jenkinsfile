pipeline {
  agent any
  stages {
    stage('Package & Verify') {
      steps {
	      script {
	        openshift.withCluster() {
			      openshift.withProject("staging"){
				      echo "Hello from project ${openshift.project()} in cluster ${openshift.cluster()}"
	          }
	        }
	      }
      }
    }
  }
}

//vim: ai ts=2 sts=2 et sw=2 ft=groovy
