#!/bin/bash

# EC2 Setup Script for FastAPI Application
# Run this script on your EC2 instance first time

echo "🚀 Setting up EC2 for FastAPI deployment..."

# Update system
echo "📦 Updating system packages..."
sudo yum update -y

# Install essential packages
echo "🔧 Installing essential packages..."
sudo yum groupinstall "Development Tools" -y
sudo yum install git python3 python3-pip python3-devel -y

# Install Python 3.9+ if needed (Amazon Linux 2)
if ! python3.9 --version &> /dev/null; then
    echo "🐍 Installing Python 3.9..."
    sudo yum install python39 python39-pip -y
    sudo alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
fi

# Create application directory
echo "📁 Creating application directory..."
mkdir -p /home/ec2-user/fastapi-app
cd /home/ec2-user/fastapi-app

# Clone the repository for initial setup
git clone https://github.com/0mer-Ashraf-ML/fastapi-sample.git .

# Set up firewall rules (if needed)
echo "🔥 Configuring firewall..."
sudo yum install firewalld -y
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

# Create systemd service file for auto-start (optional)
echo "⚙️ Creating systemd service..."
sudo tee /etc/systemd/system/fastapi.service > /dev/null <<EOF
[Unit]
Description=FastAPI application
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/fastapi-app
Environment=PATH=/home/ec2-user/fastapi-app/venv/bin
ExecStart=/home/ec2-user/fastapi-app/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8080
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# Set proper permissions
echo "🔐 Setting permissions..."
sudo chown -R ec2-user:ec2-user /home/ec2-user/fastapi-app
chmod +x /home/ec2-user/fastapi-app

echo "✅ EC2 setup completed successfully!"
echo "📝 Next steps:"
echo "   1. Set up GitHub secrets"
echo "   2. Push your code to GitHub"
echo "   3. The CI/CD pipeline will handle the rest!"
echo ""
echo "🌐 Your app will be available at: http://44.204.16.200:8080"
echo "📊 Health check URL: http://44.204.16.200:8080/health"
