# SQL_CREDIT_RISK_SCORING
End-to-end SQL project demonstrating credit risk classification, feature engineering, and a scorecard decision model using PostgreSQL


📌 Project Overview

This project utilizes PostgreSQL to analyze a retail loan portfolio and develop a heuristic credit risk classification model. Based on a synthetic dataset of financial profiles, the project aims to demonstrate the application of advanced SQL logic for data cleaning, feature engineering, and the creation of decision rules (Scorecard) directly applicable within a Risk Management department.




🎯 Objectives

- Data Quality: Identify and handle anomalies and extreme outliers in the demographic and income data of applicants to ensure analysis reliability.

- Risk Segmentation: Group applicants into income deciles and risk brackets based on the Debt-to-Income (DTI) ratio to historically calculate the Probability of   Default (PD).

- Decision Engine: Build an end-to-end Credit Scoring system via SQL to classify applications into clusters (from Prime to Reject/High Risk), optimizing automated approvals versus manual review.




📂 Analytical Pipeline Structure
The project is divided into 4 sequential scripts:

01_data_cleaning.sql: Data Preparation phase. Handling null values (e.g., missing interest rates imputed via global averages) and logically removing extreme outliers (e.g., age or employment length anomalies) using VIEWs.

02_feature_engineering.sql: Transformation of continuous variables into discrete business metrics (bucketing). Includes categorization into age brackets, discretization of DTI into risk levels, and creation of binary flags for credit history.

03_risk_segmentation.sql: Calculation of the stratified default rate. Utilizes Window Functions to divide the population into income deciles and isolate risk concentration for each segment.

04_credit_scoring_model.sql: Scorecard development. A points-based model built using nested conditional expressions that assigns penalties based on vulnerability indexes (high DTI, loan intent, lack of home ownership). The model outputs a final rating (Classes A, B, C, D) for each applicant.




📊 Calculated Metrics & KPIs

DTI (Debt-to-Income Ratio)

Default Rate % (segmented by income decile)

Total Risk Score (additive penalty model for rating)




🛠️ Tech Stack & Skills

Database: PostgreSQL 15+

Applied SQL Techniques:

Window Functions (NTILE, partitioned aggregations)

CTEs (Common Table Expressions) and Subqueries

Advanced Conditional Logic (Multiple CASE WHEN statements)

Null values Handling (COALESCE)

Data Type Casting and mathematical aggregations (ROUND, SUM, COUNT)
