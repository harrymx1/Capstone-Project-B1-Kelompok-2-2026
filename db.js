const { Pool } = require("pg");
require("dotenv").config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false,
  },
});

// Tes koneksi saat aplikasi pertama kali jalan
pool.connect((err, client, release) => {
  if (err) {
    return console.error("Gagal menyambung ke Database:", err.stack);
  }
  console.log("Database Terhubung dengan Aman!");
  release();
});

pool.on("error", (err) => {
  console.error("Unexpected error on idle client", err);
  process.exit(-1);
});

module.exports = {
  query: (text, params) => pool.query(text, params),
};
