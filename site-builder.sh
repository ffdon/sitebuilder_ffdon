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
BUILD_NUMBER="0.9.9"
BUILD_STRING=$GLUON_COMMIT"+"$BUILD_NUMBER
#echo $BUILD_STRING
DEV_CHAN="stable"
#DEV_CHAN="experiemtal"
#DEV_CHAN="beta"
TASKANZAHL="-j5"
#TASKANZAHL="-j1"
VERBOSITY="V=s"
#VERBOSITY=""

#Zu bauende  Domanen
#nach Domaenenliste
#https://docs.google.com/spreadsheets/d/1KiK__g-mgvkGOdIDcqCmA2Km_lTHLivv-61mxl2TuKM/edit?usp=sharing

#DOM01="Domaene01"
#DOM02="Domaene02"
DOM03="Domaene03"
#DOM04="Domaene04"
#DOM05="Domaene05"
#DOM06="Domaene06"
#DOM07="Domaene07"
#DOM08="Domaene08"
#DOM09="Domaene09"
#DOM10="Domaene10"
#DOM11="Domaene11"

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
dir_sitebuilder=pwd
cd ..
dir_working=pwd

if [ ! -d "$dir_working/gluon" ]; then
  git clone $Gluon_REPO $dir_working/gluon -b $GLUON_COMMIT
fi

if [ ! -d "$dir_working/sites-ffdon" ]; then
  git clone $SITES_REPO $dir_working/sites-ffdon
fi

