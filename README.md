# PostgreSQL Backup to S3

A Docker-based solution for automated PostgreSQL database backups to S3-compatible storage services. This tool provides a simple way to schedule and manage database backups with automatic cleanup of old backup files.

Inspired by [pg-dump-to-s3](https://github.com/gabfl/pg_dump-to-s3)

## Features

- Automated PostgreSQL database backups
- Support for multiple databases
- S3-compatible storage support
- Automatic cleanup of old backups
- Configurable retention period
- Docker-based for easy deployment

## Prerequisites

- Docker
- S3-compatible storage access (AWS S3, CloudHost, etc.)
- PostgreSQL database access

## Quick Start

1. Build the Docker image:
```bash
docker build -t pg-dump-to-s3-v1 .
```

2. Run the backup container:
```bash
docker run \
  -e AWS_ACCESS_KEY_ID=your_access_key \
  -e AWS_SECRET_ACCESS_KEY=your_secret_key \
  -e AWS_ENDPOINT_URL=your_s3_endpoint \
  -e S3_PATH=your/backup/path \
  -e DELETE_AFTER="7 days" \
  -e PG_DATABASES=database1,database2 \
  -e PG_PATH=postgresql://user:password@host:port \
  pg-dump-to-s3-v1
```

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `AWS_ACCESS_KEY_ID` | S3 access key | `AKIAXXXXXXXX` |
| `AWS_SECRET_ACCESS_KEY` | S3 secret key | `xxxxxxxxxxxxxxxx` |
| `AWS_ENDPOINT_URL` | S3-compatible endpoint URL | `https://s3.amazonaws.com` |
| `S3_PATH` | Backup destination path in S3 | `bucket/backup/path` |
| `DELETE_AFTER` | Retention period for backups | `7 days` |
| `PG_DATABASES` | Comma-separated list of databases to backup | `db1,db2,db3` |
| `PG_PATH` | PostgreSQL connection string | `postgresql://user:pass@host:5432` |

## Backup Process

1. The script connects to the specified PostgreSQL database(s)
2. Creates a dump file for each database
3. Uploads the dump files to the specified S3 path
4. Removes local dump files after successful upload
5. Cleans up old backup files based on the retention period

## File Naming Convention

Backup files are named using the following format:
```
YYYY-MM-DD-at-HH-MM-SS_database-name.dump
```

## Security Considerations

- Store sensitive credentials securely
- Use environment variables for configuration
- Ensure proper S3 bucket permissions
- Use secure PostgreSQL connection strings

## License

This project is not-so-open-source. Feel free to use and modify as needed.
