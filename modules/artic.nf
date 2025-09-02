process artic {

    tag "${sampleID}"

    publishDir "${params.outDir}/output-artic/${sampleID}/", mode: 'copy'

    conda params.env_artic

    input:
        tuple val(sampleID), 
            val(fastq)

    output:
        tuple val(sampleID),
            path("${sampleID}.consensus.fasta"), emit: artic_consensus

        tuple val(sampleID),
            path("${sampleID}.primertrimmed.rg.sorted.bam"),
            path("${sampleID}.primertrimmed.rg.sorted.bam.bai"), 
            path("${sampleID}.primersitereport.txt"),
            path("${sampleID}.amplicon_depths.tsv"),
            path("${sampleID}.alignreport.tsv"), emit: artic_coverage

        // Main artic outputs to keep for records
        tuple val(sampleID),
            path("${sampleID}.alignreport.tsv"),
            path("${sampleID}.amplicon_depths.tsv"),
            path("${sampleID}.consensus.fasta"),
            path("${sampleID}.minion.log.txt"),
            path("${sampleID}.pass.vcf"),
            path("${sampleID}.primersitereport.txt"),
            path("${sampleID}.primers.vcf"),
            path("${sampleID}.primertrimmed.rg.sorted.bam"),
            path("${sampleID}.primertrimmed.rg.sorted.bam.bai"), emit: main_out

    script:

    """
    # Run artic
        artic minion ${sampleID} \\
            --min-mapq ${params.min_mapq} \\
            --min-depth ${params.min_depth} \\
            --normalise ${params.normalise} \\
            --linearise-fasta \\
            --read-file ${fastq} \\
            --bed ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/scheme.bed \\
            --ref ${params.schemeDir}/${params.scheme_name}/${params.scheme_ver}/reference.fasta

    # rename the consensus sequence - fixed sed command
        sed -i 's/^>.*/>'"${sampleID}.consensus"'/' ${sampleID}.consensus.fasta
    """
}
