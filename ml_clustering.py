# 0. Install dependencies
import os
import warnings
import pandas as pd
import numpy as np
from sqlalchemy import create_engine, text
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

warnings.filterwarnings("ignore")


# 1. Koneksi ke Supabase
def get_engine():
    conn_str = os.environ["DATABASE_URL"]
    return create_engine(conn_str)


# 2. Baca data dari Supabase
def load_data(engine):
    print("Membaca data dari Supabase...")

    users        = pd.read_sql("SELECT * FROM users",                engine)
    transactions = pd.read_sql("SELECT * FROM transactions",         engine)
    clicks       = pd.read_sql("SELECT * FROM feature_clicks",       engine)
    scv          = pd.read_sql("SELECT * FROM single_customer_view", engine)

    print(f"  Users        : {users.shape}")
    print(f"  Transactions : {transactions.shape}")
    print(f"  Clicks       : {clicks.shape}")
    print(f"  SCV          : {scv.shape}")

    return users, transactions, clicks, scv


# 3. Feature Engineering
def build_features(users, transactions, clicks, scv):
    print("Feature engineering...")

    # Transaksi per kategori
    trx_pivot = (
        transactions.groupby(["user_id", "kategori"])
        .size().unstack(fill_value=0).reset_index()
    )
    trx_pivot.columns.name = None
    kategori_cols = [c for c in trx_pivot.columns if c != "user_id"]
    trx_total = trx_pivot[kategori_cols].sum(axis=1).replace(0, 1)
    for col in kategori_cols:
        trx_pivot[f"rasio_{col.lower()}"] = trx_pivot[col] / trx_total

    # Nominal transaksi
    trx_nominal = transactions.groupby("user_id")["nominal"].agg(
        total_nominal="sum", avg_nominal="mean",
        std_nominal="std",   max_nominal="max",
    ).reset_index()
    trx_nominal["std_nominal"] = trx_nominal["std_nominal"].fillna(0)

    # Flag auto debet
    metode_pivot = (
        transactions.groupby(["user_id", "metode"])
        .size().unstack(fill_value=0).reset_index()
    )
    metode_pivot.columns.name = None
    metode_pivot["flag_auto_debet"] = (
        metode_pivot["Auto_Debet"].gt(0).astype(int)
        if "Auto_Debet" in metode_pivot.columns else 0
    )

    # Investasi + Valas
    inv_valas_agg = (
        transactions[transactions["kategori"].isin(["Investasi", "Valas"])]
        .groupby("user_id")["nominal"].sum().reset_index()
        .rename(columns={"nominal": "total_investasi_valas"})
    )

    # Click behaviour
    klik_beranda = clicks.groupby("user_id").agg(
        klik_dari_beranda=("dari_beranda", "sum"),
        total_klik_all=("dari_beranda", "count"),
    ).reset_index()
    klik_beranda["rasio_klik_beranda"] = (
        klik_beranda["klik_dari_beranda"] / klik_beranda["total_klik_all"].replace(0, 1)
    )

    klik_investasi = (
        clicks[clicks["fitur_diklik"] == "Investasi"]
        .groupby("user_id").size().reset_index()
        .rename(columns={0: "klik_investasi_fitur"})
    )

    # Gabungkan ke base
    base = scv[[
        "user_id", "usia", "pendapatan_bulanan", "saldo_rata_rata",
        "is_prioritas", "mode_sederhana", "consent_ai",
        "total_transaksi", "total_nominal", "avg_nominal",
        "freq_qris", "freq_topup_ewallet", "freq_transfer",
        "freq_tagihan", "freq_investasi", "freq_tarik_tunai",
        "freq_cek_saldo", "freq_hiburan", "freq_valas",
        "total_klik", "avg_durasi", "klik_dari_beranda",
    ]].copy()

    rasio_cols = [c for c in trx_pivot.columns if c.startswith("rasio_")]

    base = (
        base
        .merge(trx_nominal,   on="user_id", how="left", suffixes=("", "_trx"))
        .merge(inv_valas_agg, on="user_id", how="left")
        .merge(klik_beranda[["user_id", "rasio_klik_beranda"]], on="user_id", how="left")
        .merge(klik_investasi, on="user_id", how="left")
        .merge(trx_pivot[["user_id"] + rasio_cols], on="user_id", how="left")
        .merge(metode_pivot[["user_id", "flag_auto_debet"]], on="user_id", how="left")
        .fillna(0)
    )

    return base


