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
