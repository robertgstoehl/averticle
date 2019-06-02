pipeline {
  agent any
  stages {
    stage('Package & Verify') {
      steps {
		    openshift.withCluster() {
			    openshift.withProject("staging"){
				    sh 'oc project'
	        }
	      }
      }
    }
  }
}

//vim: ai ts=2 sts=2 et sw=2 ft=groovy
