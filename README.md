# 📞 Telecom Customer Churn Analysis

A comprehensive SQL Server data analysis project examining customer retention patterns in a telecommunications company. Built to identify churn risk factors, quantify revenue impact, and develop targeted retention strategies through systematic data cleaning and analysis.

## 🎯 Project Overview

This project transforms 7,043 customer records into actionable retention insights across four key dimensions:
- **Contract Analysis**: Churn patterns by commitment level and their revenue implications
- **Service Portfolio**: Internet service impact on retention and customer satisfaction
- **Customer Demographics**: Senior citizen behavior and tenure relationship to churn
- **Data Quality**: Systematic handling of missing data and type mismatches

**Key Finding**: Electronic check users show 45.29% churn—3x higher than automatic payment methods (15-17%)—while fiber optic customers churn at 41.89% despite premium pricing. Month-to-month contracts drive 87% of monthly revenue loss ($120.85K of $139.13K total).

---

## 📈 Dashboard Pages

### 1️⃣ Overview Dashboard
**Purpose**: Executive summary with headline KPIs and churn patterns

**Key Metrics**:
- Total Customers: 7,043
- Churned Customers: 1,869
- Churn Rate: 26.54%
- Monthly Revenue Lost: $139.13K

**Critical Insights**:
- Month-to-month contracts account for 1,655 churned customers vs. just 48 from two-year contracts
- **Fiber optic drives 41.89% churn rate**—highest across all internet services (DSL at 18.96%, No service at 7.40%)
- New customers (0-12 months) show **47.44% churn**, dropping to 9.51% for loyal customers (49+ months)
- Month-to-month contracts represent $120.85K of the $139.13K monthly revenue lost (87%)
- Tenure inversely correlates with churn: 28.71% at 13-24 months, 20.39% at 25-48 months

### 2️⃣ Payment & Service Analysis
**Purpose**: Identify behavioral and service adoption patterns influencing retention

**Churn by Payment Method**:
- Electronic check: **45.29% churn** (highest risk payment type)
- Mailed check: 19.11% churn
- Bank transfer (automatic): 16.71% churn
- Credit card (automatic): 15.24% churn (lowest)

**Churn by Tech Support Adoption**:
- No tech support: 41.64% churn (representing 64.85% of total base)
- Yes tech support: 15.17% churn (23.62% of base)
- No internet service: 7.40% churn (11.53% of base)

---

## 🛠️ Technical Implementation

**Tools Used**: 
- **Database**: Microsoft SQL Server
- **Cleaning & Analysis**: SQL
- **Validation**: Systematic data quality checks and constraint enforcement
- **Dashboard Reporting**: Power BI

---

## 📁 Repository Structure
```

├── Dashboard Screenshots/
├── Customer Churn Dashboard.pbix
├── Customer_Churn_Cleaning&EDA.sql
├── WA_Fn-UseC_-Telco-Customer-Churn.csv
└── README.md

```
---

## 👤 Author

**Crystal Achieng**
- LinkedIn: www.linkedin.com/in/crystalachieng

---

