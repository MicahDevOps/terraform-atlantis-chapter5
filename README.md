# terraform-atlantis-chapter5
This repository is for Demo simple Atlantis-Terraform Project

## Pre-requirement and Specification:
1. Instances Centos 7 - with nginx installed
2. Terraform version: 0.12.x
3. Atlantis version: 0.11.1
4. Github account with Personal Access Token
5. Learning Spirit

## Skipped Installation and setup
- Install Terraform
- Install nginx to expose endopint Atlantis UI via Http (OR can be replaced with SLB in ALibaba)

## Setup Step:

### 1. Create Personal Access Token on our Github Account
- Login to your github account
- Go to Settings
- In the left sidebar, click Developer settings.
- In the left sidebar, click Personal access tokens.
- Click Generate new token.
- Select the scopes, or permissions, you'd like to grant this token.
- Click Generate token.
- Then coppy and safe to ur local the token that already generated before.

See [Step Reference](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token#creating-a-token).

### 2. Setup Atlantis on Instances Terraform
- Make directory /opt/terraform and /opt/terraform/atlantis-workdir
- Inside dir /opt/terraform: 
```
wget https://github.com/runatlantis/atlantis/releases/download/v0.11.1/atlantis_linux_amd64.zip && unzip atlantis_linux_amd64.zip && rm -rf atlantis_linux_amd64.zip
```
- create repo.yaml and fill with this:
```
#### This config applied on atlantis server ####
repos:
# Allow a specific repo to override.
- id: https://github.com/AlibabaCloudIndonesia/terraform-atlantis-chapter5
  allowed_overrides: [workflow, apply_requirements]
  allow_custom_workflows: true
```
- How start Atlanstis Service:
```
nohup ./atlantis server --atlantis-url=$URL \
    --gh-user=$USERNAME --gh-token=$TOKEN --gh-webhook-secret="$SECRET"\
    --repo-whitelist=$WHITELIST \
    --data-dir=$DIR --repo-config=$REPO_CONFIG &

#### URL: fill with public IP, internal IP or domain name that pointing to tf-instance. example: http://149.129.226.51/
#### USERNAME: github username
#### TOKEN: Access Token generated from step 1
#### SECRET: Random string secret to make sure the webhook is triggered by verified request. (can generate online)
#### DIR: working directory for atlantis running all command
#### REPO_CONFIG: additional config for repository setting, in this case we use repo.yaml
```
Make sure we've already export that all variable. See [Other Repository Integration Reference](https://www.runatlantis.io/docs/deployment.html#deployment-2).
- After make sure Atlantis process already running, the expose via nginx, add this config nginx:
```
    location / {
                    add_header Access-Control-Allow-Origin *;
                    proxy_pass http://127.0.0.1:4141;
            }
```
- Restart or reload nginx. (If u used SLB to expose the Atlantis backend you can skip this)
- Verify the Atlantis UI via browser. http://PUBLIC_IP_OR_INTERNAL_IP

### 3. Setting Repository Webhook
- Go to our Github Repository that will be our IaaC project.
- Go to Setting --> Webhook --> Add Webhook
- Set payload URL to http://$URL/events (make sure /events is added, its the main API to trigger event on Atlantis)
- Set Content type to application/json
- Set Secret to the Webhook Secret you generated previously
- Select Let me select individual events
- Check the box: Pull request reviews, Pushes,  Issue comments, Pull requests.
- Add the webhook. Done.
- Verify the first webhook initialization already got response 200.
See [Other Repository Integration Reference](https://www.runatlantis.io/docs/configuring-webhooks.html)

### 4. Repository Workflow Setting
- Go to our Github Repository that will be our IaaC project.
- Go to Setting --> Braches --> Branch protection rule --> Add rule
- Fill branch name pattern "master"
- Check "Require pull request reviews before merging"
- Check "Require status checks to pass before merging"
- Create

### 5. All Step is Done for the Setup



# Project Folder Structure
```
└── project1st                    <------- our first projects
    ├── main.tf
    ├── backend.tf
    ├── provider.tf
    └── variable.tf
├── atlantis.yaml               <----- atlantis config
├── alicloud.tfvars             <----- Stores all variable global
├── project1st.tfvars             <----- Stores all dynamic project variable
```


# Workflow
```
- git push origin [your-branch-name]
- Create pull request for your branch (once PR created, it will running plan and comment back the output to the PR as a comment)
- Once all expected and running well, ask approval.
- After got 2 approval, comment PR: "atlantis apply -p [your-project-name]"
- Atlantis will comment the output of the apply if its Done.
- After you make sure all infrastructure its created well based on your code, you can merge it... <3
```
