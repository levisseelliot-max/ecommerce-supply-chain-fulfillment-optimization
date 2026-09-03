# 📦 International E-Commerce Supply Chain & Fulfillment Optimization
### *End-to-End Analytics Pipeline, Predictive Risk Modeling & $151k/yr Margin Recovery Strategy*

![Python](https://img.shields.io/badge/Python-3.10%2B%20%7C%20SciPy%20%26%20Pandas-3776AB?style=flat&logo=python&logoColor=white)
![SQL BigQuery](https://img.shields.io/badge/Data%20Warehouse-Google%20BigQuery-blue)
![Data Modeling](https://img.shields.io/badge/Modeling-Star%20Schema%20%7C%20Kimball-orange)
![Tableau](https://img.shields.io/badge/Dashboard-Tableau%20Desktop-teal)
![Business Impact](https://img.shields.io/badge/ROI-332%25%20Year%201-green)

---

## 🎯 Executive Overview & Business Case

Between 2016 and 2018, the marketplace scaled commercial operations to **$13.22M in GMV** across **96,469 orders**. However, fulfillment network fragmentation suppressed baseline **On-Time In-Full (OTIF)** performance to **92.15%**, triggering **$246,350 in cumulative P&L leakage** across carrier SLA penalties and customer churn exposure.

This project delivers an enterprise-grade analytics pipeline—from raw data extraction in BigQuery SQL to an executive Tableau suite—diagnosing systemic freight bottlenecks and modeling a targeted operational turnaround.
<p align="center">
  <img width="500" height="400" alt="Screenshot 2026-08-26 at 11 55 21" src="https://github.com/user-attachments/assets/b4b56297-133e-464a-9096-31bf5ec20905" />
</p>


---

## 🛠️ Architecture & Technology Stack

[Raw Olist Source Data](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?resource=download&select=product_category_name_translation.csv) → (BigQuery SQL CTEs & Window Functions)→ FACT_fulfillment_orders


Fast-Query Tableau Extract Engine → [ Executive 3-Tab Tableau ] → C-Level Decision Memorandum (A3 Briefing)

* **Data Warehouse & ETL:** Google BigQuery (Standard SQL, Window Functions, RegEx, Partitioning)
* **Data Modeling & Scientific Computing (Python):**
  * Vectorized statistical demand fitting using `Pandas` and `NumPy`.
  * Inverse cumulative normal distribution modeling (`scipy.stats.norm.ppf`) to compute exact Z-factors for 98.0%, 92.0%, and 85.0% Cycle Service Levels ($CSL$).
  * Stochastic lead-time simulation engine generating sensitivity analysis curves across 0% to 100% lead-time compression scenarios.
* **Dimensional Modeling:** Star Schema (Kimball methodology), Conformed Dimensions, Fact Tables
* **Business Intelligence:** Tableau Desktop & Cloud (Dual-axis charts, Heatmaps, Scatter matrices, Dynamic Parameters)
* **Financial Modeling:** Unit-economic SLA penalty attribution & churn risk proxies

---

## 🔍 Root Cause Diagnostic & Core Insights

<p align="center">
<img width="465" height="243" alt="Screenshot 2026-08-26 at 19 31 03" src="https://github.com/user-attachments/assets/df321a24-a886-4c3f-96b4-54c300d67b0f" />



1. **Carrier vs. Merchant Latency:** Seller dispatch discipline is stable nationwide (~3.2 days). The failure is **100% carrier-driven**, with inter-state transit times surging by **+148% (4.72d to 11.69d)**.
2. **Inter-State Exposure:** Inter-State orders represent **64.2% of volume (61,894 orders)** and **$9.09M GMV**, but drive **$185,735 (75.4%) of network-wide P&L risk**.
3. **São Paulo (SP) Centralization Fracture:** Over 70% of inventory originates in SP. Deliveries to the North/Northeast face severe delays: **Roraima (26.4d)**, **Amapá (25.5d)**, **Amazonas (23.3d)**, and **Alagoas (21.2d)**.
4. **Merchant Risk Concentration:** The single largest financial risk contributor (`4a3ca931...`, 1,772 orders) operates at an uncompliant **89.02% OTIF**, generating **$6,260 in direct financial leakage**.

---

## 📊 Tableau BI Suite Walkthrough

### Tab 1: Executive Fulfillment Overview
<img width="961" height="554" alt="Screenshot 2026-08-26 at 19 33 59" src="https://github.com/user-attachments/assets/7d24bf94-2322-4c0f-8276-bfe8d3df28bb" />

* **KPI Scorecards (BANs):** Real-time monitoring of GMV ($13.22M), Order Volume (96,469), Baseline OTIF (92.15%), and P&L at Risk ($246.35k).
* **Dual-Axis Temporal Trend:** Correlates monthly order surges against OTIF degradation and margin loss spikes during peak trading windows.

### Tab 2: Logistics Bottlenecks & Corridor Analysis
<img width="937" height="544" alt="Screenshot 2026-08-26 at 19 34 35" src="https://github.com/user-attachments/assets/16f0701e-e09d-40e7-8119-35356be68c63" />

* **Lead Time Stage Decomposition:** Horizontal bar analysis isolating seller processing vs. carrier transit across corridor tiers.
* **Origin-to-Destination Heatmap:** Cross-state latency matrix pinpointing chronic transit failures on lanes departing São Paulo.

### Tab 3: Partner Performance & Risk Matrix
<img width="929" height="515" alt="Screenshot 2026-08-26 at 19 34 52" src="https://github.com/user-attachments/assets/96170fc4-8dfa-471c-b1a0-75e90601404f" />

* **Volume vs. Reliability Scatter Plot:** 4-quadrant merchant categorization with a 90.0% OTIF SLA reference line.
* **Top 14 High-Risk Sellers Ledger:** Actionable target list ranking chronic underperformers by financial risk exposure.

---

## 📁 Repository Structure

```text
├── sql/
│   ├── 01_raw_schema_setup.sql          # Table DDL & BigQuery ingestion schemas
│   ├── 02_lead_time_transformation.sql  # Staging transformations & timestamp delta logic
│   └── 03_fact_fulfillment_orders.sql   # Production-ready Star Schema Fact Table
│── python/
│   ├── requirements.txt                      # Dependencies (pandas, numpy, scipy, bigquery)
│   └── inventory_simulation_engine.py        # Stochastic simulation, Z-Score & Monte Carlo models
├── docs/
│   ├── Executive_Memorandum_A3.pdf      # C-Suite Strategy & Investment Memo
│   ├── Visual_Action_Plan.png           # Transformation architecture infographic
│   └── KPIs_Dictionary.md               # Business logic & metric definitions
├── tableau/
│   └── Olist_Supply_Chain_Suite.twbx    # Packaged Tableau Workbook (3 Executive Tabs)
└── README.md                            # Comprehensive project documentation
```

## 🚀 Strategic Recommendations & Financial Payback

| Pillar       | Strategic Lever        | Operational Mechanism                                                                              |   Net Financial Impact |
| ------------ | ---------------------- | -------------------------------------------------------------------------------------------------- | ---------------------: |
| **Pillar 1** | **Forward 3PL Hubs**   | Deploy forward nodes in **Recife (PE)** and **Salvador (BA)** for the top 20% of SKUs              | **+$68,000 preserved** |
| **Pillar 2** | **Dynamic Allocation** | Multi-carrier performance-based routing with automated SLA clawbacks                               | **+$48,350 recovered** |
| **Pillar 3** | **Seller Remediation** | 48-hour dispatch alerts, Buy Box boosts for sellers achieving **≥95% OTIF**, and volume throttling | **+$35,000 recovered** |

### 💰 Financial Summary

| Metric                                    |          Value |
| ----------------------------------------- | -------------: |
| **Initial Setup & API Integration CapEx** |    **$35,000** |
| **Annualized Gross Recovery**             |   **$193,350** |
| **Net Annualized Margin Preserved**       |   **$151,350** |
| **First-Year ROI**                        |       **332%** |
| **Capital Payback Period**                | **2.8 months** |

> **Key takeaway:** The proposed initiatives require an initial **$35,000 CapEx** and are expected to preserve or recover **$193,350 in annual gross value**, resulting in a **$151,350 net annualized margin impact** and a **332% first-year ROI**. The estimated capital payback period is only **2.8 months**.

## 👤 Author & Contact

**Elliot Levisse** — *Supply Chain & Operations Analytics Specialist*

Specialized in **analytics pipelines, fulfillment modeling, and operational turnaround** for global e-commerce.

* **LinkedIn:** [linkedin.com/in/elliot-levisse](https://www.linkedin.com/in/elliot-levisse)
* **Portfolio Hub:** [github.com/elliotlevisse-max](https://github.com/elliotlevisse-max)
