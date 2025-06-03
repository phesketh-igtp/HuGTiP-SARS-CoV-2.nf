process coverage {

   tag "${sampleID}"

    publishDir "${params.outDir}/artic-results/${sampleID}/"

    conda params.env_general

    input:
        tuple val(sampleID),
            path(bam),
            path(bam_bai),
            path(primersitereport, stageAs: "primersitereport.csv"),
            path(amplicon_depths, stageAs: "amplicon_depths.csv"),
            path(alignreport, stageAs: "alignreport.csv")
    output:
        path("${sampleID}.coverage.tsv")
        //path("${sampleID}.coverage.html")

    script:

        """
        # Calculate mean depth
        samtools coverage "${bam}" > ${sampleID}.coverage.tsv

       # Get complete depth data
            samtools depth ${bam} > ${sampleID}.depths.csv
            cp ${sampleID}.depths.csv depths.csv

        # generate coverage HTML
            cp ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/scheme.bed .
            Rscript ${params.scriptDir}/R/coverage_plots.R
            rm scheme.bed depths.csv
            mv sequencing_depth_plot.html ${sampleID}.depth.html
        """

}