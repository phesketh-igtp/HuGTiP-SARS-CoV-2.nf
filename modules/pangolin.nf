process pangolin {

    publishDir "${params.outDir}/output_pangolin/"

    conda params.env_general

    input:
        file(consensus)

    output:
        file("output_pangolin/*")
        
    script:

        """
        pangolin --update
        pangolin --update-data --datadir ./pangolin-db/
        pangolin ${consensus} -o output_pangolin/
        """

}