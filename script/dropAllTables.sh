#!/bin/sh

echo "ok"

COUNT=$(mysql -umysql -pmysqlPassword BINGO -Ne 'select count(*) from bingo_master')
LINE=$(mysql -umysql -pmysqlPassword BINGO -Ne 'select id from bingo_master')

I=1
while [ $COUNT -ne $I ]
do
  I=$(($I + 1 ))
  TABLEID=`echo $LINE | cut -d ' ' -f $I`
  mysql -umysql -pmysqlPassword BINGO -e "drop table IF EXISTS pingo_$TABLEID"
done

mysql -umysql -pmysqlPassword BINGO -e "truncate table bingo_master"
