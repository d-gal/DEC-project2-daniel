#!/bin/bash
cd /usr/app/dbt
dbt deps --profiles-dir /root/.dbt
dbt build --target prod --profiles-dir /root/.dbt