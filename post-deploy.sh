#!/bin/bash
# Laravel post-deployment script

# Go to the application directory
cd ~/www/massimo

# Basic deployment confirmation
echo "Files deployed successfully to www/massimo"

# Check if .env file exists, if not notify to create one
if [ ! -f .env ]; then
    echo "⚠️  WARNING: .env file not found!"
    echo "Please create a .env file by copying .env.example and configuring it for your environment."
    echo "Run: cp .env.example .env && php artisan key:generate"
fi

# Display PHP version for verification
php -v

# Laravel deployment tasks
echo "📦 Running Laravel deployment commands..."

# Install/update PHP dependencies with Composer
echo "🔄 Updating Composer dependencies..."
composer install --no-interaction --prefer-dist --optimize-autoloader

# Clear all caches
echo "🧹 Clearing all cache..."
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan optimize:clear

# Set proper permissions
echo "🔒 Setting proper permissions..."
chmod -R 775 storage bootstrap/cache
chmod -R 775 public

# Create storage symlink if it doesn't exist
echo "🔗 Creating storage link..."
php artisan storage:link

# Check routes
echo "🛣️  Verifying routes configuration..."
php artisan route:list

# Optimize the application
echo "⚡ Optimizing application..."
php artisan optimize

# Generate route cache for better performance
echo "🚀 Generating route cache..."
php artisan route:cache

# Run migrations (optional, uncomment if needed)
# echo "🗄️  Running database migrations..."
# php artisan migrate --force

# Verify application is running correctly
echo "✅ Verifying application health..."
php artisan route:resolve / --method=GET

echo "✅ Deployment completed successfully!"