#!/usr/bin/bash
#file:extractFeature_unix_sh
#@dot4diw
#@time:9/27/2020
#@version:final_used
#@fuction : extract the feature from new data.
echo "Extract Features from Me_Percent File:"
startTime=`date +%Y%m%d-%H:%M`;
startTime_s=`date +%s`;
usage() { echo "$0 usage: " &&  grep " .)\ #" $0; exit 0; }
if [ $# -eq 0 ]
then
        usage;
        exit 0;
fi

while getopts ":hf:m:o:" arg; do
    case "${arg}" in
        f) # Pass the feature list file, this parameter is required.
            featureFile="${OPTARG}"
            ;;
        m) # Pass the me_percent file, this parameter is required.
            mePercentFile="${OPTARG}"
            ;;
        o) # Programe result output file, this parameter is required.
            resultFile="${OPTARG}"
            ;;
        h | *) # Display help information about this script!
            usage
            exit 0
            ;;
    esac
done

echo "The feature file is :${featureFile}"
echo "The mepercent file is :${mePercentFile}"
echo "The result out file is : ${resultFile}"
for i in $( cat "${featureFile}" )
do
    #grepExitCode=$( grep "${i}" "${mePercentFile}" | echo $? )
    grepContent=$( grep "$i" "${mePercentFile}" )
    numberOfColumns=$( head -n 1 "${mePercentFile}" | awk '{print NF}' )
    if [ -z  "$grepContent" ]
    then
        str=$i"\t"
        for (( i=0;i<$(( $numberOfColumns - 1 ));i++))
        do
                        str=$str"0\t"
                done
                echo -e $str >> "${resultFile}"
        else
        grep "$i" "${mePercentFile}" >> "${resultFile}"
        fi
done
endTime=`date +%Y%m%d-%H:%M`
endTime_s=`date +%s`
sumTime=$[ $endTime_s - $startTime_s ]

echo "Extract Finished!"
echo "$startTime ---> $endTime" "Totl run time :$sumTime seconds"
