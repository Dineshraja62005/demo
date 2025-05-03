# PowerShell equivalent of deploy.sh
Write-Host "==== Starting Deployment Process ====" -ForegroundColor Green

# Step 1: Terraform Infrastructure Deployment
Write-Host "===== Step 1: Deploying Infrastructure with Terraform =====" -ForegroundColor Cyan
Set-Location -Path terraform
terraform init
terraform plan
terraform apply -auto-approve

# Capture Jenkins IP address
$JENKINS_IP = terraform output -raw jenkins_public_ip
Write-Host "Jenkins Server IP: $JENKINS_IP" -ForegroundColor Yellow

# Update Ansible inventory with Jenkins IP
(Get-Content -Path ..\ansible\inventory) -replace "JENKINS_IP_ADDRESS", $JENKINS_IP | Set-Content -Path ..\ansible\inventory

# Step 2: Configure Jenkins with Ansible
Write-Host "===== Step 2: Configuring Jenkins with Ansible =====" -ForegroundColor Cyan
Set-Location -Path ..\ansible
Write-Host "Waiting for Jenkins server to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 60  # Give the server time to initialize

# Run Ansible playbook
ansible-playbook install-jenkins.yml -i inventory

Write-Host "===== Step 3: Jenkins Configuration Complete =====" -ForegroundColor Cyan
Write-Host "Access Jenkins at: http://$JENKINS_IP`:8080" -ForegroundColor Green
Write-Host "Use the initial admin password displayed above" -ForegroundColor Green

Write-Host "===== Next Steps =====" -ForegroundColor Magenta
Write-Host "1. Set up Jenkins: Install recommended plugins and create admin user" -ForegroundColor White
Write-Host "2. Install additional plugins: Docker, Kubernetes CLI, Pipeline" -ForegroundColor White  
Write-Host "3. Configure credentials for Docker Hub and Kubernetes" -ForegroundColor White
Write-Host "4. Create a new Pipeline job using the Jenkinsfile" -ForegroundColor White
Write-Host "5. Run the pipeline to deploy your application" -ForegroundColor White

Write-Host "==== Deployment Process Complete ====" -ForegroundColor Green