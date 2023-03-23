#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as sudo"
  exec sudo "$0" "$@"
  exit
fi

# Read configuration values from a separate file
source /etc/backup_config.conf

# Check if the site directory exists
if [ ! -d "$SRC_PATH" ]; then
  # Log an error and exit the script if the directory doesn't exist
  echo "Error: Directory $SRC_PATH does not exist." >&2
  exit 1
fi

# Check if the WordPress configuration file exists
if [ ! -f "$SRC_PATH/wordpress/wp-config.php" ]; then
  # Log an error and exit the script if the file doesn't exist
  echo "Error: File $SRC_PATH/wordpress/wp-config.php does not exist." >&2
  exit 1
fi

# Create the database backup
mysqldump -u $DBUSER -p$DBPASS $DBNAME > $DB_BACKUP

# Create the site backup
tar -zcvf $SITE_BACKUP $SRC_PATH/wordpress

# Create the Full backup
tar -zcvf $FULL_BACKUP $SITE_BACKUP $DB_BACKUP --remove-files

##
# Need to create S3 bucket, IAM user with permission to use AWS CLI services below
##

## Get the latest backup file based on today's date
#latest_backup=$(ls -t $BACKUP_DIR/ | grep "FULL-zeawin.com-$(date "+%Y-%m-%d").tar.gz" | head -1)

## Copy the file to S3
#aws s3 cp "$BACKUP_DIR/$latest_backup" "$AWS_S3_BUCKET"

## Check if the file was copied successfully
#if [ $? -eq 0 ]; then
#  email_subject="File successfully copied to S3 bucket"
#  email_body="The file $latest_backup has been successfully copied to the S3 bucket."
#else
#  email_subject="File copy to S3 bucket failed"
#  email_body="The file $latest_backup could not be copied to the S3 bucket."
#fi

## Send the email using AWS SES
#aws ses send-email --from sender@email.com --to receiver@email.com --subject "$email_subject" --text "$email_body"


# Remove backups older than 8 days
find $BACKUP_DIR -name "FULL-${SITE}*" -mtime +8 -exec rm {} \;

