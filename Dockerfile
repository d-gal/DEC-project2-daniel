FROM ghcr.io/dbt-labs/dbt-snowflake:1.7.1

# Copy the actual dbt project (northwind folder)
COPY dbt-transformation/northwind/ /usr/app/dbt/

# Create .dbt directory and copy profiles
RUN mkdir -p /root/.dbt
COPY dbt-transformation/northwind/profiles.yml /root/.dbt/

# Copy the build script
COPY build_dbt.sh /usr/app/

WORKDIR /usr/app

ENTRYPOINT ["/bin/bash", "build_dbt.sh"]