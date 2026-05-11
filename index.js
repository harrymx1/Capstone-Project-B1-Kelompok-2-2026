const express = require("express");
const cors = require("cors");
const db = require("./db"); // Mengambil konfigurasi pool dari db.js
// Destructuring untuk mengambil getRecommendation dan getExplanation
const { getRecommendation, getExplanation } = require("./ruleEngine");
require("dotenv").config();

const app = express();

// Middleware
app.use(cors()); // Mengizinkan akses dari frontend
app.use(express.json()); // Mengizinkan server menerima data format JSON

// --- ROUTES ---

// 1. Root Route (Cek server nyala)
app.get("/", (req, res) => {
  res.send("Server CIMB Backend Running! 🚀");
});

// 2. Test DB Route (Cek koneksi ke Supabase)
app.get("/test-db", async (req, res) => {
  try {
    const result = await db.query("SELECT NOW()");
    res.json({
      success: true,
      message: "Koneksi Supabase Berhasil!",
      database_time: result.rows[0].now,
    });
  } catch (err) {
    console.error("Database Error:", err.message);
    res.status(500).json({
      success: false,
      error: "Gagal menyambung ke database",
      details: err.message,
    });
  }
});

// 3. Endpoint Login (POST): Mencatat aktivitas login
app.post("/api/auth/login", async (req, res) => {
  const { user_id } = req.body;
  try {
    const result = await db.query("SELECT * FROM single_customer_view WHERE user_id = $1", [user_id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: "Nasabah tidak ditemukan" });
    }

    // Mencatat log LOGIN ke tabel audit_logs
    await db.query("INSERT INTO audit_logs (user_id, action, reason) VALUES ($1, $2, $3)", [user_id, "LOGIN", "Akses sistem personalisasi banking"]);

    res.json({ success: true, message: "Login Berhasil", user: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// 4. Endpoint Audit Log (POST): Mencatat aktivitas manual dari Frontend
app.post("/api/log", async (req, res) => {
  const { user_id, action, reason } = req.body;
  try {
    await db.query("INSERT INTO audit_logs (user_id, action, reason) VALUES ($1, $2, $3)", [user_id, action, reason]);
    res.json({ success: true, message: "Aktivitas berhasil dicatat ke audit logs" });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// 5. Endpoint Home (GET): Mengambil data rekomendasi & profil personal (Update Minggu 4)
app.get("/api/home/:userId", async (req, res) => {
  const { userId } = req.params;
  try {
    // 1. Cari data nasabah
    const userResult = await db.query("SELECT * FROM single_customer_view WHERE user_id = $1", [userId]);

    if (userResult.rows.length === 0) {
      return res.status(404).json({ success: false, message: "User tidak ditemukan" });
    }

    const userData = userResult.rows[0];

    // 2. Ambil Rekomendasi dasar
    const personalRecommendation = getRecommendation(userData);

    // 3. Tambahkan Fitur XAI: Panggil getExplanation (Tugas Minggu 4)
    const explanation = getExplanation(userData, personalRecommendation);

    // 4. Ambil Katalog Promo
    const catalogResult = await db.query("SELECT * FROM catalog WHERE TRIM(target_segment) ILIKE TRIM($1)", [userData.segmen_persona]);

    res.json({
      success: true,
      user_profile: {
        nama: userData.nama,
        persona: userData.segmen_persona,
        kategori_fav: userData.kategori_dominan,
      },
      recommendation: {
        ...personalRecommendation,
        reason: explanation, // Respons menyertakan alasan (Output Minggu 4)
      },
      promo_catalog: catalogResult.rows,
    });
  } catch (err) {
    console.error("Home API Error:", err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

// 6. Endpoint Consent (POST): Menyimpan status privasi pengguna (Tugas Minggu 4)
app.post("/api/consent", async (req, res) => {
  const { user_id, consent_status } = req.body;
  try {
    // Update kolom consent di database (Pastikan kolom consent_ai tersedia di tabel)
    await db.query("UPDATE single_customer_view SET consent_ai = $1 WHERE user_id = $2", [consent_status, user_id]);

    // Catat perubahan ke audit log
    await db.query("INSERT INTO audit_logs (user_id, action, reason) VALUES ($1, $2, $3)", [user_id, "UPDATE_CONSENT", `User mengubah status privasi menjadi ${consent_status}`]);

    res.json({ success: true, message: "Status privasi berhasil diperbarui" });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Menentukan Port
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`=================================`);
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🔗 Test DB: GET http://localhost:${PORT}/test-db`);
  console.log(`🔗 Home: GET http://localhost:${PORT}/api/home/USR0001`);
  console.log(`=================================`);
});
