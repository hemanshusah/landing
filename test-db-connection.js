// Database Connection Troubleshooting Script
const { Pool } = require('pg');

console.log('🔍 Testing PostgreSQL Database Connection...\n');

// Test different connection configurations
const configs = [
  {
    name: 'Original Config',
    config: {
      host: '62.72.57.136',
      user: 'leadgenadmin',
      password: '7yLrHid7s5Wa',
      database: 'leadgen',
      port: 5432,
      ssl: false
    }
  },
  {
    name: 'With SSL',
    config: {
      host: '62.72.57.136',
      user: 'leadgenadmin',
      password: '7yLrHid7s5Wa',
      database: 'leadgen',
      port: 5432,
      ssl: true
    }
  },
  {
    name: 'Different Database Name (postgres)',
    config: {
      host: '62.72.57.136',
      user: 'leadgenadmin',
      password: '7yLrHid7s5Wa',
      database: 'postgres',
      port: 5432,
      ssl: false
    }
  },
  {
    name: 'Different Username (postgres)',
    config: {
      host: '62.72.57.136',
      user: 'postgres',
      password: '7yLrHid7s5Wa',
      database: 'leadgen',
      port: 5432,
      ssl: false
    }
  }
];

async function testConnection(config) {
  const pool = new Pool(config.config);
  
  try {
    console.log(`Testing: ${config.name}`);
    console.log(`Host: ${config.config.host}:${config.config.port}`);
    console.log(`User: ${config.config.user}`);
    console.log(`Database: ${config.config.database}`);
    console.log(`SSL: ${config.config.ssl}`);
    
    const client = await pool.connect();
    const result = await client.query('SELECT version(), current_database(), current_user;');
    
    console.log('✅ Connection successful!');
    console.log(`PostgreSQL Version: ${result.rows[0].version.split(' ')[0]}`);
    console.log(`Current Database: ${result.rows[0].current_database}`);
    console.log(`Current User: ${result.rows[0].current_user}`);
    console.log('---\n');
    
    client.release();
    await pool.end();
    return true;
    
  } catch (error) {
    console.log('❌ Connection failed!');
    console.log(`Error: ${error.message}`);
    console.log(`Code: ${error.code || 'N/A'}`);
    console.log('---\n');
    
    await pool.end();
    return false;
  }
}

async function runTests() {
  console.log('Database Credentials from CTO:');
  console.log('Host: 62.72.57.136');
  console.log('User: leadgenadmin');
  console.log('Password: 7yLrHid7s5Wa');
  console.log('Database: leadgen\n');
  
  let success = false;
  
  for (const config of configs) {
    const result = await testConnection(config);
    if (result) {
      success = true;
      console.log('🎉 Found working configuration!');
      break;
    }
  }
  
  if (!success) {
    console.log('❌ All connection attempts failed.');
    console.log('\nPossible issues:');
    console.log('1. Wrong password - ask CTO to verify');
    console.log('2. Wrong username - try "postgres" instead');
    console.log('3. Database doesn\'t exist - ask CTO to create "leadgen" database');
    console.log('4. User doesn\'t have access - ask CTO to grant permissions');
    console.log('5. Server requires SSL - try with ssl: true');
    console.log('6. Firewall blocking connection - ask CTO to check server settings');
  }
}

runTests().catch(console.error);
