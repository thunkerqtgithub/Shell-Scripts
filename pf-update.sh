#!/opt/homebrew/bin/bash
# runs 4th day at 10:30am

START=`date "+%A, %b %d, %r"`
MAIL="/opt/homebrew/bin/msmtp"
LOCAL_TABLE="/Users/USER/Firewall/Tables"
ISO="af al ar br cn cu de es et gb hk hn il iq ir it jp ke kr mx ng ph pk pl ru sa sy tm tr ua uz vn ye za"
IP_DENY_URL="http://www.ipdeny.com/ipblocks/data/countries"
THREATS_URL="http://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt"
ADS_URL="https://pgl.yoyo.org/adservers/iplist.php?ipformat=plain&amp;showintro=1&amp;mimetype=plaintext"
DROP_URL="http://www.spamhaus.org/drop/drop.txt"
eDROP_URL="http://www.spamhaus.org/drop/edrop.txt"
TO="#####@gmail.com"
HOST=`hostname -s`
SIGN="[Sent from $HOST]"
SUBJECT="Updated PF blocklist"

BEFORE=`cat /Users/USER/Firewall/Tables/* | wc -l`
sync
# delete only country files
#shopt -s extglob
#rm -v !("ads.zone"|"drop.lasso"|"edrop.lasso"|"threats.zone")
#shopt -u extglob

rm /Users/USER/Firewall/Tables/* 
sleep 1

cd /Users/USER/
touch drop.lasso.tmp
touch edrop.lasso.tmp
touch threats.tmp

TMPO="/Users/USER/drop.lasso.tmp"
eTMPO="/Users/USER/edrop.lasso.tmp"
tTMPO="/Users/USER/threats.tmp"

/opt/homebrew/bin/bash /Users/USER/Scripts/disable.sh

for c in $ISO
do
     output=$LOCAL_TABLE/$c.zone
     curl -s "$IP_DENY_URL/$c.zone" -o "$output"
     sleep 2
done

curl -s "$THREATS_URL" -o "$tTMPO"
cut -d'#' -f1 "$tTMPO" | sed -e '/^$/d' >"$LOCAL_TABLE/threats.zone"
rm "$tTMPO"

curl -s "$ADS_URL" -o "$LOCAL_TABLE/ads.zone"

curl -s "$DROP_URL" -o "$TMPO"
cut -d';' -f1 "$TMPO" | sed -e '/^$/d' >"$LOCAL_TABLE/drop.lasso"
rm "$TMPO"

curl -s "$eDROP_URL" -o "$eTMPO"
cut -d';' -f1 "$eTMPO" | sed -e '/^$/d' >"$LOCAL_TABLE/edrop.lasso"
rm "$eTMPO"

sync

/opt/homebrew/bin/bash /Users/USER/Scripts/enable.sh

AFTER=`cat /Users/USER/Firewall/Tables/* | wc -l`
STOP=`date "+%A, %b %d, %r"`

sync
echo -e "To: ${TO}\nSubject: ${SUBJECT}\n\n$START [start]\n$STOP [stop]\n\n[before] $BEFORE\n[after] $AFTER\n\n$SIGN" | $MAIL -a gmail ${TO}
exit $?
