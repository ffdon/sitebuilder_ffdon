#!/bin/bash 

# Script der Community Freifunk-Donau-Ries.de
# zur Erstellung der Firmware-Images
# fÃ¼r mehrere Hardware-Architekturen
# fÃ¼r mehrere DomÃ¤nen
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
GLUON_COMMIT="v2016.1.6"
BUILD_NUMBER="0.9.26"
BUILD_STRING=$GLUON_COMMIT"+"$BUILD_NUMBER
#echo $BUILD_STRING
## FÃ¼r die Bracnches  stable und experimental gibt es die Autoupdate-Funktion, 
GLUON_BRANCH="stable"
#GLUON_BRANCH="experimental"
#GLUON_BRANCH="beta"
TASKANZAHL="-j5"
#TASKANZAHL="-j2"
#TASKANZAHL="-j1"
#VERBOSITY="V=s"
VERBOSITY=""
dir_output="/ffdon"
#dir_output="/var/www/html"
#Zu bauende  Domanen
#nach Domaenenliste
#https://docs.google.com/spreadsheets/d/1KiK__g-mgvkGOdIDcqCmA2Km_lTHLivv-61mxl2TuKM/edit?usp=sharing

DOM01="Domaene-01"
#DOM02="Domaene-02"
DOM03="Domaene-03"
#DOM04="Domaene-04"
DOM05="Domaene-05"
#DOM06="Domaene-06"
DOM07="Domaene-07"
#DOM08="Domaene-08"
DOM09="Domaene-09"
#DOM10="Domaene-10"
DOM11="Domaene-11"
#DOM12="Domaene-12"
DOM13="Domaene-13"
#DOM14="Domaene-14"
DOM15="Domaene-15"
#DOM16="Domaene-16"
DOM17="Domaene-17"
#DOM18="Domaene-18"
DOM19="Domaene-19"
#DOM20="Domaene-20"
#DOM11="Domaene-21"
#zu bauende Architekturen
### unter 2016.1.5 wirft ein ... aus:
###mgk@gw03:~/workdir/gluon$ make
###Please set GLUON_TARGET to a valid target. Gluon supports the following targets:
### * ar71xx-generic
### * ar71xx-nand
### * mpc85xx-generic
### * x86-generic
### * x86-kvm_guest
### * x86-64
## * x86-xen_domu
ARCH1="ar71xx-generic"
ARCH2="ar71xx-nand"
### geht nicht #ARCH3="brcm2708-bcm2708"
### geht nicht #ARCH4="brcm2708-bcm2709"
ARCH5="mpc85xx-generic"
### geht nicht #ARCH6="ramips-rt305x"
### geht nicht #ARCH7="sunxi"
ARCH8="x86-64"
ARCH9="x86-generic"
ARCH10="x86-kvm_guest"
ARCH11="x86-xen_domu"

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
      rm -r $dir_working/gluon/site
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
        #make update GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_IMAGEDIR=/var/www/html/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        #make clean GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_IMAGEDIR=/var/www/html/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        #make GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_IMAGEDIR=/var/www/html/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        make update GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_BRANCH=$GLUON_BRANCH  GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        make clean GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_BRANCH=$GLUON_BRANCH GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        make GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_BRANCH=$GLUON_BRANCH GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
     
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
