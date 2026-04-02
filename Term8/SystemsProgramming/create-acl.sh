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
chmod u=rw $shared/folder-1/*
chmod u+x $shared/folder-1/*.sh

chmod o+x $shared/folder-1
chmod +a "user-3 allow list" $shared/folder-1

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
chmod u=rx $shared/folder-2
chmod -R a=r $shared/folder-2

chmod +a "user-1 allow list,add_file,add_subdirectory" $shared/folder-2
chmod +a "user-1 allow read,write" $shared/folder-2/*

chmod +a "user-2 allow list,delete_child" $shared/folder-2
chmod +a "user-2 allow read" $shared/folder-2/*

chmod +a "user-3 allow list" $shared/folder-2
chmod +a "user-3 allow read" $shared/folder-2/*
chmod +a "user-3 allow execute" $shared/folder-2/*.sh
