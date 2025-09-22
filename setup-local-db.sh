#!/bin/bash

# Setup Local PostgreSQL Database for Development
echo "🚀 Setting up local PostgreSQL database for LeadSpark development..."

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL is not installed."
    echo "Please install PostgreSQL:"
    echo "  macOS: brew install postgresql"
    echo "  Ubuntu: sudo apt-get install postgresql postgresql-contrib"
    echo "  Windows: Download from https://www.postgresql.org/download/"
    exit 1
fi

# Check if PostgreSQL service is running
if ! pg_isready &> /dev/null; then
    echo "🔄 Starting PostgreSQL service..."
    if command -v brew &> /dev/null; then
        brew services start postgresql
    elif command -v systemctl &> /dev/null; then
        sudo systemctl start postgresql
    fi
fi

# Create database and user
echo "📊 Creating database and user..."

# Create database
createdb leadspark_dev 2>/dev/null || echo "Database 'leadspark_dev' already exists"

# Create user (if not exists)
psql -d postgres -c "CREATE USER leadspark_user WITH PASSWORD 'dev_password123';" 2>/dev/null || echo "User 'leadspark_user' already exists"

# Grant permissions
psql -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE leadspark_dev TO leadspark_user;"
psql -d postgres -c "ALTER USER leadspark_user CREATEDB;"

echo "✅ Local database setup complete!"
echo ""
echo "Local Database Credentials:"
echo "Host: localhost"
echo "Port: 5432"
echo "Database: leadspark_dev"
echo "User: leadspark_user"
echo "Password: dev_password123"
echo ""
echo "To use this database, update your server.js with:"
echo "host: 'localhost'"
echo "user: 'leadspark_user'"
echo "password: 'dev_password123'"
echo "database: 'leadspark_dev'"
echo ""
echo "Then run: PGPASSWORD='dev_password123' psql -h localhost -U leadspark_user -d leadspark_dev -f POSTGRESQL_SETUP.sql"
