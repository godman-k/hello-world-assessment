const mysql = require('mysql2/promise');
const { GoogleAuth } = require('google-auth-library');

const connectionName = process.env.DB_INSTANCE;
const dbName = process.env.DB_NAME;
const dbUser = process.env.DB_USER;
const dbPassword = process.env.DB_PASSWORD;

let mysqlConfig = {
  user: dbUser,
  password: dbPassword,
  database: dbName,
  socketPath: `/cloudsql/${connectionName}`,
  authPlugins: {
    mysql_clear_password: () => async (parameters, cb) => {
      const auth = new GoogleAuth({
        scopes: ['https://www.googleapis.com/auth/cloud-platform']
      });
      const client = await auth.getClient();
      const tokenResponse = await client.getAccessToken();
      cb(null, tokenResponse.token);
    }
  }
};

exports.connectToCloudSQL = async (req, res) => {
  try {
    const connection = await mysql.createConnection(mysqlConfig);

    // Check if the table exists, and create it if not
    await connection.query(`
      CREATE TABLE IF NOT EXISTS greetings (
        id INT AUTO_INCREMENT PRIMARY KEY,
        message VARCHAR(255) NOT NULL
      );
    `);

    // Insert the "Hello World!" message if the table is empty
    const [rows] = await connection.query('SELECT COUNT(*) AS count FROM greetings');
    if (rows[0].count === 0) {
      await connection.query('INSERT INTO greetings (message) VALUES (?)', ['Hello World!']);
    }

    // Retrieve the data
    const [data] = await connection.query('SELECT message FROM greetings');

    await connection.end();

    // Create an HTML response
    const htmlResponse = `
      <!DOCTYPE html>
      <html>
      <body>
        <h1>
        <ul>
          ${data.map(row => `<li>${row.message}</li>`).join('')}
        </ul>
        </h1>
      </body>
      </html>
    `;

    res.status(200).send(htmlResponse);
  } catch (err) {
    console.error('ERROR:', err);
    res.status(500).send(`
      <!DOCTYPE html>
      <html>
      <head>
        <title>Error</title>
      </head>
      <body>
        <h1>Failed to connect to Cloud SQL</h1>
        <p>${err.message}</p>
      </body>
      </html>
    `);
  }
};
