process combineGenotypeSummaries {
    label "artic"
    cpus 1

    input:
        file "summary_*.csv"
    output:
        file "genotype_summary.csv"

    """
    workflow-glue combine_genotype_summaries -g *.csv -o genotype_summary.csv
    """
    
}

