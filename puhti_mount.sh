#!/bin/sh
CSC_LOGIN_NAME="tyrmi"
HOST_ID="$CSC_LOGIN_NAME@puhti.csc.fi"
MOUNT_DIR_1_name="puhti_home"
MOUNT_DIR_2_name="puhti_jkettune_projappl"
MOUNT_DIR_3_name="puhti_jkettune_scratch"
MOUNT_DIR_1="$HOME/mounts/$MOUNT_DIR_1_name"
MOUNT_DIR_2="$HOME/mounts/$MOUNT_DIR_2_name"
MOUNT_DIR_3="$HOME/mounts/$MOUNT_DIR_3_name"
REMOTE_DIR_1=/users/$CSC_LOGIN_NAME
REMOTE_DIR_2=/projappl/jkettune
REMOTE_DIR_3=/scratch/jkettune

# Create the mount dir if it does not exist:
[ ! -d $MOUNT_DIR_1 ] && mkdir -p $MOUNT_DIR_1
[ ! -d $MOUNT_DIR_2 ] && mkdir -p $MOUNT_DIR_2
[ ! -d $MOUNT_DIR_3 ] && mkdir -p $MOUNT_DIR_3

# open_connections is the number of processes with keywords sftp and the host id
open_connections=$(ps aux | grep -i sftp | grep -i $HOST_ID | grep -v grep | wc -l)
if [ $open_connections == 0 ]
then
echo "$HOST_ID not found in sftp processes. Mounting..."
echo "Mounting $REMOTE_DIR_1"
sudo sshfs -o volname=$MOUNT_DIR_1_name,allow_other,defer_permissions $HOST_ID:$REMOTE_DIR_1 $MOUNT_DIR_1
echo "Mounting $REMOTE_DIR_2"
sudo sshfs -o volname=$MOUNT_DIR_2_name,allow_other,defer_permissions $HOST_ID:$REMOTE_DIR_2 $MOUNT_DIR_2
echo "Mounting $REMOTE_DIR_3"
sudo sshfs -o volname=$MOUNT_DIR_3_name,allow_other,defer_permissions $HOST_ID:$REMOTE_DIR_3 $MOUNT_DIR_3
else
echo "$HOST_ID found in sftp processes, ongoing mount assumed. Unmounting..."
echo "Unmounting $REMOTE_DIR_1"
sudo diskutil unmount force $MOUNT_DIR_1
echo "Unmounting $REMOTE_DIR_2"
sudo diskutil unmount force $MOUNT_DIR_2
echo "Unmounting $REMOTE_DIR_3"
sudo diskutil unmount force $MOUNT_DIR_3
fi
