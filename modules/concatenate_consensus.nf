process concatenate_consensus {

    conda params.env_pangolin

    publishDir "${params.outDir}/consensus_FS_corrected/", mode: 'copy'
    publishDir "${params.outDir}/version-control/", mode: 'copy', pattern : '.yaml'

    input:
        path "concatenated_consensus.fasta"

    output:
        path("all.proovframe.consensus.fasta"), emit: consensus_cat

        // Version control
        file("pangolin.yml")
        
    script:

        """
        # Concat fasta into single file
        cat concatenated_consensus.fasta > all.proovframe.consensus.1.fasta

        cat ${params.outDir}/output-artic/*/*.proovframe.consensus.fasta \\
            all.proovframe.consensus.1.fasta \\
            > all.proovframe.consensus.2.fasta

        # remove duplicate sequences (can occur during reruns)
        seqkit rmdup --by-name \\
            all.proovframe.consensus.2.fasta \\
            > all.proovframe.consensus.fasta

        # Export conda environment
        conda env --format=environment-yaml > pangolin.yml
        """

}