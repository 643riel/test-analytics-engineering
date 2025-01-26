select
    age as value,
    16 as min_value,
    100 as max_value
from `bank-marketing-project-448216`.`dbt_gabriel`.`staging_bank_marketing`
where age not between 16 and 100
    or age is null
    -- Hay 5 registros con 17.