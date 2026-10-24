-- 03_risk_segmentation.sql
WITH IncomeDeciles AS (
    SELECT 
        person_income,
        loan_status,
        -- Divide la popolazione in 10 fasce di reddito (Decili)
        NTILE(10) OVER (ORDER BY person_income ASC) AS income_decile
    FROM vw_credit_risk_cleaned
)
SELECT 
    income_decile,
    MIN(person_income) AS min_income,
    MAX(person_income) AS max_income,
    COUNT(*) AS total_loans,
    SUM(loan_status) AS total_defaults,
    -- Calcolo del tasso di insolvenza
    ROUND(SUM(loan_status) * 100.0 / COUNT(*), 2) AS default_rate_pct
FROM 
    IncomeDeciles
GROUP BY 
    income_decile
ORDER BY 
    income_decile;
