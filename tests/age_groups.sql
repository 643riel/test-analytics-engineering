SELECT age, age_group
FROM `bank-marketing-project-448216.dbt_gabriel.staging_bank_marketing`
WHERE 
  (age < 18 AND age_group != 'unknown') OR
  (age BETWEEN 18 AND 25 AND age_group != '18-25') OR
  (age BETWEEN 26 AND 35 AND age_group != '26-35') OR
  (age BETWEEN 36 AND 50 AND age_group != '36-50') OR
  (age > 50 AND age_group != '50+')
