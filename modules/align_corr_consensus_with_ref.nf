process alignment {

    publishDir "${params.outDir}/consensus_FS_corrected/", mode: 'copy'

    input:
        path(consensus)

    output:
        path("all.proovframe.consensus_w_ref.aln.fasta")
        path("all.proovframe.consensus_w_ref.fasta")
        path("${consensus}")
    
    script:

        """
        # Add reference to multifasta (maybe add a flag to be able to change the reference?)
            cat ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/reference.fasta \\
                ${consensus} \\
                > all.proovframe.consensus_w_ref.fasta     

        #Align sequences
            mafft --auto --thread 1 \\
                all.proovframe.consensus_w_ref.fasta \\
                > all.proovframe.consensus_w_ref.aln.fasta     
        """

}