# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set formula = d.formula %}

    {%- if grains.os_family|lower in ('redhat', 'debian') %}
        {%- if d.node.pkg.use_upstream_repo %}
            {%- set sls_repo_clean = tplroot ~ '.package.repo.clean' %}
include:
  - {{ sls_repo_clean }}
        {%- endif %}

{{ formula }}-node-package-clean-pkgs:
  pkg.removed:
    - names: {{ d.node.pkg.commands|json }}
    - reload_modules: true
        {%- if d.node.pkg.use_upstream_repo %}
    - require:
      - pkgrepo: {{ formula }}-package-repo-absent
        {%- endif %}

    {%- else %}

{{ formula }}-node-package-clean-other:
  test.show_notification:
    - text: |
        The node package is unavailable for {{ salt['grains.get']('finger', grains.os_family) }}

    {%- endif %}