
LOGS = calcLog lambdaLog

all : test $(LOGS)

logs : $(LOGS)

chmod :
	@chmod 0755 *.sh

test : chmod
	-./royalTests.sh
	-./funTests.sh
	-./listTests.sh
	-./moneyTests.sh
	-./bcnfTests.sh
	-./crun.sh
	-./lrun.sh
	-./erun.sh

calcLog: chmod runCalcExamples
	./runCalcExamples.sh > $@

lambdaLog: chmod runLambdaExamples
	./runLambdaExamples.sh > $@

clean :
	rm -f *.itf *.po
	rm -f $(LOGS)
