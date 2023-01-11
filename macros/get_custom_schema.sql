{% macro generate_schema_name(custom_schema_name, node) %}

    {%- if target.name == ci -%}
        {%- set default_schema = target.schema -%}
        {%- if custom_schema_name is none -%}
            {{ default_schema }}
        {%- else -%}
            {{ default_schema }}_{{ custom_schema_name | trim }}
        {%- endif -%}
    {%- else -%}
        {{ generate_schema_name_for_env(custom_schema_name, node) }}
    {%- endif -%}

{% endmacro %}
