#!/bin/bash
set -euxo pipefail

# Log installation output for troubleshooting
exec > >(tee /var/log/user-data-install.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting Jenkins and Terraform installation"

# 1. Update Amazon Linux 2023
dnf update -y

# 2. Install Java 21 and supporting tools
dnf install -y fontconfig java-21-amazon-corretto git wget yum-utils shadow-utils

# 3. Add the official Jenkins LTS repository
wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/rpm-stable/jenkins.repo

# Import Jenkins signing key
rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2026.key

# 4. Install Jenkins
dnf install -y jenkins

# 5. Add the HashiCorp repository
yum-config-manager --add-repo \
  https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# 6. Install Terraform
dnf install -y terraform

# 7. Enable Jenkins to start automatically after reboot
systemctl enable jenkins

# 8. Start Jenkins now
systemctl start jenkins

# 9. Verify installed software
java -version
git --version
terraform version
systemctl status jenkins --no-pager

echo "Installation completed"