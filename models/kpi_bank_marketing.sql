with
    -- Resumen general de la campaña: calcula contactos totales, contactos exitosos y la tasa de conversión general.
    campaign_summary as (
        select
            'Overall' as segment,
            count(*) as total_contacts,
            sum(case when y = true then 1 else 0 end) as successful_contacts,
            avg(case when y = true then 1.0 else 0 end) * 100 as conversion_rate_percentage
        from {{ ref("staging_bank_marketing") }} 
    ),

    -- Resumen por grupos de edad: calcula métricas para cada segmento de edad.
    age_group_summary as (
        select
            age_group as segment,
            count(*) as total_contacts,
            sum(case when y = true then 1 else 0 end) as successful_contacts,
            avg(case when y = true then 1.0 else 0 end) * 100 as conversion_rate_percentage
        from {{ ref("staging_bank_marketing") }}
        group by age_group
    ),

    -- Resumen por tipo de ocupación: calcula métricas para cada segmento de ocupación.
    job_summary as (
        select
            job_normalized as segment,
            count(*) as total_contacts,
            sum(case when y = true then 1 else 0 end) as successful_contacts,
            avg(case when y = true then 1.0 else 0 end) * 100 as conversion_rate_percentage
        from {{ ref("staging_bank_marketing") }}
        group by job_normalized
    )

-- Unión de todos los segmentos en una única tabla de resultados.
select * from campaign_summary
union all
select * from age_group_summary
union all
select * from job_summary
