#!/usr/bin/bash
#dot4diw

# step0 If your data format is as follows format F1 do this step, if it as follows format F2 do skip this step:
#F1  ################################DATA FORMAT F1#####################################
    #           hsa1        hsa2        hsa3        hsa4    ...     hsan    sample_type
    #   SRR1
    #   SRR2
    #   SRR3
    #   SRR4
    #   ...
    #   SRRn
    ###################################################################################

#F2  ################################DATA FORMAT F2####################################
    #                   SRR1        SRR2        SRR3        SRR4    ...     SRRn
    #   hsa1
    #   hsa2
    #   hsa3
    #   hsa4
    #   ...
    #   hsan
    #   sample_type
    ###################################################################################

for CSV in $(ls ./*.csv)
do
    awk -F"," '{
    for(i=1;i<=NF;i++)
    {
      a[FNR,i]=$i
      }
    }
    END{
    for(i=1;i<=NF;i++)
      {
        for(j=1;j<=FNR;j++)
        {
          printf a[j,i]","
        }
        printf "\n"
       }
     }' $CSV > `basename $CSV .csv`.transcope.csv

done
sed -i 's/[ ,]*$//g' *.transcope.csv
//g' *.transcope.csv

# step1 extract the feature from the all site mePercent!
for feature in $( ls ./*.feature )
do
    OUTFILE=$(basename $CSV .csv)"-"`echo $feature | awk -F '-' '{print $NF}'| cut -d '.' -f1`
    ./extractFeature_unix_V2.sh -f $feature -m *.transcope.csv -o "${OUTFILE}""_featureExtracted.txt"
done

# step2 add the sampleinfo and classinfo into the feature site.
# if you *.csv file include the sample id srr number you can get this id by follow command.
    #head -n 1 96testing_rptm+mp+erptm-fdr0.05.transcope.csv > sampleid
tail -n 1 *.transcope.csv > classinfo

# step3 combine the classiniformation to the extracted feature data.
for extractedFeature in $( ls ./*featureExtracted.txt )
do
    #cat sampleid $extractedFeature classinfo > `basename $extractedFeature .txt`.extfeature
    cat $extractedFeature classinfo > `basename $extractedFeature .txt`.extfeature
done

# step4  transcope the *.exffeature files.
for extfeature in $(ls ./*.extfeature)
do
    awk -F "," '{
    for(i=1;i<=NF;i++)
        {
        a[FNR,i]=$i
    }}
    END{
    for(i=1;i<=NF;i++)
        {
        for(j=1;j<=FNR;j++)
            {
            printf a[j,i]","
        }
        print ""
    }}' $extfeature > `basename $extfeature featureExtracted.extfeature`extfeature.csv
done

sed -i 's/[ ,]*$//g' *extfeature.csv
//g' *extfeature.csv

# step5 generate the file of arff format.

for EXTCSV in $( ls ./*extfeature.csv )
do
    java CSV2Arff  $EXTCSV `basename $EXTCSV .csv`.arff
done
