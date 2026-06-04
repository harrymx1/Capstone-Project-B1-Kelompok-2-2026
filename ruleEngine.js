/**
 * RULE-BASED ENGINE MODUL (Scoring System)
 * Fokus: Personalisasi Rekomendasi & Explainable AI (XAI)
 */

// 1. DAFTAR FITUR & PROMO (Kandidat Awal)
// Ini adalah "wadah" awal sebelum dievaluasi
const getInitialScores = () => ({
  'QRIS': { score: 0, hero: 'Promo Gadget & Cashback QRIS', action: 'Scan QRIS sekarang dan nikmati cashback!', xai: '' },
  'INVESTASI': { score: 0, hero: 'Mulai Langkah Investasimu', action: 'Beli Reksa Dana mulai dari Rp 10.000', xai: '' },
  'PAYLATER': { score: 0, hero: 'Beli Sekarang, Bayar Nanti', action: 'Aktifkan PayLater limit hingga Rp 10 Juta', xai: '' },
  'TRANSFER': { score: 0, hero: 'Bebas Biaya Admin', action: 'Transfer antar bank gratis tanpa batas', xai: '' },
  'TOPUP': { score: 0, hero: 'Top-up E-Wallet Instan', action: 'Isi saldo GoPay/OVO tanpa ribet', xai: '' },
  'KPR': { score: 0, hero: 'Solusi KPR Masa Depan', action: 'Cek simulasi KPR dengan bunga spesial', xai: '' },
  'PENSIUN': { score: 0, hero: 'Layanan Dana Pensiun', action: 'Nikmati masa tuamu dengan aman', xai: '' },
  'PRIORITAS': { score: 0, hero: 'Exclusive Wealth Management', action: 'Akses layanan khusus nasabah prioritas', xai: '' },
  'TARIK_TUNAI': { score: 0, hero: 'Butuh Dana Cepat?', action: 'Gunakan fitur Tarik Tunai Tanpa Kartu sekarang', xai: '' },
  'TAGIHAN': { score: 0, hero: 'Bayar Tagihan Tepat Waktu', action: 'Cek dan bayar tagihan bulananmu di sini', xai: '' }
});

// 2. DAFTAR ATURAN (Rule Table)
const RULES = [
  // --- LAYER 2: BASELINE (SEGMEN PERSONA) ---
  {
    id: "BASE_GEN_Z",
    condition: (scv) => scv.segmen_persona === "Gen_Z",
    action: (scores) => {
      scores['QRIS'].score += 20;
      scores['TOPUP'].score += 20;
      scores['QRIS'].xai = "Sebagai Gen-Z, metode pembayaran cepat ini cocok untuk gaya hidup harianmu.";
    }
  },
  {
    id: "BASE_NASABAH_BASIC",
    condition: (scv) => scv.segmen_persona === "Nasabah_Basic" || scv.segmen_persona === "Basic",
    action: (scores) => {
      scores['TARIK_TUNAI'].score += 20;
      scores['PAYLATER'].score += 20;
      scores['TARIK_TUNAI'].xai = "Akses cepat untuk Tarik Tunai Tanpa Kartu dan info PayLater untuk memenuhi kebutuhan mendesakmu.";
    }
  },
  {
    id: "BASE_PEKERJA_MAPAN",
    condition: (scv) => scv.segmen_persona === "Pekerja_Mapan",
    action: (scores) => {
      scores['INVESTASI'].score += 20;
      scores['KPR'].score += 20;
      scores['TAGIHAN'].score += 15;
      scores['INVESTASI'].xai = "Sebagai pekerja mapan, penting untuk mulai menyiapkan tabungan jangka panjang.";
    }
  },
  {
    id: "BASE_PENSIUNAN",
    condition: (scv) => scv.segmen_persona === "Pensiunan",
    action: (scores) => {
      scores['PENSIUN'].score += 50; // Langsung bobot besar
      scores['TAGIHAN'].score += 30;
      scores['PENSIUN'].xai = "Disesuaikan dengan profil masa pensiunmu agar keuangan selalu stabil.";
    }
  },
  {
    id: "BASE_PRIORITAS",
    condition: (scv) => scv.segmen_persona === "Prioritas" || scv.is_prioritas == 1,
    action: (scores) => {
      scores['PRIORITAS'].score += 50;
      scores['PRIORITAS'].xai = "Layanan eksklusif ini tersedia karena Anda adalah nasabah prioritas istimewa kami.";
    }
  },
  
  // --- LAYER 3: BEHAVIORAL OVERRIDES (PERSONA MIKRO) ---
  {
    id: "BEHAVIOR_SALDO_TINGGI",
    condition: (scv) => parseFloat(scv.saldo_rata_rata) > 15000000,
    action: (scores) => {
      scores['INVESTASI'].score += 40;
      scores['INVESTASI'].xai = "Saldo rata-rata bulananmu sangat ideal untuk mulai diputar ke instrumen investasi.";
    }
  },
  {
    id: "BEHAVIOR_SERING_QRIS",
    condition: (scv) => parseInt(scv.freq_qris) > 15 || scv.kategori_dominan === 'F&B/Retail',
    action: (scores) => {
      scores['QRIS'].score += 35;
      scores['QRIS'].xai = "Kami memprioritaskan ini berdasarkan kebiasaan transaksimu yang sangat sering memakai QRIS di merchant.";
    }
  },
  {
    id: "BEHAVIOR_SERING_PAYLATER",
    condition: (scv) => scv.fitur_favorit === 'PayLater' || parseInt(scv.freq_tagihan) > 10,
    action: (scores) => {
      scores['PAYLATER'].score += 45;
      scores['PAYLATER'].xai = "Karena kamu sering mengakses PayLater dan membayar tagihan, kami sediakan kemudahannya di sini.";
    }
  },
  {
    id: "BEHAVIOR_SERING_TOPUP",
    condition: (scv) => scv.fitur_favorit === 'TopUp' || parseInt(scv.freq_topup_ewallet) > 10,
    action: (scores) => {
      scores['TOPUP'].score += 30;
      scores['TOPUP'].xai = "Kamu sering top-up E-Wallet bulan ini, gunakan fitur instan kami agar tidak perlu repot mencari menu.";
    }
  },
  {
    id: "BEHAVIOR_USIA_TUA",
    condition: (scv) => parseInt(scv.usia) >= 55,
    action: (scores) => {
      scores['PENSIUN'].score += 25;
      scores['PENSIUN'].xai = "Prioritas akses ke layanan finansial yang aman dan nyaman untuk usia Anda.";
    }
  },
  {
    id: "BEHAVIOR_USIA_MUDA",
    condition: (scv) => parseInt(scv.usia) <= 25,
    action: (scores) => {
      scores['QRIS'].score += 15;
      scores['TOPUP'].score += 15;
      scores['QRIS'].xai = "Rekomendasi khusus untuk menunjang gaya hidup dinamis dan cepatmu.";
    }
  },
  {
    id: "BEHAVIOR_PENDAPATAN_TINGGI",
    condition: (scv) => parseFloat(scv.pendapatan_bulanan) > 20000000,
    action: (scores) => {
      scores['INVESTASI'].score += 30;
      scores['PRIORITAS'].score += 20;
      scores['INVESTASI'].xai = "Pendapatanmu sangat ideal untuk mulai diversifikasi aset ke instrumen investasi.";
    }
  },
  {
    id: "BEHAVIOR_SERING_TRANSFER",
    condition: (scv) => parseInt(scv.freq_transfer) > 15,
    action: (scores) => {
      scores['TRANSFER'].score += 35;
      scores['TRANSFER'].xai = "Kamu sering mengirim dana bulan ini. Gunakan transfer bebas biaya admin dari kami.";
    }
  },
  {
    id: "BEHAVIOR_SERING_TARIK_TUNAI",
    condition: (scv) => parseInt(scv.freq_tarik_tunai) > 5,
    action: (scores) => {
      scores['TARIK_TUNAI'].score += 35;
      scores['TARIK_TUNAI'].xai = "Sering butuh uang tunai? Gunakan fitur Tarik Tunai Tanpa Kartu dengan cepat di sini.";
    }
  },
  {
    id: "BEHAVIOR_AKTIF_INVESTASI",
    condition: (scv) => parseInt(scv.freq_investasi) > 3 || parseInt(scv.freq_valas) > 3,
    action: (scores) => {
      scores['INVESTASI'].score += 40;
      scores['INVESTASI'].xai = "Aktivitas investasi dan valasmu semakin berkembang. Cek peluang pasar terbaru hari ini!";
    }
  },
  {
    id: "BEHAVIOR_MODE_SEDERHANA",
    condition: (scv) => scv.mode_sederhana === true || scv.mode_sederhana === '1' || scv.mode_sederhana == 1,
    action: (scores) => {
      scores['PENSIUN'].score += 40;
      scores['PENSIUN'].xai = "Tampilan ini diutamakan karena kamu mengaktifkan Mode Sederhana di pengaturan.";
    }
  }
];

