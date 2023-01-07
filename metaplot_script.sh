#Generating metaplot to look at transcription within the genomic sites enriched in SPO11 but not PRDM9 (DSB sites) between 
#input_bigwig are the ChRO-seq files whoes coverage we want to plot to look at transcription. 
#The three different bigwig files represent three substages of Prophase I during spermatogenesis (Leptotene/Zygotene, Pachytene and Diplotene). 
#Region_bed is the positions.

base_pairs="1000" #we choose to look at 1000 bp window
regions_bed="Peaks_unique_to_SPO11_noPRDM9.bed"
input1_bigWig="LZ_merged_all_plus.rpkm.rad.bw"
input2_bigWig="P_merged_all_plus.rpkm.rad.bw"
input3_bigWig="D_merged_all_plus.rpkm.rad.bw"
output_matrix="ChroSeq_SPO11_noPRDM9_refpoint_plus.gz"

scratch=/workdir/jl3285/Adriana_metaplot

final=/local/storage/projects/prophaseI/Jyoti

echo $scratch

cp ${final}/${input1_bigWig} ${final}/${input2_bigWig} ${final}/${input3_bigWig} ${final}/${regions_bed} $scratch
cd $scratch

echo $input1_bigWig $input2_bigWig $input3_bigWig $regions_bed

source /home/jl3285/miniconda3/bin/activate deeptools
echo deeptools activated

deeptools > out
    
computeMatrix reference-point -p 10 --referencePoint center --upstream ${base_pairs} --downstream ${base_pairs} --averageTypeBins sum --missingDataAsZero \
--regionsFileName ${regions_bed} --binSize 10 --scoreFileName ${input1_bigWig} ${input2_bigWig} ${input3_bigWig} --outFileName ${output_matrix}

echo computeMatrix done!

echo word count of orginal file >> out
wc -l Peaks_unique_to_SPO11_noPRDM9.bed >> out
echo \nword count of matrix file >> out
wc -l ${output_matrix} >> out
echo \nshould be divided by no. of samples n=3 and compared with the orginal file count >> out

#ploting both metaplot and heatmap together
plotHeatmap \
--sortRegions descend --colorMap 'viridis' \
--plotTitle "Transcription at PRDM9 independent SPO11 oligo sites" \
--yAxisLabel "Accessibility (RPKM)" --whatToShow "plot, heatmap and colorbar" \
--yMin 0 --yMax 350 --zMin 0 --heatmapHeight 13 --averageTypeSummaryPlot sum \
--matrixFile ${output_matrix} --outFileName ChroSeq_SPO11_noPRDM9_plus.pdf --outFileNameMatrix ChroSeq_SPO11_noPRDM9_plus.tab --outFileSortedRegions ChroSeq_SPO11_noPRDM9_sorted_plus.tab

echo plotProfile done!

cp ChroSeq_SPO11_noPRDM9_plus.pdf ${final}


