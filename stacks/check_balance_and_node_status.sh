#!/bin/bash

function checkbtcbalance
{
	echo -n "输入BTC地址: "
	read -p "Enter your name: " btcaddr
	if [ ${#btcaddr} -eq 34 ];then
		echo "查询btc地址 $btcaddr"
		curl https://stacks-node-api.krypton.blockstack.org/extended/v1/faucets/btc/$btcaddr
		echo -e '\n'
		exit 0
	else
		echo "btc地址错误"	
	fi
}

function checknodestatus
{
  curl http://localhost:20443/v2/info
  echo -e '\n'
}

PS3="选择: "
select option in "查询btc余额" "查看当前节点运行状态" \
"退出"
do
   case $option in
   "查询btc余额")
       checkbtcbalance ;;
   "查看当前节点运行状态")
       checknodestatus ;;
   "退出")
       break ;;
   *)
      echo "选择错误" ;;
  esac
done
clear