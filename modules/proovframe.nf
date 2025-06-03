process proovframe {

   tag "${sampleID}"

    publishDir "${params.outDir}/artic-results/${sampleID}/", mode: 'copy'

    conda params.conda_env

    input:
        tuple val(sampleID),
            path(consensus)

    output:
        path("${sampleID}.proovframe.consensus.fasta"), emit: corr_consensus

        
    script:

        """
        # Get the references locally
            cat ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/*.reference.fasta > ref.fasta
            cat ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/*.reference.fasta > ref.faa
            
        # Map proteins to consensus genom
            ${params.scriptDir}/proovframe/bin/proovframe map \\
                -a ref.faa \\
                -o ${sampleID}.proovframe.diamond.tsv \\
                ${consensus}

        # Correct the consensus genome
            ${params.scriptDir}/proovframe/bin/proovframe fix \\
                -o ${sampleID}.consensus.proovframe.fasta \\
                ${consensus} \\
                ${sampleID}.proovframe.diamond.tsv
        """

}