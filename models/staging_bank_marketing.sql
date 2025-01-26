with
    raw_data as (
        select
            *,
            -- Normalización de valores categóricos
            lower(job) as job_normalized,
            lower(marital) as marital_normalized,
            lower(education) as education_normalized,
            case
                when `default` = 'unknown' then null else lower(`default`)
            end as has_default,
            case
                when housing = 'unknown' then null else lower(housing)
            end as has_housing,
            case when loan = 'unknown' then null else lower(loan) end as has_loan,

            -- Fecha unificada ficticia
            case
                when
                    lower(month) in (
                        'jan',
                        'feb',
                        'mar',
                        'apr',
                        'may',
                        'jun',
                        'jul',
                        'aug',
                        'sep',
                        'oct',
                        'nov',
                        'dec'
                    )
                    and lower(day_of_week)
                    in ('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun')
                then
                    date(
                        2024,
                        case
                            when lower(month) = 'jan'
                            then 1
                            when lower(month) = 'feb'
                            then 2
                            when lower(month) = 'mar'
                            then 3
                            when lower(month) = 'apr'
                            then 4
                            when lower(month) = 'may'
                            then 5
                            when lower(month) = 'jun'
                            then 6
                            when lower(month) = 'jul'
                            then 7
                            when lower(month) = 'aug'
                            then 8
                            when lower(month) = 'sep'
                            then 9
                            when lower(month) = 'oct'
                            then 10
                            when lower(month) = 'nov'
                            then 11
                            when lower(month) = 'dec'
                            then 12
                        end,
                        -- Esto no es simplemente para un ejemplo para el ejercicio,
                        -- ya que no es del todo correcto
                        -- ya de por sí es raro que el dataset tenga sólo campos de
                        -- mes y de día en string
                        case
                            when lower(day_of_week) = 'mon'
                            then 1
                            when lower(day_of_week) = 'tue'
                            then 2
                            when lower(day_of_week) = 'wed'
                            then 3
                            when lower(day_of_week) = 'thu'
                            then 4
                            when lower(day_of_week) = 'fri'
                            then 5
                            when lower(day_of_week) = 'sat'
                            then 6
                            when lower(day_of_week) = 'sun'
                            then 7
                            else null
                        end
                    )
                else null
            end as last_contact_date,

            -- Segmentación por edad
            case
                when age between 18 and 25
                then '18-25'
                when age between 26 and 35
                then '26-35'
                when age between 36 and 50
                then '36-50'
                when age > 50
                then '50+'
                else 'unknown'
            end as age_group,

            -- Indicador de contactos previos
            case when pdays != 999 then true else false end as has_previous_contact
            
        from {{ source('bank_marketing', 'raw_bank_marketing') }}
        where duration > 0  -- Filtrar registros irrelevantes
    )
select
    row_number() over (order by last_contact_date, age) as client_id,
    -- acá genero un id para poder tener una PK, es raro que en el dataset no haya

    -- Si fuera un caso real, para generar un id, podría usar: 
    -- dbt_utils.generate_surrogate_key(array[cast(columna as string), cast(columna2 as string) ... ]) as client_id
    *,
    -- Duración normalizada a minutos
    duration / 60 as contact_duration_minutes,

    -- Frecuencia de contacto durante la campaña
    case
        when campaign = 1
        then 'single'
        when campaign between 2 and 3
        then 'few'
        when campaign > 3
        then 'frequent'
    end as contact_frequency,

    -- Indicador de éxito en la campaña previa
    case
        when lower(poutcome) = 'success' then true else false
    end as previous_campaign_success
from raw_data
