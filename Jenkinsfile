pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo "do some maven magic"'
        sh '''echo "something like mvn fat-jar"
for i in {0..10}; do sleep 1; echo "working... (${i}/10)"; done
echo "done"'''
      }
    }
    stage('Verify') {
      steps {
        sh 'echo "scan image with tag latest"'
      }
    }
    stage('Deploy to staging env') {
      steps {
        input(message: 'Promote to Stage?', ok: 'Promote')
        sh 'echo "deploy staging..."'
      }
    }
    stage('Deploy to production env') {
      steps {
        input(message: 'Promote to Production?', ok: 'Promote')
        sh 'echo "deploy production..."'
        echo 'ohoh'
        input 'seriously?'
      }
    }
  }
}
