#!/usr/bin/env sh

set -xeu

shared="/var/home"

sysadminctl -addUser user-1 -password 12345678
sysadminctl -addUser user-2 -password 12345678
sysadminctl -addUser user-3 -password 12345678

dseditgroup -o create folder-1-read
dseditgroup -o create folder-2-read
dseditgroup -o edit -a user-2 -t user folder-1-read
dseditgroup -o edit -a user-2 -t user folder-2-read

mkdir -m a=--- -p $shared/folder-1
mkdir -m a=--- -p $shared/folder-2

cat << EOF > $shared/folder-1/file.txt
This is an example text document.

Please read it carefuly.
Thanks you.
EOF

cat << EOF > $shared/folder-1/script.sh
#!/user/bin/env sh

echo "Hello, \$USER"
EOF

chown -R user-1 $shared/folder-1
chown -R :folder-1-read $shared/folder-1
chmod u=rwx,g=---,o=--- $shared/folder-1
chmod u=rw,g=---,o=--- $shared/folder-1/*
chmod u=rwx $shared/folder-1/*.sh
chmod o=rwx $shared/folder-1

cat << EOF > $shared/folder-2/file.md
# Hello

My cool hello file!
EOF

cat << EOF > $shared/folder-2/script.sh
#!/usr/bin/env sh

echo "Goodbye, \$USER"
EOF

chown -R user-3 $shared/folder-2
chown -R :folder-2-read $shared/folder-2
chmod u=rx,g=rwx,o=rx $shared/folder-2
chmod u=r,g=r,o=rw $shared/folder-2/*
chmod u+x $shared/folder-2/*.sh
