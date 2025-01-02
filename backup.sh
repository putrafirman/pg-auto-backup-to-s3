#!/usr/bin/env bash


set -e

# Set current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Vars
NOW=$(date +"%Y-%m-%d-at-%H-%M-%S")
DELETETION_TIMESTAMP=`[ "$(uname)" = Linux ] && date +%s --date="-$DELETE_AFTER"` # Maximum date (will delete all files older than this date)

# Split databases
IFS=',' read -ra DBS <<< "$PG_DATABASES"

# Delete old files
echo "=> Backup in progress.,.";

# Loop thru databases
for db in "${DBS[@]}"; do
    FILENAME="$NOW"_"$db"

    echo "==> backing up $db..."

    pg_dump --dbname=$PG_PATH/$db > /tmp/"$FILENAME".dump

    # Copy to S3
    aws s3 cp /tmp/"$FILENAME".dump s3://$S3_PATH/"$FILENAME".dump

    # Delete local file
    rm /tmp/"$FILENAME".dump

    # Log
    echo "==> database $db has been backed up"
done

# Delere old files
echo "=> Deleting old backups...";

# Loop thru files
echo "==> Exists File in S3 "
aws s3 ls s3://$S3_PATH/ | while read -r line;  do

    echo $line

    # Get file creation date
    createDate=`echo $line|awk {'print $1" "$2'}`
    createDate=`date -d"$createDate" +%s`

    if [[ $createDate -lt $DELETETION_TIMESTAMP ]]
    then
        # Get file name
        FILENAME=`echo $line|awk {'print $4'}`
        if [[ $FILENAME != "" ]]
          then
            echo "===> Deleting $FILENAME"
            aws s3 rm s3://$S3_PATH/$FILENAME
        fi
    fi
done;

echo "==> Finished";
echo ""