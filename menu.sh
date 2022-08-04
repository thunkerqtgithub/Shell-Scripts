#!/opt/homebrew/bin/bash

esc=`echo -en "\033"`
normal=`echo -en "${esc}[m\017"`
red="${esc}[1;31m"
green="${esc}[1;32m"
purple="${esc}[1;35m"
yellow="${esc}[1;33m"
JOBS=( org.home.daily org.home.disk org.home.yt-download org.home.hourly org.home.pf-update org.home.ports org.home.tripwire org.home.volume org.home.weekly);
re='^[+-]?[0-9]+([.][0-9]+)?$'

MENU() 
{
	echo
        echo "+ ---------- +"
        echo "|" "${green}Admin Menu${normal}" "|"
        echo "+ ---------- +"   
        echo "1 : Jobs manager"
        echo "2 : Firewall options"
        echo "3 : Network options"
        echo
        echo -n "Enter a selection (q to quit): "
}

UNLOAD_MENU() 
{
	echo
	echo  "+ --------------------- +"
        echo "|" "${green}Choose job to disable${normal}" "|"
        echo  "+ --------------------- +"
}

START_MENU() 
{
	echo
	echo  "+ ------------------- +"
        echo "|" "${green}Choose job to start${normal}" "|"
        echo  "+ ------------------- +"
}

LOAD_MENU() 
{
	echo
	echo  "+ -------------------- +"
        echo "|" "${green}Choose job to enable${normal}" "|"
        echo  "+ -------------------- +"
}

FIREWALL_MENU() 
{
	echo
	echo  "+ ---------------- +"
        echo "|" "${green}Firewall Options${normal}" "|"
        echo  "+ ---------------- +"
        echo "1 : Show rules"
	echo "2 : Enable firewall"
	echo "3 : Disable firewall"
        echo 
	echo -n "Enter a selection (q to quit, m for menu): "
}

NETWORK_MENU() 
{
	printf "\n"
	echo  "+ --------------- +"
        echo "|" "${green}Network Options${normal}" "|"
        echo  "+ --------------- +"
        echo "1 : Show network"
	echo "2 : Join ethernet"
	echo "3 : Join wlan"
	echo 
	echo -n "Enter a selection (q to quit, m for menu): "
}

LAUNCHD_MENU() 
{
	echo  "+ -------------------- +"
        echo "|" "${green}Jobs Manager Options${normal}" "|"
        echo  "+ -------------------- +"
	echo "1 : Show jobs"
        echo "2 : Enable job"
        echo "3 : Disable job"
        echo "4 : Start job"
        echo
	echo -n "Enter a selection (q to quit, m for menu): "
}

