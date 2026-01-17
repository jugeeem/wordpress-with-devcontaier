#!/bin/bash

set -e

echo "=========================================="
echo "WordPress Dev Container Setup"
echo "=========================================="

# Check if .env file exists
if [ ! -f /workspace/.env ]; then
    echo "❌ Error: .env file not found!"
    echo "Please copy .env.example to .env and configure your database credentials."
    echo ""
    echo "Run the following command:"
    echo "  cp .env.example .env"
    echo ""
    exit 1
fi

echo "✅ .env file found"

# Check if WordPress is already downloaded
if [ -f /workspace/wordpress/index.php ] && [ -f /workspace/wordpress/wp-settings.php ] && [ -f /workspace/wordpress/wp-blog-header.php ]; then
    echo "✅ WordPress is already installed"
else
    echo "📦 Downloading WordPress..."
    
    # Create wordpress directory if it doesn't exist
    mkdir -p /workspace/wordpress
    
    # Download latest WordPress
    cd /tmp
    curl -sL https://ja.wordpress.org/latest-ja.tar.gz -o latest-ja.tar.gz
    
    echo "📂 Extracting WordPress files..."
    tar -xzf latest-ja.tar.gz
    
    # Move WordPress files to the wordpress directory
    cp -r wordpress/* /workspace/wordpress/
    
    # Clean up
    rm -rf wordpress latest-ja.tar.gz
    
    echo "✅ WordPress downloaded successfully"
fi

# Set correct permissions
echo "🔒 Setting file permissions..."
chown -R www-data:www-data /workspace/wordpress
find /workspace/wordpress -type d -exec chmod 755 {} \;
find /workspace/wordpress -type f -exec chmod 644 {} \;

# Copy wp-config.php if it doesn't exist
if [ ! -f /workspace/wordpress/wp-config.php ]; then
    if [ -f /workspace/wp-config-template.php ]; then
        echo "📝 Creating wp-config.php from template..."
        cp /workspace/wp-config-template.php /workspace/wordpress/wp-config.php
        chown www-data:www-data /workspace/wordpress/wp-config.php
        chmod 644 /workspace/wordpress/wp-config.php
    fi
fi

echo ""
echo "=========================================="
echo "✅ Setup completed successfully!"
echo "=========================================="
echo ""
echo "WordPress is now accessible at:"
echo "  🌐 http://localhost:8080"
echo ""
echo "phpMyAdmin is accessible at:"
echo "  🔧 http://localhost:8081"
echo ""
echo "Next steps:"
echo "  1. Open http://localhost:8080 in your browser"
echo "  2. Complete the WordPress installation wizard"
echo "  3. Start developing!"
echo ""
