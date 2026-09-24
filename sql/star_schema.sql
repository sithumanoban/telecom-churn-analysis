CREATE DATABASE IF NOT EXISTS telco_db;
USE telco_db;

SELECT * FROM raw_telco_churn;

DROP TABLE IF EXISTS fact_churn;
DROP TABLE IF EXISTS dim_services;
DROP TABLE IF EXISTS dim_contracts;
DROP TABLE IF EXISTS dim_customers;

# Customers Table
CREATE TABLE dim_customers
(
	customer_id VARCHAR(50),
    gender VARCHAR(20),
    senior_citizen INT,
    partner VARCHAR(10),
    dependents VARCHAR(10),
PRIMARY KEY (customer_id)
);

# Services Table
CREATE TABLE dim_services
(
	customer_id VARCHAR(50),
    phone_service VARCHAR(20),
    multiple_lines VARCHAR(20),
    internet_service VARCHAR(20),
    online_security VARCHAR(20),
    online_backup VARCHAR(20),
    device_protection VARCHAR(20),
    tech_support VARCHAR(20),
    streaming_tv VARCHAR(20),
    streaming_movies VARCHAR(20),
PRIMARY KEY (customer_id),
FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id) ON DELETE CASCADE
);

# Contracts Table
CREATE TABLE dim_contracts
(
	customer_id VARCHAR(50),
    contract_type VARCHAR(50),
    paperless_billing VARCHAR(10),
    payment_method VARCHAR(50),
PRIMARY KEY (customer_id),
FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id) ON DELETE CASCADE
);

# Fact Churn Table
CREATE TABLE fact_churn
(
	customer_id VARCHAR(50),
    tenure INT,
    monthly_charges DECIMAL(7,2),
    total_charges DECIMAL(10,2),
    churn VARCHAR(10),
PRIMARY KEY (customer_id),
FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id) ON DELETE CASCADE
);

# insert data into dim_customers
INSERT INTO dim_customers (customer_id, gender, senior_citizen, partner, dependents)
SELECT customerID, gender, SeniorCitizen, Partner, Dependents
FROM raw_telco_churn;

# insert data into dim_services
INSERT INTO dim_services (customer_id, phone_service, multiple_lines, internet_service, online_security, online_backup, device_protection, tech_support, streaming_tv, streaming_movies)
SELECT customerID, PhoneService, MultipleLines, InternetService, OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies
FROM raw_telco_churn;

# insert data into dim_contracts
INSERT INTO dim_contracts (customer_id, contract_type, paperless_billing, payment_method)
SELECT customerID, Contract, PaperlessBilling, PaymentMethod
FROM raw_telco_churn;

# insert data into fact_churn
INSERT INTO fact_churn (customer_id, tenure, monthly_charges, total_charges, churn)
SELECT customerID, tenure, MonthlyCharges, TotalCharges, Churn
FROM raw_telco_churn;

SELECT COUNT(*) AS raw_rows
FROM raw_telco_churn;

SELECT COUNT(*) AS customer_rows
FROM dim_customers;

SELECT COUNT(*) AS service_rows
FROM dim_services;

SELECT COUNT(*) AS contract_rows
FROM dim_contracts;

SELECT COUNT(*) AS fact_rows
FROM fact_churn;

SELECT customer_id, COUNT(*) AS count
FROM dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT customer_id, COUNT(*) AS count
FROM fact_churn
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS unmatched_customers
FROM fact_churn f
LEFT JOIN dim_customers c
	ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS unmatched_services
FROM dim_services s
LEFT JOIN dim_customers c
	ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS unmatched_contracts
FROM dim_contracts d
LEFT JOIN dim_customers c
	ON d.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT
    c.customer_id,
    c.gender,
    c.partner,
    s.internet_service,
    d.contract_type,
    d.payment_method,
    f.tenure,
    f.monthly_charges,
    f.total_charges,
    f.churn
FROM dim_customers c
JOIN dim_services s
    ON c.customer_id = s.customer_id
JOIN dim_contracts d
    ON c.customer_id = d.customer_id
JOIN fact_churn f
    ON c.customer_id = f.customer_id
LIMIT 10;

SELECT
	COUNT(*) AS total_customers,
    SUM(CASE WHEN churn="Yes" THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
		100 * SUM(CASE WHEN churn="Yes" THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS churn_rate
FROM fact_churn;


































