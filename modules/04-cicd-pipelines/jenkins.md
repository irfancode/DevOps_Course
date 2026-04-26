# Jenkins Basics

## Installing Jenkins

### On Ubuntu
```bash
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins
sudo systemctl start jenkins
```

### Using Docker
```bash
docker run -d -p 8080:8080 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```

## Jenkinsfile Example

```groovy
pipeline {
    agent any
    
    environment {
        NODE_VERSION = '18'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh "npm ci"
            }
        }
        
        stage('Test') {
            steps {
                sh "npm test"
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh "./deploy.sh"
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            emailext body: 'Build succeeded!', subject: 'Jenkins Build', to: 'team@example.com'
        }
        failure {
            emailext body: 'Build failed!', subject: 'Jenkins Build Failed', to: 'team@example.com'
        }
    }
}
```

## Common Plugins

| Plugin | Purpose |
|--------|---------|
| pipeline | Blue Ocean/Pipeline support |
| git | Git integration |
| docker-workflow | Docker pipelines |
| credentials-binding | Secrets management |
| slack-notifier | Slack notifications |

## Jenkins CLI

```bash
jenkins-cli -s http://localhost:8080 build job-name
jenkins-cli -s http://localhost:8080 list-jobs
jenkins-cli -s http://localhost:8080 quiet-down
```

---

**Next: [Lab Exercises](./labs/lab-04-cicd-pipeline.md)**