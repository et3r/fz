#!/bin/bash

#######################
# Author: et3r        #
#######################


#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

arguments_n=$#
arguments="$@"
wordlist=""
url=""
w_flag=false
u_flag=false
h_flag=false

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${yellowColour}[x]${endColour} ${redColour} Exiting...${endColour}\n"
	exit
}

function help_panel_1(){
	echo -e "\n${yellowColour}[*]${endColour} Usage: fz -w[wordlist] ../../wordlist -u[url] \"http://url.com/FZ\" -h[help]"
}

function arguments_helper(){
	for i in $arguments; do
		
		if [ "$w_flag" == "true" ]; then
			wordlist=$i
			w_flag=""
		fi
		if [ "$u_flag" == "true" ]; then
			url=$i
			u_flag=""
		fi

		if [ "$i" == "-w" ]; then
			w_flag=true			
		elif [ "$i" == "-u" ]; then
			u_flag=true
		elif [ "$i" == "-h" ]; then
			h_flag=true
		fi
	done

	if [[ "$w_flag" == "false" || "$u_flag" == "false" || "$h_flag" == "true" ]]; then
		help_panel_1
	fi
}

function banner(){
	
	echo -e "\n"
	echo -e "${redColour}@@@@@@@@ @@@@@@@@${endColour}"
	sleep 0.07
	echo -e "${redColour}@@!           @@!${endColour}"
	sleep 0.07
	echo -e "${redColour}@!!!:!      @!!  ${endColour} ${purpleColour} Made by et3r${endColour}"
	sleep 0.07
	echo -e "${redColour}!!:       !!:${endColour}"
	sleep 0.07
	echo -e "${redColour} :       :.::.: : ${endColour}"
	sleep 0.07

	echo -e "\n${yellowColour}[*]${endColour} URL: ${greenColour}$url${endColour}"
	echo -e "${yellowColour}[*]${endColour} Wordlist: ${greenColour}$wordlist${endColour}\n"
}

function fuzzer(){
	

	echo -e "\n${grayColour}-----------------------------------------------------${endColour}"
	echo -e "|${turquoiseColour}\tURL\t\t\t\tStatus Code${endColour} |"
	echo -e "${grayColour}-----------------------------------------------------${endColour} \n"

	while IFS= read -r line 
	do
		status_code=$(curl -k -I -s ${url/FZ/$line} | head -n 1 | awk '{print $2}')

		if [ "$status_code" == "200" ]; then
			echo -e "${url/FZ/$line}\t${greenColour}$status_code${endColour}"
		elif [ "$status_code" == "401" -o "$status_code" == "301" ]; then
			echo -e "${url/FZ/$line}\t${blueColour}$status_code${endColour}"
		elif [ "$status_code" == "" ]; then
			echo -e "\n${redColour}[x] ${endColour} Server is not responding...\n"
			exit
		fi
	done < "$wordlist"
}

if [ $arguments_n -lt 4 ]
then
	help_panel_1
else
	arguments_helper
	banner
	fuzzer
fi

