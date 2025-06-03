process pangolin {

    publishDir "${params.outDir}/output_pangolin/"

    conda params.env_pangolin

    input:
        file(consensus)

    output:
        file("output_pangolin/*")
        
    script:

        """
        pangolin --update
        pangolin --update-data --datadir ./pangolin-db/
        cat ${consensus} > all.proovframe.consensus.fasta
        pangolin all.proovframe.consensus.fasta -o output_pangolin/
        """

}