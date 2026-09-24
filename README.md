# Telecom Customer Churn Analysis

An end-to-end data analytics project examining customer churn drivers for a telecom provider using Python, PostgreSQL, and Power BI.
---

## Executive Summary
* **Total Customers:** 7,043
* **Overall Churn Rate:** 26.54% (1,869 customers)
* **Monthly Revenue at Risk:** $139.13K
* **Key Churn Driver:** Month-to-month contracts combined with Fiber Optic internet service show the highest churn concentration (54.61%).

---

## Tech Stack & Architecture
* **Data Processing:** Python (Pandas) for cleaning and null-value validation.
* **Database & Querying:** PostgreSQL (Star Schema Dimensional Modeling).
* **Visualization & BI:** Power BI Desktop (DAX Measures, Custom Formatting, Dynamic Slicers).

```text
Raw CSV -> Python EDA & Cleaning -> PostgreSQL Star Schema -> Power BI Data Model -> Executive Dashboard