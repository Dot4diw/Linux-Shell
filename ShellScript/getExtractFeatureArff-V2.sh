#!/usr/bin/bash
#dot4diw
#11/15/2021
#Extract the feature arff format data from testing data set.
#WEKA & DFL

for TESTARFF in $( ls ./*.arff )
do
    ARFFNAME=$( basename $TESTARFF .arff )
    grep -E "@|^$" $TESTARFF > "${ARFFNAME}"-arffhead.txt
    grep hsa $TESTARFF | awk '{print NR"\t"$0}' > "${ARFFNAME}".name
    grep -v "@" $TESTARFF | sed '/^[  ]*$/d' > "${ARFFNAME}".data

    for FEATUREFILE in $( ls ./*.feature )
    do
        OUTNAME="${ARFFNAME}""-"`echo $FEATUREFILE | awk -F '-' '{print $NF}'| cut -d '.' -f1`
        ARFFRELATION="@relation '"${OUTNAME}" created with DFLearner'"
        echo $ARFFRELATION > "${OUTNAME}"-EF.arff
        echo >> "${OUTNAME}"-EF.arff

        GETCOL="$"
        for FEATURE in $( cat "${FEATUREFILE}" )
        do
            awk '{if ($2=="'$FEATURE'") print $0}'  $TESTARFF >> "${OUTNAME}"-EF.arff
            LNUM=$( awk '{if ($3=="'$FEATURE'") print $0}' "${ARFFNAME}".name | awk '{print $1}' )
            #GETCOL="${GETCOL}""${LNUM}"'","'
            GETCOL="${GETCOL}""${LNUM}"'","$';
        done
        COLDATA="${GETCOL}""NF"

        CLASSINFO=$( grep "@attribute" $TESTARFF | grep -v "hsa" )
        echo $CLASSINFO >> "${OUTNAME}"-EF.arff
        echo >> "${OUTNAME}"-EF.arff
        echo "@data" >> "${OUTNAME}"-EF.arff
        echo >> "${OUTNAME}"-EF.arff

        #echo $COLDATA
        #export COLDATA
        echo "awk -F ',' '{print $COLDATA}' ${ARFFNAME}.data >> ${OUTNAME}-EF.arff" > GETCOLDATA.sh
        bash GETCOLDATA.sh
        rm GETCOLDATA.sh


    done
done
