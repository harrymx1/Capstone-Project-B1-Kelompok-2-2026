const express = require("express");
const cors = require("cors");
const db = require("./db"); // Konfigurasi pool database
const { getRecommendation, getExplanation } = require("./ruleEngine");
require("dotenv").config();

const app = express();

// --- MIDDLEWARE ---
app.use(cors());
app.use(express.json());

/**
 * 1. UTILITY & CONNECTION ROUTES
 */

// Root: Health Check
app.get("/", (req, res) => {
  res.send("Server CIMB Backend Running! 🚀 (Status: Minggu 6 - Stable)");
});

// Test Database: Validasi koneksi Supabase/Postgres
app.get("/test-db", async (req, res) => {
  try {
    const result = await db.query("SELECT NOW()");
    res.json({
      success: true,
      message: "Koneksi Database Berhasil!",
      server_time: result.rows[0].now,
    });
  } catch (err) {
    console.error("Database Connection Error:", err.message);
    res.status(500).json({ success: false, error: "Database Connection Failed" });
  }
});

/**
 * 2. AUTHENTICATION & PRIVACY (Minggu 4)
 */

// Login: Autentikasi dan pencatatan audit log
app.post("/api/auth/login", async (req, res) => {
  const { user_id } = req.body;
  if (!user_id) return res.status(400).json({ success: false, message: "user_id is required" });

  try {
    const result = await db.query("SELECT * FROM single_customer_view WHERE user_id = $1", [user_id]);
    if (result.rows.length === 0) return res.status(404).json({ success: false, message: "Nasabah tidak ditemukan" });

    await db.query("INSERT INTO audit_logs (user_id, action, reason) VALUES ($1, $2, $3)", [user_id, "LOGIN", "Akses sistem personalisasi banking"]);

    res.json({ success: true, user: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Consent: Update status privasi nasabah
app.post("/api/consent", async (req, res) => {
  const { user_id, consent_status } = req.body;
  if (user_id === undefined || consent_status === undefined) {
    return res.status(400).json({ success: false, message: "user_id and consent_status are required" });
  }

  try {
    await db.query("UPDATE single_customer_view SET consent_ai = $1 WHERE user_id = $2", [consent_status, user_id]);
    await db.query("INSERT INTO audit_logs (user_id, action, reason) VALUES ($1, $2, $3)", [user_id, "UPDATE_CONSENT", `Privasi diubah ke ${consent_status}`]);

    res.json({ success: true, message: "Privacy status updated successfully" });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

/**
 * 3. CORE PERSONALIZATION (Minggu 4)
 */

// Home Dashboard: Personalisasi + Explainable AI (XAI)
app.get("/api/home/:userId", async (req, res) => {
  const { userId } = req.params;
  try {
    const userResult = await db.query("SELECT * FROM single_customer_view WHERE user_id = $1", [userId]);
    if (userResult.rows.length === 0) return res.status(404).json({ success: false, message: "User not found" });

    const userData = userResult.rows[0];
    const personalRec = getRecommendation(userData);
    const explanation = getExplanation(userData, personalRec);

    const catalogResult = await db.query("SELECT * FROM catalog WHERE TRIM(target_segment) ILIKE TRIM($1)", [userData.segmen_persona]);

    res.json({
      success: true,
      user_profile: {
        nama: userData.nama,
        persona: userData.segmen_persona,
        kategori_fav: userData.kategori_dominan,
      },
      recommendation: { ...personalRec, reason: explanation },
      promo_catalog: catalogResult.rows,
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Catalog: Ambil promo berdasarkan segmen
app.get("/api/catalog/:segment", async (req, res) => {
  const { segment } = req.params;
  try {
    const result = await db.query("SELECT * FROM catalog WHERE TRIM(target_segment) ILIKE TRIM($1)", [segment]);
    res.json({ success: true, data: result.rows });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

/**
 * 4. TRACKING & ANALYTICS (Minggu 5)
 */

// Log: Pencatatan aktivitas manual
app.post("/api/log", async (req, res) => {
  const { user_id, action, reason } = req.body;
  if (!user_id || !action) return res.status(400).json({ success: false, message: "user_id and action are required" });

  try {
    await db.query("INSERT INTO audit_logs (user_id, action, reason) VALUES ($1, $2, $3)", [user_id, action, reason]);
    if (action.toUpperCase().includes("CLICK")) {
      await db.query("INSERT INTO feature_clicks (user_id, feature_name) VALUES ($1, $2)", [user_id, action]);
    }
    res.json({ success: true, message: "Activity logged" });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Feature Click: Track klik spesifik untuk metrik
app.post("/api/feature-click", async (req, res) => {
  const { user_id, feature_name } = req.body;
  if (!user_id || !feature_name) return res.status(400).json({ success: false, message: "Missing required fields" });

  try {
    await db.query("INSERT INTO feature_clicks (user_id, feature_name) VALUES ($1, $2)", [user_id, feature_name]);
    res.json({ success: true, message: "Click tracked" });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Stats: Ranking fitur terpopuler
app.get("/api/feature-stats", async (req, res) => {
  try {
    const result = await db.query(`
      SELECT feature_name, COUNT(*) as total_clicks 
      FROM feature_clicks 
      GROUP BY feature_name 
      ORDER BY total_clicks DESC
    `);
    res.json({ success: true, data: result.rows });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// CTR Analytics: Metrik efektivitas per segmen
app.get("/api/analytics/ctr", async (req, res) => {
  try {
    const query = `
      SELECT 
        scv.segmen_persona,
        COUNT(fc.id) as total_clicks,
        COUNT(DISTINCT scv.user_id) as total_users,
        ROUND((COUNT(fc.id)::numeric / NULLIF(COUNT(DISTINCT scv.user_id), 0)), 2) as ctr_score
      FROM single_customer_view scv
      LEFT JOIN feature_clicks fc ON scv.user_id = fc.user_id
      GROUP BY scv.segmen_persona
      ORDER BY ctr_score DESC;
    `;
    const result = await db.query(query);
    res.json({ success: true, metric: "CTR per Segment", data: result.rows });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Audit Trail: Log privasi dan keamanan nasabah
app.get("/api/analytics/audit", async (req, res) => {
  try {
    const result = await db.query(`
      SELECT * FROM audit_logs 
      WHERE action IN ('UPDATE_CONSENT', 'LOGIN') 
      ORDER BY timestamp DESC 
      LIMIT 100
    `);
    res.json({ success: true, data: result.rows });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// --- 5. SERVER STARTUP ---
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`=============================================`);
  console.log(`🚀 CIMB BACKEND SERVER ACTIVE`);
  console.log(`📡 Port: ${PORT}`);
  console.log(`---------------------------------------------`);
  console.log(`🔗 Test DB     : GET http://localhost:${PORT}/test-db`);
  console.log(`🔗 Home (XAI)  : GET http://localhost:${PORT}/api/home/USR0001`);
  console.log(`🔗 Stats Click : GET http://localhost:${PORT}/api/feature-stats`);
  console.log(`📊 Analytics CTR: GET http://localhost:${PORT}/api/analytics/ctr`);
  console.log(`🔒 Audit Trail : GET http://localhost:${PORT}/api/analytics/audit`);
  console.log(`=============================================`);
});
