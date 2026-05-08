// Fungsi untuk menentukan rekomendasi berdasarkan persona dan data transaksi
const getRecommendation = (userData) => {
  const { segmen_persona, kategori_dominan, avg_nominal } = userData;

  let recommendation = {
    primary_hero: "",
    suggested_action: "",
    insight: "",
  };

  // Logika sederhana Rule-Based
  if (segmen_persona === "Gen Z") {
    recommendation.primary_hero = "Promo Gadget & Hiburan Kekinian";
    recommendation.suggested_action = "Top-up E-Wallet atau beli Voucher Game";
    recommendation.insight = "Karena kamu sering bertransaksi di QRIS Merchant.";
  } else if (segmen_persona === "Pekerja_Mapan") {
    recommendation.primary_hero = "Solusi Investasi & KPR";
    recommendation.suggested_action = "Cek simulasi KPR atau buka Deposito";
    recommendation.insight = "Berdasarkan saldo rata-rata dan profil kemapananmu.";
  } else {
    recommendation.primary_hero = "Kemudahan Transaksi Harian";
    recommendation.suggested_action = "Gunakan fitur bayar tagihan otomatis";
    recommendation.insight = "Agar pengelolaan keuangan harianmu lebih simpel.";
  }

  return recommendation;
};

module.exports = { getRecommendation };
