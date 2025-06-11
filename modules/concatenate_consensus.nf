process concatenate_consensus {

    conda params.env_pangolin

    publishDir "${params.outDir}/consensus_FS_corrected/", mode: 'copy'

    input:
        tuple val(sampleID),
            path(corr_consensus), 
            path(diamond)

    output:
        path("all.proovframe.consensus.fasta"), emit: consensus_cat
        
    script:

        """
        # Concat fasta into single file
        cat ${corr_consensus} > all.proovframe.consensus.1.fasta

        cat ${params.outDir}/output-artic/*/*.proovframe.consensus.fasta \\
            all.proovframe.consensus.1.fasta \\
            > all.proovframe.consensus.2.fasta    

        # remove duplicate sequences (can occur during reruns)
        seqkit rmdup --by-name \\
            all.proovframe.consensus.2.fasta \\
            > all.proovframe.consensus.fasta     
        """

}