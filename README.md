---

# Ejercicio Práctico para Analytics Engineering

Debe realizar un fork de este repositorio para desarrollar y entregar su trabajo.

Si está interesado en aplicar al test, puede enviar un correo a jgarcial@deacero.com.

## Ejercicio DBT

Este ejercicio utiliza datos de una campaña de marketing por correo electrónico disponibles en el [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/222/bank+marketing). Los datos contienen información sobre diversas campañas de marketing directo de una institución bancaria.

**Objetivo del Ejercicio:**

El objetivo es evaluar el dominio de la herramienta DBT (Data Build Tool) del candidato, su capacidad para incorporar pruebas unitarias, mantener la calidad de los datos y desplegar modelos de datos en BigQuery. El objetivo de negocio es crear un Data Mart que permita al equipo de marketing analizar la efectividad de sus campañas, enfocándose en KPIs como la tasa de conversión, el número de contactos exitosos y la segmentación de clientes.

### Instrucciones del Ejercicio:

1. **Configuración del Proyecto DBT:**
    - Crea un nuevo proyecto de DBT.
    - Conéctalo a BigQuery. Asegúrate de configurar correctamente las credenciales y el dataset de destino.
    
2. **Obtención de Datos:**
    - Descarga los datos del [Bank Marketing dataset](https://archive.ics.uci.edu/dataset/222/bank+marketing).
    - Carga los datos en una tabla en BigQuery llamada `raw_bank_marketing`.

3. **Modelado:**
    - Crea un modelo `staging_bank_marketing.sql` para transformar los datos iniciales utilizando CTEs (Common Table Expressions). Este modelo debe realizar las siguientes tareas:
        - Limpiar y normalizar los datos.
        - Filtrar registros irrelevantes.
        - Crear nuevas columnas necesarias para el análisis.
        
    - Crea un modelo `kpi_bank_marketing.sql` para agregar los KPIs de marketing utilizando CTEs. Este modelo debe calcular:
        - Tasa de conversión: porcentaje de contactos exitosos sobre el total de contactos.
        - Número de contactos exitosos: total de conversiones logradas.
        - Segmentación de clientes: clasificación de clientes basada en criterios relevantes como edad, ocupación, etc.
       
4. **Pruebas Unitarias:**
    - Agrega pruebas unitarias en el archivo `schema.yml` para asegurar la integridad de los datos. Incluye pruebas para:
        - Validar tipos de datos.
        - Comprobar valores nulos.
        - Verificar rangos y unicidad de campos clave.
    
5. **Despliegue y Calidad:**
    - Configura un pipeline CI/CD para desplegar los modelos DBT usando herramientas como GitHub Actions o GitLab CI. Asegúrate de incluir pasos para:
        - Validación de código.
        - Ejecución de pruebas unitarias.
        - Despliegue en BigQuery.
    - Configura alertas para pruebas fallidas y realiza auditorías periódicas de calidad de datos. Considera el uso de herramientas como dbt tests, Great Expectations, o similares para automatizar estas auditorías.

### Entrega del Ejercicio

- Suba su proyecto a un repositorio de GitHub y comparta el enlace en un correo dirigido a jgarcial@deacero.com.
- Asegúrese de que el repositorio incluya:
    - Todo el código fuente del proyecto DBT.
    - Documentación que explique el proceso seguido, las decisiones tomadas y cómo ejecutar el proyecto.
    - Instrucciones claras sobre cómo configurar y ejecutar el pipeline CI/CD.

### Criterios de Evaluación

- **Exactitud y eficacia del modelo:** ¿Los modelos transforman y agregan los datos de manera correcta y eficiente?
- **Calidad del código:** ¿El código es claro, bien documentado y sigue buenas prácticas?
- **Implementación de pruebas unitarias:** ¿Las pruebas unitarias son exhaustivas y cubren los casos relevantes?
- **Despliegue y automatización:** ¿El pipeline CI/CD está correctamente configurado y automatiza el proceso de despliegue y pruebas?

¡Suerte a todos! 

------------------------------------------------------------
# Bank Marketing Analysis Project

## Descripción
Este proyecto tiene como objetivo analizar los datos de una campaña de marketing bancario utilizando modelos de DBT (Data Build Tool). Se realizan tareas de limpieza, normalización y cálculo de indicadores clave de rendimiento (KPIs) para evaluar la efectividad de la campaña.

## Estructura del Proyecto

### Modelos

#### 1. **staging_bank_marketing**
Modelo de staging encargado de:
- Limpiar y normalizar los datos provenientes del dataset.
- Generar nuevas columnas calculadas, como:
  - **job_normalized, marital_normalized, education_normalized**: Valores categóricos normalizados a minúsculas.
  - **has_default, has_housing, has_loan**: Indicadores booleanos con valores desconocidos reemplazados por `NULL`.
  - **last_contact_date**: Fecha ficticia unificada basada en los campos `month` y `day_of_week`.
  - **age_group**: Segmentación por grupos de edad.
  - **has_previous_contact**: Indica si el cliente tuvo contactos previos en la campaña.
  - **contact_duration_minutes**: Duración del contacto convertida a minutos.
  - **contact_frequency**: Categoriza la frecuencia de contacto en "single", "few" o "frequent".
  - **previous_campaign_success**: Indicador booleano del éxito en la campaña previa.

#### 2. **kpi_bank_marketing**
Modelo de análisis que calcula KPIs de la campaña. Realiza:
- Resumen general de la campaña (contactos totales, exitosos y tasa de conversión).
- Resúmenes segmentados por:
  - Grupo de edad.
  - Ocupación.
- Combina los resultados en una tabla unificada.

### Esquema de Pruebas (schema.yml)
Se definen pruebas para validar la calidad de los datos en cada modelo:
- **staging_bank_marketing**:
  - Pruebas de unicidad y no nulos para `client_id`.
  - Validación de rangos en columnas como `age` y `contact_duration_minutes`.
  - Aceptación de valores permitidos en campos categóricos como `has_default`, `age_group`, `contact_frequency`, entre otros.
- **kpi_bank_marketing**:
  - Validación de no nulos en métricas clave como `total_contacts`, `successful_contacts` y `conversion_rate_percentage`.

### Dataset
El dataset utilizado contiene información sobre campañas de marketing telefónico realizadas por una institución bancaria. Incluye campos como:
- Datos demográficos: edad, ocupación, estado civil, nivel educativo.
- Información financiera: si tiene créditos hipotecarios, personales o en default.
- Resultados de campañas anteriores: duración del contacto, frecuencia, y éxito previo.

### Requisitos
- **DBT**: Herramienta para modelado de datos.
- **Macros personalizadas**: Pruebas como `between` y `positive_value` están implementadas con macros adicionales.
- **Dataset fuente**: `bank-additional-full.csv`.

### Cómo Usar el Proyecto
1. Clonar el repositorio:
   ```bash
   git clone <url-del-repositorio>
   ```

2. Configurar las conexiones a la base de datos en el archivo `profiles.yml` de DBT.

3. Ejecutar los modelos:
```bash
dbt run
```

4. Validar los datos con las pruebas definidas:
```bash
dbt test
```

## Consideraciones
El campo last_contact_date es ficticio y solo se utiliza para ejercicios prácticos.
La segmentación por edad asigna "unknown" a valores fuera de los rangos especificados.
Algunos campos categóricos reemplazan valores "unknown" por NULL para mejor manejo de datos.