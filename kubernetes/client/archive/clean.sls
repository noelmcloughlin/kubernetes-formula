# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set formula = d.formula %}
{%- set sls_alternatives_clean = tplroot ~ '.client.alternatives.clean' %}

include:
  - {{ sls_alternatives_clean }}

{{ formula }}-client-archive-absent:
  file.absent:
    - names:
      - {{ d.dir.tmp }}{{ '/' if grains.os != 'Windows' else '\' }}client*
      - {{ d.client.pkg.path }}{{ '/bin/' if grains.os != 'Windows' else '\' }}
        {%- if d.linux.altpriority|int == 0 or grains.os_family in ('Arch', 'MacOS') %}
            {%- for cmd in d.client.pkg.commands|unique %}
      - /usr/local/bin/{{ cmd }}
            {%- endfor %}
        {%- endif %}
