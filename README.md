# WordPress Site Backup Script

This bash script performs a daily backup of a WordPress site and its associated database and send a backup to S3 bucket. Then it removes backups retention that are older than 8 days.

## Prerequisites

MySQL command-line client installed.
AWS CLI configured with an S3 bucket and an IAM user with permission to use AWS CLI services.
Configuration file "/etc/backup_config.conf" that contains values for several configuration variables.

## Usage

Run the script with sudo privileges:

'''bash
sudo ./wordpress_site_backup.sh

## How it works

The script checks if it is running as root (i.e., with sudo permissions) and if not, it runs itself with sudo permissions.

It sources a configuration file "/etc/backup_config.conf" that contains values for several configuration variables.

It checks if the source directory specified in the configuration file exists. If not, it logs an error message and exits the script.

It checks if the WordPress configuration file exists. If not, it logs an error message and exits the script.

It creates a MySQL database backup using the mysqldump command.

It creates a tarball of the WordPress site directory.

It creates a full backup of the site and database by combining the MySQL database backup and the WordPress site tarball.

It gets the latest backup file based on today's date.

It copies the latest backup file to s3 bucket using AWS S3 cp command

It sends out a notification email with the the backup file information

It removes backups older than 8 days in the backup directory.


## Disclaimer

This script is provided as-is, without warranty of any kind. Use at your own risk.
