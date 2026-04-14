process guppyplex {

    tag "${sampleID}"

    publishDir "${params.outDir}/guppyplex/", mode: 'copy'
    publishDir "${params.outDir}/version-control/", mode: 'copy', pattern : '.yaml'

    conda params.env_artic

    input:
        tuple val(sampleID), 
            val(barcode)

    output:
        tuple val(sampleID),
            path("${sampleID}-M${params.runID}-SCoV2.fastq"), emit: guppyplex_out
        
        // Version control
        file("artic.yml")
        
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

    # Export conda environment
    conda env --format=environment-yaml > artic.yml  
    """
}
