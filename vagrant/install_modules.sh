#!/bin/bash

mkdir -p modules-contrib/
puppet module install --modulepath=modules-contrib/ camptocamp-openldap
