process guppyplex {

    tag "${sampleID}"

    publishDir "${params.outDir}/RELECOV/", mode: 'copy'

    conda params.env_artic

    input:
        tuple val(sampleID), 
            val(barcode),
            val(type)

    output:
        tuple val(sampleID),
            path("${sampleID}-${params.runID}-SCoV2.fastq"), emit: guppyplex_out
        
    script:

    """
        # Run guppyplex to QC the reads
        artic guppyplex \\
            --min-length ${params.min_len} \\
            --max-length ${params.max_len} \\
            --directory ${params.dataDir}/${barcode} \\
            --prefix ${sampleID} \\
            --output ${sampleID}-${params.runID}-SCoV2.fastq
    """
}
