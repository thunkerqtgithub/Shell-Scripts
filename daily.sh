this is another test
#!/opt/homebrew/bin/bash
# runs daily 9:30am

RSYNC="/opt/homebrew/bin/rsync -a --delete"
TARGET="/Volumes/Daily/Incrementals"
OLD="--link-dest=$TARGET/daily.1"
SOURCE="/Volumes/Daily/Incrementals/Source/"
VAR=$(find /opt/homebrew/Cellar/msmtp -name '*[0-9.]' -maxdepth 1 -type d)
OPT_DIR="$VAR/etc"
ETC_DIR="/etc/ssl"
bold=$(tput bold)
#normal=$(tput sgr0)
esc=`echo -en "\033"`
normal=`echo -en "${esc}[m\017"`
red="${esc}[1;31m"
purple="${esc}[1;35m"
green="${esc}[1;32m"

createDirs() 
{
	if [ ! -d "$TARGET" ]; then
   		mkdir -p "$TARGET"
	fi

	if [ ! -d "$SOURCE/$OPT_DIR" ]; then
               mkdir -p "$SOURCE/$OPT_DIR"
        fi
	
	if [ ! -d "$SOURCE/$ETC_DIR" ]; then
		mkdir -p "$SOURCE/$ETC_DIR"
	fi
}

createSource() {
$RSYNC --exclude='.DS_Store' --exclude='.bash_history' --exclude='Sites' --exclude='.bash_sessions' --exclude='.viminfo' --exclude='Library' --exclude='Pictures' --exclude='Vantrue' --exclude='DropFile' --exclude='Movies' --exclude='Public' --exclude='.CFUserTextEncoding' --exclude='.Trash' "/Users/USER" "$SOURCE"

#$RSYNC --exclude='Utilities' "/Applications" "$SOURCE/"
$RSYNC "/Users/USER/Library/Calendars" "$SOURCE/USER/Library/"
$RSYNC "/Users/USER/Library/Keychains" "$SOURCE/USER/Library/"
$RSYNC "/etc/sudoers" "$SOURCE/etc/"
$RSYNC "/etc/hosts" "$SOURCE/etc/"
$RSYNC "$OPT_DIR/msmtprc" "$SOURCE/$OPT_DIR/"
$RSYNC "$ETC_DIR/certs" "$SOURCE/$ETC_DIR/"
$RSYNC --exclude='com.bombich.ccchelper.plist' "/Library/LaunchDaemons" "$SOURCE/Library/"
$RSYNC "/Users/USER/Library/Mail" "$SOURCE/USER/Library/"
$RSYNC "/Users/USER/Library/Workflows" "$SOURCE/USER/Library/"
# $RSYNC "/Users/USER/Library/Application Support/AddressBook" "$SOURCE/USER/Library/Application Support/"
# $RSYNC "/Users/USER/Library/Safari/Bookmarks.plist" "$SOURCE/USER/Library/Safari/"
# $RSYNC --exclude='Movies' --exclude='TV Shows' --exclude='.Trashes' --exclude='.TemporaryItems' --exclude='.DocumentRevisions-V100' --exclude='.Spotlight-V100' --exclude='.apdisk' --exclude='.fseventsd' --exclude='.iTunes Preferences.plist' "/Volumes/iTunes" "$SOURCE"

}

deleteOldestSnapshot() {
	if [ -d "$TARGET/daily.0" ]; then
		rm -fr "$TARGET/daily.6" >/dev/null 2>&1
	fi
}

rotateSnapshot() {
	for i in {6..1}
	do
   		mv "$TARGET/daily.$[${i}-1]" "$TARGET/daily.${i}" >/dev/null 2>&1
		sync
	done
}

createSnapshot() {
	$RSYNC "$OLD" "$SOURCE" "$TARGET/daily.0"
}

mount | grep -i "/Volumes/Daily"
if [ $? -eq 0 ]; then
	#echo "["${purple}Running Snapshot Backup${normal}"]"
        echo "Running Incremental Backup!"
        echo -ne '[=====>] 10%\r\c'
        createDirs
        sleep 1
        echo -ne '[==========>] 20%\r\c'
        createSource
        sleep 1
        echo -ne '[===============>] 30%\r\c'
        sleep 1
        echo -ne '[===================>] 40%\r\c'
        deleteOldestSnapshot
        sleep 1
        echo -ne '[========================>] 50%\r\c'
        sleep 1
        echo -ne '[=============================>] 60%\r\c'
        rotateSnapshot
        sleep 1
        echo -ne '[==================================>] 70%\r\c'
        sleep 1
        echo -ne '[=======================================>] 80%\r\c'
        createSnapshot
        sleep 1
        echo -ne '[============================================>] 90%\r\c'
        sleep 1
        echo -ne '[=================================================>] 100%\r\c'
	sleep 1
        echo -ne '\n'
	#echo "${green}Completed Successfully!${normal}"
	echo "🟢 Completed Successfully!"
else
        echo "🔴 Volume 'Daily' missing!"
fi
exit $?