# 4. Clustering
FEATURE_COLS = [
    "usia", "pendapatan_bulanan", "saldo_rata_rata", "is_prioritas", "mode_sederhana",
    "freq_qris", "freq_topup_ewallet", "freq_transfer", "freq_tagihan", "freq_investasi",
    "freq_tarik_tunai", "freq_hiburan", "freq_valas", "total_transaksi",
    "avg_nominal", "total_investasi_valas",
    "rasio_qris", "rasio_topup_ewallet", "rasio_tagihan",
    "rasio_investasi", "rasio_hiburan", "rasio_valas",
    "total_klik", "avg_durasi", "rasio_klik_beranda",
    "klik_investasi_fitur", "flag_auto_debet",
]

def run_clustering(base):
    print("Menjalankan K-Means (k=5)...")

    for col in FEATURE_COLS:
        if col not in base.columns:
            base[col] = 0

    X_scaled = StandardScaler().fit_transform(base[FEATURE_COLS])

    kmeans = KMeans(n_clusters=5, random_state=42, n_init=20, max_iter=500)
    base["cluster_raw"] = kmeans.fit_predict(X_scaled)

    sil = silhouette_score(X_scaled, base["cluster_raw"])
    print(f"  Silhouette Score (k=5): {sil:.4f}")

    return base, X_scaled


def assign_persona(base):
    SALDO_P75      = base["saldo_rata_rata"].quantile(0.75)
    PENDAPATAN_P75 = base["pendapatan_bulanan"].quantile(0.75)

    centroid = base.groupby("cluster_raw")[[
        "usia", "pendapatan_bulanan", "saldo_rata_rata",
        "is_prioritas", "freq_qris", "freq_topup_ewallet",
        "freq_tagihan", "total_investasi_valas",
    ]].mean()

    labels = ["Prioritas", "Pensiunan", "Gen_Z", "Pekerja_Mapan", "Basic"]
    scores = pd.DataFrame(index=centroid.index, columns=labels, data=0.0)

    for c in centroid.index:
        row = centroid.loc[c]
        scores.loc[c, "Prioritas"] = (
            row["is_prioritas"] * 5
            + row["saldo_rata_rata"] / SALDO_P75
            + row["pendapatan_bulanan"] / PENDAPATAN_P75
            + row["total_investasi_valas"] / (base["total_investasi_valas"].max() + 1)
        )
        scores.loc[c, "Pensiunan"] = (
            row["usia"] / base["usia"].max()
            - row["freq_qris"] / (base["freq_qris"].max() + 1) * 0.5
        )
        scores.loc[c, "Basic"] = (
            (1 - row["usia"] / base["usia"].max())
            + row["freq_qris"] / (base["freq_qris"].max() + 1)
            + row["freq_topup_ewallet"] / (base["freq_topup_ewallet"].max() + 1)
        )
        scores.loc[c, "Pekerja_Mapan"] = (
            row["freq_tagihan"] / (base["freq_tagihan"].max() + 1)
            + (1 if 26 <= row["usia"] <= 50 else 0)
            - row["is_prioritas"]
        )
        scores.loc[c, "Gen_Z"] = (
            (1 - row["saldo_rata_rata"] / (base["saldo_rata_rata"].max() + 1))
            + (1 - row["pendapatan_bulanan"] / (base["pendapatan_bulanan"].max() + 1))
            - row["total_investasi_valas"] / (base["total_investasi_valas"].max() + 1)
        )

    cluster_to_persona = {}
    used_labels, used_clusters = set(), set()
    flat = (
        scores.stack().sort_values(ascending=False)
        .reset_index().rename(columns={"level_0": "cluster", "level_1": "persona", 0: "score"})
    )
    for _, r in flat.iterrows():
        c, p = r["cluster"], r["persona"]
        if c not in used_clusters and p not in used_labels:
            cluster_to_persona[c] = p
            used_clusters.add(c); used_labels.add(p)
        if len(cluster_to_persona) == 5:
            break

    base["segmen_persona"] = base["cluster_raw"].map(cluster_to_persona)
    print("  Mapping cluster → persona:")
    for k, v in cluster_to_persona.items():
        print(f"    Cluster {k} → {v}")

    return base


