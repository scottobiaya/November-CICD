
pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 60, unit: 'MINUTES')
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'apply = build/update infrastructure, destroy = sh 'terraform plan -destroy -input=false -out=tfplan'
        )
    }

    environment {
        TF_IN_AUTOMATION   = 'true'
        TF_INPUT           = 'false'
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_DIR             = 'terraform'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Tools and AWS Identity') {
            steps {
                sh 'terraform version'
                sh 'aws sts get-caller-identity'
            }
        }

        stage('Terraform Init') {
            steps {
                dir(env.TF_DIR) {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Format Check') {
            steps {
                dir(env.TF_DIR) {
                    sh 'terraform fmt -check -recursive'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir(env.TF_DIR) {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir(env.TF_DIR) {
                    withCredentials([
                        string(
                            credentialsId: 'terraform-public-key',
                            variable: 'TF_VAR_public_key'
                        )
                    ]) {
                        script {
                            if (params.ACTION == 'destroy') {
                                sh 'terraform plan -destroy -input=false -out=tfplan'
                            } else {
                                sh 'terraform plan -input=false -out=tfplan'
                            }
                        }
                    }

                    sh 'terraform show -no-color tfplan > plan.txt'
                    archiveArtifacts artifacts: 'plan.txt', allowEmptyArchive: true
                }
            }
        }

        stage('Approval') {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input(
                        message: "Review plan.txt in the build artifacts. Proceed with terraform ${params.ACTION}?",
                        ok: "Yes, ${params.ACTION}"
                    )
                }
            }
        }

        stage('Terraform Apply / Destroy') {
            steps {
                dir(env.TF_DIR) {
                    sh 'terraform apply -input=false -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
            echo "Terraform ${params.ACTION} completed successfully."
        }

        failure {
            echo 'Pipeline failed. Check the stage that turned red above.'
        }

        always {
            dir(env.TF_DIR) {
                sh 'rm -f tfplan plan.txt'
            }
        }
    }
}
