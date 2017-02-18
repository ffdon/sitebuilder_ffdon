#!/bin/bash 

# Script der Community Freifunk-Donau-Ries.de
# zur Erstellung der Firmware-Images
# fuer mehrere Hardware-Architekturen
# fuer mehrere Domaenen
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
GLUON_COMMIT="v2016.3.2"
BUILD_NUMBER="0.9.30"
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
dir_output="/ffdon"
#dir_output="/var/www/html"
#Zu bauende  Domaenen
#nach Domaenenliste
#https://docs.google.com/spreadsheets/d/1KiK__g-mgvkGOdIDcqCmA2Km_lTHLivv-61mxl2TuKM/edit?usp=sharing

DOM01="Domaene-01"
#DOM03="Domaene-03"
#DOM05="Domaene-05"
#DOM07="Domaene-07"
#DOM09="Domaene-09"
#DOM11="Domaene-11"
#DOM13="Domaene-13"
#DOM15="Domaene-15"
#DOM17="Domaene-17"
#DOM19="Domaene-19"
#zu bauende Architekturen
### unter 2016.1.5 wirft ein ... aus:
###mgk@gw03:~/workdir/gluon$ make
###Please set GLUON_TARGET to a valid target. Gluon supports the following targets:
ARCH1="ar71xx-generic"
#ARCH2="ar71xx-nand"
#ARCH5="mpc85xx-generic"
#ARCH8="x86-64"
#ARCH9="x86-generic"
#ARCH10="x86-kvm_guest"
#ARCH11="x86-xen_domu"
### * ar71xx-generic
### * ar71xx-nand
### * mpc85xx-generic
### * x86-generic
### * x86-kvm_guest
### * x86-64
## * x86-xen_domu
### geht nicht #ARCH3="brcm2708-bcm2708"
### geht nicht #ARCH4="brcm2708-bcm2709"
### geht nicht #ARCH6="ramips-rt305x"
### geht nicht #ARCH7="sunxi"

# Vorbereitungen
dir_sitebuilder=`pwd`
cd ..
dir_working=`pwd`
echo $dir_working
SECRET=$dir_working/keys/mgk_secret.key

if [ ! -d "$dir_working/gluon" ]; then
  #echo git clone $Gluon_REPO $dir_working/gluon -b $GLUON_COMMIT
#  echo git clone $Gluon_REPO -b $GLUON_COMMIT
#  git clone $Gluon_REPO -b $GLUON_COMMIT
  git clone $Gluon_REPO
  cd gluon
  git checkout $GLUON_COMMIT
fi

if [ ! -d "$dir_working/gluon/site" ]; then
  mkdir $dir_working/gluon/site
fi

if [ ! -d "$dir_working/sites-ffdon" ]; then
  git clone $SITES_REPO $dir_working/sites-ffdon
fi

for Domaene in $DOM01 $DOM02 $DOM03 $DOM04 $DOM05 $DOM06 $DOM07 $DOM08 $DOM09 $DOM10 $DOM11 $DOM12 $DOM13 $DOM14 $DOM15 $DOM16 $DOM17 $DOM18 $DOM19 $DOM20 $DOM21
  do
    cd $dir_working/sites-ffdon
    git checkout $Domaene 
#################################################################################################################################
    mkdir -p $dir_output/$Domaene/versions/v$BUILD_NUMBER
    #mkdir -p /ffdon/firmware-ffdonV2/$Domaene/versions/v$BUILD_NUMBER
    #mkdir -p /var/www/html/$Domaene/versions/v$BUILD_NUMBER
    #letzterBefehlErfolgreich;
    cd $dir_working
    # Gluon Repo aktualisieren 
    cd $dir_working/gluon
    git fetch 
    git checkout $1

    # Dateien in das Gluon-Repo kopieren
    # In der site.conf werden hierbei Umgebungsvariablen durch die aktuellen Werte ersetzt

    if [ -d $dir_working/gluon/site  ]; then
      rm -rf $dir_working/gluon/site
    fi

    mkdir $dir_working/gluon/site 

    cp -r $dir_working/sites-ffdon/site.mk $dir_working/sites-ffdon/site.conf $dir_working/sites-ffdon/modules $dir_working/sites-ffdon/i18n $dir_working/gluon/site

    #letzterBefehlErfolgreich;

    for Arch in $ARCH1 $ARCH2 $ARCH3 $ARCH4 $ARCH5 $ARCH6 $ARCH7 $ARCH8 $ARCH9 $ARCH10 $ARCH11 $ARCH12
      do
        cd $dir_working/gluon 
#echo ###################################################
#echo ***************************************************
#echo *** wir wÃ¼rden jetzt $Domaene $Arch Kompilieren ***
#echo ***************************************************
#echo ###################################################

echo $dir_working/make.log

#echo "Drücken Sie eine beliebige Taste ... "
#stty -icanon -echo min 1 time 0
#dd bs=1 count=1 >/dev/null 2>&1
#stty stty -g
#echo


        #make update GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_IMAGEDIR=/var/www/html/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        #make clean GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_IMAGEDIR=/var/www/html/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        #make GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_IMAGEDIR=/var/www/html/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        make update GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_BRANCH=$GLUON_BRANCH  GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        make clean GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_BRANCH=$GLUON_BRANCH GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        make GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_BRANCH=$GLUON_BRANCH GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
#        make GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_BRANCH=$GLUON_BRANCH GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY    2>&1 | tee $dir_working/make_v$BUILD_NUMBER$(date +%y%m%d_%H%M).log   
#        make GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_BRANCH=$GLUON_BRANCH GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY    2>&1 | tee $dir_working/make.log

   echo "Das war "$Domaene $Arch
    done
  # Manifeste erstellen 
#make manifest GLUON_RELEASE=v2016.1.4 GLUON_BRANCH=experimental GLUON_PRIORITY=0 GLUON_IMAGEDIR=/ffdon/firmware-ffdonV2/Domaene-01/versions/v0.9.10/
#make manifest GLUON_RELEASE=v2016.1.4 GLUON_BRANCH=experimental GLUON_PRIORITY=0
  make manifest GLUON_RELEASE=$BUILD_STRING GLUON_BRANCH=experimental GLUON_PRIORITY=0 GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER
  make manifest GLUON_RELEASE=$BUILD_STRING GLUON_BRANCH=beta GLUON_PRIORITY=1 GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER
  make manifest GLUON_RELEASE=$BUILD_STRING GLUON_BRANCH=stable GLUON_PRIORITY=3 GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER

  # Manifeste signieren 
  # sh contrib/sign.sh/home/mgk/workdir/keys/mgk_secret.key /ffdon/firmware-ffdonV2/Domaene-01/versions/v0.9.10/images/sysupgrade/experimental.manifest
  sh contrib/sign.sh $SECRET $dir_output/$Domaene/versions/v$BUILD_NUMBER/sysupgrade/experimental.manifest
  sh contrib/sign.sh $SECRET $dir_output/$Domaene/versions/v$BUILD_NUMBER/sysupgrade/beta.manifest
  sh contrib/sign.sh $SECRET $dir_output/$Domaene/versions/v$BUILD_NUMBER/sysupgrade/stable.manifest

done
