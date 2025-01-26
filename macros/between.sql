{% test between(model, column_name, min, max) %}
  -- Validar que los valores de la columna estén dentro del rango definido
  with validation as (
      select
          {{ column_name }} as value,
          {{ min }} as min_value,
          {{ max }} as max_value
      from {{ model }}
      where {{ column_name }} not between {{ min }} and {{ max }}
         or {{ column_name }} is null -- Considera valores nulos como fuera del rango
  )
  select *
  from validation
{% endtest %}
