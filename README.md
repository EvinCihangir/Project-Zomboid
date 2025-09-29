# Getting Started: Deploying a Project Zomboid Server with This Repository

This repository automates the deployment of a Project Zomboid server using AWS infrastructure. Below are step-by-step instructions to get started.

---

## Prerequisites

1. **AWS Account**  
   You need an active AWS account with permissions to create EC2 instances, security groups, IAM roles, etc.

2. **Terraform Installed**  
   [Install Terraform](https://www.terraform.io/downloads.html) on your local machine.

3. **AWS CLI Configured**  
   [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and run `aws configure` to set up your credentials.

---

## Repository Setup

1. **Clone the Repository**
   ```sh
   git clone https://github.com/benpngo/project_zomboid_server.git
   cd project_zomboid_server
   ```

2. **Review and Edit Variables**  
   Open `variables.tf` (or similar file) and update any necessary variables such as region, instance type, Discord bot token, etc.

---

## Deployment Steps

1. **Initialize Terraform**
   ```sh
   terraform init
   ```

2. **Preview the Infrastructure Plan**
   ```sh
   terraform plan
   ```

3. **Apply the Terraform Plan**
   ```sh
   terraform apply
   ```
   Confirm when prompted. Terraform will provision the AWS resources and set up the Project Zomboid server.

---

## Connecting to Your Server

- After deployment, Terraform will output the public IP or hostname of your Project Zomboid server.
- Use the Project Zomboid game client to connect using this IP.

---

## Managing and Destroying Resources

- To update configuration, modify your Terraform files and run `terraform apply` again.
- To destroy all resources:
   ```sh
   terraform destroy
   ```
   Confirm when prompted.

---

## Troubleshooting

- Check AWS console for resource status.
- Review Terraform output and logs for errors.
- Ensure IAM permissions are sufficient for resource creation.

---

## Additional Information

- Refer to any included `README.md` or comments in `.tf` files for details on customizations and advanced configuration.
- For Discord bot integration, you may need to invite the bot to your Discord server and set permissions.

