# LeadSpark PostgreSQL Migration Guide

## 🗄️ **What Changed**

Your CTO wants to migrate from **Supabase** to a **direct PostgreSQL database** for better control and custom authentication.

### **Old Setup (Supabase):**
- Cloud-hosted PostgreSQL
- Built-in authentication
- Easy setup, less control

### **New Setup (PostgreSQL):**
- **Database**: `leadgen` on `62.72.57.136`
- **User**: `leadgenadmin`
- **Password**: `7yLrHid7s5Wa`
- **Custom authentication system**
- **Full database control**

## 🚀 **Quick Setup**

### **Step 1: Set Up Database**
```bash
# Run the database setup script
./setup-database.sh
```

### **Step 2: Install Dependencies**
```bash
# Install Node.js dependencies
npm install
```

### **Step 3: Start Backend Server**
```bash
# Start the API server
npm start
```

### **Step 4: Test Everything**
```bash
# Test API health
curl http://localhost:3001/api/health

# Test waitlist (from browser)
# Go to http://localhost:8010 and try the waitlist form
```

## 📊 **Database Schema**

### **Tables Created:**
- `waitlist` - Waitlist signups (name, email, phone)
- `users` - User accounts for authentication
- `user_sessions` - JWT session management
- `leads` - Lead management data
- `campaigns` - Marketing campaigns
- `analytics` - User activity tracking

### **Key Features:**
- ✅ **Password hashing** with bcrypt
- ✅ **JWT authentication** for sessions
- ✅ **Data validation** on both frontend and backend
- ✅ **Rate limiting** for API protection
- ✅ **CORS** configured for frontend

## 🔧 **API Endpoints**

### **Waitlist:**
- `POST /api/waitlist` - Add to waitlist
- `GET /api/waitlist/stats` - Get waitlist statistics

### **Authentication:**
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/profile` - Get user profile

### **Leads:**
- `GET /api/leads` - Get user's leads
- `POST /api/leads` - Create new lead

## 🔄 **Migration Process**

### **What Was Updated:**
1. **Frontend**: Replaced Supabase calls with custom API service
2. **Backend**: Created Node.js/Express API server
3. **Database**: PostgreSQL schema with proper relationships
4. **Authentication**: Custom JWT-based auth system

### **Files Added:**
- `server.js` - Backend API server
- `api-service.js` - Frontend API client
- `POSTGRESQL_SETUP.sql` - Database schema
- `package.json` - Node.js dependencies
- `config.js` - Configuration management

## 🛠️ **Development Workflow**

### **Start Development:**
```bash
# Terminal 1: Start backend
npm start

# Terminal 2: Start frontend
python3 -m http.server 8010
```

### **Test Database Connection:**
```bash
PGPASSWORD='7yLrHid7s5Wa' psql -h 62.72.57.136 -U leadgenadmin -d leadgen -c "SELECT version();"
```

## 🔒 **Security Features**

- ✅ **Password hashing** with bcrypt (12 rounds)
- ✅ **JWT tokens** with 7-day expiration
- ✅ **Rate limiting** (100 requests per 15 minutes)
- ✅ **Input validation** on all endpoints
- ✅ **CORS protection** configured
- ✅ **Helmet.js** for security headers

## 📈 **Benefits of Migration**

1. **Full Control**: Complete database and authentication control
2. **Performance**: Direct database connection, no API overhead
3. **Customization**: Custom authentication and business logic
4. **Cost**: No Supabase subscription costs
5. **Security**: Your own security implementation

## 🚨 **Important Notes**

- **Change JWT Secret**: Update `JWT_SECRET` in production
- **SSL**: Enable SSL for production database connections
- **Environment Variables**: Use `.env` file for production config
- **Backup**: Set up regular database backups
- **Monitoring**: Add logging and monitoring for production

## 🆘 **Troubleshooting**

### **Database Connection Issues:**
```bash
# Test connection manually
PGPASSWORD='7yLrHid7s5Wa' psql -h 62.72.57.136 -U leadgenadmin -d leadgen
```

### **API Server Issues:**
```bash
# Check if port 3001 is available
lsof -i :3001

# Check server logs
npm start
```

### **Frontend Issues:**
- Check browser console for API errors
- Verify `api-service.js` is loaded
- Check CORS configuration

## 📞 **Support**

If you encounter issues:
1. Check the server logs
2. Verify database connection
3. Test API endpoints individually
4. Check browser console for errors

**Your LeadSpark app is now running on your own PostgreSQL database!** 🎉
