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