LAUNCH_LOAD() 
{

LOAD_MENU;
declare -a LOAD=0
LENGTH=${#JOBS[@]}

for ((i = 1; i <= ${LENGTH}; i++)); do
        VAR=`launchctl list | grep ${JOBS[i-1]}` >/dev/null 2>&1
	if [ -z "$VAR" ]; then
                List2[i-1]=${JOBS[i-1]}
        fi
done

LOAD=("${List2[@]}")
COUNT=${#LOAD[@]}

IFS=$'\n' LOAD=($(sort <<<"${LOAD[*]}"))
unset IFS

if [ ${COUNT} -lt 1 ]; then
	echo ${red}"No jobs found!"${normal}
	LAUNCHD;
else
for ((i = 1; i <= ${COUNT}; i++)); do
        echo "$i : ${LOAD[i-1]}"
done
printf "\n"
echo -n "Enter a selection (q to quit, m for menu): "
read choice

if [[ ${choice} = 'q' ]]; then
	echo
        exit $?

elif [[ ${choice} = 'm' ]]; then
	/opt/homebrew/bin/bash /Users/USER/Scripts/menu.sh
        exit $?

elif ! [[ ${choice} =~ $re ]] || [[ ${choice} -lt 1 ]] || [[ ${choice} -gt ${COUNT} ]]; then
	printf ${red}"Try again!"${normal}
        printf "\n"
        LAUNCH_LOAD;

else
	cd /Library/LaunchDaemons
        IFS=","
        for x in $choice
        do
		launchctl load -w ${LOAD[$x-1]}".plist"
                echo ${green}Enabled${normal} ${LOAD[$x-1]}.plist
	done
fi
fi
unset List2
unset LOAD
LAUNCH_LOAD;

}

LAUNCH_UNLOAD() 
{

UNLOAD_MENU;
declare -a UNLOAD=0
LENGTH=${#JOBS[@]}

for ((i = 1; i <= ${LENGTH}; i++)); do
        VAR=`launchctl list | grep ${JOBS[i-1]}` >/dev/null 2>&1
        #if [ "$VAR" != "" ]; then
	if [ -n "$VAR" ]; then
                List2[i-1]=${JOBS[i-1]}
        fi
done

UNLOAD=("${List2[@]}")
COUNT=${#UNLOAD[@]}

IFS=$'\n' UNLOAD=($(sort <<<"${UNLOAD[*]}"))
unset IFS

if [ ${COUNT} -lt 1 ]; then
        echo ${red}"No jobs found!"${normal}
	LAUNCHD;
else

for ((i = 1; i <= ${COUNT}; i++)); do
        echo "$i : ${UNLOAD[i-1]}"
done
printf "\n"
echo -n "Enter a selection (q to quit, m for menu): "
read choice

if [[ ${choice} = 'q' ]]; then
        echo
	exit $?

elif [[ ${choice} = 'm' ]]; then
	/opt/homebrew/bin/bash /Users/USER/Scripts/menu.sh
        exit $?

elif ! [[ ${choice} =~ $re ]] || [[ ${choice} -lt 1 ]] || [[ ${choice} -gt ${COUNT} ]]; then
	printf ${red}"Try again!"${normal}
        printf "\n"
        LAUNCH_UNLOAD;

else
	cd /Library/LaunchDaemons
        IFS=","
        for x in $choice
        do
        	launchctl unload -w ${UNLOAD[$x-1]}".plist"
                echo ${red}Disabled${normal} ${UNLOAD[$x-1]}.plist
	done
fi
fi
unset List2
unset UNLOAD
LAUNCH_UNLOAD;

}

LAUNCH_START() 
{

START_MENU;
declare -a START=0
LENGTH=${#JOBS[@]}

for ((i = 1; i <= ${LENGTH}; i++)); do
        VAR=`launchctl list | grep ${JOBS[i-1]}` >/dev/null 2>&1
        #if [ "$VAR" != "" ]; then
	if [ -n "$VAR" ]; then
                List2[i-1]=${JOBS[i-1]}
        fi
done

START=("${List2[@]}")
COUNT=${#START[@]}

IFS=$'\n' START=($(sort <<<"${START[*]}"))
unset IFS

if [ ${COUNT} -lt 1 ]; then
        echo ${red}"No jobs found!"${normal}
	LAUNCHD;
else

for ((i = 1; i <= ${COUNT}; i++)); do
        echo "$i : ${START[i-1]}"
done
printf "\n"
echo -n "Enter a selection (q to quit, m for menu): "
read choice

if [[ ${choice} = 'q' ]]; then
	echo
        exit $?

elif [[ ${choice} = 'm' ]]; then
        /opt/homebrew/bin/bash /Users/USER/Scripts/menu.sh
        exit $?

elif ! [[ ${choice} =~ $re ]] || [[ ${choice} -lt 1 ]] || [[ ${choice} -gt ${COUNT} ]]; then
	printf ${red}"Try again!"${normal}
        printf "\n"
        LAUNCH_START;

else
	cd /Library/LaunchDaemons
        IFS=","
        for x in $choice
        do
        	launchctl start ${START[$x-1]}
                echo ${green}Started${normal} ${START[$x-1]}.plist
	done
fi
fi
unset List2
unset START
LAUNCH_START;

}

LAUNCHD() 
{	

COUNT=4
quit="no"
while [ $quit != "yes" ]
do
	echo
	LAUNCHD_MENU;
	read choice

if [[ ${choice} = 'q' ]]; then
	quit="yes"
	printf "\n"
        exit $?

elif [[ ${choice} = 'm' ]]; then
        /opt/homebrew/bin/bash /Users/USER/Scripts/menu.sh
        exit $?

elif ! [[ ${choice} =~ $re ]] || [[ ${choice} -lt 1 ]] || [[ ${choice} -gt ${COUNT} ]]; then
	printf ${red}"Try again!"${normal}
        printf "\n"

else

case $choice in
1) /opt/homebrew/bin/bash /Users/USER/Scripts/showAgents.sh
;;

2) LAUNCH_LOAD;
;;

3) LAUNCH_UNLOAD;
;;

4) LAUNCH_START;
;;

*)
printf ${red}"Try again!"${normal}
esac
fi
done
exit $?

}

FIREWALL() 
{

COUNT=3
quit="no"
while [ $quit != "yes" ]
do
 	FIREWALL_MENU;       
	read choice

if [[ ${choice} = 'q' ]]; then
        quit="yes"
	printf "\n"
	exit $?

elif [[ ${choice} = 'm' ]]; then
        /opt/homebrew/bin/bash /Users/USER/Scripts/menu.sh
        exit $?

elif ! [[ ${choice} =~ $re ]] || [[ ${choice} -lt 1 ]] || [[ ${choice} -gt ${COUNT} ]]; then
	printf ${red}"Try again!"${normal}
        printf "\n"

else

case $choice in

1) 
/opt/homebrew/bin/bash /Users/USER/Scripts/showRules.sh
FIREWALL;
exit $?
;;

2) 
/opt/homebrew/bin/bash /Users/USER/Scripts/en.sh
FIREWALL;
exit $?
;;

