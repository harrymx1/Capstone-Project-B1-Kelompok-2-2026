const { Pool } = require("pg");
require("dotenv").config();

// Inisialisasi koneksi menggunakan data dari file .env
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  // SSL diperlukan untuk koneksi aman ke database cloud seperti Supabase
  ssl: {
    rejectUnauthorized: false,
  },
});

// Menambahkan log sederhana untuk memantau jika ada error pada pool
pool.on("error", (err) => {
  console.error("Unexpected error on idle client", err);
  process.exit(-1);
});

module.exports = {
  // Fungsi query global yang akan digunakan di file index.js
  query: (text, params) => pool.query(text, params),
};
