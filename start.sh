#!/bin/bash

cd task-manager/

npm install

read -p "Provide your LAN or WLAN IP address: " IP
IP=${IP:-localhost}
echo -e "Ip is now set to $IP\n"

read -p "Provide a desired port number for your front-end application: " PORT
PORT=${PORT:-3000}
echo -e "Frontend web application now set to $PORT\n"

echo -e "Note you must ensure that the backend server is running.\n" 

read -p "Can you confirm your server is running at Port 8080? (y/n): " ANS
ANS=${ANS:-n}

if [[ "${ANS,,}" == "n" ]]; then
	echo -e "Server port is not 8080\n"
	read -p "Provide the port number for the backend server: " S_PORT
	echo -e "\nSetting CORS at backend server.\n"
    curl -X POST http://$IP:$S_PORT/api/origins -H "Content-Type: application/json" -d "{\"uri\":\"http://$IP:$PORT\"}"
	echo -e "\nStarting Application\n"
	REACT_APP_ORIGIN="http://$IP:$PORT" HOST=$IP REACT_APP_API_URL="http://$IP:$S_PORT" PORT="$PORT" npm start
elif [[ "${ANS,,}" == "y" ]]; then
	echo -e "\nSetting CORS at backend server.\n"
	curl -X POST http://$IP:8080/api/origins -H "Content-Type: application/json" -d "{\"uri\":\"http://$IP:$PORT\"}"
	REACT_APP_ORIGIN="http://$IP:$PORT" HOST=$IP REACT_APP_API_URL="http://$IP:8080" PORT="$PORT" npm start
else
	echo -e "\nWrong input $ANS\n"
fi

EXIT 0
