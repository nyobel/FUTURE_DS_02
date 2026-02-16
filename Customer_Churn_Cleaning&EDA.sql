-- ===========================================
-- CLEANING
-- ===========================================
SELECT * FROM customer_churn

-- Check for duplicates or nulls on primary key
SELECT 
	customerID,
	COUNT(*)
FROM customer_churn
GROUP BY customerID
HAVING COUNT(*) > 1 OR customerID IS NULL  -- 0 nulls/duplicates

-- Check for blanks or nulls
SELECT * FROM customer_churn
WHERE TRIM(gender) = '' OR gender IS NULL
OR TRIM(Partner) = '' OR Partner IS NULL
OR TRIM(Dependents) = '' OR Dependents IS NULL
OR TRIM(PhoneService) = '' OR PhoneService IS NULL
OR TRIM(Dependents) = '' OR Dependents IS NULL
OR TRIM(MultipleLines) = '' OR MultipleLines IS NULL
OR TRIM(InternetService) = '' OR InternetService IS NULL
OR TRIM(OnlineSecurity) = '' OR OnlineSecurity IS NULL
OR TRIM(OnlineBackup) = '' OR OnlineBackup IS NULL
OR TRIM(DeviceProtection) = '' OR DeviceProtection IS NULL
OR TRIM(TechSupport) = '' OR TechSupport IS NULL
OR TRIM(StreamingTV) = '' OR StreamingTV IS NULL
OR TRIM(StreamingMovies) = '' OR StreamingMovies IS NULL
OR TRIM(Contract) = '' OR Contract IS NULL
OR TRIM(PaperlessBilling) = '' OR PaperlessBilling IS NULL
OR TRIM(PaymentMethod) = '' OR PaymentMethod IS NULL
OR TRIM(Churn) = '' OR Churn IS NULL   -- 0 blanks/nulls

-- Check for whitespaces
SELECT * FROM customer_churn
WHERE TRIM(gender) != gender
OR TRIM(Partner) != Partner
OR TRIM(Dependents) != Dependents
OR TRIM(PhoneService) != PhoneService
OR TRIM(Dependents) != Dependents
OR TRIM(MultipleLines) != MultipleLines
OR TRIM(InternetService) != InternetService
OR TRIM(OnlineSecurity) != OnlineSecurity
OR TRIM(OnlineBackup) != OnlineBackup
OR TRIM(DeviceProtection) != DeviceProtection
OR TRIM(TechSupport) != TechSupport
OR TRIM(StreamingTV) != StreamingTV
OR TRIM(StreamingMovies) != StreamingMovies
OR TRIM(Contract) != Contract
OR TRIM(PaperlessBilling) != PaperlessBilling
OR TRIM(PaymentMethod) != PaymentMethod
OR TRIM(Churn) != Churn -- 0 whitespaces

-- Check for uniqueness
SELECT DISTINCT gender FROM customer_churn
SELECT DISTINCT SeniorCitizen FROM customer_churn
SELECT DISTINCT Partner FROM customer_churn
SELECT DISTINCT Dependents FROM customer_churn
SELECT DISTINCT PhoneService FROM customer_churn
SELECT DISTINCT MultipleLines FROM customer_churn
SELECT DISTINCT InternetService FROM customer_churn
SELECT DISTINCT OnlineSecurity FROM customer_churn
SELECT DISTINCT OnlineBackup FROM customer_churn
SELECT DISTINCT DeviceProtection FROM customer_churn
SELECT DISTINCT TechSupport FROM customer_churn
SELECT DISTINCT StreamingTV FROM customer_churn
SELECT DISTINCT StreamingMovies FROM customer_churn
SELECT DISTINCT Contract FROM customer_churn
SELECT DISTINCT PaperlessBilling FROM customer_churn
SELECT DISTINCT PaymentMethod FROM customer_churn
SELECT DISTINCT Churn FROM customer_churn -- all columns are standardized


-- ===========================================
-- EDA
-- ===========================================

-- -------------------------
-- 1. Overall churn metrics
-- -------------------------

-- total number of customers

SELECT
    COUNT(customerID) as total_customer,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS stayed_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(10,2)) AS churn_rate_percent
FROM customer_churn -- 7043 total customers, 1869 churned customers, 5174 stayed customers and a churn rate of 26.54%


-- total revenue impact

