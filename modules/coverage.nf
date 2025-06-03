process coverage {

   tag "${sampleID}"

    publishDir "${params.outDir}/artic-results/${sampleID}/"

    input:
        tuple val(sampleID),
            file(bam),
            file(bam_bai),
            file(primersitereport),
            file(amplicon_depths),
            file(alignreport)
    output:
        file("${sampleID}.coverage_mean.tab")
        file("${sampleID}.coverage.html")

    script:

        """
        # Calculate mean depth
            depth=$(samtools coverage "${bam}" | sed '1d')

        # Check if mean_depth is empty (no positions available)
            if [ -z "\${depth}" ]; then mean_depth="NA"; fi

        # Append the result to the output file
            echo -e "${sampleID}\t\${depth}" >> ${sampleID}.coverage_mean.tab

        # generate coverage HTML
                       

        """

}