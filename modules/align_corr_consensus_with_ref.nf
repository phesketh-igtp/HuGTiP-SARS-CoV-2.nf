process alignment {

    publishDir "${params.outDir}/consensus_FS_corrected/", mode: 'copy'

    input:
        path(consensus)

    output:
            path("all_corr_consensus_aln.fasta")
            path("all_corr_consensus_and_ref.fasta")
        
    script:

        """
        # Add reference to multifasta (maybe add a flag to be able to change the reference?)
            cat ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/reference.fasta \\
                ${consensus} \\
                > all.proovframe.consensus_w_ref.fasta     

        #Align sequences
            mafft --auto --thread 2 \\
                all.proovframe.consensus_w_ref.fasta \\
                > all.proovframe.consensus_w_ref.aln.fasta     
        """

}