# ELK in AWS using Terraform

An easy way to spin-up ELK (Elasticsearch, Logstash, Kibana) stack in AWS EC2 using no more than 4 commands. 
This repo supports 2 ways of running ELK stack

 1. ELK inside docker container
 2. Standard

# Initialization
To initialize project first  perform below steps to have ELK run on your configurations.


## Configure AWS credentials file
Give path to your AWS credentials file.

    */ELK-Infra-using-aws/TerraformTemplate/{standard} or {using-docker}/provider.tf
Example:

    shared_credentials_file = "/Users/username/.aws/creds"

## Pem file
Add pem file to either of the below directory, depending on your preference, for provisioning instance.

    */ELK-Infra-using-aws/TerraformTemplate/using-docker/pem-file/
    or
    */ELK-Infra-using-aws/TerraformTemplate/standard/pem-file/


## Edit variable file

Edit variable file with appropriate values for below placeholders.

    */ELK-Infra-using-aws/TerraformTemplate/{standard} or {using-docker}/variables.tf

#### keyname
Add the pem file name used for provisioning without .pem extension.

    variable "keyname" {
        default = "pem-file-name"
    }
    
    Example:
    variable "keyname" {
    default = "ELKServer"
    }

#### region to use
Add the region you want to spin-up EC2 instances in.

    variable "region" {
        default = "us-east-1"
    }
Example:

    variable "region" {
            default = "ca-central-1"
    }

## ELK configuration files
ELK can be configured using configuration files. Below mentioned paths to the files should only be edited and not renamed.

**Beats Configuration:**

    */ELK-Infra-using-aws/TerraformTemplate/{standard} or {using-docker}/ConfigFiles/02-beats-input.conf

**Filter configuration**

    */ELK-Infra-using-aws/TerraformTemplate/{standard} or {using-docker}/ConfigFiles/12-json.conf

**Output configuration**

    */ELK-Infra-using-aws/TerraformTemplate/{standard} or {using-docker}/ConfigFiles/30-output.conf

**Filebeats configuration**

    */ELK-Infra-using-aws/TerraformTemplate/{standard} or {using-docker}/Scripts/filebeat.sh

# Executing project
There are 2 ways to execute this project, but commands are same.

**Basic steps to execute:**
Head to the any of the directory below:

    */ELK-Infra-using-aws/TerraformTemplate/{standard} or {using-docker}
**Execute below commands:**

*Initialize terraform template*

    terraform init
*Plan template*

      terraform plan
*Apply the template*


    terraform apply
   At the prompt type **yes** to apply

### Using Terraform
If terraform is installed in the system (or follow [here](https://learn.hashicorp.com/terraform/getting-started/install.html) to install)

To execute project if terraform is installed. Follow the steps mentioned under the header **Basic steps to execute**.
 
### Using Docker
To execute using docker go to the root directory of project.

    */ELK-Infra-using-aws/
**Execute commands below:**

*Build docker container*

    docker build -t elkbox .
  
 *Run the container*

     docker run --name elk_box -i elkbox
   
Follow the steps mentioned under the header **Basic steps to execute**.

## Login to Kibana Dashboard

    http://your-public-ip:90
|Username| Password |
|--|--|
| admin |  kibanaadmin|


# Other configuration settings
To edit configuration of Nginx, Elasticsearch, Kibana and Filebeats you can edit below files:

**Nginx**

    */ELK-Infra-using-aws/TerraformTemplate/{standard} or {using-docker}/ConfigFiles/kibana

**Elasticsearch**
Edit the properties between EOF1 tags.

    */ELK-Infra-using-aws/TerraformTemplate/{standard} or {using-docker}/Scripts/generateElaticsearchProperties.sh

**Logstash**
Edit the properties between EOF1 tags.

    */ELK-Infra-using-aws/TerraformTemplate/{standard} or {using-docker}/Scripts/generateKibanaProperties.sh

**Filebeats**
Edit the properties between EOF1 tags.

    */ELK-Infra-using-aws/TerraformTemplate/{standard} or {using-docker}/Scripts/filebeat.sh

## Plug-in project
One can write a groovy file as a wrapper to project and execute it using Jenkins. This can be used for DevOps.
