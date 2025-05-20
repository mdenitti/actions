#!/bin/bash
# Script to troubleshoot Laravel routing issue
# Created: May 20, 2025

# Define text colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Laravel Route Troubleshooting ===${NC}"
echo -e "${YELLOW}Starting troubleshooting process for Laravel 12...${NC}"

# Go to the application directory
cd "$(dirname "$0")"
echo -e "${GREEN}Working from directory:${NC} $(pwd)"

# Check PHP and Laravel version
echo -e "\n${BLUE}=== Environment Check ===${NC}"
php -v
echo ""
php artisan --version

# Clear all caches
echo -e "\n${BLUE}=== Clearing All Caches ===${NC}"
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan optimize:clear

# Show all routes for debugging
echo -e "\n${BLUE}=== Current Route List ===${NC}"
php artisan route:list

# Check storage permissions
echo -e "\n${BLUE}=== Checking Storage Permissions ===${NC}"
chmod -R 775 storage bootstrap/cache
echo "Storage permissions updated"

# Check for composer updates
echo -e "\n${BLUE}=== Checking Composer ===${NC}"
composer dump-autoload

# Create a test route to verify routing system
echo -e "\n${BLUE}=== Adding Test Route ===${NC}"
cat << 'EOF' > routes/test.php
<?php

use Illuminate\Support\Facades\Route;

Route::get('/test-route', function () {
    return response()->json([
        'status' => 'success',
        'message' => 'Test route is working correctly',
        'timestamp' => now()->toDateTimeString(),
    ]);
});
EOF

echo "Created a test route file at routes/test.php"

# Add the test route to bootstrap/app.php
echo -e "\n${BLUE}=== Updating App Configuration ===${NC}"
sed -i.bak "s/web: __DIR__.'\/..\/routes\/web.php',/web: __DIR__.'\/..\/routes\/web.php',\n        test: __DIR__.'\/..\/routes\/test.php',/g" bootstrap/app.php
echo "Test route registered in bootstrap/app.php"

# Run diagnostics to check the welcome route
echo -e "\n${BLUE}=== Running Route Diagnostics ===${NC}"
echo "Testing route resolution for '/'..."
php artisan route:resolve / --method=GET

echo -e "\n${YELLOW}Completed troubleshooting steps.${NC}"
echo -e "${GREEN}Try accessing your application again at:${NC}"
echo "http://productionserver.be/test-route"
echo -e "Then try the root route: http://productionserver.be/"
echo ""
echo -e "${BLUE}If the test route works but the root route doesn't, the issue may be with${NC}"
echo "the specific implementation of your root route or welcome view."
echo -e "To restore your original app.php file, run: ${RED}mv bootstrap/app.php.bak bootstrap/app.php${NC}"
