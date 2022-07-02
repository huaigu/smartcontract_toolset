#!/bin/bash
jailed=`desmos q staking validator desmosvaloper1ursy*********s8e59h25 | awk '/jailed/'`;

TOKEN="1508945******a5AokKWUjhdUTx2uSHxCU";
ID="32****46";
URL="https://api.telegram.org/bot$TOKEN/sendMessage";
Message="Desmos node go jailed";

if [ "$jailed" == "jailed: false" ]
then
	echo 'not in jailed'
	exit 0
else
	echo 'jailed, sending notification message to bot'
	curl -s -X POST $URL -d chat_id=$ID -d text="$Message" > /dev/null 2>&1
	exit 0
fi