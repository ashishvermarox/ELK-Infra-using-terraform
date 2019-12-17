#!groovy

final PROJ_DIR = "proj_dir"
final destroy = 'true'

//to use specific node specify name
//nodelabel = 'somevalue'
//node(nodelabel){}

node{
    timestamps{
        timeout(time: 24, unit: 'HOURS'){
        
            //To use credentials from Jenkins use
            //withCredentials(){}
            
            def branch = 'master'
            try{
                currentBuild.displayName = "#${env.BUILD_NUMBER}"
                
                stage('Checkout Git repo'){
                    checkout changelog: false, poll:false, scm: [$class: 'GitSCM',
                                                                branches: [[name: "${branch}"]],
                                                                extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: PROJ_DIR]],
                                                                userRemoteConfigs: [[credentialsId: 'git-token',
                                                                                    url: 'https://github.com/ashishvermarox/ELK-Infra-using-aws.git']]]
                }
                
                //To use VARS as params in python file do: --user \"${I_USER}\" --pass \"${I_PASS}\"
                //sh "python abc.py --user \"${I_USER}\" --pass \"${I_PASS}\""
                
                def containerImage = docker.build("cont-image", "./${PROJ_DIR}")
                containerImage.inside{
                    stage('Initialize terraform'){
                        dir(PROJ_DIR){
                            sh '''
                            terraform init -input=false standard
                            #terraform init -input=false using-docker
                            '''
                        }
                    }
                    
                    stage('Validate templates'){
                        dir(PROJ_DIR){
                            sh '''
                            terraform validate standard
                            #terraform validate using-docker
                            '''
                        }
                    }
                    
                    stage('Plan templates'){
                        dir(PROJ_DIR){
                            sh '''
                            terraform plan -input=false -detailed-exitcode -out=elk-plan.out standard
                            #terraform plan -input=false -detailed-exitcode -out=elk-plan.out using-docker
                            '''
                        }
                    }
                    
                    stage('Execute templates'){
                        dir(PROJ_DIR){
                            sh '''
                            terraform apply -input=false -auto-approve elk-plan.out
                            '''
                        }
                    }
                    
                    if("${destroy}" == 'true'){
                        dir(PROJ_DIR){
                            sh '''
                            terraform destroy -input=false -auto-approve standard
                            '''
                        }
                    }
                    
                    stage('Grab Login Info'){
                        if("${destroy}" == 'true'){
                            echo "Infra Destroyed."
                        }
                        else{
                            dir(PROJ_DIR){
                                sh '''
                                terraform output -json > manifest.json
                                '''
                            }
                        }
                    }
                    
                    currentBuild.result = 'SUCCESS' 
                }
            }
            catch (e){
                currentBuild.result = 'FAILURE'
                println(e)
                throw e
            } finally{
                archiveArtifacts allowEmptyArchive: true, artifacts: '**/manifest.json'
            }
        }
    }
}