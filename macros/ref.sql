{% macro ref(model_name, relation=False) %}

    {% set ref_rel = builtins.ref(model_name) %}
    {%- if target.name == 'ci' and not relation -%}
        {% set empty_rel %}
            (select * from {{ ref_rel }} limit 0) a
        {% endset %}
        {% do return(empty_rel) %}
    {% else %}
        {% do return(ref_rel) %}
  {% endif %}

{% endmacro %}
