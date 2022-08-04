#!/opt/homebrew/bin/bash
# runs every 2 minutes

TO="#####@gmail.com"
HOST=`hostname -s`
SIGN="[Sent from $HOST]"
MAIL="/opt/homebrew/bin/msmtp" 
BORDER="++++++++++++++++++++++++++\n"
TITLE="\tTripwire Home - Change Report"
RULE="Rule: Confirm file changes or creation\n"
MSG1="Alert: Violations found: "
MSG2="Modified element name(s):"

catch()
{
   if [[ $(find "/$1/$2" -type f -cmin -2 \( ! -name ".DS_Store" ! -name ".localized" ! -name "*.swp" ! -name "0" \) | wc -l) -gt 0 ]]; then
	TODAY=`date`
	COUNT=`find "/$1/$2" -type f -cmin -2 \( ! -name ".DS_Store" ! -name ".localized" ! -name "*.swp" ! -name "0" \) | wc -l`
	HEAD="Modified Objects:$COUNT"
        FILES="$(find "/$1/$2" -type f -cmin -2 \( ! -name ".DS_Store" ! -name ".localized" ! -name "*.swp" ! -name "0" \))"
        [ -n "$FILES" ] && echo -e "To: ${TO}\nSubject: "$MSG1 $COUNT"\n\n$BORDER$TITLE\nDate: $TODAY\n$RULE$BORDER\n$MSG2\n$FILES\n\n$SIGN" | $MAIL -a gmail ${TO}
        sync
fi
}

catch2()
{
   if [[ $(find "$1" -type f -cmin -2 \( ! -name ".DS_Store" ! -name ".localized" ! -name "*.swp" ! -name "0" ! -name "printers.conf.O" ! -name "printers.conf" ! -name "Brother_HL_L2370DW_series.ppd" ! -name "Brother_HL_L2370DW_series.ppd.O" \) | wc -l) -gt 0 ]]; then
	TODAY=`date`
	COUNT=`find "$1" -type f -cmin -2 \( ! -name ".DS_Store" ! -name ".localized" ! -name "*.swp" ! -name "0" ! -name "printers.conf.O" ! -name "printers.conf" ! -name "Brother_HL_L2370DW_series.ppd" ! -name "Brother_HL_L2370DW_series.ppd.O" \) | wc -l`
	HEAD="Modified Objects:$COUNT"
	FILES="$(find "$1" -type f -cmin -2 \( ! -name ".DS_Store" ! -name ".localized" ! -name "*.swp" ! -name "0" ! -name "printers.conf.O" ! -name "printers.conf" ! -name "Brother_HL_L2370DW_series.ppd" ! -name "Brother_HL_L2370DW_series.ppd.O" \))"
	[ -n "$FILES" ] && echo -e "To: ${TO}\nSubject: "$MSG1 $COUNT"\n\n$BORDER$TITLE\nDate: $TODAY\n$RULE$BORDER\n$MSG2\n$FILES\n\n$SIGN" | $MAIL -a gmail ${TO}
	sync
        fi
}

declare -A aa1
declare -A aa2
declare -A aa3

aa1=([.ssh]="Users/USER" [.bash_profile]="Users/USER" [Public]="Users/USER" [Downloads]="Users/USER" [Firewall]="Users/USER" [Documents]="Users/USER" [Scripts]="Users/USER" \
[Desktop]="Users/USER" [Network]="Users/USER" [Library/Workflows]="Users/USER" [LaunchDaemons]="Library" [LaunchAgents]="Library" \
[StartupItems]="Library" [Internet Plug-Ins]="Library" [bin]="opt/homebrew" [sbin]="opt/homebrew" [etc]="opt/homebrew")

aa2=([LaunchDaemons]="System/Library" [LaunchAgents]="System/Library" [Frameworks]="System/Library" [sbin]="usr" [bin]="usr" [Scripts]="Library")

aa3=([/etc/]="" [/sbin/]="" [/bin/]="" [/home/]="" [/Applications/]="" [/opt/]="")

for key in "${!aa1[@]}"; do
        catch "${aa1[$key]}" "$key"
        sync
done

for key in "${!aa2[@]}"; do
	catch "${aa2[$key]}" "$key"
	sync
done

for key in "${!aa3[@]}"; do
	catch2 "$key"
	sync
done

exit $?
