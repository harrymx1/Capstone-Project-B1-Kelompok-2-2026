<<<<<<< HEAD
# mbanking

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# Capstone-Project-B1-Kelompok-2-2026
Prototipe sistem personalisasi mobile banking berbasis AI (Clustering) dan Rule-Based Engine untuk rekomendasi dinamis, transparan, dan kontekstual. Capstone Project FILKOM UB 2026 x CIMB Niaga (Topik B.1).


# 🏦 AI-Powered Mobile Banking Personalization (Capstone Project)

![Next.js](https://img.shields.io/badge/Next.js-black?style=flat-square&logo=next.js)
![Express.js](https://img.shields.io/badge/Express.js-000000?style=flat-square&logo=express&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=flat-square&logo=postgresql&logoColor=white)

Proyek ini adalah prototipe sistem personalisasi layanan *mobile banking* berbasis Analitik dan Artificial Intelligence (AI). Sistem ini dirancang untuk memberikan pengalaman pengguna yang dinamis, kontekstual, dan transparan dengan memanfaatkan riwayat data perilaku nasabah (transaksi, profil, dan interaksi aplikasi).

**Mitra Proyek:** CIMB Niaga  
**Konteks:** Topik B.1 - Capstone Project Fakultas Ilmu Komputer (FILKOM) Universitas Brawijaya 2026.

---

## Fitur Utama (4 Pilar Sistem)

### 1. User-Facing UI (Simulasi Mobile Banking)
- **Persona-Based Login:** Menggunakan sistem *dropdown* otentikasi (tanpa registrasi manual) untuk menghindari masalah *Cold Start*, memungkinkan demontrasi AI secara instan menggunakan data *dummy* yang telah di-*seed*.
- **Dynamic Content:** *Quick Actions* dan *Banner Promo* berubah secara *real-time* sesuai segmen dan riwayat interaksi pengguna.
- **Explainable AI (XAI):** Fitur "Kenapa saya melihat ini?" untuk memberikan transparansi rekomendasi kepada nasabah.
- **Privacy Control:** *Toggle* manajemen izin (*consent*) penggunaan data.

### 2. Personalisasi Engine (Hybrid Architecture)
- **Rule-Based Engine (Real-time):** Logika di sisi *backend* (Node.js) yang mengeksekusi rekomendasi akhir secara instan berdasarkan aktivitas terbaru nasabah.
- **Machine Learning (Batch Processing):** Algoritma *K-Means Clustering* (Python) yang berjalan di latar belakang (terjadwal) untuk mengelompokkan nasabah ke dalam segmen perilaku (misal: Gen-Z, Pekerja Mapan).

### 3. Dashboard Admin & Analytics
- Layar monitor untuk tim internal bank guna memantau efektivitas rekomendasi AI.
- Menampilkan metrik *Click-Through Rate* (CTR), performa rekomendasi per segmen, hasil simulasi *A/B Testing*, serta *Audit Trail* (Log Privasi & Penggunaan Data).

### 4. Data Pipeline & Single Customer View (SCV)
- **Dataset Sintetis:** Menggunakan 50-200 data nasabah *dummy* beserta ratusan riwayat transaksinya.
- **ETL Pipeline:** Penyatuan tabel Profil, Transaksi, dan Interaksi menjadi satu **Single Customer View (SCV)** menggunakan SQL `VIEW` untuk mempercepat proses *inference* (API) dan *retraining* (ML).

---

## Tech Stack (The Hybrid Powerhouse)

Proyek ini memisahkan layanan *Web Operational* dengan *AI/Analytics Engine* untuk efisiensi komputasi:

- **Frontend (Nasabah UI & Admin Dashboard):** Next.js (React), Tailwind CSS, Recharts (Visualisasi Data).
- **Backend (API & Rule-Based Logic):** Node.js dengan framework Express.js.
- **Database & ORM:** PostgreSQL + Prisma ORM (Pemrosesan SCV & Audit Logging).
- **Machine Learning (Clustering):** Python, Scikit-Learn, Pandas (berjalan sebagai *batch processing script*).

---

## Cara Kerja Sistem (Flow Logika)



Sistem ini didesain bebas dari *real-time streaming analytics* skala besar yang berat.
1. **Inference (Menebak):** Saat nasabah login, aplikasi web memanggil API Express. *Rule-based engine* membaca tabel *Single Customer View* (SCV) dan memberikan *output* promo yang dipersonalisasi dalam hitungan milidetik.
2. **Retraining (Belajar):** *Script* Python dieksekusi secara berkala (*Batch*). Algoritma mengambil seluruh data SCV terbaru, melatih ulang *cluster* nasabah, dan menyimpan nilai `cluster_id` yang baru kembali ke *database*.

---
>>>>>>> a531de5c89f7e1cd030b1c9ab4331dd008cac2aa
