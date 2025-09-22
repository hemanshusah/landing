#!/bin/bash

# LeadSpark Database Setup Script
# This script sets up the PostgreSQL database for LeadSpark

echo "🚀 Setting up LeadSpark PostgreSQL Database..."

# Database connection details
DB_HOST="62.72.57.136"
DB_USER="leadgenadmin"
DB_NAME="leadgen"
DB_PASSWORD="7yLrHid7s5Wa"

# Check if psql is available
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL client (psql) is not installed."
    echo "Please install PostgreSQL client tools."
    exit 1
fi

echo "📊 Testing database connection..."

# Test connection
PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "SELECT version();" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Database connection successful!"
else
    echo "❌ Database connection failed!"
    echo "Please check your credentials and network connection."
    echo ""
    echo "Trying to connect manually..."
    PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "SELECT version();"
    exit 1
fi

echo "📝 Creating database schema..."

# Run the SQL setup script
PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -f POSTGRESQL_SETUP.sql

if [ $? -eq 0 ]; then
    echo "✅ Database schema created successfully!"
else
    echo "❌ Failed to create database schema!"
    exit 1
fi

echo "🔍 Verifying tables..."

# Check if tables were created
PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "\dt" | grep -E "(waitlist|users|leads|campaigns|analytics)"

if [ $? -eq 0 ]; then
    echo "✅ All tables created successfully!"
else
    echo "❌ Some tables may not have been created properly."
fi

echo "📊 Checking waitlist stats..."

# Check waitlist stats
PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "SELECT * FROM waitlist_stats;"

echo ""
echo "🎉 Database setup complete!"
echo ""
echo "Next steps:"
echo "1. Install Node.js dependencies: npm install"
echo "2. Start the backend server: npm start"
echo "3. Test the API: curl http://localhost:3001/api/health"
echo ""
echo "Database connection details:"
echo "Host: $DB_HOST"
echo "Database: $DB_NAME"
echo "User: $DB_USER"
