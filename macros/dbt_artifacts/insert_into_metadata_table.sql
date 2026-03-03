{% macro insert_into_metadata_table(dataset, fields, content) -%}

    {% if content != "" %}

        {# Get the relation that the results will be uploaded to #}
        {% set dataset_relation = dbt_artifacts.get_relation(dataset) %}
        {# Insert the data into the table #}
        {{ return(adapter.dispatch('insert_into_metadata_table', 'dbt_artifacts')(dataset_relation, fields, content)) }}

    {% endif %}

{%- endmacro %}

{% macro spark__insert_into_metadata_table(relation, fields, content) -%}

    {% set insert_into_table_query %}
    insert into {{ relation }} {{ fields }}
    {{ content }}
    {% endset %}

    {% do run_query(insert_into_table_query) %}

{%- endmacro %}

{% macro snowflake__insert_into_metadata_table(relation, fields, content) -%}

    {% set insert_into_table_query %}
    insert into {{ relation }} {{ fields }}
    {{ content }}
    {% endset %}

    {% do run_query(insert_into_table_query) %}

{%- endmacro %}

{% macro bigquery__insert_into_metadata_table(relation, fields, content) -%}

    {% set insert_into_table_query %}
    insert into {{ relation }} {{ fields }}
    values
    {{ content }}
    {% endset %}

    {% do run_query(insert_into_table_query) %}

{%- endmacro %}

{% macro postgres__insert_into_metadata_table(relation, fields, content) -%}

    {% set insert_into_table_query %}
    insert into {{ relation }} {{ fields }}
    values
    {{ content }}
    {% endset %}

    {% do run_query(insert_into_table_query) %}

{%- endmacro %}

{% macro duckdb__insert_into_metadata_table(relation, fields, content) -%}

    {#
        Write one Parquet file per dataset per invocation to S3.
        Path: <external_root>/dbt_artifacts/<dataset>/<invocation_id>.parquet
        Override the root via var('dbt_artifacts_s3_root'), otherwise falls back to
        target.external_root (set in profiles.yml for dev_duckdb / prod_duckdb).
    #}
    {% set external_root = var('dbt_artifacts_s3_root', target.external_root) %}
    {% set s3_path = external_root ~ '/dbt_artifacts/' ~ relation.identifier ~ '/' ~ invocation_id ~ '.parquet' %}

    {% set copy_query %}
    copy (
        select * from (
            values
            {{ content }}
        ) as t {{ fields }}
    ) to '{{ s3_path }}' (format parquet)
    {% endset %}

    {% do run_query(copy_query) %}

{%- endmacro %}

{% macro sqlserver__insert_into_metadata_table(relation, fields, content) -%}

    {% set insert_into_table_query %}
    insert into {{ relation }} {{ fields }}
    {{ content }}
    {% endset %}

    {% do run_query(insert_into_table_query) %}

{%- endmacro %}

{% macro default__insert_into_metadata_table(relation, fields, content) -%}
{%- endmacro %}



{% macro trino__insert_into_metadata_table(relation, fields, content) -%}

    {% set insert_into_table_query %}
    insert into {{ relation }} {{ fields }}
    values
    {{ content }}
    {% endset %}

    {% do run_query(insert_into_table_query) %}

{%- endmacro %}
