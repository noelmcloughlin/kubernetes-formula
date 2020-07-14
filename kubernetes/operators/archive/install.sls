#  -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set formula = d.formula %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

{%- if 'wanted' in d.operators and d.operators.wanted %}
    {%- for tool in d.operators.wanted|unique %}
        {%- if 'pkg' in d.operators and tool in d.operators['pkg'] and d.operators.pkg[tool] %}
            {%- if d.operators.pkg[tool]['use_upstream'] == 'archive' and 'archive' in d.operators.pkg[tool] %}

{{ formula }}-operators-archive-{{ tool }}-install:
  file.directory:
    - name: {{ d.operators.pkg[tool]['path'] }}/
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - mode: 755
    - clean: True
    - makedirs: True
    - require_in:
      - archive: {{ formula }}-operators-archive-{{ tool }}-install
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(d.operators.pkg[tool]['archive']) }}
    - retry: {{ d.retry_option }}
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - enforce_toplevel: false
    - trim_output: true
    - recurse:
        - user
        - group

            {% endif %}
        {% endif %}
    {%- endfor %}
{%- endif %}