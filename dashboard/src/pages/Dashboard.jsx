import "../App.css";

import { useEffect, useState } from "react";
import axios from "axios";
import {
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
  XAxis,
  YAxis,
  Tooltip,
  CartesianGrid,
  ResponsiveContainer,
  Legend,
} from "recharts";

import {
  FaUsers,
  FaMousePointer,
  FaChartBar,
  FaShieldAlt,
} from "react-icons/fa";

const COLORS = [
  "#ef4444",
  "#3b82f6",
  "#22c55e",
  "#f59e0b",
  "#8b5cf6",
  "#06b6d4",
  "#ec4899",
  "#14b8a6",
];

export default function Dashboard() {
  const [featureStats, setFeatureStats] = useState([]);
  const [auditLogs, setAuditLogs] = useState([]);
  const [auditUserIdFilter, setAuditUserIdFilter] = useState("");
  const [auditActionFilter, setAuditActionFilter] = useState("ALL");

  const fetchFeatureStats = async () => {
    try {
      const response = await axios.get(
        "http://localhost:3000/api/feature-stats"
      );

      const formattedData = response.data.data.map((item) => ({
        feature: item.feature_name,
        clicks: Number(item.total_clicks),
      }));

      setFeatureStats(formattedData);
    } catch (error) {
      console.error(error);
    }
  };

  const fetchAuditLogs = async () => {
    try {
      const response = await axios.get(
        "http://localhost:3000/api/analytics/audit"
      );

      setAuditLogs(response.data.data);
    } catch (error) {
      console.error(error);
    }
  };

  useEffect(() => {
    Promise.resolve().then(() => {
      fetchFeatureStats();
      fetchAuditLogs();
    });
  }, []);

  const totalClicks = featureStats.reduce(
    (sum, item) => sum + item.clicks,
    0
  );

  const totalAudit = auditLogs.length;

  const totalUsers = new Set(auditLogs.map((log) => log.user_id)).size;

  const filteredAuditLogs = auditLogs.filter((log) => {
    const matchesUserId = String(log.user_id ?? "")
      .toLowerCase()
      .includes(auditUserIdFilter.trim().toLowerCase());

    const matchesAction =
      auditActionFilter === "ALL" || String(log.action) === auditActionFilter;

    return matchesUserId && matchesAction;
  });

  const resetAuditFilters = () => {
    setAuditUserIdFilter("");
    setAuditActionFilter("ALL");
  };

  return (
    <div
      style={{
        background: "#f3f4f6",
        minHeight: "100vh",
        padding: "30px",
        fontFamily: "Arial",
      }}
    >
      {/* HEADER */}
      <div style={{ marginBottom: 30 }}>
        <h1 style={{ margin: 0, fontSize: 80 }}>
          Banking Analytics Dashboard
        </h1>

        <p style={{ color: "#6b7280" }}>
          Monitoring Personalization & User Activity
        </p>
      </div>

      {/* SUMMARY CARDS */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))",
          gap: 20,
          marginBottom: 30,
        }}
      >
        <SummaryCard
          title="Total Clicks"
          value={totalClicks}
          icon={<FaMousePointer />}
          color="#ef4444"
        />

        <SummaryCard
          title="Audit Logs"
          value={totalAudit}
          icon={<FaShieldAlt />}
          color="#3b82f6"
        />

        <SummaryCard
          title="Active Users"
          value={totalUsers}
          icon={<FaUsers />}
          color="#22c55e"
        />

        <SummaryCard
          title="Tracked Features"
          value={featureStats.length}
          icon={<FaChartBar />}
          color="#f59e0b"
        />
      </div>

      {/* CHART SECTION */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "2fr 1fr",
          gap: 20,
          marginBottom: 30,
        }}
      >
        {/* BAR CHART */}
        <div style={cardStyle}>
          <h2 style={{ color: "#111827", marginBottom: 20 }}>Feature Click Statistics</h2>

          <div style={{ width: "100%", height: 400 }}>
            <ResponsiveContainer>
              <BarChart data={featureStats}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="feature" />
                <YAxis />
                <Tooltip />
                <Bar dataKey="clicks">
                  {featureStats.map((entry, index) => (
                    <Cell
                      key={index}
                      fill={COLORS[index % COLORS.length]}
                    />
                  ))}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* PIE CHART */}
        <div style={cardStyle}>
          <h2 style={{ color: "#111827", marginBottom: 20 }}>Feature Distribution</h2>

          <div
            style={{
                width: "100%",
                height: 400,
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
            }}
            >
            <ResponsiveContainer>
              <PieChart>
                <Pie
                    data={featureStats.slice(0, 6)}
                    dataKey="clicks"
                    nameKey="feature"
                    outerRadius={120}
                >
                  {featureStats.map((entry, index) => (
                    <Cell
                      key={index}
                      fill={COLORS[index % COLORS.length]}
                    />
                  ))}
                </Pie>

                <Tooltip />
                <Legend
                    layout="horizontal"
                    verticalAlign="bottom"
                    align="center"
                />
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>

      {/* AUDIT TABLE */}
      <div style={cardStyle}>
        <h2 style={{ color: "#111827", marginBottom: 20 }}>Audit Trail Activity</h2>

        <div className="audit-filter-row">
          <input
            className="audit-filter-control"
            type="text"
            placeholder="Cari User ID..."
            value={auditUserIdFilter}
            onChange={(event) => setAuditUserIdFilter(event.target.value)}
          />

          <select
            className="audit-filter-control"
            value={auditActionFilter}
            onChange={(event) => setAuditActionFilter(event.target.value)}
          >
            <option value="ALL">Semua Aktivitas</option>
            <option value="LOGIN">LOGIN</option>
            <option value="UPDATE_CONSENT">UPDATE_CONSENT</option>
          </select>

          <button
            className="audit-reset-button"
            type="button"
            onClick={resetAuditFilters}
          >
            Reset Filter
          </button>
        </div>

        <p className="audit-result-count">
          Menampilkan {filteredAuditLogs.length} data audit
        </p>

        <div style={{ overflowX: "auto" }}>
          <table
            style={{
              width: "100%",
              borderCollapse: "collapse",
              marginTop: 20,
            }}
          >
            <thead>
              <tr style={{ background: "#e5e7eb" }}>
                <th style={tableHeader}>User ID</th>
                <th style={tableHeader}>Action</th>
                <th style={tableHeader}>Reason</th>
                <th style={tableHeader}>Timestamp</th>
              </tr>
            </thead>

            <tbody>
              {filteredAuditLogs.map((log) => (
                <tr key={log.id}>
                  <td style={tableCell}>{log.user_id}</td>
                  <td style={tableCell}>{log.action}</td>
                  <td style={tableCell}>{log.reason}</td>
                  <td style={tableCell}>
                    {new Date(log.timestamp).toLocaleString()}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

function SummaryCard({ title, value, icon, color }) {
  return (
    <div
      style={{
        background: "#fff",
        borderRadius: 16,
        padding: 20,
        boxShadow: "0 4px 12px rgba(0,0,0,0.08)",
      }}
    >
      <div
        style={{
          width: 50,
          height: 50,
          borderRadius: 12,
          background: color,
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          color: "#fff",
          fontSize: 22,
          marginBottom: 16,
        }}
      >
        {icon}
      </div>

      <h3 style={{ margin: 0, fontSize: 28 }}>{value}</h3>

      <p style={{ marginTop: 8, color: "#6b7280" }}>{title}</p>
    </div>
  );
}

const cardStyle = {
  background: "#fff",
  borderRadius: 16,
  padding: 20,
  boxShadow: "0 4px 12px rgba(0,0,0,0.08)",
};

const tableHeader = {
  padding: 12,
  textAlign: "left",
};

const tableCell = {
  padding: 12,
  borderBottom: "1px solid #e5e7eb",
};
