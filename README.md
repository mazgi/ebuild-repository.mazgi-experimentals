# An experimental ebuild repository

## How to use

```console
cat<<EOF | sudo tee /etc/portage/repos.conf/mazgi-experimentals.conf
[mazgi-experimentals]
location = /var/db/repos/mazgi-experimentals
sync-type = git
sync-uri = https://github.com/mazgi/ebuild-repository.mazgi-experimentals.git
EOF
```

```console
sudo emaint --repo mazgi-experimentals sync
```
