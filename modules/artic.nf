process artic {

    tag "${sampleID}"

    publishDir "${params.outDir}/output-artic/${sampleID}/", mode: 'copy'

    conda params.env_artic

    input:
        tuple val(sampleID), 
            val(barcode),
            val(type)

    output:
        tuple val(sampleID),
            path("${sampleID}.consensus.fasta"), emit: artic_consensus

        tuple val(sampleID),
            path("${sampleID}.primertrimmed.rg.sorted.bam"),
            path("${sampleID}.primertrimmed.rg.sorted.bam.bai"), 
            path("${sampleID}.primersitereport.txt"),
            path("${sampleID}.amplicon_depths.tsv"),
            path("${sampleID}.alignreport.csv"), emit: artic_coverage

        path("${sampleID}-${params.runID}-SCoV2.fastq.gz"), emit: prep_fastq_out
        
        // Main artic outputs to keep for records - fixed multi-line tuple
        tuple val(sampleID),
            path("${sampleID}.alignreport.csv"),
            path("${sampleID}.amplicon_depths.tsv"),
            path("${sampleID}.artic.log.txt"),
            path("${sampleID}.consensus.fasta"),
            path("${sampleID}.minion.log.txt"),
            path("${sampleID}.pass.named.vcf.gz"),
            path("${sampleID}.primersitereport.txt"),
            path("${sampleID}.primers.vcf"),
            path("${sampleID}.primertrimmed.rg.sorted.bam"),
            path("${sampleID}.primertrimmed.rg.sorted.bam.bai"), emit: main_out
        
    script:
    """
        # Run guppyplex to QC the reads
        artic guppyplex \\
            --min-length ${params.min_len} \\
            --max-length ${params.max_len} \\
            --directory ${params.dataDir}/run_${params.runID}/*/*/fastq_pass/${barcode} \\
            --prefix ${sampleID} \\
            --output ${sampleID}-${params.runID}-SCoV2.fastq

        # Skip model download since they already exist
        # artic_get_models

        # Run artic
        artic minion \\
            --normalise ${params.normalise} \\
            --min-mapq ${params.min_mapq} \\
            --min-depth ${params.min_depth} \\
            --threads 2 \\
            --read-file ${sampleID}-${params.runID}-SCoV2.fastq \\
            --linearise-fasta \\
            --bed ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/scheme.bed \\
            --ref ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/reference.fasta \\
            ${sampleID}

        # rename the consensus sequence - fixed sed command
        sed -i 's/^>.*/>'"${sampleID}"'/' ${sampleID}.consensus.fasta

        # compress the guppyplex files for RELECOV
        gzip --best ${sampleID}-${params.runID}-SCoV2.fastq
    """
}
