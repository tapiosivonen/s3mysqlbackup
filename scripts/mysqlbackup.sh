#!/bin/sh

# dump database and encrypt it to backup key
nice -n 11 mysqldump --defaults-file=secure/<configfile> --opt --databases <dbname> | gzip -c | gpg -a -e -r "<backupkey>" >latest.gz.enc

# upload the encrypted backup file to s3
nice -n 11 aws --region <awsregion> --profile <profilename> s3 cp --sse AES256 latest.gz.enc s3://<bucket>/latest.gz.enc

# recycle old backups, keep last 4
if [ -f "latest.gz.enc" ]
then
  rm 4.gz.enc
  mv 3.gz.enc 4.gz.enc
  mv 2.gz.enc 3.gz.enc
  mv 1.gz.enc 2.gz.enc
  mv latest.gz.enc 1.gz.enc
else
  echo "backup failed."
fi
