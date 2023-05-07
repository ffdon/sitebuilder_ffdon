#!/bin/bash

# Script der Community Freifunk-Donau-Ries.de
# zur Erstellung der Firmware-Images
# fuer mehrere Hardware-Architekturen
# fuer mehrere Domaenen
# und jetzt 'NEU' mit mehreren Architekturen gleichzeitig
# über tmux, tmuxifier und ein bischen Magie in der bash, bzw zsh.
#
###############################################################################################
# Buildscript zur Erstellung der Images
#
# Dieses Script holt die passende Gluon-Version von GitHub und Ã¼bertrÃ¤gt die Gluon-Konfiguration
#
###############################################################################################
# Konstanten-Belegungen nachvolgender Variablen
SITES_REPO="https://github.com/ffdon/sites-ffdon.git"
Gluon_REPO="https://github.com/freifunk-gluon/gluon.git gluon"
#GLUON_COMMIT="v2016.2.1"
#GLUON_COMMIT="v2016.2"
#GLUON_COMMIT="v2017.1.8"
GLUON_COMMIT="v2018.2.3"
BUILD_NUMBER="1.0.08"
BUILD_STRING=$GLUON_COMMIT"+"$BUILD_NUMBER
#echo $BUILD_STRING
## Fuer die Branches  stable und experimental gibt es die Autoupdate-Funktion,
GLUON_BRANCH="stable"
## sobald wir auf ein Release wie z.B. v2016.2.1 zurückgreifen ist der Branch stable
#GLUON_BRANCH="experimental"
#GLUON_BRANCH="beta"
## beim ersten Durchgang sollte  nur ein -j1 gefahren werden, da es hier warscheinlicher ist alle Quellen rechtzeitig zu erreichen
## https://forum.freifunk.net/t/fehler-beim-bauen/11773
# TASKANZAHL="-j5"
#TASKANZAHL="-j2"
TASKANZAHL="-j1"
#VERBOSITY="V=s"
#VERBOSITY=""
VERBOSITY="V=99"
### Änderung für Multiplexing
#dir_output="/var/builddir/outdir/"
dir_output="/var/builddir/workdir/output"
### das wird später definiert

# Vorbereitungen
#dir_sitebuilder=`pwd`
dir_sitebuilder=/var/builddir/workdir/sitebuilder_ffdon
#cd ..
#dir_working=`pwd`
dir_working=/var/builddir/workdir
dir_targets=/var/builddir/workdir/targets
dir_targetlog="/var/builddir/workdir/states"
#echo $dir_working
SECRET=$dir_working/keys/mgk_secret.key