3) 
/opt/homebrew/bin/bash /Users/USER/Scripts/dis.sh
FIREWALL;
exit $?
;;

*)
printf ${red}"Try again!"${normal}
esac
fi
done
exit $?

}

NETWORK() 
{

COUNT=3
quit="no"
while [ $quit != "yes" ]
do
        NETWORK_MENU;
        read choice

if [[ ${choice} = 'q' ]]; then
        quit="yes"
	echo
        exit $?

elif [[ ${choice} = 'm' ]]; then
        /opt/homebrew/bin/bash /Users/USER/Scripts/menu.sh
        exit $?

elif ! [[ ${choice} =~ $re ]] || [[ ${choice} -lt 1 ]] || [[ ${choice} -gt ${COUNT} ]]; then
	printf ${red}"Try again!"${normal}
        printf "\n"

else

case $choice in
1)
/opt/homebrew/bin/bash /Users/USER/Scripts/lan.sh
NETWORK;
exit $?
;;

2)
/opt/homebrew/bin/bash /Users/USER/Network/profiles/wired.sh
NETWORK;
exit $?
;;

3)
/opt/homebrew/bin/bash /Users/USER/Network/profiles/wireless.sh
NETWORK;
exit $?
;;

*)
printf ${red}"Try again!"${normal}
esac
fi
done
exit $?

}

COUNT=3
quit="no"
while [ $quit != "yes" ]
do
	MENU;
	read choice

if [[ ${choice} = 'q' ]]; then
	quit="yes"
	printf "\n"
	exit $?

elif ! [[ ${choice} =~ $re ]] || [[ ${choice} -lt 1 ]] || [[ ${choice} -gt ${COUNT} ]]; then
	printf ${red}"Try again!"${normal}
        printf "\n"

else

case $choice in
1) LAUNCHD ;;
2) FIREWALL ;;
3) NETWORK ;;

*)
printf ${red}"Try again!"${normal}
printf "\n"
esac
fi
done
exit $?
