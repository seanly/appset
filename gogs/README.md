# gogs

## backup 

```
docker-compose exec gogs bash 

USER=git ./gogs backup
```


## restore


```
docker-compose exec gogs bash 

# step1: update config
mkdir -p /tmp/backup
cd /tmp/backup
unzip /path/to/gogs-backup-xxx.zip
# NOTE: update custom/conf/app.ini to new env
zip -r gogs-backup-xxx.zip gogs-backup

# step2: restore backup
mkdir -p /data/tmp
USER=git /app/gogs/gogs restore --from /mnt/tmp/gogs-backup-20231125151338.zip -v -t /data/tmp

```