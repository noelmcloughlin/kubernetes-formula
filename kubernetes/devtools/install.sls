# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set formula = d.formula %}

    {%- if 'wanted' in d.devtools and d.devtools.wanted %}
        {%- for tool in d.devtools.wanted %}
            {%- if 'pkg' in d.devtools and tool in d.devtools['pkg'] and d.devtools['pkg'][tool] %}
                {%- if 'archive' in d.devtools['pkg'][tool] %}

{{ formula }}-devtools-{{ tool }}-archive-install:
  file.directory:
    - name: {{ d.devtools['pkg'][tool]['archive']['name'] }}/
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - mode: 755
    - clean: True
    - makedirs: True
    - require_in:
      - archive: {{ formula }}-devtools-{{ tool }}-archive-install
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    - name: {{ d.devtools['pkg'][tool]['archive']['name'] }}/
    - source: {{ d.devtools['pkg'][tool]['archive']['source'] }}
    - source_hash: {{ d.devtools['pkg'][tool]['archive']['source_hash'] }}
    - enforce_toplevel: false
    - trim_output: true
    - retry: {{ d.retry_option }}
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - recurse:
        - user
        - group
                    {%- if tool not in ('audit2rbac',) %} {# tarbombs #}
    - options: '--strip-components=1'
                    {%- endif %}

                    {%- if d.linux.altpriority|int == 0 or grains.os_family in ('Arch', 'MacOS') %}
                        {%- for cmd in d.devtools['pkg'][tool]['commands'] %}

{{ formula }}-devtools-{{ tool }}-archive-install-symlink-{{ cmd }}:
  file.symlink:
    - name: /usr/local/bin/{{ cmd }}
    - target: {{ d.devtools['pkg'][tool]['archive']['name'] }}/{{ tool }}
    - force: True
    - require:
      - archive: {{ formula }}-devtools-{{ tool }}-archive-install

                        {% endfor %}
                    {% endif %}
                {% endif %}

            {% endif %}
        {%- endfor %}
    {%- endif %}
