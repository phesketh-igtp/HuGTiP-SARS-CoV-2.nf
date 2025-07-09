process guppyplex {

    tag "${sampleID}"

    publishDir "${params.outDir}/RELECOV/", mode: 'copy'

    conda params.env_artic

    input:
        tuple val(sampleID), 
            val(barcode)

    output:
        tuple val(sampleID),
            path("${sampleID}-M${params.runID}-SCoV2.fastq"), emit: guppyplex_out
        
    script:

    """

    mkdir -p reads

    ln -s ${params.dataDir}/${barcode}/* reads/

    # Run guppyplex to QC the reads
        artic guppyplex \\
            --min-length ${params.min_len} \\
            --max-length ${params.max_len} \\
            --quality ${params.min_qval} \\
            --directory reads/ \\
            --prefix ${sampleID} \\
            --output ${sampleID}-M${params.runID}-SCoV2.fastq
    """
}

// --directory ${params.dataDir}/${barcode} \\
