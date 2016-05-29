#!/bin/bash 

# Script der Community Freifunk-Donau-Ries.de
# zur Erstellung der Firmware-Images
# für mehrere Hardware-Architekturen
# für mehrere Domänen
# 
###############################################################################################
# Buildscript zur Erstellung der Images
# 
# Dieses Script holt die passende Gluon-Version von GitHub und überträgt die Gluon-Konfiguration
#
###############################################################################################
# Konstanten-Belegungen nachvolgender Variablen
SITES_REPO="https://github.com/ffdon/sites-ffdon.git"
Gluon_REPO="https://github.com/freifunk-gluon/gluon.git gluon"
GLUON_COMMIT="v2016.1.4"
BUILD_NUMBER="0.9.10"
BUILD_STRING=$GLUON_COMMIT"+"$BUILD_NUMBER
#echo $BUILD_STRING
DEV_CHAN="stable"
#DEV_CHAN="experiemtal"
#DEV_CHAN="beta"
TASKANZAHL="-j4"
#TASKANZAHL="-j1"
#VERBOSITY="V=s"
VERBOSITY=""
dir_output="/ffdon/firmware-ffdonV2"
#dir_output="/var/www/html"

#Zu bauende  Domanen
#nach Domaenenliste
#https://docs.google.com/spreadsheets/d/1KiK__g-mgvkGOdIDcqCmA2Km_lTHLivv-61mxl2TuKM/edit?usp=sharing

DOM01="Domaene-01"
#DOM02="Domaene-02"
#DOM03="Domaene-03"
#DOM04="Domaene-04"
#DOM05="Domaene-05"
#DOM06="Domaene-06"
#DOM07="Domaene-07"
#DOM08="Domaene-08"
#DOM09="Domaene-09"
#DOM10="Domaene-10"
#DOM11="Domaene-11"
#DOM11="Domaene-12"
#DOM11="Domaene-13"

#zu bauende Architekturen
ARCH1="ar71xx-generic"
#ARCH2="ar71xx-nand"
#ARCH3="mpc85xx-generic"
#ARCH4="x86-generic"
#ARCH5="x86-kvm_guest"
#ARCH6="x86-64"
#ARCH7="x86-xen_domu"
#ARCH8=""

# Vorbereitungen
dir_sitebuilder=`pwd`
cd ..
dir_working=`pwd`
echo $dir_working

if [ ! -d "$dir_working/gluon" ]; then
  #echo git clone $Gluon_REPO $dir_working/gluon -b $GLUON_COMMIT
  echo git clone $Gluon_REPO -b $GLUON_COMMIT
  git clone $Gluon_REPO -b $GLUON_COMMIT
fi

if [ ! -d "$dir_working/gluon/site" ]; then
  mkdir $dir_working/gluon/site
fi

if [ ! -d "$dir_working/sites-ffdon" ]; then
  git clone $SITES_REPO $dir_working/sites-ffdon
fi

for Domaene in $DOM01 $DOM02 $DOM03 $DOM04 $DOM05 $DOM06 $DOM07 $DOM08 $DOM09 $DOM10 $DOM11 
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

    for Arch in $ARCH1 $ARCH2 $ARCH3 $ARCH4 $ARCH5 $ARCH6 $ARCH7 $ARCH8
      do
        cd $dir_working/gluon 
        #$DEV_CHAN
        #$TASKANZAHL
        #$VERBOSITY
#echo ###################################################
echo ***************************************************
echo *** wir würden jetzt $Domaene $Arch Kompilieren ***
echo ***************************************************
#echo ###################################################
        #make update GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_IMAGEDIR=/var/www/html/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        #make clean GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_IMAGEDIR=/var/www/html/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        #make GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_IMAGEDIR=/var/www/html/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        make update GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        make clean GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
        make GLUON_RELEASE=$BUILD_STRING GLUON_TARGET=$Arch GLUON_IMAGEDIR=$dir_output/$Domaene/versions/v$BUILD_NUMBER $TASKANZAHL $VERBOSITY
     
   echo "Das war "$Domaene $Arch
    done
done
