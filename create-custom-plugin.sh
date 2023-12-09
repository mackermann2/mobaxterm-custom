#!/bin/bash
### This Create MobaXterm Plugin All Packages Already Downloaded By Instalation APT-GET And Located In Directory /var/apt/cache/

##### It Can Be Changed #####

NAME_PLUGIN='net-snmp-utils'

NAME_DIR_DISTR='distr'
NAME_DIR_SOURCE='source'

#############################


DIR_WORKING=$(pwd)
echo ">>> Working Directory - $DIR_WORKING";

DIR_DISTR="$DIR_WORKING/$NAME_DIR_DISTR"
DIR_SOURCE="$DIR_WORKING/$NAME_DIR_SOURCE"

### Check Workspace Directory
for DIR in $DIR_DISTR $DIR_SOURCE ;
    do
        ### If Directory Not Exist Creat It
        if [ ! -d ${DIR} ]; then

            echo ">>> Directory ${DIR} Created";
            mkdir ${DIR};

        ### If Directory Not Empty Clear It
        elif [ ! -z "$( ls -A ${DIR} )" ]; then

            echo ">>> Directory ${DIR} Cleared";
            rm -rf ${DIR}/*;

        else

            echo ">>> Directory ${DIR} Exist And Empty";

        fi

    done


### Find Downloaded Packages In Apt Cache And Write It In List
echo ">>> Create Package List From apt cache";
du -ha /var/apt/cache/* | awk '{print $NF}' | grep tar. > $DIR_WORKING/list-packages

### Copy Packages To Distrib Dir
echo ">>> Copy Packages From apt cache To $DIR_DISTR";
for PACKAGE in $( cat $DIR_WORKING/list-packages ); do cp $PACKAGE $DIR_DISTR ; done

### Extract Packages To Source Dir
echo ">>> Extract Packages To $DIR_SOURCE";
for PACKAGE in $( ls -A $DIR_DISTR ); do tar -xvf $DIR_DISTR/$PACKAGE -C $DIR_SOURCE ; done

### Create ZIP Archive Of Plugin
echo ">>> Create ZIP Archive Of Plugin $NAME_PLUGIN.zip"
cd $DIR_SOURCE && zip -r $DIR_WORKING/$NAME_PLUGIN.zip * && cd $DIR_WORKING

### Rename ZIP Archive To .mxt3
echo ">>> Rename .zip Archive To .mxt3";
mv $DIR_WORKING/$NAME_PLUGIN.zip $DIR_WORKING/$NAME_PLUGIN.mxt3

if [ -f $DIR_WORKING/$NAME_PLUGIN.mxt3 ]; then

    echo ">>> Create Plugin $DIR_WORKING/$NAME_PLUGIN.mxt3 is DONE!!!";

fi

exit 0;