### all targets
targets=(ar71xx-generic ar71xx-nand ar71xx-tiny brcm2708-bcm2708 brcm2708-bcm2709 generic mpc85xx-generic ramips-mt7621 x86-64 x86-generic x86-geode ar71xx-mikrotik ipq806x mvebu ramips-mt7628 ramips-rt305x sunxi)
### all useable targets
targets=(ar71xx-generic ar71xx-nand ar71xx-tiny brcm2708-bcm2708 brcm2708-bcm2709 generic mpc85xx-generic ramips-mt7621 x86-64 x86-generic x86-geode)
### selected targets
targets=(ar71xx-generic ar71xx-nand ar71xx-tiny brcm2708-bcm2708 brcm2708-bcm2709 mpc85xx-generic ramips-mt7621 x86-64 x86-generic x86-geode)
### all domains
domains=(01 03 05 07 09 11 13 15 17 19)
domainnames=(Test-Domaene Donauwoerth Noerdlingen Wemding Baeumenheim Monheim Harburg Oettingen Rain Umland)
###selected Domains
domains=(01 03 05 07 09 11 13 15 17 19)
domain=01
countoftargets=${#targets[@]}
countofdomains=${#domains[@]}

####
### Konstanten für den Report
####
startupdstate=":construction: wip"
#echo startupdstate: $startupdstate
statedir="/var/builddir/workdir/states"
rm $statedir/*.fin
jobs=("update" "clean")
jobs=("${jobs[@]}" "${domains[@]}")
echo Line 81 ${jobs[@]}
#https://www.artificialworlds.net/blog/2012/10/17/bash-associative-array-examples/
declare -A STATE


###############################################################################
#####  Funktionen  ############################################################
###############################################################################
zaehler=0
acti=0
pass=0
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

function decide () {
        #echo $(date) Sekunde $(date +%S) Argunent $argu Dekade $deca Zeitscheibe $deci
        if [ $acti -gt $pass ]
        then
                clear
                echo -e "\033[41m  AKTIV \033[0m" $deci
                echo Line 109 $target
                do_a_job
                # $acti $pass
        else
                clear
                echo -e          " passiv " $deci 
                echo Line 115 $target
                # $acti $pass
        fi
}

function report () {
	# target.job.state-Variablen mit Vorgabe füllen
for target in ${targets[@]}
do
        for job  in ${jobs[@]}
        do
                STATE[$target.$job]=$startupdstate
        done
done
#echo ar71xx-nand.13 ${STATE[ar71xx-nand.13]}
#echo ar71xx-nand.14 ${STATE[ar71xx-nand.14]}
#echo ar71xx-nand.15 ${STATE[ar71xx-nand.15]}
#Verzeichnis auf vorhandene Dateien prüfen und mdate in Variable speichern
for target in ${targets[@]}
do
        for job  in ${jobs[@]}
        do
                if [ -f $statedir/$target.$job.fin ]
                then
                        STATE[$target.$job]=":white_check_mark: "$(date -r $statedir/$target.$job.fin +%H:%M)
                        #echo found in $statedir/$target.$job.fin
                #else
                        #echo notfound $statedir/$target.$job.fin
                fi
        done
done
headerstart="|Target|"
formatstart="|:--|"
splittstart="||"
footerstart="|sign|"
header=$headerstart
format=$formatstart
splitt=$splittstart
footer=$footerstart
declare -A body
for job  in ${jobs[@]}
do
        header=$header$job"|"
        format=$format":--:|"
        splitt=$splitt"|"
        footer=$footer"|"
        #echo ${STATE[$target.$job]}
done
MESSAGE="Compilestatus zu GLUON $BUILD_STRING

$header
$format
$splitt"

for target in ${targets[@]}
do
        body[$target]="|$target|"
        for job  in ${jobs[@]}
        do
                body[$target]=${body[$target]}${STATE[$target.$job]}"|"
                #echo ${STATE[$target.$job]}
        done
        MESSAGE="$MESSAGE
${body[$target]}"
done
MESSAGE="$MESSAGE
$footer"

#echo $MESSAGE
TEAM="ffdon"
CHANNEL="serverlounge"
mmctl post create $TEAM:$CHANNEL --message "${MESSAGE}"
}

function decidereport () {
	lastfile="$(ls -rt1 $statedir/ | tail -1)"
	if [ "$lastfile" != "$memoriedfile" ]
	then
		report
		memoriedfile=$lastfile
	fi
}

###############################################################################
#####  Programmablauf  ############################################################
###############################################################################
echo Line 201 $countoftargets Targets wurden ausgewählt und $countofdomains Domains sind zu kompilieren.
### DEMO-Schleife
for target in ${targets[@]}
do
	domainindex=-1
	for domain in ${domains[@]}
	do
		domainindex=$[domainindex+1]
		echo Line 209 Target $target, Domain $domain - ${domainnames[$domainindex]}
	done
done

### Schleife zur Verzeichnis- und Joblist-Vorbereitung
domain=01
for target in ${targets[@]}
#      10        20        30        40        50        60        70        80        90
do
	# Erzeuge Job-Liste
	echo "#!/bin/bash"				> $dir_targets/$target.joblist
	chmod 0700 $dir_targets/$target.joblist
	echo "">> $dir_targets/$target.joblist
	# Prüfe und erzeuge Target-Verzeichnis
	if [ ! -d "$dir_targets/$target" ]
	then
		mkdir $dir_targets/$target
	fi
	echo "cd $dir_targets/$target"			>> $dir_targets/$target.joblist
	# Prüfe und Clone Gluon-Verzeichnis
	echo "if [ ! -d $dir_targets/$target/gluon ];then git clone $Gluon_REPO; fi"\
							>> $dir_targets/$target.joblist
	echo "cd gluon"					>> $dir_targets/$target.joblist
	echo "git fetch"				>> $dir_targets/$target.joblist
	# Checke Gluon-Version aus
	echo "git checkout $GLUON_COMMIT"		>> $dir_targets/$target.joblist
	# Prüfe und Clone Site-Verzeichnis
	echo "if [ ! -d $dir_targets/$target/gluon/site ];then git clone $SITES_REPO $dir_targets/$target/gluon/site; fi"\
							>> $dir_targets/$target.joblist
	echo "cd site"					>> $dir_targets/$target.joblist
	echo "git fetch"				>> $dir_targets/$target.joblist
#	sitebranch="Domaene-01_"$GLUON_COMMIT
	sitebranch="Domaene-01_"$GLUON_COMMIT"_v"$BUILD_NUMBER
	echo "git checkout $sitebranch"         >> $dir_targets/$target.joblist
#	echo "git checkout $Domaene"			>> $dir_targets/$target.joblist
	echo "cd $dir_targets/$target/gluon"		>> $dir_targets/$target.joblist
#	echo "make update GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$target GLUON_BRANCH=$GLUON_BRANCH GLUON_IMAGEDIR=$dir_output/$domain/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY > $dir_targetlog/$target.update.log 2> $dir_targetlog/$target.update.err && touch $dir_targetlog/$target.update.fin"\
	echo "make update GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$target GLUON_BRANCH=$GLUON_BRANCH GLUON_IMAGEDIR=$dir_output/$domain/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY && touch $dir_targetlog/$target.update.fin"\
							>> $dir_targets/$target.joblist
	echo "make clean  GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$target GLUON_BRANCH=$GLUON_BRANCH GLUON_IMAGEDIR=$dir_output/$domain/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY && touch $dir_targetlog/$target.clean.fin"\
							>> $dir_targets/$target.joblist
	domainindex=-1
	for domain in ${domains[@]}
	do
		domainindex=$[domainindex+1]
		echo "cd site"				>> $dir_targets/$target.joblist
#		echo "git fetch"			>> $dir_targets/$target.joblist
		#sitebranch="Domaene-"$domain"_"$GLUON_COMMIT
		sitebranch="Domaene-"$domain"_"$GLUON_COMMIT"_v"$BUILD_NUMBER
		echo "git checkout $sitebranch"		>> $dir_targets/$target.joblist
		echo "cd $dir_targets/$target/gluon"	>> $dir_targets/$target.joblist
		#echo Target $target, Domain $domain - ${domainnames[$domainindex]}
		echo "make        GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$target GLUON_BRANCH=$GLUON_BRANCH GLUON_IMAGEDIR=$dir_output/$domain/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY && touch $dir_targetlog/$target.$domain.fin"\
							>> $dir_targets/$target.joblist
        done
	#echo "">> $dir_targets/$target.joblist
	#echo "">> $dir_targets/$target.joblist
#########################################################################################
#########################################################################################
#########################################################################################
done

### Schleife zur Job-Vorbereitung
for target in ${targets[@]}
do
        domainindex=-1
        for domain in ${domains[@]}
        do
                domainindex=$[domainindex+1]
                echo Line 276 Target $target, Domain $domain - ${domainnames[$domainindex]}
        done
done

#rm -rf $statedir/*.fin

###
### Ab hier folgt eine Endlos-Schleife mit Sleep 
###


while true
do
	sleep 5
	decidereport
done
exit

