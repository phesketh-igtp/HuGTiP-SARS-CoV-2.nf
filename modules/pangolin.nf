process pangolin {

    publishDir "${params.outDir}/output-pangolin/"

    conda params.env_pangolin

    input:
        file(consensus)

    output:
        file("output-pangolin/lineage_report.csv")
        
    script:

        """
        # Concat fasta into single file
        cat ${consensus} > all.proovframe.consensus.fasta

        # Update the pangolin database
        pangolin --update; mkdir pangolin-db/
        pangolin --update-data --datadir pangolin-db/

        # Run pangolin
        pangolin all.proovframe.consensus.fasta \\
            -o output-pangolin/ \\
            -d pangolin-db/
        """

}