// 3. FUNGSI EKSEKUSI ENGINE
const runRuleEngine = (scvData) => {
  // Gatekeeper Layer 1
  if (!scvData.consent_ai || scvData.consent_ai == 0 || scvData.consent_ai === '0' || scvData.consent_ai === false) {
    // Jika nasabah tidak setuju penggunaan AI, berikan UI default tanpa personalisasi
    return {
      primary_hero: "Kemudahan Transaksi Harian",
      suggested_action: "Gunakan aplikasi ini untuk semua kebutuhan perbankanmu.",
      reason: "Rekomendasi default karena izin AI (Privacy Consent) dimatikan.",
      top_menus: ["TRANSFER", "TOPUP", "QRIS", "CEK_SALDO"]
    };
  }

  // Inisialisasi Skor
  let scores = getInitialScores();

  // Evaluasi semua kondisi terhadap tabel aturan
  for (const rule of RULES) {
    if (rule.condition(scvData)) {
      rule.action(scores);
    }
  }

  // Sorting berdasarkan skor dari tertinggi ke terendah
  let sortedFeatures = Object.keys(scores)
    .map(key => ({ 
      id: key, 
      score: scores[key].score, 
      hero: scores[key].hero,
      action: scores[key].action,
      xai: scores[key].xai 
    }))
    .sort((a, b) => b.score - a.score);

  // Fitur pemenang (tertinggi) akan menjadi Pahlawan Utama (Primary Hero)
  let winner = sortedFeatures[0];

  return {
    primary_hero: winner.hero,
    suggested_action: winner.action,
    reason: winner.xai || "Rekomendasi ini disusun secara khusus berdasarkan pola transaksi dan kebutuhan finansialmu.",
    top_menus: sortedFeatures.slice(0, 4).map(f => f.id) // Kirim 4 menu teratas
  };
};

// 4. WRAPPER UNTUK BACKWARD-COMPATIBILITY DENGAN INDEX.JS
const getRecommendation = (userData) => {
  const result = runRuleEngine(userData);
  return {
    primary_hero: result.primary_hero,
    suggested_action: result.suggested_action,
    insight: result.reason,
    top_menus: result.top_menus
  };
};

const getExplanation = (userData, recommendation) => {
  return recommendation.insight;
};

module.exports = {
  getRecommendation,
  getExplanation,
  runRuleEngine
};
