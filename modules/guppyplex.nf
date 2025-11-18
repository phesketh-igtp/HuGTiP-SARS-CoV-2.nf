process guppyplex {

    tag "${sampleID}"

    publishDir "${params.outDir}/guppyplex/", mode: 'copy'

    conda params.env_artic

    input:
        tuple val(sampleID), 
            val(barcode)

    output:
        tuple val(sampleID),
            path("${sampleID}-M${params.runID}-SCoV2.fastq"), emit: guppyplex_out
        
    script:

    """
    # Run guppyplex to QC the reads
        artic guppyplex \\
            --min-length ${params.min_len} \\
            --max-length ${params.max_len} \\
            --quality ${params.min_qval} \\
            --directory ${params.dataDir}/${barcode} \\
            --prefix ${sampleID} \\
            --output ${sampleID}-M${params.runID}-SCoV2.fastq
    """
}
