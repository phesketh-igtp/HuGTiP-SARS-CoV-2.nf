process alignment {

    publishDir "${params.outDir}/consensus_FS_corrected/"

    input:
        file(consensus)

    output:
            file("all_corr_consensus_aligned.fasta")
            file("all_corr_consensus_and_ref.fasta")
        
    script:

        """
        # Add reference to multifasta (maybe add a flag to be able to change the reference?)
            cat ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/*.reference.fasta \\
                ${consensus} \\
                > all_corr_consensus_and_ref.fasta

        #Align sequences
            mafft --thread ${params.cpu} \\
                --auto all_consensus_and_ref.fasta \\
                > all_corr_consensus_aligned.fasta
        """

}