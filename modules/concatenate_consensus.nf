process concatenate_consensus {

    publishDir "${params.outDir}"

    conda params.env_pangolin

    publishDir "${params.outDir}/consensus_FS_corrected/", mode: 'copy'

    input:
        path(consensus)

    output:
        path("all.proovframe.consensus.fasta"), emit: consensus_cat
        
    script:

        """
        # Concat fasta into single file
        cat ${consensus} > all.proovframe.consensus.1.fasta

        # remove duplicate sequences (can occur during reruns)
        seqkit rmdup --by-name \\
            all.proovframe.consensus.1.fasta \\
            > all.proovframe.consensus.fasta     
        """

}