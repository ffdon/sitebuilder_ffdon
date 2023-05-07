#!/bin/bash
numberofargs=$#
zaehler=0
acti=0
pass=0
targetpath=/var/builddir/workdir/targets
lastjoblist=00:00:00

function parameterinput () {
	#Diese Funktion wertet die übergebenen Parameter aus
	# ausgewertet werden:
	# Architektur um ein eventuell vorhandenes Script auszuführen
	# Zeitscheibenmarkierungen um festzulegen, in welchen der
        # Sekunden 1 bis 10 einJob ausgeführt wird um Kollisionen zu vermeiden
	zeitscheibe1=0
	zeitscheibe2=0
	zeitscheibe3=0
	zeitscheibe4=0
	zeitscheibe5=0
	zeitscheibe6=0
	zeitscheibe7=0
	zeitscheibe8=0
	zeitscheibe9=0
	zeitscheibe10=0
	for i in $@
		do
			zaehler=$(( $zaehler + 1 ))
			case $1 in
				1       		) zeitscheibe1=1;;
				2       		) zeitscheibe2=1;;
				3       		) zeitscheibe3=1;;
				4       		) zeitscheibe4=1;;
				5       		) zeitscheibe5=1;;
				6       		) zeitscheibe6=1;;
				7       		) zeitscheibe7=1;;
				8       		) zeitscheibe8=1;;
				9       		) zeitscheibe9=1;;
				10      		) zeitscheibe10=1;;
				ar71xx-generic		) target="ar71xx-generic";;
				ar71xx-nand		) target="ar71xx-nand";;
				ar71xx-tiny		) target="ar71xx-tiny";;
				brcm2708-bcm2708	) target="brcm2708-bcm2708";;
				brcm2708-bcm2709	) target="brcm2708-bcm2709";;
				generic			) target="generic";;
				mpc85xx-generic		) target="mpc85xx-generic";;
				ramips-mt7621		) target="ramips-mt7621";;
				x86-64			) target="x86-64";;
				x86-generic		) target="x86-generic";;
				x86-geode		) target="x86-geode";;
				mvebu			) target="mvebu";;
				ramips-rt305x		) target="ramips-rt305x";;
				ar71xx-mikrotik		) target="ar71xx-mikrotik";;
				ipq806x			) target="ipq806x";;
				sunxi			) target="sunxi";;
				ramips-mt7628		) target="ramips-mt7628";;
				*       		) echo der Parameter Nummer $zaehler $1 ist ungültig;;
			esac
			shift
		done
}

function decide () {
	# in dieser Funktion wird ausgewertet ob eine aktive oder eine passive
	# Zeitscheibe vorliegt
        #echo $(date) Sekunde $(date +%S) Argunent $argu Dekade $deca Zeitscheibe $deci
        if [ $acti -gt $pass ]
        then
                clear
                echo -e "\033[41m  AKTIV \033[0m" $deci
	        echo $target
#               do_a_job
		run_a_joblist
		# $acti $pass
        else
                clear
                echo -e          " passiv " $deci 
		echo $target
		# $acti $pass
        fi
}

function run_a_joblist () {
	if [ -f $targetpath/$target.joblist ]
	then
		newjoblist=$(date -r $targetpath/$target.joblist)
		if [ "$newjoblist" != "$lastjoblist" ]
		then
			bash $targetpath/$target.joblist
#			read -n1 -r -p "Press any key to continue..." key
#			echo test
		fi
		lastjoblist=$newjoblist
	else
		lastjoblist=00:00:00
	fi
#	echo jetztwuerde ich was machen
}

function do_a_job () {
	# in dieser Funktion wird ein "einzeiliger" job abgeholt
	# testhalber holen wir ein ganzes script ab.
	file=$targetpath/$target.joblist
	echo $file
	if [ -f "$file" ]
	then
		$file
#		getjob=$(cat $targetpath/$target.joblist)
#		job="$getjob"
#		echo $job
		#$job  > $targetpath/$target.job.stdout 2> $targetpath/$target.job.stderr && echo "" > $targetpath/$target.job
		#rm "$file"
	else
		echo "gibt doch nix zu tun"
	fi
}

parameterinput $@
cd $targetpath

########################################################################
###  PROVISORIUM  ######################################################
########################################################################
#cd $targetpath
#exit

while true
do
# Auslesen der aktuellen Sekunde
        seku=$(date +%-S)
# Aufteilen ein Zeitscheiben 1 bis 10
        argu=$((seku/10))
        case "$argu" in
                0) deca="1" & deci=$seku;;
                1) deca="2" & deci=$(($seku-10));;
                2) deca="3" & deci=$(($seku-20));;
                3) deca="4" & deci=$(($seku-30));;
                4) deca="5" & deci=$(($seku-40));;
                5) deca="6" & deci=$(($seku-50));;
        esac
# Zeitverschiebung zur Vermeidung der Null
	deci=$(($deci+1))
#       echo $(date) Sekunde $(date +%S) Argunent $argu Dekade $deca Zeitscheibe $deci
# Unterscheidung der Zeitscheiben
	case "$deci" in
#                0)  acti=$zeitscheibe1 ;;
                1)  acti=$zeitscheibe1 ;;
                2)  acti=$zeitscheibe2 ;;
                3)  acti=$zeitscheibe3 ;;
                4)  acti=$zeitscheibe4 ;;
                5)  acti=$zeitscheibe5 ;;
                6)  acti=$zeitscheibe6 ;;
                7)  acti=$zeitscheibe7 ;;
                8)  acti=$zeitscheibe8 ;;
                9)  acti=$zeitscheibe9 ;;
                10) acti=$zeitscheibe10 ;;
        esac
#echo Target nach Auswahl Zeitscheibe: $target
	decide
        sleep 1
done
exit
