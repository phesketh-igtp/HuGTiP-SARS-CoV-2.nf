process NEXTCLADE_ANALYSIS {

    tag "${runID}"

    cpus 1

    conda 

    input:
        val runID
        path consensus_genomes

    output:
        file "nextclade.json"
        file "*.errors.csv"
        path "nextclade.version", emit: version

    script:
        
        update_tag = ''

    """
    
    # Always update the nextclade dataset
        nextclade dataset get --name 'sars-cov-2' --output-dir 'data/sars-cov-2' $update_tag
        
        # print the version of nextclade utilised
            nextclade --version | sed 's/ /,/' > nextclade.version
            echo "nextclade_data_tag,$nextclade_data_tag" >> nextclade.version

    nextclade run \
        --input-dataset data/sars-cov-2 \\
        --output-json nextclade.json \\
        --jobs 1 \\
        --output-csv nextclade.${runID}.csv \\
        consensus_genomes

    """
}