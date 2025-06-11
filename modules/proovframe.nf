process proovframe {

   tag "${sampleID}"

    publishDir "${params.outDir}/output-artic/${sampleID}/", mode: 'copy'

    conda params.env_general

    input:
        tuple val(sampleID),
            path(consensus)

    output:
        tuple val(sampleID),
            path("${sampleID}.proovframe.consensus.fasta"), 
            path("${sampleID}.proovframe.diamond.tsv"), emit: proovframe_out

    script:

        """
        # Get the references locally
            cat ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/reference.fasta > ref.fasta
            cat ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/reference.faa > ref.faa
            
        # Map proteins to consensus genom
            proovframe map \\
                -a ref.faa \\
                -o ${sampleID}.proovframe.diamond.tsv \\
                ${consensus}

        # Correct the consensus genome
            proovframe fix \\
                -o ${sampleID}.proovframe.consensus.fasta \\
                ${consensus} \\
                ${sampleID}.proovframe.diamond.tsv
        """
}