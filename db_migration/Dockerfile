FROM flyway/flyway

# Create the /flyway/sql directory in the container
RUN mkdir -p /flyway/sql

# Copy the SQL migration scripts into the container
COPY ./sql /flyway/sql
