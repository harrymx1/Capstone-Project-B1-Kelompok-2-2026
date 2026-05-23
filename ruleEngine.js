/**
 * RULE-BASED ENGINE MODUL (Minggu 4)
 * Fokus: Personalisasi Rekomendasi & Explainable AI (XAI)
 */

// 1. Fungsi untuk menentukan rekomendasi berdasarkan persona
const getRecommendation = (userData) => {
  const { segmen_persona } = userData;

  let recommendation = {
    primary_hero: "",
    suggested_action: "",
    insight: "",
  };

  // Logika Rule-Based untuk menentukan konten Beranda
  if (segmen_persona === "Gen_Z") {
    recommendation.primary_hero = "Promo Gadget & Hiburan Kekinian";
    recommendation.suggested_action = "Top-up E-Wallet atau beli Voucher Game";
    recommendation.insight = "Karena kamu sering bertransaksi di QRIS Merchant.";
  } else if (segmen_persona === "Pekerja_Mapan") {
    recommendation.primary_hero = "Solusi Investasi & KPR";
    recommendation.suggested_action = "Cek simulasi KPR atau buka Deposito";
    recommendation.insight = "Berdasarkan saldo rata-rata dan profil kemapananmu.";
  } else if (segmen_persona === "Pensiunan") {
      recommendation.primary_hero = "Layanan Kesehatan & Dana Pensiun";
      recommendation.suggested_action ="Nikmati promo kesehatan dan transfer dana pensiun.";
      recommendation.insight = "Disesuaikan dengan kebutuhan finansial dan kesehatan masa pensiun.";
  } else if (segmen_persona === "Prioritas") {
      recommendation.primary_hero = "Exclusive Wealth & Lifestyle";
      recommendation.suggested_action = "Akses layanan premium dan wealth management.";
      recommendation.insight = "Karena Anda termasuk nasabah prioritas dengan benefit eksklusif.";
  } else {
    recommendation.primary_hero = "Kemudahan Transaksi Harian";
    recommendation.suggested_action = "Gunakan fitur bayar tagihan otomatis";
    recommendation.insight = "Agar pengelolaan keuangan harianmu lebih simpel.";
  }

  return recommendation;
};

// 2. Fungsi Explainable AI (XAI): Memberikan alasan spesifik di balik rekomendasi
const getExplanation = (userData, recommendation) => {
  const { segmen_persona, total_qris, saldo_rata_rata } = userData;

  // Logika IF-THEN untuk template alasan (XAI)
  if (segmen_persona === "Gen_Z") {
    return `Kami menyarankan ${recommendation.primary_hero} karena catatan kami menunjukkan Anda telah melakukan ${total_qris || 0} transaksi QRIS bulan ini.`;
  }

  if (segmen_persona === "Pekerja_Mapan") {
    return `Rekomendasi ini muncul karena saldo rata-rata Anda berada di atas ambang batas minimum untuk produk investasi premium.`;
  }

  if (segmen_persona === "Pensiunan") {
    return `Kami merekomendasikan layanan kesehatan dan promo pensiun karena profil Anda termasuk segmen pensiunan aktif.`;
  }

  if (segmen_persona === "Prioritas") {
    return `Rekomendasi premium ini diberikan karena Anda termasuk nasabah prioritas dengan akses layanan eksklusif.`;
  }

  return `Rekomendasi ini dipilih secara khusus berdasarkan riwayat transaksi dan kategori pengeluaran favorit Anda.`;
};

// 3. Ekspor kedua fungsi agar bisa digunakan di index.js [cite: 1]
module.exports = {
  getRecommendation,
  getExplanation,
};
