process coverage {

   tag "${sampleID}"

    publishDir "${params.outDir}/output-artic/${sampleID}/", mode: 'copy'

    conda params.env_general

    input:
        tuple val(sampleID),
            path(bam),
            path(bam_bai),
            path(primersitereport, stageAs: "primersitereport.csv"),
            path(amplicon_depths, stageAs: "amplicon_depths.csv"),
            path(alignreport, stageAs: "alignreport.csv")
    output:
        path("${sampleID}.coverage.csv"), emit: coverage_res
        //path("${sampleID}.coverage.html")

    script:

        """
        # Calculate mean depth
        echo "sampleID,chr,startpos,endpos,numreads,covbases,coverage,meandepth,meanbaseq,meanmapq" > ${sampleID}.coverage.csv
        samtools coverage "${bam}" \\
            | sed '1d' \\
            | sed 's/^/${sampleID},/g' \\
            | sed 's/\t/,/g' \\
            >> ${sampleID}.coverage.csv

       # Get complete depth data
            samtools depth ${bam} > ${sampleID}.depths.csv
            cp ${sampleID}.depths.csv depths.csv

        # generate coverage HTML
            cp ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/scheme.bed .
            #Rscript ${params.scriptDir}/R/coverage_plots.R
            
            #rm depths.csv #scheme.bed 
            #mv sequencing_depth_plot.html ${sampleID}.depth.html
        """

}