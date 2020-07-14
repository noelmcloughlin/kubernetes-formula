# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set formula = d.formula %}

{%- if 'wanted' in d.sigs and d.sigs.wanted %}
    {%- for tool in d.sigs.wanted|unique %}
        {%- if d.sigs.pkg[tool]['use_upstream'] == 'binary' %}
            {%- if 'pkg' in d.sigs and tool in d.sigs['pkg'] and d.sigs['pkg'][tool] %}

{{ formula }}-sigs-binary-{{ tool }}-clean:
  file.absent:
    - names:
      - {{ d.sigs['pkg'][tool]['path'] }}/bin/{{ tool }}
      - {{ d.sigs['pkg'][tool]['path'] }}/{{ tool }}
                {%- for cmd in d.sigs['pkg'][tool]['commands']|unique %}
      - /usr/local/bin/{{ cmd }}
                {%- endfor %}

            {% endif %}
        {% endif %}
    {%- endfor %}
{%- endif %}