# 5. Upsert ke Supabase
def upsert_segmentasi_persona(base, engine):
    print("Upsert segmentasi_persona...")

    rows = base[["user_id", "cluster_raw", "segmen_persona"] + FEATURE_COLS].copy()

    sql = text("""
        INSERT INTO segmentasi_persona (
            user_id, cluster_raw, segmen_persona,
            usia, pendapatan_bulanan, saldo_rata_rata,
            is_prioritas, mode_sederhana,
            freq_qris, freq_topup_ewallet, freq_transfer,
            freq_tagihan, freq_investasi, freq_tarik_tunai,
            freq_hiburan, freq_valas, total_transaksi,
            avg_nominal, total_investasi_valas,
            rasio_qris, rasio_topup_ewallet, rasio_tagihan,
            rasio_investasi, rasio_hiburan, rasio_valas,
            total_klik, avg_durasi, rasio_klik_beranda,
            klik_investasi_fitur, flag_auto_debet
        ) VALUES (
            :user_id, :cluster_raw, :segmen_persona,
            :usia, :pendapatan_bulanan, :saldo_rata_rata,
            :is_prioritas, :mode_sederhana,
            :freq_qris, :freq_topup_ewallet, :freq_transfer,
            :freq_tagihan, :freq_investasi, :freq_tarik_tunai,
            :freq_hiburan, :freq_valas, :total_transaksi,
            :avg_nominal, :total_investasi_valas,
            :rasio_qris, :rasio_topup_ewallet, :rasio_tagihan,
            :rasio_investasi, :rasio_hiburan, :rasio_valas,
            :total_klik, :avg_durasi, :rasio_klik_beranda,
            :klik_investasi_fitur, :flag_auto_debet
        )
        ON CONFLICT (user_id) DO UPDATE SET
            cluster_raw           = EXCLUDED.cluster_raw,
            segmen_persona        = EXCLUDED.segmen_persona,
            usia                  = EXCLUDED.usia,
            pendapatan_bulanan    = EXCLUDED.pendapatan_bulanan,
            saldo_rata_rata       = EXCLUDED.saldo_rata_rata,
            is_prioritas          = EXCLUDED.is_prioritas,
            mode_sederhana        = EXCLUDED.mode_sederhana,
            freq_qris             = EXCLUDED.freq_qris,
            freq_topup_ewallet    = EXCLUDED.freq_topup_ewallet,
            freq_transfer         = EXCLUDED.freq_transfer,
            freq_tagihan          = EXCLUDED.freq_tagihan,
            freq_investasi        = EXCLUDED.freq_investasi,
            freq_tarik_tunai      = EXCLUDED.freq_tarik_tunai,
            freq_hiburan          = EXCLUDED.freq_hiburan,
            freq_valas            = EXCLUDED.freq_valas,
            total_transaksi       = EXCLUDED.total_transaksi,
            avg_nominal           = EXCLUDED.avg_nominal,
            total_investasi_valas = EXCLUDED.total_investasi_valas,
            rasio_qris            = EXCLUDED.rasio_qris,
            rasio_topup_ewallet   = EXCLUDED.rasio_topup_ewallet,
            rasio_tagihan         = EXCLUDED.rasio_tagihan,
            rasio_investasi       = EXCLUDED.rasio_investasi,
            rasio_hiburan         = EXCLUDED.rasio_hiburan,
            rasio_valas           = EXCLUDED.rasio_valas,
            total_klik            = EXCLUDED.total_klik,
            avg_durasi            = EXCLUDED.avg_durasi,
            rasio_klik_beranda    = EXCLUDED.rasio_klik_beranda,
            klik_investasi_fitur  = EXCLUDED.klik_investasi_fitur,
            flag_auto_debet       = EXCLUDED.flag_auto_debet
    """)

    with engine.begin() as conn:
        conn.execute(sql, rows.to_dict(orient="records"))

    print(f"  {len(rows)} user di-upsert ke segmentasi_persona")


