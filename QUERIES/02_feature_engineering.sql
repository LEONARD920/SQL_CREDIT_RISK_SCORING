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
