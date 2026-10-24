-- 01_data_cleaning.sql
-- Creation of a view with cleaned data
CREATE OR REPLACE VIEW vw_credit_risk_cleaned AS
SELECT 
    *,
    -- Handling null values: replacing with 0 or the global average
    COALESCE(person_emp_length, 0) AS person_emp_length_clean,
    COALESCE(loan_int_rate, 
             (SELECT AVG(loan_int_rate) FROM credit_risk_dataset WHERE loan_int_rate IS NOT NULL)
            ) AS loan_int_rate_clean
FROM 
    credit_risk_dataset
WHERE 
    -- Removal of extreme outliers
    person_age < 100 
    AND person_emp_length < 60;


-- 02_feature_engineering.sql
SELECT 
    person_age,
    person_income,
    loan_amnt,
    loan_status, -- 1 = Default, 0 = Non-Default
    
    -- Age Segmentation
    CASE 
        WHEN person_age BETWEEN 18 AND 25 THEN '1. Gen Z (18-25)'
        WHEN person_age BETWEEN 26 AND 35 THEN '2. Millennials (26-35)'
        WHEN person_age BETWEEN 36 AND 50 THEN '3. Gen X (36-50)'
        ELSE '4. Boomers (50+)' 
    END AS age_bracket,

    -- Debt-to-Income Ratio (DTI)
    -- Crucial metric for Credit Risk Analysis
    CASE 
        WHEN loan_percent_income <= 0.10 THEN 'Low Risk (<=10%)'
        WHEN loan_percent_income > 0.10 AND loan_percent_income <= 0.25 THEN 'Medium Risk (11-25%)'
        WHEN loan_percent_income > 0.25 AND loan_percent_income <= 0.40 THEN 'High Risk (26-40%)'
        ELSE 'Critical (>40%)'
    END AS dti_category,

    -- Credit History Flag
    CASE 
        WHEN cb_person_default_on_file = 'Y' THEN 1 
        ELSE 0 
    END AS historic_default_flag

FROM vw_credit_risk_cleaned;



-- 03_risk_segmentation.sql
WITH IncomeDeciles AS (
    SELECT 
        person_income,
        loan_status,
        -- Divides the population into 10 income brackets (Deciles)
        NTILE(10) OVER (ORDER BY person_income ASC) AS income_decile
    FROM vw_credit_risk_cleaned
)
SELECT 
    income_decile,
    MIN(person_income) AS min_income,
    MAX(person_income) AS max_income,
    COUNT(*) AS total_loans,
    SUM(loan_status) AS total_defaults,
    -- Calculation of the default rate
    ROUND(SUM(loan_status) * 100.0 / COUNT(*), 2) AS default_rate_pct
FROM 
    IncomeDeciles
GROUP BY 
    income_decile
ORDER BY 
    income_decile;



-- 04_credit_scoring_model.sql
WITH RiskScoring AS (
    SELECT 
        *,
        -- Assignment of risk points based on features (higher score = higher risk)
        (
            CASE WHEN loan_percent_income > 0.35 THEN 30 
                 WHEN loan_percent_income > 0.20 THEN 15 ELSE 0 END +
                 
            CASE WHEN cb_person_default_on_file = 'Y' THEN 40 ELSE 0 END +
            
            CASE WHEN loan_intent IN ('MEDICAL', 'VENTURE') THEN 10 
                 WHEN loan_intent IN ('DEBTCONSOLIDATION') THEN 20 ELSE 0 END +
                 
            CASE WHEN person_home_ownership = 'RENT' THEN 10 ELSE 0 END
        ) AS total_risk_score
    FROM vw_credit_risk_cleaned
)
SELECT 
    person_income,
    loan_amnt,
    loan_percent_income,
    total_risk_score,
    -- Final classification using CASE WHEN
    CASE 
        WHEN total_risk_score >= 60 THEN 'Class D - Reject / High Risk'
        WHEN total_risk_score >= 40 THEN 'Class C - Approve with Increased Rate'
        WHEN total_risk_score >= 20 THEN 'Class B - Moderate Risk'
        ELSE 'Class A - Low Risk / Prime'
    END AS risk_classification,
    loan_status AS actual_default
FROM 
    RiskScoring
ORDER BY 
    total_risk_score DESC;
