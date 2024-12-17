process genotypeSummary {
    // Produce a genotype summary spreadsheet
    label "artic"
    cpus 1
    input:
        tuple val(alias), file(vcf), file(tbi), file(bam), file(bam_index)
        file "reference.vcf"
    output:
        file "*genotype.csv"
    script:
        def lab_id = params.lab_id ? "--lab_id ${params.lab_id}" : ""
        def testkit = params.testkit ? "--testkit ${params.testkit}" : ""
    """
    workflow-glue genotype_summary \
        -b $bam \
        -v $vcf \
        -d reference.vcf \
        --sample $alias \
        $lab_id \
        $testkit \
        -o ${csvName}.genotype.csv
    """
}