def update_segmen_in_table(base, engine, table_name):
    print(f"Update segmen_persona di tabel {table_name}...")

    sql = text(f"""
        UPDATE {table_name}
        SET segmen_persona = :segmen_persona
        WHERE user_id = :user_id
    """)

    rows = base[["user_id", "segmen_persona"]].to_dict(orient="records")
    with engine.begin() as conn:
        conn.execute(sql, rows)

    print(f"  {len(rows)} baris di-update di {table_name}")


def replace_profil_persona(base, engine):
    print("Update profil_persona...")

    profil_cols = [
        "usia", "pendapatan_bulanan", "saldo_rata_rata",
        "is_prioritas", "mode_sederhana",
        "freq_qris", "freq_topup_ewallet", "freq_transfer",
        "freq_tagihan", "freq_investasi", "freq_tarik_tunai",
        "total_transaksi", "avg_nominal", "total_investasi_valas",
        "total_klik", "avg_durasi",
    ]
    profil_df = base.groupby("segmen_persona")[profil_cols].mean().round(2).reset_index()

    sql = text("""
        INSERT INTO profil_persona (
            segmen_persona,
            usia, pendapatan_bulanan, saldo_rata_rata,
            is_prioritas, mode_sederhana,
            freq_qris, freq_topup_ewallet, freq_transfer,
            freq_tagihan, freq_investasi, freq_tarik_tunai,
            total_transaksi, avg_nominal, total_investasi_valas,
            total_klik, avg_durasi
        ) VALUES (
            :segmen_persona,
            :usia, :pendapatan_bulanan, :saldo_rata_rata,
            :is_prioritas, :mode_sederhana,
            :freq_qris, :freq_topup_ewallet, :freq_transfer,
            :freq_tagihan, :freq_investasi, :freq_tarik_tunai,
            :total_transaksi, :avg_nominal, :total_investasi_valas,
            :total_klik, :avg_durasi
        )
        ON CONFLICT (segmen_persona) DO UPDATE SET
            usia                  = EXCLUDED.usia,
            pendapatan_bulanan    = EXCLUDED.pendapatan_bulanan,
            saldo_rata_rata       = EXCLUDED.saldo_rata_rata,
            is_prioritas          = EXCLUDED.is_prioritas,
            mode_sederhana        = EXCLUDED.mode_sederhana,
            freq_qris             = EXCLUDED.freq_qris,
            freq_topup_ewallet    = EXCLUDED.freq_topup_ewallet,
            freq_transfer         = EXCLUDED.freq_transfer,
            freq_tagihan          = EXCLUDED.freq_tagihan,
            freq_investasi        = EXCLUDED.freq_investasi,
            freq_tarik_tunai      = EXCLUDED.freq_tarik_tunai,
            total_transaksi       = EXCLUDED.total_transaksi,
            avg_nominal           = EXCLUDED.avg_nominal,
            total_investasi_valas = EXCLUDED.total_investasi_valas,
            total_klik            = EXCLUDED.total_klik,
            avg_durasi            = EXCLUDED.avg_durasi
    """)

    with engine.begin() as conn:
        conn.execute(sql, profil_df.to_dict(orient="records"))

    print(f"  profil_persona di-update ({len(profil_df)} persona)")


# 6. Main
def main():
    print("=" * 50)
    print("  WEEKLY CLUSTERING JOB")
    print("=" * 50)

    engine = get_engine()

    users, transactions, clicks, scv = load_data(engine)
    base = build_features(users, transactions, clicks, scv)
    base, _ = run_clustering(base)
    base = assign_persona(base)

    print("\nDistribusi persona:")
    print(base["segmen_persona"].value_counts().to_string())

    upsert_segmentasi_persona(base, engine)
    update_segmen_in_table(base, engine, "users")
    update_segmen_in_table(base, engine, "single_customer_view")
    replace_profil_persona(base, engine)

    print("\nWeekly clustering selesai!")
    print("=" * 50)


if __name__ == "__main__":
    main()