SELECT DISTINCT 
    COUNT(customerID) as total_customer,
    SUM(MonthlyCharges) AS potential_total_monthly_revenue,
    SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) AS monthly_revenue_lost,
    SUM(TotalCharges) AS potential_total_revenue,
    SUM(CASE WHEN Churn = 'Yes' THEN TotalCharges ELSE 0 END) AS total_revenue_lost
FROM customer_churn  -- 139K in revenue is lost monthly and a total revenue of 2.8M


-- customer lifespan value

SELECT 
    Churn,
    COUNT(*) AS total_customers,
    AVG(tenure) AS avg_tenure_in_months,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(AVG(TotalCharges), 2) AS avg_total_charges
FROM customer_churn
GROUP BY Churn -- an average of $74 and $1531 is lost in monthly_charges and total_charges respectively

-- -------------------------
-- 2. Churn by gender
-- -------------------------
SELECT DISTINCT
    gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(10,2)) AS churn_rate_percent
FROM customer_churn
GROUP BY gender
ORDER BY churn_rate_percent DESC  -- churn rate distribution is evenly distributed females(26.92%) and males(26.16%)

-- -------------------------
-- 3. Churn by SeniorCitizen
-- -------------------------
SELECT DISTINCT
    CASE WHEN SeniorCitizen = 1 THEN 'Yes' ELSE 'No' END AS SeniorCitizen,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(10,2)) AS churn_rate_percent
FROM customer_churn
GROUP BY SeniorCitizen
ORDER BY churn_rate_percent DESC    -- senior citizens are likely to churn with a rate of 42%

-- -------------------------
-- 3. Churn by contract type
-- -------------------------
SELECT DISTINCT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(10,2)) AS churn_rate_percent
FROM customer_churn
GROUP BY Contract
ORDER BY churn_rate_percent DESC    -- month-to-month contracts  hold the highest churn rate of 43%

-- -------------------------
-- 4. Churn by tenure segments (0-12, 13-24, 25-48, 49+ months)
-- -------------------------
WITH tenure_segmented AS
(
    SELECT 
        *,
        CASE 
            WHEN tenure <= 12 THEN '0-12 months (New)'
            WHEN tenure <= 24 THEN '13-24 months'
            WHEN tenure <= 48 THEN '25-48 months'
            ELSE '49+ months (Loyal)'
        END AS tenure_segments
    FROM customer_churn
)   

SELECT
    tenure_segments,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(10,2)) AS churn_rate_percent
FROM tenure_segmented
GROUP BY tenure_segments
ORDER BY churn_rate_percent DESC  -- new customers have the highest churn rate of 47%

-- -------------------------
-- 5. Churn by monthly charges quartiles
-- -------------------------
WITH charge_quartiles AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY MonthlyCharges) as price_tier
    FROM customer_churn
)
SELECT 
    CASE 
        WHEN price_tier = 1 THEN 'Low ($0-25)'
        WHEN price_tier = 2 THEN 'Medium-Low ($25-50)'
        WHEN price_tier = 3 THEN 'Medium-High ($50-75)'
        ELSE 'High ($75+)'
    END as price_segment,
    COUNT(*) as total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as churn_rate_percent
FROM charge_quartiles
GROUP BY price_tier
ORDER BY price_tier desc -- Medium-High ($50-75) proce tier has the highest churn rate of 37% followed by High($75+) with a rate of 33%

-- 6. Service adoption vs. churn
SELECT
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(10,2)) AS churn_rate_percent,
    ROUND(AVG(MonthlyCharges), 2) as avg_monthly_charges
FROM customer_churn
GROUP BY InternetService
ORDER BY churn_rate_percent DESC    -- fibre optic has the highest churn rate of 42%

-- -------------------------
-- 7. Payment method impact
-- -------------------------
SELECT
    PaymentMethod,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(10,2)) AS churn_rate_percent
FROM customer_churn
GROUP BY PaymentMethod
ORDER BY churn_rate_percent DESC    --electronic check has the highest churn rate of 45%

-- -------------------------
-- 8. Impact of tech support on churn rate
-- -------------------------
SELECT
    TechSupport,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    CAST(ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS DECIMAL(10,2)) AS churn_rate_percent
FROM customer_churn
GROUP BY TechSupport
ORDER BY churn_rate_percent DESC   -- no tech support has the highest churn rate of 42%     