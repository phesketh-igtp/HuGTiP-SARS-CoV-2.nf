process artic {

    tag "${sampleID}"

    publishDir "${params.outDir}/artic-results/${sampleID}/"

    input:
        tuple val(sampleID), 
            val(barcode),
            val(type)
        file(handover)

    output:
        tuple val(sampleID),
            file("${sampleID}.consensus.fasta"), emit: artic_consensus

        tuple val(sampleID),
            file("${sampleID}.primertrimmed.rg.sorted.bam"),
            file("${sampleID}.primertrimmed.rg.sorted.bam.bai"), 
            file("${sampleID}.primersitereport.txt"),
            file("${sampleID}.amplicon_depths.tsv"),
            file("${sampleID}.alignreport.csv"), emit: artic_coverage

        file("${sampleID}-${params.runID}-SCoV2.fastq.gz"), emit: prep_fastq_out
        
        // Main artic outputs to keep for records
        file("${sampleID}.alignreport.csv")
        file("${sampleID}.amplicon_depths.tsv")
        file("${sampleID}.artic.log.txt")
        file("${sampleID}.consensus.fasta")
        file("${sampleID}.minion.log.txt")
        file("${sampleID}.pass.named.vcf.gz")
        file("${sampleID}.pass.named.vcf.gz.tbi")
        file("${sampleID}.primersitereport.txt")
        file("${sampleID}.primers.vcf")
        file("${sampleID}.primertrimmed.rg.sorted.bam")
        file("${sampleID}.primertrimmed.rg.sorted.bam.bai")
        
    script:

        """
        # Run guppyplex to QC the reads
            artic guppyplex \\
                --min-length ${params.min_len} \\
                --max-length ${params.max_len} \\
                --directory ${params.dataDir}/${barcode} \\
                --prefix ${sampleID} \\
                --output ${sampleID}-${params.runID}-SCoV2.fastq

        # download the models (if not already downloaded)
            artic_get_models

        # Run artic
            artic minion \\
                --normalise ${params.normalise} \\
                --min-mapq ${params.min_mapq} \\
                --min-depth ${params.min_depth} \\
                --threads 1 \\
                --read-file ${sampleID}-M213-SCoV2.fastq \\
                --linearise-fasta \\
                --bed "${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/*.scheme.bed" \\
                --ref "${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/*.reference.fasta" \\
                ${sampleID}

        # rename the consensus sequence
            sed -i "s/^>\S*/>${sampleID}/" "${sampleID}.consensus.fasta"

        # compress the guppyplex files for RELECOV
            gzip --best ${sampleID}-${params.runID}-SCoV2.fastq
        """
}