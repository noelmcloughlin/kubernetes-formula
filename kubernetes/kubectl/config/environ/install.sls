# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import kubernetes as k8s with context %}
{%- set sls_binary_install = tplroot ~ '.kubectl.binary' %}
{%- set sls_package_install = tplroot ~ '.kubectl.package' %}
{%- set sls_source_install = tplroot ~ '.kubectl.source' %}

    {%- if 'environ' in k8s.kubectl and k8s.kubectl.environ %}
        {%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_binary_install }}
  - {{ sls_package_install }}
  - {{ sls_source_install }}

k8s-kubectl-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ k8s.kubectl.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='k8s-kubectl-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 640
    - user: {{ k8s.rootuser }}
    - group: {{ k8s.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        environ: {{ k8s.kubectl.environ|json }}
    - require:
      - sls: {{ sls_binary_install }}
      - sls: {{ sls_package_install }}
      - sls: {{ sls_source_install }}

    {%- endif %}
