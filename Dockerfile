# Use Ubuntu as base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Add PostgreSQL repository
RUN apt-get update && apt-get install -y curl ca-certificates gnupg
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
RUN echo "deb http://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install required packages including PostgreSQL 15 client
RUN apt-get update && apt-get install -y \
    python3-pip \
    postgresql-client-15 \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Create app directory
WORKDIR /app

# Copy backup script and config
COPY backup.sh /app/

# Make script executable
RUN chmod +x /app/backup.sh

# Set entrypoint
ENTRYPOINT ["/app/backup.sh"]