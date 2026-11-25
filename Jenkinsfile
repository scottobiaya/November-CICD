
pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 90, unit: 'MINUTES')
    }

    environment {
        TF_IN_AUTOMATION   = 'true'
        TF_INPUT           = 'false'
        AWS_DEFAULT_REGION = 'us-east-1'
        EXPECTED_ACCOUNT   = '585768150796'
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

                sh '''
                    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
                    if [ "$ACCOUNT_ID" != "$EXPECTED_ACCOUNT" ]; then
                        echo "ERROR: Incorrect AWS account: $ACCOUNT_ID"
                        exit 1
                    fi
                    echo "AWS account verified: $ACCOUNT_ID"
                '''
            }
        }

        stage('Terraform Format Check') {
            steps {
                dir('terraform') {
                    sh 'terraform fmt -check -recursive'
                }
            }
        }

        stage('Deploy Dev') {
            steps {
                dir('terraform/environments/dev') {
                    sh 'terraform init -input=false'
                    sh 'terraform validate'
                    sh 'terraform plan -input=false -var-file=terraform.tfvars -out=tfplan'
                    sh 'terraform show -no-color tfplan > plan.txt'
                    archiveArtifacts artifacts: 'plan.txt', fingerprint: true
                    sh 'terraform apply -input=false -auto-approve tfplan'
                }
            }
        }

        stage('Deploy Staging') {
            steps {
                dir('terraform/environments/staging') {
                    sh 'terraform init -input=false'
                    sh 'terraform validate'
                    sh 'terraform plan -input=false -var-file=terraform.tfvars -out=tfplan'
                    sh 'terraform show -no-color tfplan > plan.txt'
                    archiveArtifacts artifacts: 'plan.txt', fingerprint: true
                    sh 'terraform apply -input=false -auto-approve tfplan'
                }
            }
        }

        stage('Production Plan') {
            steps {
                dir('terraform/environments/prod') {
                    sh 'terraform init -input=false'
                    sh 'terraform validate'
                    sh 'terraform plan -input=false -var-file=terraform.tfvars -out=tfplan'
                    sh 'terraform show -no-color tfplan > plan.txt'
                    archiveArtifacts artifacts: 'plan.txt', fingerprint: true
                }
            }
        }

        stage('Production Approval') {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input(
                        message: 'Dev and Staging have deployed. Review the Production plan artifact before approving.',
                        ok: 'Approve Production Deployment'
                    )
                }
            }
        }

        stage('Deploy Production') {
            steps {
                dir('terraform/environments/prod') {
                    sh 'terraform apply -input=false -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
            echo 'Dev, Staging and Production deployments completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Check the failed stage and its console output.'
        }

        aborted {
            echo 'Pipeline was aborted or approval was not completed.'
        }

        always {
            sh '''
                for ENV in dev staging prod; do
                    rm -f "terraform/environments/$ENV/tfplan"
                    rm -f "terraform/environments/$ENV/plan.txt"
                done
            '''
        }
    }
}
