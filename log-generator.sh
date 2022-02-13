#!/bin/bash

if [ $# -ne 1 ]
then
  {
    echo "引数を1つだけ入力してください"
    echo "使用方法：今日の目標時間を第1引数に入力"
  } 1>&2
  exit 1
fi

month=$(date "+%Y%m")
today=$(date "+%Y%m%d")
mkdir -p ~/bootcamp/log/"$month"
cp log_template.txt "$today".txt
sed -i 11i"$1"h "$today".txt
mv "$today".txt ~/bootcamp/log/"$month"
