#! /bin/bash


function backupdir() {
  BACKUP_DIR=$1
  FILENAME_PREFIX=$2
  SOURCE_PATH=$3

  echo $BACKUP_DIR

  if [ ! -d "$BACKUP_DIR" ]; then
    echo "1"
    mkdir -p "$BACKUP_DIR";
  fi

  pushd .

  cd "$BACKUP_DIR"
  pwd
  echo "2"
  date=`date "+%m-%d-%Y-%H-%M-%S"`

  echo $SOURCE_PATH
  tar cfvz "$FILENAME_PREFIX-$date.tar.gz" "$SOURCE_PATH"
  pwd
  ls -lt "$FILENAME_PREFIX"* | awk '{if(NR>5) print $9}' | xargs rm

  popd
}

backupdir "/Users/Scott/backups" "ssh" "/Users/Scott/.ssh"
backupdir "/Users/Scott/backups" "aws" "/Users/Scott/.aws"
backupdir "/Users/Scott/backups" "launch-agents" "/Users/scott/Library/LaunchAgents"
backupdir "/Users/Scott/backups" "preferences-adobe" "/Users/scott/Library/Preferences/Adobe*"
backupdir "/Users/Scott/backups" "homebrew-etc" "/opt/homebrew/etc"
backupdir "/Users/Scott/backups" "scottwalter-catalog" "/Users/scott/Pictures/Scott Walter Photography Catalog"
backupdir "/Users/Scott/backups" "swp-catalog" "/Users/scott/Pictures/SWP Catalog"


# backupdir "/Volumes/Extra Stuff/Backups" "ssh" "/Users/Scott/.ssh"
# backupdir "/Volumes/Extra Stuff/Backups" "aws" "/Users/Scott/.aws"
# backupdir "/Volumes/Extra Stuff/Backups" "launch-agents" "/Users/scott/Library/LaunchAgents"



# mkdir -p ~/backups
# pushd .
# cd ~/backups
# date=`date "+%m-%d-%Y-%H-%M-%S"`
# tar -cf "sysfiles-$date.tar" -C ~/.ssh ~/.aws

# ls -lt sysfiles-*tar | awk '{if(NR>5) print $9}' | xargs rm
# popd