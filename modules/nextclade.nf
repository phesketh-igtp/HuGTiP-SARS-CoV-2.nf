process nextclade {

    publishDir "${params.outDir}/output-nextclade/", mode: 'copy'
    publishDir "${params.outDir}/version-control/", mode: 'copy', pattern : '.yml'

    conda params.env_nextclade

    input:
        path(consensus)

    output:
        file("output_nextclade/*")
        
    script:

        """
        mkdir -p latest-db/
        mkdir -p latest-db/nextclade
        cat ${consensus} > all.proovframe.consensus.fasta
        nextclade dataset get -n "nextstrain/sars-cov-2/wuhan-hu-1" -o latest-db/nextclade
        nextclade run all.proovframe.consensus.fasta \\
            -D latest-db/nextclade \\
            --output-all output_nextclade/
        """

}