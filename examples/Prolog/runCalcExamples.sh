#! /bin/sh
# (c) 2002 Oscar.Nierstrasz@acm.org

./crun.sh 'ON 0 TOTAL OFF'
./crun.sh 'ON 5 + 7 TOTAL OFF'
./crun.sh 'ON 4 * ( 3 + 2 ) TOTAL OFF'
./crun.sh 'ON (1+2)*(3+4) TOTAL LASTANSWER + 10 TOTAL OFF'
./crun.sh 'ON IF LASTANSWER,1,2 TOTAL IF LASTANSWER,3,4 TOTAL OFF'
