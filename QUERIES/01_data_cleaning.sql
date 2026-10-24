-- 01_data_cleaning.sql
-- Creazione di una vista o CTE con dati ripuliti
CREATE OR REPLACE VIEW vw_credit_risk_cleaned AS
SELECT 
    *,
    -- Gestione dei valori nulli: sostituzione con la media o 0
    COALESCE(person_emp_length, 0) AS person_emp_length_clean,
    COALESCE(loan_int_rate, 
             (SELECT AVG(loan_int_rate) FROM credit_risk_dataset WHERE loan_int_rate IS NOT NULL)
            ) AS loan_int_rate_clean
FROM 
    credit_risk_dataset
WHERE 
    -- Rimozione degli outlier estremi
    person_age < 100 
    AND person_emp_length < 60;
