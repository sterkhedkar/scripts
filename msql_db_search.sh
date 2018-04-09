#!/bin/bash
IFS='
'

#Config 
SLEEPTIME=1
BIGreen='\033[1;92m'      # Green Bold
IGreen='\033[0;92m'       # Green 
UGreen='\033[4;32m'       # Green Underline
BBlue='\033[1;34m'        # Blue Bold
RESET='\033[0m'           # Reset to normal
On_White='\033[47m'       # White Background
UYellow='\033[4;33m'      # Yellow Underline
BRed='\033[1;31m'         # Red


# Clear the console before starting
clear

printf "${BBlue}\n\t\t\tWELCOME TO MYSQL DB SEARCH${RESET}"
printf "\n\t$(date) @ $(hostname)\n"

printf "${IGreen}Please enter the mysql username associated with your database: "
read USERNAME

echo "y" | mysql_config_editor set --login-path=local --host=localhost --user=$USERNAME --password 

printf "\n${RESET}Connecting...\n"
sleep $SLEEPTIME

printf "${BBlue}Please enter the desired database name: ${RESET}"  
read DB

printf "${BBlue}Please enter the search string: ${RESET}"  
read SEARCHSTRING

UNIQTBL=""

for TABLE in `mysql --login-path=local $DB -e "show tables" | grep -v \`mysql --login-path=local $DB -e "show tables" | head -1\``
do
    for COLUMN in `mysql --login-path=local $DB -e "desc $TABLE" | grep -v \`mysql --login-path=local $DB -e "desc $TABLE" | head -1\` | grep -v int | awk '{print $1}'`
    do
        if [ `mysql --login-path=local $DB -e "Select * from $TABLE where $COLUMN='$SEARCHSTRING'" | wc -l` -gt 1 ]
        then
            if [ "$TABLE" != "$UNIQTB" ]; then
                UNIQTB=$TABLE
                printf "Table Name: "
                printf "${BRed}$TABLE${RESET}"
                echo -e "\n\tColumn: ${UYellow}$COLUMN${RESET}"
            else
                echo -e "\tColumn: ${UYellow}$COLUMN${RESET}"
            fi
        fi
    done
done
